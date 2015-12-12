import strutils, os, times
import x, xlib, xutil
import fix_lib/png
import nsu_types

var
 homeDir = getHomeDir()

proc nsu_save_image(destPath: string,image: PXImage,width,height: cint): bool =
 result = true
 var
  fp: File
  png_ptr: png_structp
  png_info_ptr: png_infop

 let red_mask = image.red_mask
 let green_mask = image.green_mask
 let blue_mask = image.blue_mask

 if not fp.open(destPath, fmWrite):
  stderr.writeLine("***Error Save_Image: Could not open file for writing")
  result = false

 png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, nil, nil, nil)
 if png_ptr == nil:
  stderr.writeLine("***Error Save_Image: Could not allocate write struct")
  result = false

 png_info_ptr = png_create_info_struct(png_ptr)
 if png_info_ptr == nil:
  stderr.writeLine("***Error Save_Image: Could not allocate info struct")
  result = false

 if not result:
  return

 png_init_io (png_ptr, fp)
 png_set_IHDR (png_ptr, png_info_ptr, png_uint32(width), png_uint32(height),
         8, PNG_COLOR_TYPE_RGBA, PNG_INTERLACE_NONE,
         PNG_COMPRESSION_TYPE_BASE, PNG_FILTER_TYPE_BASE)

 let title: cstring = "NSU_Screenshot"
 var
  title_text: png_textp
 new(title_text)

 title_text.compression = -1
 title_text.key = "Title"
 title_text.text = title
 png_set_text(png_ptr, png_info_ptr, title_text, 1)
 png_write_info (png_ptr, png_info_ptr)

 for y in 0..height-1:
   var png_row: seq[png_byte] = @[]
   for x in 0..width-1:
    var pixel = XGetPixel(image,x,y)
    let blue: cuchar = cuchar((pixel and blue_mask))
    let green: cuchar = cuchar((pixel and green_mask) shr 8)
    let red: cuchar = cuchar((pixel and red_mask) shr 16)
    let alpha: cuchar = cuchar(255)
    png_row.add(red)
    png_row.add(green)
    png_row.add(blue)
    png_row.add(alpha)

   png_write_row (png_ptr, png_row)

 png_write_end (png_ptr, nil)
 fp.close()


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
 result = cast[TWindow](cast[culong](actWind)- 1)
 # Fixes the off by one value

proc nsu_selWindowOrArea (isAreaSelection: bool): TSelVal =
 var
  display: PDisplay = XOpenDisplay(nil)
  root: TWindow = DefaultRootWindow(display)
  cursor = XCreateFontCursor(display,34)
  selWindow: TWindow
  start_x, start_y, end_x, end_y, width, height, x, y: cint = 0
  event: TXEvent
  gcVal: TXGCValues
  gc: TGc
  isDone,isButtonPressed: bool

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

 # discard XAllowEvents(display, SyncPointer,CurrentTime)
 while not isDone:
  # discard XFlush(display)
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
 # echo "Start:\t x:$1\ty:$2" % [$start_x,$start_y]
 # echo "End:\t x:$1\ty:$2" % [$end_x,$end_y]
 # echo "$1" % repr(selWindow)

proc nsu_genFilePath* (fileName,savePath: string): string =
 ## Generates full file path if not specified.
 if fileName == "":
  var
   tStamp: string = ""
   iTimeNow: int = (int)getTime()
  let timeNowUtc = getGMTime(fromSeconds(iTimeNow))
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
  code = 0
  width,height: cint = 0
  image: PXImage
  gwa: TXWindowAttributes
  display: PDisplay = XOpenDisplay(nil)
  root: TWindow = DefaultRootWindow(display)
  selRes: TSelVal

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
 else:
  return


 case mode
 of AREA, SELECT_WIN, ACTIVE_WIN:
  if selRes.useWindow:
   discard XGetWindowAttributes(display, selRes.window, addr gwa)
   width = gwa.width
   height = gwa.height
   image = XGetImage(display,cast[TDrawable](selRes.window), 0,0 ,
                     cuint(gwa.width), cuint(gwa.height), AllPlanes, cint(ZPixmap))
  else:
   discard XGetWindowAttributes(display, root, addr gwa)
   width = selRes.width
   height = selRes.height
   image = XGetImage(display,cast[TDrawable](root), selRes.start_x, selRes.start_y,
                     cuint(selRes.width), cuint(selRes.height), AllPlanes, cint(ZPixmap))

 of FULL:
  discard XGetWindowAttributes(display, root, addr gwa)
  width = gwa.width
  height = gwa.height
  image = XGetImage(display,cast[TDrawable](root), 0,0 , cuint(width),cuint(height),AllPlanes, cint(ZPixmap))

 else: return

 result = nsu_genFilePath(fileName,savePath)
 if not nsu_save_image(result,image,width,height):
  result = ""

