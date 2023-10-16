import os
import argparse
import pandas as pd

def get_args():
    parser = argparse.ArgumentParser(
        prog="Aggregate Metaphlan bugs lists",
        description="Aggregates Metaphlan bugs lists from Humann outputs for multiple samples into a single TSV"
    )
    parser.add_argument("-i", "--indir",
                        help="Input directory that contains all of the sample directories",
                        required=True)
    parser.add_argument("-o", "--outfile",
                        help="Output file path",
                        required=True)
    parsed_args = parser.parse_args()
    return parsed_args

def get_filepaths(directory):
    subdirs = [d for d in os.listdir(directory) if os.path.isdir(os.path.join(directory, d))]
    filepaths = []
    for sampid in subdirs:
        metaphlan_path = os.path.join(directory, sampid, f"{sampid}_humann_temp", f"{sampid}_metaphlan_bugs_list.tsv")
        if os.path.exists(metaphlan_path):
            filepaths.append(metaphlan_path)
    return filepaths

def concat_files(filepaths_list):
    full = None  # Initialize full DataFrame
    for f in filepaths_list:
        df = pd.read_csv(f, sep="\t", header=4)
        # Set the index to be the clade name
        df.set_index("#clade_name", inplace=True)
        # Rename the 'relative_abundance' column to the sample name
        sample_id = os.path.basename(os.path.dirname(f))
        df.rename(columns={"relative_abundance": sample_id}, inplace=True)
        if full is None:
            full = df[["NCBI_tax_id", "additional_species"]]
        full = pd.concat([full, df[sample_id]], axis=1)
    return full

if __name__ == "__main__":
    args = get_args()
    filepaths_list = get_filepaths(args.indir)

    if not filepaths_list:
        print("No valid Metaphlan files found in the specified directories.")
    else:
        print("Aggregating the following files:")
        for filepath in filepaths_list:
            print(filepath)
        full = concat_files(filepaths_list)

        if full is not None:
            full.to_csv(args.outfile, sep="\t")
            print(f"Aggregated data saved to {args.outfile}")
        else:
            print("Error: Unable to aggregate data. Please check the input files.")
