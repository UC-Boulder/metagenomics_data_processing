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
[**Globus**](https://www.globus.org/) = gooey interface for moving files. This is recommended by the CU Boulder research computing dept. 