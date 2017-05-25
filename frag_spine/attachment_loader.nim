import
  frag/graphics/two_d/texture,
  frag/graphics/two_d/vertex

import
  attachment_vertices,
  frag_spine,
  spine,
  util

type
  AttachmentLoader* = ref object
    super*: spAttachmentLoader
    atlasAttachmentLoader*: ptr spAtlasAttachmentLoader

type 
  CreateAttachmentCallback = proc(loader: ptr spAttachmentLoader, skin: ptr spSkin, `type`: spAttachmentType, name, path: cstring): ptr spAttachment {.cdecl.}
  DisposeCallback = proc(loader: ptr spAttachmentLoader) {.cdecl.}
  ConfigureAttachmentCallback = proc(loader: ptr spAttachmentLoader, attachment: ptr spAttachment) {.cdecl.}
  DisposeAttachmentCallback = proc(loader: ptr spAttachmentLoader, attachment: ptr spAttachment) {.cdecl.}

const quadTriangles = @[uint16 0, 1, 2, 2, 3, 0]

proc createAttachmentFunc(loader: ptr spAttachmentLoader, skin: ptr spSkin, `type`: spAttachmentType, name, path: cstring): ptr spAttachment {.cdecl.} =
  let self = cast[AttachmentLoader](loader)
  spAttachmentLoader_createAttachment(addr(self.atlasAttachmentLoader.super), skin, `type`, name, path)

proc disposeFunc(loader: ptr spAttachmentLoader) {.cdecl.} =
  discard

proc configureAttachmentFunc(loader: ptr spAttachmentLoader, attachment: ptr spAttachment) {.cdecl.} =
  attachment.attachmentLoader = loader

  case attachment.`type`:
    of SP_ATTACHMENT_REGION:
      let regionAttachment = cast[ptr spRegionAttachment](attachment)
      let region = cast[ptr spAtlasRegion](regionAttachment.rendererObject)
      var attachmentVertices = AttachmentVertices(
        texture: cast[Texture](region.page.rendererObject),
        renderData: RenderData(
          vertices: @[],
          indices: quadTriangles
        )
      )
      var ii = 0
      for i in 0..<4:
        attachmentVertices.renderData.vertices.add(
          PosUVColorVertex(
            u: regionAttachment.uvs[ii],
            v: regionAttachment.uvs[ii + 1]
          )
        )
        inc(ii, 2)
      regionAttachment.rendererObject = cast[pointer](attachmentVertices)
    of SP_ATTACHMENT_MESH:
      var meshAttachment = cast[ptr spMeshAttachment](attachment)
      var region = cast[ptr spAtlasRegion](meshAttachment.rendererObject)
      var attachmentVertices = AttachmentVertices(
        texture: cast[Texture](region.page.rendererObject),
        renderData: RenderData(
          vertices: @[],
          indices: convertToSeq[uint16, cushort](meshAttachment.triangles, meshAttachment.trianglesCount)
        )
      )
      var i, ii = 0
      while ii < meshAttachment.super.worldVerticesLength:
        attachmentVertices.renderData.vertices.add(
          PosUVColorVertex(
            u: meshAttachment.uvs.offset(ii)[0],
            v: meshAttachment.uvs.offset(ii + 1)[0]
          )
        )
        inc(ii, 2)
        inc(i)
      meshAttachment.rendererObject = cast[pointer](attachmentVertices)
    else:
      discard

proc disposeAttachmentFunc(loader: ptr spAttachmentLoader, attachment: ptr spAttachment) {.cdecl.} =
  discard

var disposeFuncPtr : DisposeCallback = disposeFunc
var createAttachmentFuncPtr : CreateAttachmentCallback = createAttachmentFunc
var configureAttachmentFuncPtr : ConfigureAttachmentCallback = configureAttachmentFunc
var disposeAttachmentFuncPtr : DisposeAttachmentCallback = disposeAttachmentFunc

proc create*(atlas: ptr spAtlas): AttachmentLoader =
  result = AttachmentLoader()
  spAttachmentLoader_init(addr result.super, disposeFuncPtr, createAttachmentFuncPtr, configureAttachmentFuncPtr, disposeAttachmentFuncPtr)
  result.atlasAttachmentLoader = spAtlasAttachmentLoader_create(atlas)