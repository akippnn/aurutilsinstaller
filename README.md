# aurutilsinstaller

> [!IMPORTANT]
> The development of this small project has been halted indefinitely for some time. I have burned myself out and have been focusing on other personal projects since (such as NixOS) as well as personal matters. Though it doesn't seem hopeful that I can come back to this. If you'd like to contribute then feel free to fork and maybe a PR as well, thank you :').  
> \- aki

Deploy aurutils using `bash` (and optionally `dialog`), both part of Arch Linux's Core repository, with an offline fallback using git submodules.

This repository comes with scripts and dependencies required to abstract multiple modes of setup for aurutils. Both GUI and commands (using flags) are provided for the beginners to navigate through the installation.

## Usage

### Requirements

- `git`

### Installation

Use either of the following commands

- Download scripts only and use git+pacman [(recommended)](## 'With internet access, it is recommended to sync the required dependencies to ensure system stability and retain the ability to update packages easily via pacman.')
  ```bash
  $ git clone https://github.com/akippnn/aurutilsinstaller.git && cd aurutilsinstaller
  ```
- Download all dependencies for offline installation (make sure all is fairly up-to-date)
  ```bash
  $ git clone --recurse-submodules -j8 https://github.com/akippnn/aurutilsinstaller.git && cd aurutilsinstaller
  ```

[//]: <> (Not needed at the moment, may be useful.)
<!--
#Set all scripts in the repository as executable (see `man find` for more details):
#```bash
#$ find . -type f -name main.sh -o -path "scripts/*" -name "*.sh" -exec chmod +x {} +
#```
-->

Set the main script as executable.
```bash
$ chmod +x main.sh
```

Run the script.
```bash
$ bash main.sh // user interface
$ bash main.sh --help // commandline interface
```

## Updates

Check [my blog](https://akippnn.github.io/blog/2023-09-06/) for more information.
