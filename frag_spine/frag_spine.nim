import
  os

import 
  spine

import
  frag/graphics/two_d/texture

type
  SkeletonDrawable* = ref object
    skeleton*: ptr spSkeleton
    animationState*: ptr spAnimationState
    timeScale*: float
    ownsAnimationData*: bool

proc offset*[A](some: ptr A; b: int): ptr A =
  result = cast[ptr A](cast[int](some) + (b * sizeof(A)))

proc spAtlasPage_createTexture*(self: ptr spAtlasPage; path: cstring) {.exportc: "_spAtlasPage_createTexture".} =
  let texture = load($path)
  texture.init()
  self.rendererObject = cast[pointer](texture)

proc spAtlasPage_disposeTexture*(self: ptr spAtlasPage) {.exportc: "_spAtlasPage_disposeTexture".} =
  discard

proc spUtil_readFile*(path: cstring; length: ptr cint): cstring {.exportc: "_spUtil_readFile".} =
  readFile(path, length)
