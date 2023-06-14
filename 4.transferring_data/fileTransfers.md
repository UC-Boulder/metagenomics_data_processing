# **Transferring large amounts of data**

## scp 
[**scp use**](https://linuxize.com/post/how-to-use-scp-command-to-securely-transfer-files/)
This is good for: smaller zipped files, files on google drive, files from one server to another, downloading some databases from the web

### Use
```
scp -r {path to what you want to copy} {path to where you want it to go}
```

## wget 
[**wget use**](https://www.digitalocean.com/community/tutorials/how-to-use-wget-to-download-files-and-interact-with-rest-apis)
This is good for: if you have large files and/or a download link

### Use
```
cd {location where you would like to have the data from the link go}
wget {link to download}
```

## sftp 
[**sftp use**](https://www.digitalocean.com/community/tutorials/how-to-use-sftp-to-securely-transfer-files-with-a-remote-server)
This is good for: the CU Boulder research computer really likes this method! 

1. get into correct directory where your files are <u>stored<u> (the files you want to move somewhere else.)


2. sftp to where you would like to move the files.  This is very similar to ssh, but for file transfer.
```
sftp <username>@login.rc.colorado.edu
```

3. go to the folder where you want to <u>put<u> the files. 

	
4. use put for the files you want to move.  If you want to put a folder with everything in it, you need to use the -r option.  Here is an example.
```
put -r example # this would move everything within the directory "example"
```

On the other hand, you could do something like this:
```
put example/*.gz # this could move everything ending in ".gz" within the example directory.
```
The \* character is a wildcard so it allows you to select anything ending with .gz. FYI the wildcard can be used at the beginning of text test\* would get everything starting with "test". And could even be used twice (ex. \*test\* would select anything with the word text anywhere in its name.)


## Other tools for file transfers 
[**Globus**](https://www.globus.org/) = gooey interface for moving files. 
Globus is a file transfer service that is used and recommended by the Research Computing department at the University of Colorado Boulder. You'll need to download and authorize "Globus Connect Personal" onto your computer for it to work. 

CU Boulder has its own Globus endpoint, which can be accessed by clicking on the "Endpoint" button and searching for the CU Boulder Research Computing endpoint. Once on the endpoint, you'll be able to specify the path to your computer cluster account, and the folder you want to transfer the files to (eg: "/scratch/alpine/emye7956/data/". You need to specify two endpoints for every file transfer (where the files are, and where you want to move them to). So if one endpoint is a path on the CU Boulder Research Computing endpoint, the other endpoint might be on "myPC" "Volumes/IPHY/ADORlab/project" ... or whereever you want to move files to or from. 

Globus utilized a data transfer node (DTN) for speedier transfers of large data. It also resumes failed transfers from where they left off, which is handy for internet interruptions. For transfers that take more than a day, you'll need to reauthorize your credentials every 24hours. 
*useful tip - sometimes when configuring your endpoint, you might get told "you do not have access to this directory". Don't panic. If you have downloaded globus connect personal, click on the icon, go to preferences, then go to the "access" tab, and add the path to which you need access to.
