# aurutilsinstaller

### Description

Deploy [`aurutils`](https://github.com/AladW/aurutils) tools for Arch Linux systems with ~~bash~~perl.

For beginners, this tool provides an interactible CLI to automatically setup aurutils on any Arch Linux system. Please note that there are more convenient and easy-to-install `pacman` wrappers that abstract AUR installation.<sup>[[wiki: AUR helpers](https://wiki.archlinux.org/title/AUR_helpers)]</sup> `aurutils` on the other hand takes advantage of what is typically part of any Arch Linux systems: bash.

For system administrators and related, this is a collection of template scripts used to automatically install Arch.

Note that you can use the script as root to avoid password requests; however you will need to run the script using sudo.

### Usage
##### Using the interactible CLI (for beginners)
Clone this repository
`$ git clone https://github.com/akippnn/aurutilsinstaller.git`
When the command is done, enter the cloned repository
`$ cd aurutilsinstaller`
Give execute permissions to the script
`# chmod +x start.sh`
You may either run the script as user
`$ ./start.sh`
You can also start the script as root (to avoid root password requests)
`# ./start.sh`
##### Using it as a command
`./start.sh help`
This includes all the tools you can use without using the interactible CLI.
