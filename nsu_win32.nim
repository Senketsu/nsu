import strutils, os, times
import windows
import fix_lib/png
import nsu_types


const
 NULL: HANDLE = 0
 FALSE = 0
 nsuClassName = "nsuWinClass"

var
 selWindow: HWND
 begPt,endPt,temPt: POINT
 rcSel: RECT
 curSelVal: TSelVal
 isVisibleWin: bool = false
 isButtonPressed: bool = false
 homeDir = getHomeDir()

proc nsu_init_windows():HWND
proc clear(val: var TSelVal)

curSelVal.clear()
selWindow = nsu_init_windows()

proc clear(val: var TSelVal)=
 val.start_x = 0
 val.start_y = 0
 val.end_x = 0
 val.end_y = 0
 val.width = 0
 val.height = 0
 val.window = NULL
 val.useWindow = false

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

proc nsu_save_image(destPath: string,image: HDC,width,height: cint): bool =
 result = true
 var
  fp: File
  png_ptr: png_structp
  png_info_ptr: png_infop

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
    var pixel: COLORREF = GetPixel(image, x, y)
    let blue: cuchar = cast[cuchar](GetBValue(pixel))
    let green: cuchar = cast[cuchar](GetGValue(pixel))
    let red: cuchar = cast[cuchar](GetRValue(pixel))
    let alpha: cuchar = cuchar(255)
    png_row.add(red)
    png_row.add(green)
    png_row.add(blue)
    png_row.add(alpha)

   png_write_row (png_ptr, png_row)

 png_write_end (png_ptr, nil)
 fp.close()



proc nsuRedrawSelection (hWnd: HWND, rect: RECT)=
 var
  hdc: HDC
  hOldPen: HPEN
  hOldBrush: HBRUSH
 # let myBrush = (HBRUSH) GetWindowLong(hWnd, GCL_HBRBACKGROUND)
 hdc = GetDC(hWnd)
 hOldPen = (HPEN)SelectObject(hDC, CreatePen(PS_SOLID, 1, RGB(19, 187, 242)));
 hOldBrush = (HBRUSH)SelectObject(hDC, GetStockObject(NULL_BRUSH))

 # discard SetROP2(hDC, R2_MASKPEN)
 discard Rectangle(hDC, rect.TopLeft.x, rect.TopLeft.y,
   rect.BottomRight.x, rect.BottomRight.y)

 discard DeleteObject(SelectObject(hDC, hOldPen))
 discard DeleteObject(SelectObject(hDC, hOldBrush))
 discard ReleaseDC(hWnd, hDC);


proc nsuWndProc (hWnd: HWND, uMsg: WINUINT, wParam: WPARAM, lParam: LPARAM): LRESULT {.stdcall.} =
 var
  hdc: HDC
  ps: PAINTSTRUCT
  rcClient: RECT

 case uMsg
 of WM_PAINT:
   discard

 of WM_LBUTTONDOWN:
  if isVisibleWin:
   discard ReleaseCapture()
   discard GetCursorPos(addr begPt)
   rcSel.TopLeft.x = LOWORD(cast[LONG](lParam))
   rcSel.TopLeft.y = HIWORD(cast[LONG](lParam))
   rcSel.BottomRight.x = rcSel.TopLeft.x
   rcSel.BottomRight.y = rcSel.TopLeft.y

   discard SetCapture(selWindow)
   isButtonPressed = true

 of WM_MOUSEMOVE:
  if isVisibleWin and isButtonPressed:
   rcSel.BottomRight.x = LOWORD(cast[LONG](lParam))
   rcSel.BottomRight.y = HIWORD(cast[LONG](lParam))

   discard GetClientRect(hWnd, addr rcClient)
   if rcSel.BottomRight.x < 0: rcSel.BottomRight.x = 0
   if rcSel.BottomRight.x > rcClient.BottomRight.x: rcSel.BottomRight.x = rcClient.BottomRight.x
   if rcSel.BottomRight.y < 0: rcSel.BottomRight.y = 0
   if rcSel.BottomRight.y > rcClient.BottomRight.y: rcSel.BottomRight.y = rcClient.BottomRight.y
   # discard InvalidateRect( hwnd, nil, 1 )
   nsuRedrawSelection(hWnd, rcSel)

 of WM_LBUTTONUP:
  if isVisibleWin:
   isButtonPressed = false
   discard GetCursorPos(addr endPt)
   discard ShowWindow(hWnd,0)
   isVisibleWin = false

   discard GetClientRect(hWnd, addr rcClient)
   let myBrush = (HBRUSH) GetWindowLong(hWnd, GCL_HBRBACKGROUND);
   discard FillRect((HDC)wParam, rcClient, myBrush)


   temPt.x = 0
   temPt.y = 0
   if begPt.x > endPt.x and begPt.y > endPt.y:
    temPt = begPt
    begPt = endPt
    endPt = temPt

   if begPt.x > endPt.x and begPt.y < endPt.y:
    temPt.x = begPt.x
    begPt.x = endPt.x
    endPt.x = temPt.x

   if begPt.x < endPt.x and begPt.y > endPt.y:
    temPt.y = begPt.y
    begPt.y = endPt.y
    endPt.y = temPt.y

   var width,height: cint = 0
   width = if endPt.x > begPt.x : endPt.x - begPt.x else: begPt.x - endPt.x
   height = if endPt.y > begPt.y : endPt.y - begPt.y else: begPt.y - endPt.y

   if width <= 10 or height <= 10:
    discard GetCursorPos(addr begPt)
    curSelVal.window = WindowFromPoint(begPt)
    curSelVal.useWindow = true
    PostQuitMessage(0)

   curSelVal.start_x = begPt.x
   curSelVal.start_y = begPt.y
   curSelVal.end_x = endPt.x
   curSelVal.end_y = endPt.y
   curSelVal.width =  width
   curSelVal.height = height
   PostQuitMessage(0)

 else:
  return DefWindowProc( hWnd, uMsg, wParam, lParam )

 return 0

proc nsu_init_windows():HWND =
  var
    wc: WNDCLASSEX
    hwnd: HWND
    msg: MSG
  result = NULL
  let hInstance = GetModuleHandle(nil)

  wc.cbSize = WINUINT(sizeof(WNDCLASSEX))
  wc.style = 0
  wc.lpfnWndProc = WNDPROC(nsuWndProc)
  wc.cbClsExtra    = 0
  wc.cbWndExtra    = 0
  wc.hInstance     = hInstance
  wc.hbrBackground = (HBRUSH)0
  wc.hCursor       = LoadCursor( NULL, IDC_CROSS )
  wc.lpszMenuName  = nil
  wc.hIcon        = NULL
  wc.lpszClassName = nsuClassName

  if RegisterClassEx(addr(wc)) == 0:
    stdout.writeLine("[nsu] Window Registration Failed!")
    return

  hwnd = CreateWindowEx( 0, nsuClassName, "",
         WS_POPUP, 0,0, GetSystemMetrics(78), GetSystemMetrics(79),
            NULL, NULL , hInstance, nil)


  # Just to make sure they are gone
  var lStyle = GetWindowLongPtr(hwnd, GWL_STYLE)
  lStyle = lStyle and not (WS_CAPTION or WS_THICKFRAME or WS_MINIMIZE or WS_MAXIMIZE or WS_SYSMENU)
  discard SetWindowLongPtr(hwnd, GWL_STYLE, lStyle)
  var lExStyle = GetWindowLongPtr(hwnd, GWL_EXSTYLE)
  lExStyle = lExStyle and not (WS_EX_DLGMODALFRAME or WS_EX_CLIENTEDGE or WS_EX_STATICEDGE)
  discard SetWindowLongPtr(hwnd, GWL_EXSTYLE, lExStyle)
  discard SetWindowPos(selWindow, 0, 0, 0, 0, 0,
   SWP_FRAMECHANGED or SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER or SWP_NOOWNERZORDER)

  if hwnd == NULL:
    var err = GetLastError()
    stdout.writeLine("[nsu] Failed to setup subwindow !")
    return
  result = hwnd

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
  selWinRc: RECT
  hDesktopDC, hCaptureDC,hCustomDC: HDC
  hCaptureBitmap: HBITMAP
  hDesktopWnd: HWND

 if delay > 0:
  if countDown:
   nsu_countDown(delay)
  else:
   nsu_silentDelay(delay)

 case mode
 of FULL:
  discard

 of AREA:
  isVisibleWin = true
  discard ShowWindow(selWindow,SW_SHOW)
  var msg: MSG
  while GetMessage( addr msg, NULL, 0, 0 ) > 0:
   discard TranslateMessage( addr msg )
   discard DispatchMessage ( addr msg )

 of ACTIVE_WIN:
  curSelVal.window = GetForegroundWindow()
  curSelVal.useWindow = true

 of SELECT_WIN:
  isVisibleWin = true
  isButtonPressed = true
  discard ShowWindow(selWindow,SW_SHOW)
  var msg: MSG
  while GetMessage ( addr msg, NULL, 0, 0 ) > 0:
   discard TranslateMessage( addr msg )
   discard DispatchMessage ( addr msg )
 else:
  return

 case mode
 of AREA, SELECT_WIN, ACTIVE_WIN:
  if curSelVal.useWindow:

   discard GetWindowRect(curSelVal.window, addr selWinRc)
   width = selWinRc.BottomRight.x - selWinRc.TopLeft.x
   height = selWinRc.BottomRight.y - selWinRc.TopLeft.y
   hDesktopWnd = GetDesktopWindow()
   hDesktopDC = GetDC(hDesktopWnd)
   hCustomDC = GetDC(curSelVal.window)
   hCaptureDC = CreateCompatibleDC(hCustomDC)
   hCaptureBitmap = CreateCompatibleBitmap(hCustomDC, width, height)
   discard SelectObject(hCaptureDC,hCaptureBitmap)
   discard BitBlt(hCaptureDC, 0,0, width,height, hDesktopDC,
    selWinRc.TopLeft.x, selWinRc.TopLeft.y, SRCCOPY) # selWinRc.TopLeft.x, selWinRc.TopLeft.y


  else:
   hDesktopWnd = GetDesktopWindow()
   hDesktopDC = GetDC(hDesktopWnd)
   hCaptureDC = CreateCompatibleDC(hDesktopDC)
   hCaptureBitmap = CreateCompatibleBitmap(hDesktopDC, curSelVal.width, curSelVal.height)
   width = curSelVal.width
   height = curSelVal.height
   discard SelectObject(hCaptureDC,hCaptureBitmap)
   discard BitBlt(hCaptureDC, 0,0, curSelVal.width, curSelVal.height,
       hDesktopDC, curSelVal.start_x, curSelVal.start_y, SRCCOPY )

 of FULL:
  width = GetSystemMetrics(78)
  height = GetSystemMetrics(79)
  hDesktopWnd = GetDesktopWindow()
  hDesktopDC = GetDC(hDesktopWnd)
  hCaptureDC = CreateCompatibleDC(hDesktopDC)
  hCaptureBitmap = CreateCompatibleBitmap(hDesktopDC, width, height)
  discard SelectObject(hCaptureDC,hCaptureBitmap)
  discard BitBlt(hCaptureDC, 0,0,width,height, hDesktopDC, 0,0,SRCCOPY )

 else: return

 result = nsu_genFilePath(fileName,savePath)
 if not nsu_save_image(result,hCaptureDC,width,height):
  result = ""

 discard ReleaseDC(hDesktopWnd,hDesktopDC)
 if curSelVal.useWindow:
  discard ReleaseDC(curSelVal.window, hCustomDC)
 discard DeleteDC(hCaptureDC)
 discard DeleteObject(hCaptureBitmap)

 curSelVal.clear()
