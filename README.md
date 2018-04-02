# Nim Screenshot Utility (nsu)
This library/tool was made for [Pomf It !](https://github.com/Senketsu/pomfit)

## Contents
- [About](#about)
- [Requirements](#requirements)
- [Installation](#installation)
  - [Nimble](#nimble)
  - [Manual](#manual)
- [Troubleshooting](#troubleshooting)
- [Usage](#usage)
  - [Binary](#binary)
  - [Library](#library)
- [Contacts](#contact)

## About:
Nsu is very simple and small screenshot library / tool with very basic functionality.
Its was made as replacement of external tool dependancy for pomfit ('scrot').

This library is crossplatform (Windows & Linux).
On Windows it was implemented through the old win32 api.
On Linux based systems, it was implemented through the x11 api.
OSX support not planned unless someone donates a macbook.

**Note:** You can compile this library to cmd line tool.

### Requirements:
------------------------
* `Nim` compiler and `nimble` package manager. *(preferably nim 0.18.0 and up)
* For compiling, this library depends on `x11` `oldwinapi` and `png` Nimble packages.
* For runtime, `libpng` and `zlib`.

### Installation:
#### Nimble:
Run `nimble install nsu`. Nimble will install both binary and library for you.
#### Manual:
You can build **nsu** as standalone tool, a lesser(?) brother of scrot.
Use nimble to install `x11 oldwinapi png` packages.
```
git clone https://github.com/Senketsu/nsu.git
cd ./nsu
nim c nsu.nim
```
Copy or symlink the binary into your /usr/local/bin directory.

### Troubleshooting:
------------------------
**Compiling issues:**
Please make sure you are using **Nim >=0.18.0**
If you are using older Nim compilers (0.17.x and below), please compile with '-d:deprecated'
  (and update your build system)
**Windows & libPNG**
You might have issues with libpng as the wrapper is more up to date then the libraries Nim is shipped with.
(as of April 01 2018 | Nim 0.18.0)
If you have up to date libraries from another source or you build them yourself, good on you !


### Usage:
------------------------
#### binary
```
Usage: nsu [options] .. [filename]
  Options with no arguments or group of options with only one having argument,
   can be put in one section.
   e.g: nsu -acd:5
   (Takes active window screenshot with countdown of 5 seconds.)

Options: [arguments]
  -h, --help		 Shows this help screen
  -v, --version		 Will print current version information.
  -s, --select		 Lets you choose area or window to capture.
  -a, --active		 Will capture active window screenshot.
  -f, --full		 Will capture full screen.
  -d, --delay [num]	 Will delay capturing by given number of seconds.
  -c, --count		 Will show textual countdown of the delay.
  -p, --path [text]	 Will use given path to save ss into.

Example:
  nsu -fcd:5 -p:/home/senketsu/Pictures nsu_test.png
  This will countdown from 5 seconds to capture full screen
    and save it into my Pictures folder with the name nsu_test.
```
#### library
Simply include nsu into your project and use these calls.
Every call returns file path to newly made screenshot or empty string if it fails.

**The main procedure**

`proc nsu_take_ss*(mode: NsuMode, fileName: string = "", savePath: string = "",
                   delay:int = 0, countDown: bool = false): string =`
* @mode - NsuMode for screenshot [FULL, AREA,ACTIVE_WIN, SELECT_WIN]
* @fileName - user specified filename (optional)
* @savePath - user specified path to save into (optional)
* @delay - Delay in seconds (useful only for FULL or ACTIVE_WIN mode screen shot) (optional) [max 15sec]
* @countDown - To output countdow into stdout

**Or you can call the convenience procs**

`proc nsu_active_win_ss*(fileName,savePath: string = "",delay: int = 0): string =`
* Convenience proc for active window screenshot. Optional fileName, savePath, delay parameters.

`proc nsu_select_win_ss*(fileName,savePath: string = "",delay: int = 0): string =`
* Convenience proc for selected window screenshot. Optional fileName, savePath, delay parameters.

`proc nsu_area_ss*(fileName,savePath: string = "",delay: int = 0): string =`
* Convenience proc for area(or selected window) screenshot. Optional fileName, savePath, delay parameters.

`proc nsu_full_ss*(fileName,savePath: string = "",delay: int = 0): string =`
* Convenience proc to full screenshot. Optional fileName, savePath, delay parameters.


### Contact
* Feedback , thoughts , bug reports ?
* Feel free to contact me on [twitter](https://twitter.com/Senketsu_Dev) ,or visit [stormbit IRC network](https://kiwiirc.com/client/irc.stormbit.net/?nick=Guest|?#Senketsu)
* Or create [issue](https://github.com/Senketsu/nsu/issues) on this Github page.

