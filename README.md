# aurutilsinstaller

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

### "2.0"

Ironically, the previous version was 2.1.1. But semver is not for me.

There was a real need to separate all the scripts into their own files, but I was only active recently in Arch Linux to made said changes. Now that the project itself is modular, it will be much easier to make changes and add new scripts for different purposes.

I never really thought of using a TUI until now, and so I used one specifically made for shell scripts. There are a lot to choose from, one example is `gum` and another is `FTXUI`. There are some thoughts to use C++ and GNU Makefile going forward (and still have). I used `dialog` because it is in the `core` repository. But originally, I wanted to add arg parsing to simplify the installation process with a command that can be saved and copy-pasted. Now that the project is modular, both are possible if I abstract them, without the need of duplicate code.

Another thing I've learned of is the existence of git submodules, which will actually give another option for those that want to compile all the dependencies on their own in an environment where internet connection is a problem. I believe it is safe unless it is used in an outdated system, or the local copy of the submodules is old.


