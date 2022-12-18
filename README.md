# aurutilsinstaller

### Note

As of now, I will make changes in the experimental branch. I may make some needed changes in there but unfortunately I won't be able to test if it works; I currently do not have a testing environment to confirm whether it works or not.

Also, please read text warnings carefully. The script as of now is not in a 100% working state.

### Description

A single shell script to deploy Aurutils scripts in a human-readable way for Arch systems. 

This is not a substitute to manually installing aurutils for the first time, though it can be used as such but there are other more convenient and straightforward to set-up wrappers that abstract AUR installation.<sup>[[wiki: AUR helpers](https://wiki.archlinux.org/title/AUR_helpers)]</sup> Rather the purpose of this script is for deployment purposes; for technicians that prefer the usage of aurutils for fresh Arch installations and make more use out of the commands that already exist in the system, such as `pacman`.

What this script does is execute common commands used to install aurutils (the script displays such commands), and help configure it for standard use. The script is designed in a way to guide the user through setting up aurutils step-by-step.

This is also great for beginners that are just getting started to Arch Linux. Shell scripting is very important for repetitive tasks where you can cut down the amount of commands used in a very transparent manner. Making your own script shouldn't be very difficult when you can get accustomed to working around the CLI; hint, you don't need to remember commands, you just need to know where to look. Google is your friend ;)

### Usage
##### If you're an experienced user
All you need to do is run the `start.sh` script.

##### For beginners
Clone this repository
`git clone https://github.com/akippnn/aurutilsinstaller.git`
When the command is done, enter the cloned repository
`cd aurutilsinstaller`
Give execute permissions to the script
`chmod +x aurutilsinstaller.sh`
Run the script (do not run as sudo/root)
`./aurutilsinstaller.sh`
