# Nim Screenshot Utility (nsu)
This library/tool was made for [Pomf It !](https://github.com/Senketsu/pomfit)

## About:
Nsu is very simple and small screenshot library with very basic functionality.
Its was made as replacement of external tool dependancy for pomfit ('scrot').

This library depends on `x11` / `oldwinapi` wrappers from the offical Nimble repo,
  and from [nimlibpng](https://github.com/barcharcraz/nimlibpng) wrapper from Nimble that is shipped with, for now.

This library/tool is cross platform, on Windows it uses the win32 api and on *Nix & x11
based systems uses x11 api.

**Note:** You can compile this library to cmd line tool.


### Usage:
------------------------
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

**Or you can call the convience procs**

`proc nsu_active_win_ss*(fileName,savePath: string = "",delay: int = 0): string =`
* Convience proc for active window screenshot. Optional fileName, savePath, delay parameters.

`proc nsu_select_win_ss*(fileName,savePath: string = "",delay: int = 0): string =`
* Convience proc for selected window screenshot. Optional fileName, savePath, delay parameters.

`proc nsu_area_ss*(fileName,savePath: string = "",delay: int = 0): string =`
* Convience proc for area(or selected window) screenshot. Optional fileName, savePath, delay parameters.

`proc nsu_full_ss*(fileName,savePath: string = "",delay: int = 0): string =`
* Convience proc to full screenshot. Optional fileName, savePath, delay parameters.


### Depends:
------------------------
* For compiling, this library depends on `x11` / `oldwinapi` wrappers from the offical Nimble repo.
* For runtime, `libpng` and `zlib`.

### Contact
* Feedback , thoughts , bug reports ?
* Feel free to contact me on [twitter](https://twitter.com/Senketsu_Dev) ,or visit [stormbit IRC network](https://kiwiirc.com/client/irc.stormbit.net/?nick=Guest|?#Senketsu)
* Or create [issue](https://github.com/Senketsu/nsu/issues) on this Github page.

