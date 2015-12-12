when defined(windows):
  const pnglib = "libpng16-16.dll"
elif defined(macosx):
  const pnglib = "libpng.dylib"
else:
  const pnglib = "libpng.so"


const PNG_LIBPNG_VER_STRING* = "1.6.8"
const PNG_HEADER_VERSION_STRING* = " libpng version 1.6.8 - December 19, 2013\n"
const
  PNG_TRANSFORM_IDENTITY* = 0x0000
  PNG_TRANSFORM_STRIP_16* = 0x0001
  PNG_TRANSFORM_STRIP_ALPHA* = 0x0002
  PNG_TRANSFORM_PACKING* = 0x0004
  PNG_TRANSFORM_PACKSWAP* = 0x0008
  PNG_TRANSFORM_EXPAND* = 0x0010
  PNG_TRANSFORM_INVERT_MONO* = 0x0020
  PNG_TRANSFORM_SHIFT*       = 0x0040
  PNG_TRANSFORM_BGR*         = 0x0080
  PNG_TRANSFORM_SWAP_ALPHA*  = 0x0100
  PNG_TRANSFORM_SWAP_ENDIAN* = 0x0200
  PNG_TRANSFORM_INVERT_ALPHA* = 0x0400
  PNG_TRANSFORM_STRIP_FILLER* = 0x0800
  PNG_TRANSFORM_STRIP_FILLER_BEFORE* = PNG_TRANSFORM_STRIP_FILLER
  PNG_TRANSFORM_STRIP_FILLER_AFTER* = 0x1000
  PNG_TRANSFORM_GRAY_TO_RGB* = 0x2000
  PNG_TRANSFORM_EXPAND_16*   = 0x4000
  PNG_TRANSFORM_SCALE_16*    = 0x8000
  PNG_FLAG_MNG_EMPTY_PLTE*   = 0x01
  PNG_FLAG_MNG_FILTER_64*    = 0x04
  PNG_ALL_MNG_FEATURES*      = 0x05
const
  PNG_COLOR_MASK_PALETTE*    = 1
  PNG_COLOR_MASK_COLOR*      = 2
  PNG_COLOR_MASK_ALPHA*      = 4
  PNG_COLOR_TYPE_GRAY*       = 0
  PNG_COLOR_TYPE_PALETTE*    = (PNG_COLOR_MASK_COLOR or PNG_COLOR_MASK_PALETTE)
  PNG_COLOR_TYPE_RGB*        = (PNG_COLOR_MASK_COLOR)
  PNG_COLOR_TYPE_RGB_ALPHA*  = (PNG_COLOR_MASK_COLOR or PNG_COLOR_MASK_ALPHA)
  PNG_COLOR_TYPE_GRAY_ALPHA* = (PNG_COLOR_MASK_ALPHA)
  PNG_COLOR_TYPE_RGBA*       = PNG_COLOR_TYPE_RGB_ALPHA
  PNG_COLOR_TYPE_GA*         = PNG_COLOR_TYPE_GRAY_ALPHA
const
  PNG_INTERLACE_NONE*        = 0
  PNG_INTERLACE_ADAM7*       = 1
  PNG_INTERLACE_LAST*        = 2
const
  PNG_COMPRESSION_TYPE_BASE* = 0
  PNG_COMPRESSION_TYPE_DEFAULT* = PNG_COMPRESSION_TYPE_BASE
const
  PNG_FILTER_TYPE_BASE*      = 0
  PNG_INTRAPIXEL_DIFFERENCING* = 64
  PNG_FILTER_TYPE_DEFAULT*   = PNG_FILTER_TYPE_BASE
type
  png_uint32* = uint32
  png_double = float64
  png_doublep = ptr float64
  png_struct* = object
  png_structp* = ptr png_struct
  png_structrp* = ptr png_struct
  png_const_structp = ptr png_struct
  png_structpp* = ptr ptr png_struct
  png_const_charp = cstring
  png_byte* = cuchar
  png_bytep* = ptr png_byte
  png_const_bytep = ptr png_byte
  png_bytepp = ptr ptr png_byte
  png_color* = object
    red: png_byte
    green: png_byte
    blue: png_byte
  png_colorp = ptr png_color
  png_color_16* = object
    index: png_byte
    red: png_uint_16
    green: png_uint_16
    blue: png_uint_16
    gray: png_uint_16
  png_color_16p = ptr png_color_16
  png_const_color_16p = ptr png_color_16
  png_color_16_pp = ptr ptr png_color_16
  png_color_8* = object
    red: png_byte
    green: png_byte
    blue: png_byte
    grey: png_byte
    alpha: png_byte
  png_color_8p = ptr png_color_8
  png_color_8pp = ptr ptr png_color_8
  png_alloc_size_t = csize
  png_size_t = csize
  png_voidp = pointer
  png_const_voidp = pointer
  png_uint_16 = uint16
  png_uint_16p = ptr png_uint_16
  png_int_32 = int32
  png_fixed_point = png_int_32
  png_fixed_pointp = ptr png_fixed_point
  png_time* = object
    year: png_uint_16
    month: png_byte
    day: png_byte
    hour: png_byte
    minute: png_byte
    second: png_byte
  png_timep = ptr png_time
  png_charp* = cstring
  png_charpp* = ptr png_charp
  png_info* = object
  png_infop* = ptr png_info
  png_const_infop = ptr png_info
  png_infopp* = ptr ptr png_info
  png_sPLT_entry = object
    red: png_uint_16
    green: png_uint_16
    blue: png_uint_16
    alpha: png_uint_16
    frequency: png_uint_16
  png_sPLT_entryp = ptr png_sPLT_entry
  png_const_sPLT_entryp = ptr png_sPLT_entry
  png_sPLT_entrypp = ptr ptr png_sPLT_entry
  png_sPLT_t = object
    name: png_charp
    depth: png_byte
    entries: png_sPLT_entryp
    nentries: png_int_32
  png_sPLT_tp = ptr png_sPLT_t
  png_const_sPLT_tp = ptr png_sPLT_t
  png_sPLT_tpp = ptr ptr png_sPLT_t
  png_text* = object
    compression*: cint
    key*: png_charp
    text*: png_charp
    text_length*: png_size_t
    itext_length*: png_size_t
    lang*: png_charp
  png_textp* = ref png_text
  png_const_textp = ptr png_text
  png_textpp = ptr ptr png_text
  png_unknown_chunk = object
    name: array[png_byte, 0..4]
    data: ptr png_byte
    size: png_size_t
    location: png_byte
  png_unknown_chunkp = ptr png_unknown_chunk
  png_const_unknown_chunkp = ptr png_unknown_chunk
  png_unknown_chunkpp = ptr ptr png_unknown_chunk
  png_control = object
  png_controlp = ptr png_control
  png_image = object
    opaque: png_controlp
    version: png_uint_32
    width: png_uint_32
    height: png_uint_32
    format: png_uint_32
    flags: png_uint_32
    colormap_entries: png_uint_32
    warning_or_error: png_uint_32
    message: array[cchar, 0..63]
  png_imagep = ptr png_image
  png_const_imagep = ptr png_image
  png_imagepp = ptr ptr png_image
  png_row_info = object
    width: png_uint_32
    rowbytes: png_size_t
    color_depth: png_byte
    bit_depth: png_byte
    channels: png_byte
    pixel_depth: png_byte
  png_row_infop = ptr png_row_info
  png_row_infopp = ptr ptr png_row_info
  png_const_row_infop = ptr png_row_info
  png_error_ptr = proc(struct: png_structp, errstring: png_const_charp) {.cdecl.}
  png_rw_ptr = proc(struct: png_structp; data: png_bytep, size: png_size_t) {.cdecl.}
  png_flush_ptr = proc(struct: png_structp) {.cdecl.}
  png_read_status_ptr = proc(struct: png_structp; uintv: png_uint_32; intv: cint) {.cdecl.}
  png_write_status_ptr = proc(struct: png_structp; uintv: png_uint_32; intv: cint) {.cdecl.}
  png_progressive_info_ptr = proc(struct: png_structp; info: png_infop) {.cdecl.}
  png_progressive_end_ptr = proc(struct: png_structp; info: png_infop) {.cdecl.}
  png_progressive_frame_ptr = proc(struct: png_structp; frame: png_uint_32) {.cdecl.}
  png_progressive_row_ptr = proc(struct: png_structp; data: png_bytep; row_num: png_uint_32; pass: cint) {.cdecl.}
  png_user_transform_ptr = proc(struct: png_structp; rinfo: png_row_infop; data: png_bytep) {.cdecl.}
  png_user_chunk_ptr = proc(struct: png_structp; uchnkp: png_unknown_chunkp): int {.cdecl.}
  png_malloc_ptr = proc(struct: png_structp, size: png_alloc_size_t): png_voidp {.cdecl.}
  png_free_ptr = proc(struct: png_structp, voidp: png_voidp) {.cdecl.}
proc png_access_version_number*(): png_uint_32 {.cdecl,
    importc: "png_access_version_number", dynlib: pnglib.}
proc png_benign_error*(png_ptr: png_structp; error: png_const_charp) {.cdecl,
    importc: "png_benign_error", dynlib: pnglib.}
proc png_build_grayscale_palette*(bit_depth: cint; palette: png_colorp) {.cdecl,
    importc: "png_build_grayscale_palette", dynlib: pnglib.}
proc png_calloc*(png_ptr: png_structp; size: png_alloc_size_t): png_voidp {.
    cdecl, importc: "png_calloc", dynlib: pnglib.}
proc png_chunk_benign_error*(png_ptr: png_structp; error: png_const_charp) {.
    cdecl, importc: "png_chunk_benign_error", dynlib: pnglib.}
proc png_chunk_error*(png_ptr: png_structp; error: png_const_charp) {.cdecl,
    importc: "png_chunk_error", dynlib: pnglib.}
proc png_chunk_warning*(png_ptr: png_structp; message: png_const_charp) {.cdecl,
    importc: "png_chunk_warning", dynlib: pnglib.}
# void png_convert_from_struct_tm (png_timep ptime, struct tm FAR * ttime);

#proc png_convert_from_time_t*(ptime: png_timep; ttime: time_t) {.cdecl,
#    importc: "png_convert_from_time_t", dynlib: pnglib.}
proc png_convert_to_rfc1123*(png_ptr: png_structp; ptime: png_timep): png_charp {.
    cdecl, importc: "png_convert_to_rfc1123", dynlib: pnglib.}
proc png_create_info_struct*(png_ptr: png_structp): png_infop {.cdecl,
    importc: "png_create_info_struct", dynlib: pnglib.}
proc png_create_read_struct*(user_png_ver: png_const_charp;
                             error_ptr: png_voidp; error_fn: png_error_ptr;
                             warn_fn: png_error_ptr): png_structp {.cdecl,
    importc: "png_create_read_struct", dynlib: pnglib.}
proc png_create_read_struct_2*(user_png_ver: png_const_charp;
                               error_ptr: png_voidp; error_fn: png_error_ptr;
                               warn_fn: png_error_ptr; mem_ptr: png_voidp;
                               malloc_fn: png_malloc_ptr; free_fn: png_free_ptr): png_structp {.
    cdecl, importc: "png_create_read_struct_2", dynlib: pnglib.}
proc png_create_write_struct*(user_png_ver: png_const_charp;
                              error_ptr: png_voidp; error_fn: png_error_ptr;
                              warn_fn: png_error_ptr): png_structp {.cdecl,
    importc: "png_create_write_struct", dynlib: pnglib.}
proc png_create_write_struct_2*(user_png_ver: png_const_charp;
                                error_ptr: png_voidp; error_fn: png_error_ptr;
                                warn_fn: png_error_ptr; mem_ptr: png_voidp;
                                malloc_fn: png_malloc_ptr; free_fn: png_free_ptr): png_structp {.
    cdecl, importc: "png_create_write_struct_2", dynlib: pnglib.}
proc png_data_freer*(png_ptr: png_structp; info_ptr: png_infop; freer: cint;
                     mask: png_uint_32) {.cdecl, importc: "png_data_freer",
    dynlib: pnglib.}
proc png_destroy_info_struct*(png_ptr: png_structp; info_ptr_ptr: png_infopp) {.
    cdecl, importc: "png_destroy_info_struct", dynlib: pnglib.}
proc png_destroy_read_struct*(png_ptr_ptr: png_structpp;
                              info_ptr_ptr: png_infopp;
                              end_info_ptr_ptr: png_infopp) {.cdecl,
    importc: "png_destroy_read_struct", dynlib: pnglib.}
proc png_destroy_write_struct*(png_ptr_ptr: png_structpp;
                               info_ptr_ptr: png_infopp) {.cdecl,
    importc: "png_destroy_write_struct", dynlib: pnglib.}
proc png_error*(png_ptr: png_structp) {.cdecl, importc: "png_error", dynlib: pnglib.}
proc png_error*(png_ptr: png_structp; error: png_const_charp) {.cdecl,
    importc: "png_error", dynlib: pnglib.}
proc png_free*(png_ptr: png_structp; vptr: png_voidp) {.cdecl,
    importc: "png_free", dynlib: pnglib.}
#this function appears in the documentation but is not exported from libpng.so on
#my system
#proc png_free_chunk_list*(png_ptr: png_structp) {.cdecl,
#    importc: "png_free_chunk_list", dynlib: pnglib.}
proc png_free_default*(png_ptr: png_structp; vptr: png_voidp) {.cdecl,
    importc: "png_free_default", dynlib: pnglib.}
proc png_free_data*(png_ptr: png_structp; info_ptr: png_infop; num: cint) {.
    cdecl, importc: "png_free_data", dynlib: pnglib.}
proc png_get_bit_depth*(png_ptr: png_const_structp; info_ptr: png_const_infop): png_byte {.
    cdecl, importc: "png_get_bit_depth", dynlib: pnglib.}
proc png_get_bKGD*(png_ptr: png_const_structp; info_ptr: png_infop;
                   background: ptr png_color_16p): png_uint_32 {.cdecl,
    importc: "png_get_bKGD", dynlib: pnglib.}
proc png_get_channels*(png_ptr: png_const_structp; info_ptr: png_const_infop): png_byte {.
    cdecl, importc: "png_get_channels", dynlib: pnglib.}
proc png_get_cHRM*(png_ptr: png_const_structp; info_ptr: png_const_infop;
                   white_x: ptr cdouble; white_y: ptr cdouble;
                   red_x: ptr cdouble; red_y: ptr cdouble; green_x: ptr cdouble;
                   green_y: ptr cdouble; blue_x: ptr cdouble;
                   blue_y: ptr cdouble): png_uint_32 {.cdecl,
    importc: "png_get_cHRM", dynlib: pnglib.}
proc png_get_cHRM_fixed*(png_ptr: png_const_structp; info_ptr: png_const_infop;
                         white_x: ptr png_uint_32; white_y: ptr png_uint_32;
                         red_x: ptr png_uint_32; red_y: ptr png_uint_32;
                         green_x: ptr png_uint_32; green_y: ptr png_uint_32;
                         blue_x: ptr png_uint_32; blue_y: ptr png_uint_32): png_uint_32 {.
    cdecl, importc: "png_get_cHRM_fixed", dynlib: pnglib.}
proc png_get_cHRM_XYZ*(png_ptr: png_structp; info_ptr: png_const_infop;
                       red_X: ptr cdouble; red_Y: ptr cdouble;
                       red_Z: ptr cdouble; green_X: ptr cdouble;
                       green_Y: ptr cdouble; green_Z: ptr cdouble;
                       blue_X: ptr cdouble; blue_Y: ptr cdouble;
                       blue_Z: ptr cdouble): png_uint_32 {.cdecl,
    importc: "png_get_cHRM_XYZ", dynlib: pnglib.}
proc png_get_cHRM_XYZ_fixed*(png_ptr: png_structp; info_ptr: png_const_infop;
                             int_red_X: ptr png_fixed_point;
                             int_red_Y: ptr png_fixed_point;
                             int_red_Z: ptr png_fixed_point;
                             int_green_X: ptr png_fixed_point;
                             int_green_Y: ptr png_fixed_point;
                             int_green_Z: ptr png_fixed_point;
                             int_blue_X: ptr png_fixed_point;
                             int_blue_Y: ptr png_fixed_point;
                             int_blue_Z: ptr png_fixed_point): png_uint_32 {.
    cdecl, importc: "png_get_cHRM_XYZ_fixed", dynlib: pnglib.}
proc png_get_chunk_cache_max*(png_ptr: png_const_structp): png_uint_32 {.cdecl,
    importc: "png_get_chunk_cache_max", dynlib: pnglib.}
proc png_get_chunk_malloc_max*(png_ptr: png_const_structp): png_alloc_size_t {.
    cdecl, importc: "png_get_chunk_malloc_max", dynlib: pnglib.}
proc png_get_color_type*(png_ptr: png_const_structp; info_ptr: png_const_infop): png_byte {.
    cdecl, importc: "png_get_color_type", dynlib: pnglib.}
proc png_get_compression_buffer_size*(png_ptr: png_const_structp): png_uint_32 {.
    cdecl, importc: "png_get_compression_buffer_size", dynlib: pnglib.}
proc png_get_compression_type*(png_ptr: png_const_structp;
                               info_ptr: png_const_infop): png_byte {.cdecl,
    importc: "png_get_compression_type", dynlib: pnglib.}
proc png_get_copyright*(png_ptr: png_const_structp): png_byte {.cdecl,
    importc: "png_get_copyright", dynlib: pnglib.}
proc png_get_current_row_number*(a2: png_const_structp): png_uint_32 {.cdecl,
    importc: "png_get_current_row_number", dynlib: pnglib.}
proc png_get_current_pass_number*(a2: png_const_structp): png_byte {.cdecl,
    importc: "png_get_current_pass_number", dynlib: pnglib.}
proc png_get_error_ptr*(png_ptr: png_const_structp): png_voidp {.cdecl,
    importc: "png_get_error_ptr", dynlib: pnglib.}
proc png_get_filter_type*(png_ptr: png_const_structp; info_ptr: png_const_infop): png_byte {.
    cdecl, importc: "png_get_filter_type", dynlib: pnglib.}
proc png_get_gAMA*(png_ptr: png_const_structp; info_ptr: png_const_infop;
                   file_gamma: ptr cdouble): png_uint_32 {.cdecl,
    importc: "png_get_gAMA", dynlib: pnglib.}
proc png_get_gAMA_fixed*(png_ptr: png_const_structp; info_ptr: png_const_infop;
                         int_file_gamma: ptr png_uint_32): png_uint_32 {.cdecl,
    importc: "png_get_gAMA_fixed", dynlib: pnglib.}
proc png_get_header_ver*(png_ptr: png_const_structp): png_byte {.cdecl,
    importc: "png_get_header_ver", dynlib: pnglib.}
proc png_get_header_version*(png_ptr: png_const_structp): png_byte {.cdecl,
    importc: "png_get_header_version", dynlib: pnglib.}
proc png_get_hIST*(png_ptr: png_const_structp; info_ptr: png_const_infop;
                   hist: ptr png_uint_16p): png_uint_32 {.cdecl,
    importc: "png_get_hIST", dynlib: pnglib.}
proc png_get_iCCP*(png_ptr: png_const_structp; info_ptr: png_const_infop;
                   name: png_charpp; compression_type: ptr cint;
                   profile: png_bytepp; proflen: ptr png_uint_32): png_uint_32 {.
    cdecl, importc: "png_get_iCCP", dynlib: pnglib.}
proc png_get_IHDR*(png_ptr: png_structp; info_ptr: png_infop;
                   width: ptr png_uint_32; height: ptr png_uint_32;
                   bit_depth: ptr cint; color_type: ptr cint;
                   interlace_type: ptr cint; compression_type: ptr cint;
                   filter_type: ptr cint): png_uint_32 {.cdecl,
    importc: "png_get_IHDR", dynlib: pnglib.}
proc png_get_image_height*(png_ptr: png_const_structp; info_ptr: png_const_infop): png_uint_32 {.
    cdecl, importc: "png_get_image_height", dynlib: pnglib.}
proc png_get_image_width*(png_ptr: png_const_structp; info_ptr: png_const_infop): png_uint_32 {.
    cdecl, importc: "png_get_image_width", dynlib: pnglib.}
proc png_get_int_32*(buf: png_bytep): png_int_32 {.cdecl,
    importc: "png_get_int_32", dynlib: pnglib.}
proc png_get_interlace_type*(png_ptr: png_const_structp;
                             info_ptr: png_const_infop): png_byte {.cdecl,
    importc: "png_get_interlace_type", dynlib: pnglib.}
proc png_get_io_chunk_type*(png_ptr: png_const_structp): png_uint_32 {.cdecl,
    importc: "png_get_io_chunk_type", dynlib: pnglib.}
proc png_get_io_ptr*(png_ptr: png_structp): png_voidp {.cdecl,
    importc: "png_get_io_ptr", dynlib: pnglib.}
proc png_get_io_state*(png_ptr: png_structp): png_uint_32 {.cdecl,
    importc: "png_get_io_state", dynlib: pnglib.}
proc png_get_libpng_ver*(png_ptr: png_const_structp): png_byte {.cdecl,
    importc: "png_get_libpng_ver", dynlib: pnglib.}
proc png_get_mem_ptr*(png_ptr: png_const_structp): png_voidp {.cdecl,
    importc: "png_get_mem_ptr", dynlib: pnglib.}
proc png_get_oFFs*(png_ptr: png_const_structp; info_ptr: png_const_infop;
                   offset_x: ptr png_uint_32; offset_y: ptr png_uint_32;
                   unit_type: ptr cint): png_uint_32 {.cdecl,
    importc: "png_get_oFFs", dynlib: pnglib.}
proc png_get_pCAL*(png_ptr: png_const_structp; info_ptr: png_const_infop;
                   purpose: ptr png_charp; X0: ptr png_int_32;
                   X1: ptr png_int_32; itype: ptr cint; nparams: ptr cint;
                   units: ptr png_charp; params: ptr png_charpp): png_uint_32 {.
    cdecl, importc: "png_get_pCAL", dynlib: pnglib.}
proc png_get_pHYs*(png_ptr: png_const_structp; info_ptr: png_const_infop;
                   res_x: ptr png_uint_32; res_y: ptr png_uint_32;
                   unit_type: ptr cint): png_uint_32 {.cdecl,
    importc: "png_get_pHYs", dynlib: pnglib.}
proc png_get_pixel_aspect_ratio*(png_ptr: png_const_structp;
                                 info_ptr: png_const_infop): cfloat {.cdecl,
    importc: "png_get_pixel_aspect_ratio", dynlib: pnglib.}
proc png_get_pHYs_dpi*(png_ptr: png_const_structp; info_ptr: png_const_infop;
                       res_x: ptr png_uint_32; res_y: ptr png_uint_32;
                       unit_type: ptr cint): png_uint_32 {.cdecl,
    importc: "png_get_pHYs_dpi", dynlib: pnglib.}
proc png_get_pixel_aspect_ratio_fixed*(png_ptr: png_const_structp;
                                       info_ptr: png_const_infop): png_fixed_point {.
    cdecl, importc: "png_get_pixel_aspect_ratio_fixed", dynlib: pnglib.}
proc png_get_pixels_per_inch*(png_ptr: png_const_structp;
                              info_ptr: png_const_infop): png_uint_32 {.cdecl,
    importc: "png_get_pixels_per_inch", dynlib: pnglib.}
proc png_get_pixels_per_meter*(png_ptr: png_const_structp;
                               info_ptr: png_const_infop): png_uint_32 {.cdecl,
    importc: "png_get_pixels_per_meter", dynlib: pnglib.}
proc png_get_progressive_ptr*(png_ptr: png_const_structp): png_voidp {.cdecl,
    importc: "png_get_progressive_ptr", dynlib: pnglib.}
proc png_get_PLTE*(png_ptr: png_const_structp; info_ptr: png_const_infop;
                   palette: ptr png_colorp; num_palette: ptr cint): png_uint_32 {.
    cdecl, importc: "png_get_PLTE", dynlib: pnglib.}
proc png_get_rgb_to_gray_status*(png_ptr: png_const_structp): png_byte {.cdecl,
    importc: "png_get_rgb_to_gray_status", dynlib: pnglib.}
proc png_get_rowbytes*(png_ptr: png_const_structp; info_ptr: png_const_infop): png_uint_32 {.
    cdecl, importc: "png_get_rowbytes", dynlib: pnglib.}
proc png_get_rows*(png_ptr: png_const_structp; info_ptr: png_const_infop): png_bytepp {.
    cdecl, importc: "png_get_rows", dynlib: pnglib.}
proc png_get_sBIT*(png_ptr: png_const_structp; info_ptr: png_infop;
                   sig_bit: ptr png_color_8p): png_uint_32 {.cdecl,
    importc: "png_get_sBIT", dynlib: pnglib.}
proc png_get_sCAL*(png_ptr: png_const_structp; info_ptr: png_const_infop;
                   unit: ptr cint; width: ptr cdouble; height: ptr cdouble) {.
    cdecl, importc: "png_get_sCAL", dynlib: pnglib.}
proc png_get_sCAL_fixed*(png_ptr: png_const_structp; info_ptr: png_const_infop;
                         unit: ptr cint; width: png_fixed_pointp;
                         height: png_fixed_pointp) {.cdecl,
    importc: "png_get_sCAL_fixed", dynlib: pnglib.}
proc png_get_sCAL_s*(png_ptr: png_const_structp; info_ptr: png_const_infop;
                     unit: ptr cint; width: png_charpp; height: png_charpp) {.
    cdecl, importc: "png_get_sCAL_s", dynlib: pnglib.}
proc png_get_signature*(png_ptr: png_const_structp; info_ptr: png_infop): png_bytep {.
    cdecl, importc: "png_get_signature", dynlib: pnglib.}
proc png_get_sPLT*(png_ptr: png_const_structp; info_ptr: png_const_infop;
                   splt_ptr: ptr png_sPLT_tp): png_uint_32 {.cdecl,
    importc: "png_get_sPLT", dynlib: pnglib.}
proc png_get_sRGB*(png_ptr: png_const_structp; info_ptr: png_const_infop;
                   file_srgb_intent: ptr cint): png_uint_32 {.cdecl,
    importc: "png_get_sRGB", dynlib: pnglib.}
proc png_get_text*(png_ptr: png_const_structp; info_ptr: png_const_infop;
                   text_ptr: ptr png_textp; num_text: ptr cint): png_uint_32 {.
    cdecl, importc: "png_get_text", dynlib: pnglib.}
proc png_get_tIME*(png_ptr: png_const_structp; info_ptr: png_infop;
                   mod_time: ptr png_timep): png_uint_32 {.cdecl,
    importc: "png_get_tIME", dynlib: pnglib.}
proc png_get_tRNS*(png_ptr: png_const_structp; info_ptr: png_infop;
                   trans_alpha: ptr png_bytep; num_trans: ptr cint;
                   trans_color: ptr png_color_16p): png_uint_32 {.cdecl,
    importc: "png_get_tRNS", dynlib: pnglib.}
# This function is really an inline macro.

proc png_get_uint_16*(buf: png_bytep): png_uint_16 {.cdecl,
    importc: "png_get_uint_16", dynlib: pnglib.}
proc png_get_uint_31*(png_ptr: png_structp; buf: png_bytep): png_uint_32 {.
    cdecl, importc: "png_get_uint_31", dynlib: pnglib.}
# This function is really an inline macro.

proc png_get_uint_32*(buf: png_bytep): png_uint_32 {.cdecl,
    importc: "png_get_uint_32", dynlib: pnglib.}
proc png_get_unknown_chunks*(png_ptr: png_const_structp;
                             info_ptr: png_const_infop;
                             unknowns: png_unknown_chunkpp): png_uint_32 {.
    cdecl, importc: "png_get_unknown_chunks", dynlib: pnglib.}
proc png_get_user_chunk_ptr*(png_ptr: png_const_structp): png_voidp {.cdecl,
    importc: "png_get_user_chunk_ptr", dynlib: pnglib.}
proc png_get_user_height_max*(png_ptr: png_const_structp): png_uint_32 {.cdecl,
    importc: "png_get_user_height_max", dynlib: pnglib.}
proc png_get_user_transform_ptr*(png_ptr: png_const_structp): png_voidp {.cdecl,
    importc: "png_get_user_transform_ptr", dynlib: pnglib.}
proc png_get_user_width_max*(png_ptr: png_const_structp): png_uint_32 {.cdecl,
    importc: "png_get_user_width_max", dynlib: pnglib.}
proc png_get_valid*(png_ptr: png_const_structp; info_ptr: png_const_infop;
                    flag: png_uint_32): png_uint_32 {.cdecl,
    importc: "png_get_valid", dynlib: pnglib.}
proc png_get_x_offset_inches*(png_ptr: png_const_structp;
                              info_ptr: png_const_infop): cfloat {.cdecl,
    importc: "png_get_x_offset_inches", dynlib: pnglib.}
proc png_get_x_offset_inches_fixed*(png_ptr: png_structp;
                                    info_ptr: png_const_infop): png_fixed_point {.
    cdecl, importc: "png_get_x_offset_inches_fixed", dynlib: pnglib.}
proc png_get_x_offset_microns*(png_ptr: png_const_structp;
                               info_ptr: png_const_infop): png_int_32 {.cdecl,
    importc: "png_get_x_offset_microns", dynlib: pnglib.}
proc png_get_x_offset_pixels*(png_ptr: png_const_structp;
                              info_ptr: png_const_infop): png_int_32 {.cdecl,
    importc: "png_get_x_offset_pixels", dynlib: pnglib.}
proc png_get_x_pixels_per_inch*(png_ptr: png_const_structp;
                                info_ptr: png_const_infop): png_uint_32 {.cdecl,
    importc: "png_get_x_pixels_per_inch", dynlib: pnglib.}
proc png_get_x_pixels_per_meter*(png_ptr: png_const_structp;
                                 info_ptr: png_const_infop): png_uint_32 {.
    cdecl, importc: "png_get_x_pixels_per_meter", dynlib: pnglib.}
proc png_get_y_offset_inches*(png_ptr: png_const_structp;
                              info_ptr: png_const_infop): cfloat {.cdecl,
    importc: "png_get_y_offset_inches", dynlib: pnglib.}
proc png_get_y_offset_inches_fixed*(png_ptr: png_structp;
                                    info_ptr: png_const_infop): png_fixed_point {.
    cdecl, importc: "png_get_y_offset_inches_fixed", dynlib: pnglib.}
proc png_get_y_offset_microns*(png_ptr: png_const_structp;
                               info_ptr: png_const_infop): png_int_32 {.cdecl,
    importc: "png_get_y_offset_microns", dynlib: pnglib.}
proc png_get_y_offset_pixels*(png_ptr: png_const_structp;
                              info_ptr: png_const_infop): png_int_32 {.cdecl,
    importc: "png_get_y_offset_pixels", dynlib: pnglib.}
proc png_get_y_pixels_per_inch*(png_ptr: png_const_structp;
                                info_ptr: png_const_infop): png_uint_32 {.cdecl,
    importc: "png_get_y_pixels_per_inch", dynlib: pnglib.}
proc png_get_y_pixels_per_meter*(png_ptr: png_const_structp;
                                 info_ptr: png_const_infop): png_uint_32 {.
    cdecl, importc: "png_get_y_pixels_per_meter", dynlib: pnglib.}
proc png_handle_as_unknown*(png_ptr: png_structp; chunk_name: png_bytep): cint {.
    cdecl, importc: "png_handle_as_unknown", dynlib: pnglib.}
proc png_image_begin_read_from_file*(image: png_imagep; file_name: cstring): cint {.
    cdecl, importc: "png_image_begin_read_from_file", dynlib: pnglib.}
proc png_image_begin_read_from_stdio*(image: png_imagep; file: TFile): cint {.
    cdecl, importc: "png_image_begin_read_from_stdio", dynlib: pnglib.}
proc png_image_begin_read_from_memory*(image: png_imagep;
                                       memory: png_const_voidp; size: png_size_t): cint {.
    cdecl, importc: "png_image_begin_read_from_memory", dynlib: pnglib.}
proc png_image_finish_read*(image: png_imagep; background: png_colorp;
                            buffer: pointer; row_stride: png_int_32;
                            colormap: pointer): cint {.cdecl,
    importc: "png_image_finish_read", dynlib: pnglib.}
proc png_image_free*(image: png_imagep) {.cdecl, importc: "png_image_free",
    dynlib: pnglib.}
proc png_image_write_to_file*(image: png_imagep; file: cstring;
                              convert_to_8bit: cint; buffer: pointer;
                              row_stride: png_int_32; colormap: pointer): cint {.
    cdecl, importc: "png_image_write_to_file", dynlib: pnglib.}
proc png_image_write_to_stdio*(image: png_imagep; file: TFile;
                               convert_to_8_bit: cint; buffer: pointer;
                               row_stride: png_int_32; colormap: pointer): cint {.
    cdecl, importc: "png_image_write_to_stdio", dynlib: pnglib.}
proc png_info_init_3*(info_ptr: png_infopp; png_info_struct_size: png_size_t) {.
    cdecl, importc: "png_info_init_3", dynlib: pnglib.}
proc png_init_io*(png_ptr: png_structp; fp: TFile) {.cdecl,
    importc: "png_init_io", dynlib: pnglib.}
proc png_longjmp*(png_ptr: png_structp; val: cint) {.cdecl,
    importc: "png_longjmp", dynlib: pnglib.}
proc png_malloc*(png_ptr: png_structp; size: png_alloc_size_t): png_voidp {.
    cdecl, importc: "png_malloc", dynlib: pnglib.}
proc png_malloc_default*(png_ptr: png_structp; size: png_alloc_size_t): png_voidp {.
    cdecl, importc: "png_malloc_default", dynlib: pnglib.}
proc png_malloc_warn*(png_ptr: png_structp; size: png_alloc_size_t): png_voidp {.
    cdecl, importc: "png_malloc_warn", dynlib: pnglib.}
proc png_permit_mng_features*(png_ptr: png_structp;
                              mng_features_permitted: png_uint_32): png_uint_32 {.
    cdecl, importc: "png_permit_mng_features", dynlib: pnglib.}
proc png_process_data*(png_ptr: png_structp; info_ptr: png_infop;
                       buffer: png_bytep; buffer_size: png_size_t) {.cdecl,
    importc: "png_process_data", dynlib: pnglib.}
proc png_process_data_pause*(a2: png_structp; save: cint): png_size_t {.cdecl,
    importc: "png_process_data_pause", dynlib: pnglib.}
proc png_process_data_skip*(a2: png_structp): png_uint_32 {.cdecl,
    importc: "png_process_data_skip", dynlib: pnglib.}
proc png_progressive_combine_row*(png_ptr: png_structp; old_row: png_bytep;
                                  new_row: png_bytep) {.cdecl,
    importc: "png_progressive_combine_row", dynlib: pnglib.}
proc png_read_end*(png_ptr: png_structp; info_ptr: png_infop) {.cdecl,
    importc: "png_read_end", dynlib: pnglib.}
proc png_read_image*(png_ptr: png_structp; image: png_bytepp) {.cdecl,
    importc: "png_read_image", dynlib: pnglib.}
proc png_read_info*(png_ptr: png_structp; info_ptr: png_infop) {.cdecl,
    importc: "png_read_info", dynlib: pnglib.}
proc png_read_png*(png_ptr: png_structp; info_ptr: png_infop; transforms: cint;
                   params: png_voidp) {.cdecl, importc: "png_read_png",
                                        dynlib: pnglib.}
proc png_read_row*(png_ptr: png_structp; row: png_bytep; display_row: png_bytep) {.
    cdecl, importc: "png_read_row", dynlib: pnglib.}
proc png_read_rows*(png_ptr: png_structp; row: png_bytepp;
                    display_row: png_bytepp; num_rows: png_uint_32) {.cdecl,
    importc: "png_read_rows", dynlib: pnglib.}
proc png_read_update_info*(png_ptr: png_structp; info_ptr: png_infop) {.cdecl,
    importc: "png_read_update_info", dynlib: pnglib.}
proc png_reset_zstream*(png_ptr: png_structp): cint {.cdecl,
    importc: "png_reset_zstream", dynlib: pnglib.}
proc png_save_int_32*(buf: png_bytep; i: png_int_32) {.cdecl,
    importc: "png_save_int_32", dynlib: pnglib.}
proc png_save_uint_16*(buf: png_bytep; i: cuint) {.cdecl,
    importc: "png_save_uint_16", dynlib: pnglib.}
proc png_save_uint_32*(buf: png_bytep; i: png_uint_32) {.cdecl,
    importc: "png_save_uint_32", dynlib: pnglib.}
proc png_set_add_alpha*(png_ptr: png_structp; filler: png_uint_32; flags: cint) {.
    cdecl, importc: "png_set_add_alpha", dynlib: pnglib.}
proc png_set_alpha_mode*(png_ptr: png_structp; mode: cint; output_gamma: cdouble) {.
    cdecl, importc: "png_set_alpha_mode", dynlib: pnglib.}
proc png_set_alpha_mode_fixed*(png_ptr: png_structp; mode: cint;
                               output_gamma: png_fixed_point) {.cdecl,
    importc: "png_set_alpha_mode_fixed", dynlib: pnglib.}
proc png_set_background*(png_ptr: png_structp; background_color: png_color_16p;
                         background_gamma_code: cint; need_expand: cint;
                         background_gamma: cdouble) {.cdecl,
    importc: "png_set_background", dynlib: pnglib.}
proc png_set_background_fixed*(png_ptr: png_structp;
                               background_color: png_color_16p;
                               background_gamma_code: cint; need_expand: cint;
                               background_gamma: png_uint_32) {.cdecl,
    importc: "png_set_background_fixed", dynlib: pnglib.}
proc png_set_benign_errors*(png_ptr: png_structp; allowed: cint) {.cdecl,
    importc: "png_set_benign_errors", dynlib: pnglib.}
proc png_set_bgr*(png_ptr: png_structp) {.cdecl, importc: "png_set_bgr",
    dynlib: pnglib.}
proc png_set_bKGD*(png_ptr: png_structp; info_ptr: png_infop;
                   background: png_color_16p) {.cdecl, importc: "png_set_bKGD",
    dynlib: pnglib.}
proc png_set_check_for_invalid_index*(png_ptr: png_structrp; allowed: cint) {.
    cdecl, importc: "png_set_check_for_invalid_index", dynlib: pnglib.}
proc png_set_cHRM*(png_ptr: png_structp; info_ptr: png_infop; white_x: cdouble;
                   white_y: cdouble; red_x: cdouble; red_y: cdouble;
                   green_x: cdouble; green_y: cdouble; blue_x: cdouble;
                   blue_y: cdouble) {.cdecl, importc: "png_set_cHRM",
                                      dynlib: pnglib.}
proc png_set_cHRM_fixed*(png_ptr: png_structp; info_ptr: png_infop;
                         white_x: png_uint_32; white_y: png_uint_32;
                         red_x: png_uint_32; red_y: png_uint_32;
                         green_x: png_uint_32; green_y: png_uint_32;
                         blue_x: png_uint_32; blue_y: png_uint_32) {.cdecl,
    importc: "png_set_cHRM_fixed", dynlib: pnglib.}
proc png_set_cHRM_XYZ*(png_ptr: png_structp; info_ptr: png_infop;
                       red_X: cdouble; red_Y: cdouble; red_Z: cdouble;
                       green_X: cdouble; green_Y: cdouble; green_Z: cdouble;
                       blue_X: cdouble; blue_Y: cdouble; blue_Z: cdouble) {.
    cdecl, importc: "png_set_cHRM_XYZ", dynlib: pnglib.}
proc png_set_cHRM_XYZ_fixed*(png_ptr: png_structp; info_ptr: png_infop;
                             int_red_X: png_fixed_point;
                             int_red_Y: png_fixed_point;
                             int_red_Z: png_fixed_point;
                             int_green_X: png_fixed_point;
                             int_green_Y: png_fixed_point;
                             int_green_Z: png_fixed_point;
                             int_blue_X: png_fixed_point;
                             int_blue_Y: png_fixed_point;
                             int_blue_Z: png_fixed_point) {.cdecl,
    importc: "png_set_cHRM_XYZ_fixed", dynlib: pnglib.}
proc png_set_chunk_cache_max*(png_ptr: png_structp;
                              user_chunk_cache_max: png_uint_32) {.cdecl,
    importc: "png_set_chunk_cache_max", dynlib: pnglib.}
proc png_set_compression_level*(png_ptr: png_structp; level: cint) {.cdecl,
    importc: "png_set_compression_level", dynlib: pnglib.}
proc png_set_compression_mem_level*(png_ptr: png_structp; mem_level: cint) {.
    cdecl, importc: "png_set_compression_mem_level", dynlib: pnglib.}
proc png_set_compression_method*(png_ptr: png_structp; imethod: cint) {.cdecl,
    importc: "png_set_compression_method", dynlib: pnglib.}
proc png_set_compression_strategy*(png_ptr: png_structp; strategy: cint) {.
    cdecl, importc: "png_set_compression_strategy", dynlib: pnglib.}
proc png_set_compression_window_bits*(png_ptr: png_structp; window_bits: cint) {.
    cdecl, importc: "png_set_compression_window_bits", dynlib: pnglib.}
proc png_set_crc_action*(png_ptr: png_structp; crit_action: cint;
                         ancil_action: cint) {.cdecl,
    importc: "png_set_crc_action", dynlib: pnglib.}
proc png_set_error_fn*(png_ptr: png_structp; error_ptr: png_voidp;
                       error_fn: png_error_ptr; warning_fn: png_error_ptr) {.
    cdecl, importc: "png_set_error_fn", dynlib: pnglib.}
proc png_set_expand*(png_ptr: png_structp) {.cdecl, importc: "png_set_expand",
    dynlib: pnglib.}
proc png_set_expand_16*(png_ptr: png_structp) {.cdecl,
    importc: "png_set_expand_16", dynlib: pnglib.}
proc png_set_expand_gray_1_2_4_to_8*(png_ptr: png_structp) {.cdecl,
    importc: "png_set_expand_gray_1_2_4_to_8", dynlib: pnglib.}
proc png_set_filler*(png_ptr: png_structp; filler: png_uint_32; flags: cint) {.
    cdecl, importc: "png_set_filler", dynlib: pnglib.}
proc png_set_filter*(png_ptr: png_structp; imethod: cint; filters: cint) {.cdecl,
    importc: "png_set_filter", dynlib: pnglib.}
proc png_set_filter_heuristics*(png_ptr: png_structp; heuristic_method: cint;
                                num_weights: cint; filter_weights: png_doublep;
                                filter_costs: png_doublep) {.cdecl,
    importc: "png_set_filter_heuristics", dynlib: pnglib.}
proc png_set_filter_heuristics_fixed*(png_ptr: png_structp;
                                      heuristic_method: cint; num_weights: cint;
                                      filter_weights: png_fixed_point_p;
                                      filter_costs: png_fixed_point_p) {.cdecl,
    importc: "png_set_filter_heuristics_fixed", dynlib: pnglib.}
proc png_set_flush*(png_ptr: png_structp; nrows: cint) {.cdecl,
    importc: "png_set_flush", dynlib: pnglib.}
proc png_set_gamma*(png_ptr: png_structp; screen_gamma: cdouble;
                    default_file_gamma: cdouble) {.cdecl,
    importc: "png_set_gamma", dynlib: pnglib.}
proc png_set_gamma_fixed*(png_ptr: png_structp; screen_gamma: png_uint_32;
                          default_file_gamma: png_uint_32) {.cdecl,
    importc: "png_set_gamma_fixed", dynlib: pnglib.}
proc png_set_gAMA*(png_ptr: png_structp; info_ptr: png_infop;
                   file_gamma: cdouble) {.cdecl, importc: "png_set_gAMA",
    dynlib: pnglib.}
proc png_set_gAMA_fixed*(png_ptr: png_structp; info_ptr: png_infop;
                         file_gamma: png_uint_32) {.cdecl,
    importc: "png_set_gAMA_fixed", dynlib: pnglib.}
#this function is in the libpng(3) manpage but is not actually exported from
#libpng.so on this developer's box
#proc png_set_gray_1_2_4_to_8*(png_ptr: png_structp) {.cdecl,
#    importc: "png_set_gray_1_2_4_to_8", dynlib: pnglib.}
proc png_set_gray_to_rgb*(png_ptr: png_structp) {.cdecl,
    importc: "png_set_gray_to_rgb", dynlib: pnglib.}
proc png_set_hIST*(png_ptr: png_structp; info_ptr: png_infop; hist: png_uint_16p) {.
    cdecl, importc: "png_set_hIST", dynlib: pnglib.}
proc png_set_iCCP*(png_ptr: png_structp; info_ptr: png_infop;
                   name: png_const_charp; compression_type: cint;
                   profile: png_const_bytep; proflen: png_uint_32) {.cdecl,
    importc: "png_set_iCCP", dynlib: pnglib.}
proc png_set_interlace_handling*(png_ptr: png_structp): cint {.cdecl,
    importc: "png_set_interlace_handling", dynlib: pnglib.}
proc png_set_invalid*(png_ptr: png_structp; info_ptr: png_infop; mask: cint) {.
    cdecl, importc: "png_set_invalid", dynlib: pnglib.}
proc png_set_invert_alpha*(png_ptr: png_structp) {.cdecl,
    importc: "png_set_invert_alpha", dynlib: pnglib.}
proc png_set_invert_mono*(png_ptr: png_structp) {.cdecl,
    importc: "png_set_invert_mono", dynlib: pnglib.}
proc png_set_IHDR*(png_ptr: png_structp; info_ptr: png_infop;
                   width: png_uint_32; height: png_uint_32; bit_depth: cint;
                   color_type: cint; interlace_type: cint;
                   compression_type: cint; filter_type: cint) {.cdecl,
    importc: "png_set_IHDR", dynlib: pnglib.}
proc png_set_keep_unknown_chunks*(png_ptr: png_structp; keep: cint;
                                  chunk_list: png_bytep; num_chunks: cint) {.
    cdecl, importc: "png_set_keep_unknown_chunks", dynlib: pnglib.}

#png_set_longjmp_fn is disabled since there is really no good way
#to use sjlj from nimrod
discard """
proc png_set_longjmp_fn*(png_ptr: png_structp; longjmp_fn: png_longjmp_ptr;
                         jmp_buf_size: size_t): ptr jmp_buf {.cdecl,
    importc: "png_set_longjmp_fn", dynlib: pnglib.}
"""
proc png_set_chunk_malloc_max*(png_ptr: png_structp;
                               user_chunk_cache_max: png_alloc_size_t) {.cdecl,
    importc: "png_set_chunk_malloc_max", dynlib: pnglib.}
proc png_set_compression_buffer_size*(png_ptr: png_structp; size: png_uint_32) {.
    cdecl, importc: "png_set_compression_buffer_size", dynlib: pnglib.}
proc png_set_mem_fn*(png_ptr: png_structp; mem_ptr: png_voidp;
                     malloc_fn: png_malloc_ptr; free_fn: png_free_ptr) {.cdecl,
    importc: "png_set_mem_fn", dynlib: pnglib.}
proc png_set_oFFs*(png_ptr: png_structp; info_ptr: png_infop;
                   offset_x: png_uint_32; offset_y: png_uint_32; unit_type: cint) {.
    cdecl, importc: "png_set_oFFs", dynlib: pnglib.}
proc png_set_packing*(png_ptr: png_structp) {.cdecl, importc: "png_set_packing",
    dynlib: pnglib.}
proc png_set_packswap*(png_ptr: png_structp) {.cdecl,
    importc: "png_set_packswap", dynlib: pnglib.}
proc png_set_palette_to_rgb*(png_ptr: png_structp) {.cdecl,
    importc: "png_set_palette_to_rgb", dynlib: pnglib.}
proc png_set_pCAL*(png_ptr: png_structp; info_ptr: png_infop;
                   purpose: png_charp; X0: png_int_32; X1: png_int_32;
                   itype: cint; nparams: cint; units: png_charp;
                   params: png_charpp) {.cdecl, importc: "png_set_pCAL",
    dynlib: pnglib.}
proc png_set_pHYs*(png_ptr: png_structp; info_ptr: png_infop;
                   res_x: png_uint_32; res_y: png_uint_32; unit_type: cint) {.
    cdecl, importc: "png_set_pHYs", dynlib: pnglib.}
proc png_set_progressive_read_fn*(png_ptr: png_structp;
                                  progressive_ptr: png_voidp;
                                  info_fn: png_progressive_info_ptr;
                                  row_fn: png_progressive_row_ptr;
                                  end_fn: png_progressive_end_ptr) {.cdecl,
    importc: "png_set_progressive_read_fn", dynlib: pnglib.}
proc png_set_PLTE*(png_ptr: png_structp; info_ptr: png_infop;
                   palette: png_colorp; num_palette: cint) {.cdecl,
    importc: "png_set_PLTE", dynlib: pnglib.}
proc png_set_quantize*(png_ptr: png_structp; palette: png_colorp;
                       num_palette: cint; maximum_colors: cint;
                       histogram: png_uint_16p; full_quantize: cint) {.cdecl,
    importc: "png_set_quantize", dynlib: pnglib.}
proc png_set_read_fn*(png_ptr: png_structp; io_ptr: png_voidp;
                      read_data_fn: png_rw_ptr) {.cdecl,
    importc: "png_set_read_fn", dynlib: pnglib.}
proc png_set_read_status_fn*(png_ptr: png_structp;
                             read_row_fn: png_read_status_ptr) {.cdecl,
    importc: "png_set_read_status_fn", dynlib: pnglib.}
proc png_set_read_user_chunk_fn*(png_ptr: png_structp;
                                 user_chunk_ptr: png_voidp;
                                 read_user_chunk_fn: png_user_chunk_ptr) {.
    cdecl, importc: "png_set_read_user_chunk_fn", dynlib: pnglib.}
proc png_set_read_user_transform_fn*(png_ptr: png_structp;
    read_user_transform_fn: png_user_transform_ptr) {.cdecl,
    importc: "png_set_read_user_transform_fn", dynlib: pnglib.}
proc png_set_rgb_to_gray*(png_ptr: png_structp; error_action: cint;
                          red: cdouble; green: cdouble) {.cdecl,
    importc: "png_set_rgb_to_gray", dynlib: pnglib.}
proc png_set_rgb_to_gray_fixed*(png_ptr: png_structp; error_action: cint;
                                red: png_uint_32; green: png_uint_32) {.cdecl,
    importc: "png_set_rgb_to_gray_fixed", dynlib: pnglib.}
proc png_set_rows*(png_ptr: png_structp; info_ptr: png_infop;
                   row_pointers: png_bytepp) {.cdecl, importc: "png_set_rows",
    dynlib: pnglib.}
proc png_set_sBIT*(png_ptr: png_structp; info_ptr: png_infop;
                   sig_bit: png_color_8p) {.cdecl, importc: "png_set_sBIT",
    dynlib: pnglib.}
proc png_set_sCAL*(png_ptr: png_structp; info_ptr: png_infop; unit: cint;
                   width: cdouble; height: cdouble) {.cdecl,
    importc: "png_set_sCAL", dynlib: pnglib.}
proc png_set_sCAL_fixed*(png_ptr: png_structp; info_ptr: png_infop; unit: cint;
                         width: png_fixed_point; height: png_fixed_point) {.
    cdecl, importc: "png_set_sCAL_fixed", dynlib: pnglib.}
proc png_set_sCAL_s*(png_ptr: png_structp; info_ptr: png_infop; unit: cint;
                     width: png_charp; height: png_charp) {.cdecl,
    importc: "png_set_sCAL_s", dynlib: pnglib.}
proc png_set_scale_16*(png_ptr: png_structp) {.cdecl,
    importc: "png_set_scale_16", dynlib: pnglib.}
proc png_set_shift*(png_ptr: png_structp; true_bits: png_color_8p) {.cdecl,
    importc: "png_set_shift", dynlib: pnglib.}
proc png_set_sig_bytes*(png_ptr: png_structp; num_bytes: cint) {.cdecl,
    importc: "png_set_sig_bytes", dynlib: pnglib.}
proc png_set_sPLT*(png_ptr: png_structp; info_ptr: png_infop;
                   splt_ptr: png_const_sPLT_tp; num_spalettes: cint) {.cdecl,
    importc: "png_set_sPLT", dynlib: pnglib.}
proc png_set_sRGB*(png_ptr: png_structp; info_ptr: png_infop; srgb_intent: cint) {.
    cdecl, importc: "png_set_sRGB", dynlib: pnglib.}
proc png_set_sRGB_gAMA_and_cHRM*(png_ptr: png_structp; info_ptr: png_infop;
                                 srgb_intent: cint) {.cdecl,
    importc: "png_set_sRGB_gAMA_and_cHRM", dynlib: pnglib.}
proc png_set_strip_16*(png_ptr: png_structp) {.cdecl,
    importc: "png_set_strip_16", dynlib: pnglib.}
proc png_set_strip_alpha*(png_ptr: png_structp) {.cdecl,
    importc: "png_set_strip_alpha", dynlib: pnglib.}
#this function is in libpng(3) but not actually exported from libpng.so
#proc png_set_strip_error_numbers*(png_ptr: png_structp; strip_mode: png_uint_32) {.
#    cdecl, importc: "png_set_strip_error_numbers", dynlib: pnglib.}
proc png_set_swap*(png_ptr: png_structp) {.cdecl, importc: "png_set_swap",
    dynlib: pnglib.}
proc png_set_swap_alpha*(png_ptr: png_structp) {.cdecl,
    importc: "png_set_swap_alpha", dynlib: pnglib.}
proc png_set_text*(png_ptr: png_structp; info_ptr: png_infop;
                   text_ptr: png_textp; num_text: cint) {.cdecl,
    importc: "png_set_text", dynlib: pnglib.}
proc png_set_text_compression_level*(png_ptr: png_structp; level: cint) {.cdecl,
    importc: "png_set_text_compression_level", dynlib: pnglib.}
proc png_set_text_compression_mem_level*(png_ptr: png_structp; mem_level: cint) {.
    cdecl, importc: "png_set_text_compression_mem_level", dynlib: pnglib.}
proc png_set_text_compression_strategy*(png_ptr: png_structp; strategy: cint) {.
    cdecl, importc: "png_set_text_compression_strategy", dynlib: pnglib.}
proc png_set_text_compression_window_bits*(png_ptr: png_structp;
    window_bits: cint) {.cdecl, importc: "png_set_text_compression_window_bits",
                         dynlib: pnglib.}
proc png_set_text_compression_method*(png_ptr: png_structp; imethod: cint) {.
    cdecl, importc: "png_set_text_compression_method", dynlib: pnglib.}
proc png_set_tIME*(png_ptr: png_structp; info_ptr: png_infop;
                   mod_time: png_timep) {.cdecl, importc: "png_set_tIME",
    dynlib: pnglib.}
proc png_set_tRNS*(png_ptr: png_structp; info_ptr: png_infop;
                   trans_alpha: png_bytep; num_trans: cint;
                   trans_color: png_color_16p) {.cdecl, importc: "png_set_tRNS",
    dynlib: pnglib.}
proc png_set_tRNS_to_alpha*(png_ptr: png_structp) {.cdecl,
    importc: "png_set_tRNS_to_alpha", dynlib: pnglib.}
proc png_set_unknown_chunks*(png_ptr: png_structp; info_ptr: png_infop;
                             unknowns: png_unknown_chunkp; num: cint;
                             location: cint): png_uint_32 {.cdecl,
    importc: "png_set_unknown_chunks", dynlib: pnglib.}
proc png_set_unknown_chunk_location*(png_ptr: png_structp; info_ptr: png_infop;
                                     chunk: cint; location: cint) {.cdecl,
    importc: "png_set_unknown_chunk_location", dynlib: pnglib.}
proc png_set_user_limits*(png_ptr: png_structp; user_width_max: png_uint_32;
                          user_height_max: png_uint_32) {.cdecl,
    importc: "png_set_user_limits", dynlib: pnglib.}
proc png_set_user_transform_info*(png_ptr: png_structp;
                                  user_transform_ptr: png_voidp;
                                  user_transform_depth: cint;
                                  user_transform_channels: cint) {.cdecl,
    importc: "png_set_user_transform_info", dynlib: pnglib.}
proc png_set_write_fn*(png_ptr: png_structp; io_ptr: png_voidp;
                       write_data_fn: png_rw_ptr; output_flush_fn: png_flush_ptr) {.
    cdecl, importc: "png_set_write_fn", dynlib: pnglib.}
proc png_set_write_status_fn*(png_ptr: png_structp;
                              write_row_fn: png_write_status_ptr) {.cdecl,
    importc: "png_set_write_status_fn", dynlib: pnglib.}
proc png_set_write_user_transform_fn*(png_ptr: png_structp;
    write_user_transform_fn: png_user_transform_ptr) {.cdecl,
    importc: "png_set_write_user_transform_fn", dynlib: pnglib.}
proc png_sig_cmp*(sig: png_bytep; start: png_size_t; num_to_check: png_size_t): cint {.
    cdecl, importc: "png_sig_cmp", dynlib: pnglib.}
proc png_start_read_image*(png_ptr: png_structp) {.cdecl,
    importc: "png_start_read_image", dynlib: pnglib.}
proc png_warning*(png_ptr: png_structp; message: png_const_charp) {.cdecl,
    importc: "png_warning", dynlib: pnglib.}
proc png_write_chunk*(png_ptr: png_structp; chunk_name: png_bytep;
                      data: png_bytep; length: png_size_t) {.cdecl,
    importc: "png_write_chunk", dynlib: pnglib.}
proc png_write_chunk_data*(png_ptr: png_structp; data: png_bytep;
                           length: png_size_t) {.cdecl,
    importc: "png_write_chunk_data", dynlib: pnglib.}
proc png_write_chunk_end*(png_ptr: png_structp) {.cdecl,
    importc: "png_write_chunk_end", dynlib: pnglib.}
proc png_write_chunk_start*(png_ptr: png_structp; chunk_name: png_bytep;
                            length: png_uint_32) {.cdecl,
    importc: "png_write_chunk_start", dynlib: pnglib.}
proc png_write_end*(png_ptr: png_structp; info_ptr: png_infop) {.cdecl,
    importc: "png_write_end", dynlib: pnglib.}
proc png_write_flush*(png_ptr: png_structp) {.cdecl, importc: "png_write_flush",
    dynlib: pnglib.}
proc png_write_image*(png_ptr: png_structp; image: png_bytepp) {.cdecl,
    importc: "png_write_image", dynlib: pnglib.}
proc png_write_info*(png_ptr: png_structp; info_ptr: png_infop) {.cdecl,
    importc: "png_write_info", dynlib: pnglib.}
proc png_write_info_before_PLTE*(png_ptr: png_structp; info_ptr: png_infop) {.
    cdecl, importc: "png_write_info_before_PLTE", dynlib: pnglib.}
proc png_write_png*(png_ptr: png_structp; info_ptr: png_infop; transforms: cint;
                    params: png_voidp) {.cdecl, importc: "png_write_png",
    dynlib: pnglib.}
proc png_write_row*(png_ptr: png_structp; row: seq[png_byte]) {.cdecl,
    importc: "png_write_row", dynlib: pnglib.}
proc png_write_rows*(png_ptr: png_structp; row: png_bytepp;
                     num_rows: png_uint_32) {.cdecl, importc: "png_write_rows",
    dynlib: pnglib.}
proc png_write_sig*(png_ptr: png_structp) {.cdecl, importc: "png_write_sig",
    dynlib: pnglib.}
