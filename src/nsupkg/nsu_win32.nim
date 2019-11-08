import strutils, os, times
import flippy
import winim
import nsu_types


const
 NULL: HANDLE = 0

var
 selWindow: HWND
 begPt,endPt,temPt: POINT
 rcSel: RECT
 curSelVal: TSelVal
 isVisibleWin: bool = false
 isButtonPressed: bool = false

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
 ## If no path, save to attempt to save into home/pictures
 var homeDir = getHomeDir()
 var picturesPath = joinPath(homeDir,"Pictures")
 if fileName == "":
  var
   tStamp: string = ""
   iTimeNow: int = getTime().toSeconds().toInt()
  when defined(deprecated):
    let timeNowUtc = getGMTime(fromSeconds(iTimeNow))
    tStamp = format(timeNowUtc,"yyyy-MM-dd-HH'_'mm'_'ss")
  else:
    let timeNowUtc = utc(fromUnix(iTimeNow))
    tStamp = timeNowUtc.format("yyyy-MM-dd-HH'_'mm'_'ss")
  result = joinPath(if savePath == "": picturesPath else: savePath, "$1_$2.png" % [tstamp, "nsu"])
 else:
  result = joinPath(if savePath == "": picturesPath else: savePath, fileName)


proc nsu_save_image(destPath: string, hdc: HDC, hBitmap: HBITMAP, width, height: int): bool =
  var image = newImage(width, height, 4) 

  # setup bmi structure
  var mybmi: BITMAPINFO
  mybmi.bmiHeader.biSize = int32 sizeof(mybmi)
  mybmi.bmiHeader.biWidth = int32 width
  mybmi.bmiHeader.biHeight = int32 height
  mybmi.bmiHeader.biPlanes = 1
  mybmi.bmiHeader.biBitCount = 32
  mybmi.bmiHeader.biCompression = BI_RGB
  mybmi.bmiHeader.biSizeImage = DWORD(width * height * 4.int32)
  
  # copy data from bmi structure to the flippy image
  discard CreateDIBSection(hdc, addr mybmi, DIB_RGB_COLORS, cast[ptr pointer](unsafeAddr(image.data[0])), 0, 0)
  discard GetDIBits(hdc, hBitmap, 0, height.UINT, cast[ptr pointer](unsafeAddr(image.data[0])), addr mybmi, DIB_RGB_COLORS)

  # for some reason windows bitmaps are flipped? flip it back
  image = image.flipVertical()
  # for some reason windows uses BGR, convert it to RGB
  for x in 0 ..< image.width:
    for y in 0 ..< image.height:
      var pixel = image.getRgba(x, y)
      (pixel.r, pixel.g, pixel.b) = (pixel.b, pixel.g, pixel.r)
      image.putRgba(x, y, pixel)

  image.save(destPath)
  return true



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
 discard Rectangle(hdc=hDC, left=rect.left, top=rect.top, right=rect.right, bottom=rect.bottom)

 discard DeleteObject(SelectObject(hDC, hOldPen))
 discard DeleteObject(SelectObject(hDC, hOldBrush))
 discard ReleaseDC(hWnd, hDC);


proc nsuWndProc (hWnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM): LRESULT {.stdcall.} =
 var
  rcClient: RECT

 case uMsg
 of WM_PAINT:
   discard

 of WM_LBUTTONDOWN:
  if isVisibleWin:
   discard ReleaseCapture()
   discard GetCursorPos(addr begPt)
   rcSel.left = LONG(LOWORD(cast[LONG](lParam)))
   rcSel.top = LONG(HIWORD(cast[LONG](lParam)))
   rcSel.right = rcSel.left
   rcSel.bottom = rcSel.top

   discard SetCapture(selWindow)
   isButtonPressed = true

 of WM_MOUSEMOVE:
  if isVisibleWin and isButtonPressed:
   rcSel.right = LONG(LOWORD(cast[LONG](lParam)))
   rcSel.bottom = LONG(HIWORD(cast[LONG](lParam)))

   discard GetClientRect(hWnd, addr rcClient)
   if rcSel.right < 0: rcSel.right = 0
   if rcSel.right > rcClient.right: rcSel.right = rcClient.right
   if rcSel.bottom < 0: rcSel.bottom = 0
   if rcSel.bottom > rcClient.bottom: rcSel.bottom = rcClient.bottom
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
    nsuClassName = "nsuWinClass"
  result = NULL
  let hInstance = GetModuleHandle(nil)

  wc.cbSize = UINT(sizeof(WNDCLASSEX))
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
    stdout.writeLine("[nsu] Failed to setup subwindow ! $1" % [$err])
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
   discard DispatchMessage( addr msg )

 of ACTIVE_WIN:
  curSelVal.window = GetForegroundWindow()
  curSelVal.useWindow = true

 of SELECT_WIN:
  isVisibleWin = true
  isButtonPressed = true
  discard ShowWindow(selWindow,SW_SHOW)
  var msg: MSG
  while GetMessage( addr msg, NULL, 0, 0 ) > 0:
   discard TranslateMessage( addr msg )
   discard DispatchMessage( addr msg )


 case mode
 of AREA, SELECT_WIN, ACTIVE_WIN:
  if curSelVal.useWindow:

   discard GetWindowRect(curSelVal.window, addr selWinRc)
   width = selWinRc.right - selWinRc.left
   height = selWinRc.bottom - selWinRc.top
   hDesktopWnd = GetDesktopWindow()
   hDesktopDC = GetDC(hDesktopWnd)
   hCustomDC = GetDC(curSelVal.window)
   hCaptureDC = CreateCompatibleDC(hCustomDC)
   hCaptureBitmap = CreateCompatibleBitmap(hCustomDC, width, height)
   discard SelectObject(hCaptureDC,hCaptureBitmap)
   discard BitBlt(hCaptureDC, 0,0, width, height, hDesktopDC,
    selWinRc.left, selWinRc.top, SRCCOPY) # selWinRc.TopLeft.x, selWinRc.TopLeft.y


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
  var devModeSettings: DEVMODE
  discard EnumDisplaySettings(nil, ENUM_CURRENT_SETTINGS, addr devModeSettings )
  width = devModeSettings.dmPelsWidth 
  height = devmodeSettings.dmPelsHeight
  hDesktopWnd = GetDesktopWindow()
  hDesktopDC = GetDC(hDesktopWnd)
  hCaptureDC = CreateCompatibleDC(hDesktopDC)
  hCaptureBitmap = CreateCompatibleBitmap(hDesktopDC, width, height)
  discard SelectObject(hCaptureDC,hCaptureBitmap)
  discard BitBlt(hCaptureDC, 0,0,width,height, hDesktopDC, 0,0,SRCCOPY )

 result = nsu_genFilePath(fileName,savePath)
 if not nsu_save_image(result, hCaptureDC, hCaptureBitmap, width, height):
  result = ""

 discard ReleaseDC(hDesktopWnd,hDesktopDC)
 if curSelVal.useWindow:
  discard ReleaseDC(curSelVal.window, hCustomDC)
 discard DeleteDC(hCaptureDC)
 discard DeleteObject(hCaptureBitmap)

 curSelVal.clear()
