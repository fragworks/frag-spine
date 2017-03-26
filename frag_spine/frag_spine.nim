import 
  spine

proc spAtlasPage_createTexture*(self: ptr spAtlasPage; path: cstring) {.exportc: "_spAtlasPage_createTexture".} =
  discard

proc spAtlasPage_disposeTexture*(self: ptr spAtlasPage) {.exportc: "_spAtlasPage_disposeTexture".} =
  discard

proc spUtil_readFile*(path: cstring; length: ptr cint): cstring {.exportc: "_spUtil_readFile".} =
  readFile(path, length)