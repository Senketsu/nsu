import strutils, os, times
import flippy
import x11/x, x11/xlib, x11/xutil
import nsu_types


proc nsu_save_image(destPath: string, pximage: PXImage, width, height: int): bool =
  var image = newImage(width, height, 4)

  let red_mask = pximage.red_mask
  let green_mask = pximage.green_mask
  let blue_mask = pximage.blue_mask

  for x in 0 ..< image.width:
    for y in 0 ..< image.height:
      var x11pixel = XGetPixel(pximage,cint(x),cint(y))
      var pixel = image.getRgba(x, y)
      pixel.r = uint8((x11pixel and red_mask) shr 16)
      pixel.g = uint8((x11pixel and green_mask) shr 8)
      pixel.b = uint8(x11pixel and blue_mask)
      pixel.a = uint8(255)
      image.putRgba(x, y, pixel)

  image.save(destPath)
  return true


proc nsu_countDown(delay: int) =
 var start = delay
 stdout.writeLine("Taking screenshot in $1 second$2.." % [$delay,
   if delay == 1: "" else: "s"])
 for i in 1..delay:
  stdout.write("$1.." % $start)
  flushFile(stdout)
  dec(start)
  sleep(1000)
 stdout.write("\n")

proc nsu_silentDelay(delay: int) =
 case delay
 of 1..15:
  sleep(delay*1000)
 else:
  discard

proc nsu_getActiveWindow (delay: int = 0):TWindow =
 result = cast[TWindow](culong(0))
 var
  display: xlib.PDisplay = XOpenDisplay(nil)
  actWind: x.TWindow
  res: cint
  revert_to: cint

 # Avoid long sleep by mistake
 if delay > 0:
  nsu_countDown(delay)


 res = XGetInputFocus(display, addr actWind, addr revert_to)
 result = cast[TWindow](cast[culong](actWind) - 1)
 # Fixes the off by one value

proc nsu_selWindowOrArea (isAreaSelection: bool): TSelVal =
 var
  display: PDisplay = XOpenDisplay(nil)
  root: TWindow
  cursor = XCreateFontCursor(display,34)
  selWindow: TWindow
  start_x, start_y, end_x, end_y, width, height, x, y: cint = 0
  event: TXEvent
  gcVal: TXGCValues
  gc: TGc
  isDone,isButtonPressed: bool
 {.gcsafe.}:
  root = DefaultRootWindow(display)
 result.useWindow = false
 if isAreaSelection:
  gcVal.foreground = XWhitePixel(display, 0)
  gcVal.function = GXxor
  gcVal.background = XBlackPixel(display, 0)
  gcVal.plane_mask = gcVal.background xor gcVal.foreground
  gcVal.line_width = 1
  gcVal.subwindow_mode = IncludeInferiors

  gc = XCreateGC(display, root,
   GCFunction or GCForeground or GCBackground or GCSubwindowMode or GCLineWidth, addr gcval)

 var res = XGrabPointer(display,root,0,
  ButtonMotionMask or ButtonPressMask or ButtonReleaseMask,
  GrabModeAsync, GrabModeAsync, root, cursor, CurrentTime)
 if not res == GrabSuccess:
  return

 while not isDone:
  discard XNextEvent(display,addr event)
  case event.theType
  of ButtonPress:
   let buttEvent = cast[PXButtonEvent](event.addr)
   start_x = buttEvent.x_root
   start_y = buttEvent.y_root

   isButtonPressed = true

  of ButtonRelease:
   let buttEvent = cast[PXButtonEvent](event.addr)

   end_x = buttEvent.x_root
   end_y = buttEvent.y_root
   selWindow = buttEvent.subwindow

   if width < 10 and height < 10:
    result.useWindow = true
   if not isAreaSelection:
    result.useWindow = true

   discard XUngrabPointer(display,CurrentTime)
   if isAreaSelection:
    discard XDrawRectangle(display, root, gc, x, y, cuint(width), cuint(height))
   discard XSync(display, 1)
   isDone = true

  of MotionNotify:
   if isAreaSelection and isButtonPressed:

    let motEvent = cast[PXMotionEvent](event.addr)
    discard XDrawRectangle(display, root, gc, x, y, cuint(width), cuint(height))
    width = motEvent.x_root - start_x
    height = motEvent.y_root - start_y

    ## Ugliness to make width/height positive and put the start positions
    ## in the right place so we can draw backwards basically. */
    if width < 0:
     width = abs(width)
     x = motEvent.x_root
    else:
     x = start_x

    if height < 0:
     height = abs(height)
     y = motEvent.y_root
    else:
     y = start_y

    discard XDrawRectangle(display, root, gc, x, y, cuint(width), cuint(height))

  else:
   discard

 result.start_x = start_x
 result.start_y = start_y
 result.end_x = end_x
 result.end_y = end_y
 result.width = width
 result.height = height
 result.window = selWindow

proc nsu_genFilePath* (fileName,savePath: string): string =
 ## Generates full file path if not specified.
 var
  homeDir = getHomeDir()
 if fileName == "":
  var
   tStamp: string = ""
   iTimeNow: int = getTime().toSeconds().toInt()
  when defined(deprecated):
    let timeNowUtc = getGMTime(fromSeconds(iTimeNow))
    tStamp = format(timeNowUtc,"yyyy-MM-dd-HH'_'mm'_'ss")
  else:
    let timeNowUtc = utc(fromUnix(iTimeNow))
    tStamp = format(timeNowUtc,"yyyy-MM-dd-HH'_'mm'_'ss")
  result = joinPath(if savePath == "": homeDir else: savePath, "$1_$2.png" % [tstamp, "nsu"])
 else:
  result = joinPath(if savePath == "": homeDir else: savePath, fileName)

proc nsu_take_ss*(mode: NsuMode, fileName: string = "", savePath: string = "",
                   delay:int = 0, countDown: bool = false): string =
 ## Main screenshoting  procedure.
 ## @mode - NsuMode for screenshot [FULL, AREA,ACTIVE_WIN, SELECT_WIN]
 ## @fileName - user specified filename (optional)
 ## @savePath - user specified path to save into (optional)
 ## @delay - Delay for FULL or ACTIVE_WIN mode screen shot (optional) [max 15sec]
 ## @countDown - To output countdow into stdout
 result = ""

 var
  width,height: cuint = 0
  image: PXImage
  gwa: TXWindowAttributes
  display: PDisplay = XOpenDisplay(nil)
  root: TWindow
  selRes: TSelVal

 {.gcsafe.}:
  root = DefaultRootWindow(display)
 if delay > 0:
  if countDown:
   nsu_countDown(delay)
  else:
   nsu_silentDelay(delay)

 case mode
 of FULL:
  discard
 of AREA:
  selRes = nsu_selWindowOrArea(true)
 of ACTIVE_WIN:
  selRes.window = nsu_getActiveWindow()
  selRes.useWindow = true
 of SELECT_WIN:
  selRes = nsu_selWindowOrArea(false)


 case mode
 of AREA, SELECT_WIN, ACTIVE_WIN:
  if selRes.useWindow:
   discard XGetWindowAttributes(display, selRes.window, addr gwa)
   width = cuint(gwa.width)
   height = cuint(gwa.height)
   image = XGetImage(display,cast[TDrawable](selRes.window), 0,0 , width, height, AllPlanes, cint(ZPixmap))
  else:
   discard XGetWindowAttributes(display, root, addr gwa)
   width = cuint(selRes.width)
   height = cuint(selRes.height)
   image = XGetImage(display,cast[TDrawable](root), selRes.start_x, selRes.start_y, width, height, AllPlanes, cint(ZPixmap))

 of FULL:
  discard XGetWindowAttributes(display, root, addr gwa)
  width = cuint(gwa.width)
  height = cuint(gwa.height)
  image = XGetImage(display,cast[TDrawable](root), 0,0 , width,height,AllPlanes, cint(ZPixmap))

 result = nsu_genFilePath(fileName,savePath)
 if not nsu_save_image(result, image, width.int, height.int):
  result = ""
