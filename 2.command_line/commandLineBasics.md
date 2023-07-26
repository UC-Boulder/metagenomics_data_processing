# **Command Line Basics**
## **What is the command line**
The command line, also called the Windows command line, command screen, or text interface, is a user interface that's navigated by typing commands at prompts, instead of using a mouse. For example, the Windows folder in a Windows command line is "C:\Windows>" (as shown in the picture). In Unix or Linux, it may be "%" or ">" depending on the shell. Unlike a GUI (graphical user interface) operating system, a command line only uses a keyboard to navigate by entering commands and does not utilize a mouse for navigating.

Although using a command-line interface requires the memorization of many different commands, it can be valuable resource and should not be ignored. Using a command line, you can perform almost all the same tasks that can be done with a GUI. However, many tasks can be performed quicker and can be easier to automate and do remotely.

For example, users who have Microsoft Windows may find a task such as renaming 100+ files in a folder, a very time intensive task. However, renaming 100+ files in a directory can be done in less than a minute with a single command in the command line. The task could also be automated using a batch file or other scripts to run instantly.

**In the case of metagenomics, you will need to work in the command line to interact with all of your fastq files, metagenomic processing tools, servers you  will need, etc.**

## **Using command line in mac**
Terminal is a utility that allows you to interact with your Mac through the command line. Linux operating systems include similar tools, since both Linux and macOS are Unix-like OSes. The command line interface (CLI), or the language that you type into Terminal to interact with your Mac, is called bash. Everything we discuss below is a bash command.
[**Command line crash course**](https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Understanding_client-side_tools/Command_line)


## **Some VERY helpful linux commands**
ls - The most frequently used command in Linux to list directories

pwd - Print working directory command in Linux

cd - Linux command to navigate through directories

mkdir - Command used to create directories in Linux

mv - Move or rename files in Linux

cp - Similar usage as mv but for copying files in Linux

rm - Delete files or directories

touch - Create blank/empty files

ln - Create symbolic links (shortcuts) to other files

cat - Display file contents on the terminal

clear - Clear the terminal display

echo - Print any text that follows the command

less - Linux command to display paged outputs in the terminal

man - Access manual pages for all Linux commands

uname - Linux command to get basic information about the OS

whoami - Get the active username

tar - Command to extract and compress files in Linux

grep - Search for a string within an output

head - Return the specified number of lines from the top

tail - Return the specified number of lines from the bottom

diff - Find the difference between two files

cmp - Allows you to check if two files are identical

comm - Combines the functionality of diff and cmp

sort - Linux command to sort the content of a file while outputting

export - Export environment variables in Linux

zip - Zip files in Linux

unzip - Unzip files in Linux

ssh - Secure Shell command in Linux

service - Linux command to start and stop services

ps - Display active processes

kill and killall - Kill active processes by process ID or name

df - Display disk filesystem information

mount - Mount file systems in Linux

chmod - Command to change file permissions

chown - Command for granting ownership of files or folders

ifconfig - Display network interfaces and IP addresses

traceroute - Trace all the network hops to reach the destination

wget - Direct download files from the internet

ufw - Firewall command

iptables - Base firewall for all other firewall utilities to interface with

apt, pacman, yum, rpm - Package managers depending on the distro

sudo - Command to escalate privileges in Linux

cal - View a command-line calendar

alias - Create custom shortcuts for your regularly used commands

dd - Majorly used for creating bootable USB sticks

whereis - Locate the binary, source, and manual pages for a command

whatis - Find what a command is used for

top - View active processes live with their system usage

useradd and usermod - Add new user or change existing users data

passwd - Create or update passwords for existing users

## Using conda 
Conda is an incredibly helpful tool which can be used with command line. It is a package and environment organizer. 

A simple way to think about conda is that you can set up different environments which can be activated/deactivated. Within these different environments, you can install different packages. 
For example, you might have an environment for quality checking data in which all packages required for those types of steps are within that environment. You might have another for assigning taxonomy where you could have kraken2, phyloflash, humann3, etc. installed. 

[**Conda website**](https://conda.io/projects/conda/en/latest/user-guide/getting-started.html)

Once you have conda installed, you can use it to install many of the packages you will use. A big benefit of using conda to install packages is that it will install the dependencies a package might require and manages these so that you do not have a bunch of duplicates in your library. 

Example of setting up a conda environment, activating it, installing a package
```
conda create -n exampleEnv # make environment
conda activate exampleEnv # activate that environment
conda install bioconda exampleTool # install an example tool within your environment
conda deactivate exampleEnv # deactivate that environment to go back to your base
```

Conda base environment = Conda has a default environment called base that include a Python installation and some core system libraries and dependencies of Conda. It is a “best practice” to avoid installing additional packages into your base software environment.
