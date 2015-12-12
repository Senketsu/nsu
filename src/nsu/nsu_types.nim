
when defined(Windows):
 from windows import HWND
 type
  TSelVal* = tuple
   start_x, start_y, end_x, end_y, width, height: cint
   window: HWND
   useWindow: bool

else:
 type
  TSelVal* = tuple
   start_x, start_y, end_x, end_y, width, height: cint
   window: culong
   useWindow: bool

type
 NsuMode* = enum
  FULL
  AREA
  ACTIVE_WIN
  SELECT_WIN

