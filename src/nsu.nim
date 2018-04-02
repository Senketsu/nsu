import strutils, parseopt , os
import nsupkg/nsu_types

when defined(Windows):
 import nsupkg/nsu_win32
else:
 import nsupkg/nsu_x11

const VERSION = "v0.1.4"

proc writeVersion() =
 echo "Nim Screenshot Utility [nsu] $1" % VERSION
 echo "Copyright Senketsu (@Senketsu_Dev) [https://github.com/Senketsu/nsu]"

proc writeHelp() =
 stdout.writeLine("Usage: nsu [options] .. [filename]")
 stdout.write("  Options with no arguments or group of options")
 stdout.writeLine(" with only one having argument,\n   can be put in one section.")
 stdout.writeLine("   e.g: nsu -acd:5")
 stdout.writeLine("   (Takes active window screenshot with countdown of 5 seconds.)\n")
 stdout.writeLine("Options: [arguments]")
 stdout.writeLine("  -h, --help\t\t Shows this help screen")
 stdout.writeLine("  -v, --version\t\t Will print current version information.")
 stdout.writeLine("  -s, --select\t\t Lets you choose area or window to capture.")
 stdout.writeLine("  -a, --active\t\t Will capture active window screenshot.")
 stdout.writeLine("  -f, --full\t\t Will capture full screen.")
 stdout.writeLine("  -d, --delay [num]\t Will delay capturing by given number of seconds.")
 stdout.writeLine("  -c, --count\t\t Will show textual countdown of the delay.")
 stdout.writeLine("  -p, --path [text]\t Will use given path to save ss into.")
 stdout.writeLine("\nExample:")
 stdout.writeLine("  nsu -fcd:5 -p:/home/senketsu/Pictures nsu_test.png")
 stdout.writeLine("  This will countdown from 5 seconds to capture full screen")
 stdout.writeLine("    and save it into my Pictures folder with the name nsu_test.\n")
 stdout.writeLine("This is free software , see COPYING for licensing information.")
 stdout.writeLine("Copyright Senketsu [@Senketsu_Dev] [https://github.com/Senketsu/nsu]\n")


proc isNumber(s: string): bool =
 var i = 0
 while s[i] in {'0'..'9'}: inc(i)
 result = i == s.len and s.len > 0

proc yesOrNo(question: string): bool =
 echo question
 while true:
  let line = readLine(stdin)
  let tlLine = line.toLowerAscii()
  case tlLine
  of "y","yes":
   result = true
   break
  of "n","no":
   result = false
   break
  else:
   stdout.writeLine("* Not a valid choice, type 'yes'(y/Y) or 'no'(n/N) and press enter.")

proc nsu_active_win_ss*(fileName,savePath: string = "",delay: int = 0): string =
 ## Convience proc for active window screenshot. Optional fileName, savePath, delay parameters.
 result = nsu_take_ss(ACTIVE_WIN, fileName, savePath, delay)

proc nsu_select_win_ss*(fileName,savePath: string = "",delay: int = 0): string =
 ## Convience proc for selected window screenshot. Optional fileName, savePath, delay parameters.
 result = nsu_take_ss(SELECT_WIN, fileName, savePath, delay)

proc nsu_area_ss*(fileName,savePath: string = "",delay: int = 0): string =
 ## Convience proc for area(or selected window) screenshot. Optional fileName, savePath, delay parameters.
 result = nsu_take_ss(AREA, fileName, savePath, delay)

proc nsu_full_ss*(fileName,savePath: string = "",delay: int = 0): string =
 ## Convience proc to full screenshot. Optional fileName, savePath, delay parameters.
 result = nsu_take_ss(FULL, fileName, savePath, delay)



proc main() =

 var
  delay: int
  countDown: bool
  mode: NsuMode
  fileName,savePath,resFile: string = ""

 for kind, key, val in getopt():
  case kind
  of cmdArgument:
    fileName = key

  of cmdLongOption, cmdShortOption:
    case key
    of "help", "h":
     writeHelp()
     return
    of "version", "v":
     writeVersion()
     return

    of "select", "s":
     mode = AREA
    of "full", "f":
     mode = FULL
    of "active", "a":
     mode = ACTIVE_WIN
    of "delay","d":
     if isNumber(val):
      delay = parseInt(val)
     else:
      echo "Invalid delay parameter. Delay must be integer."
    of "count", "c":
     countDown = true
    of "path", "folder", "p":
     savePath = val

    else:
     echo "Option: $1 val $2" % [key,val]
     echo "Invalid arguments. Aborting"
     return


  of cmdEnd: assert(false) # cannot happen

 if savePath != "":
  if not existsDir(savePath):
   if yesOrNo("Specified directory doesn't exist. Do you want to create it ? (Y/N)"):
    createDir(savePath)
   else:
    echo "Aborting operation."
    return

 resFile = nsu_take_ss(mode,fileName,savePath,delay,countDown)
 if resFile == "":
  echo "Error saving screenshot !"
 else:
  echo "Screenshot saved to: $1" % resFile



when isMainModule: main()
