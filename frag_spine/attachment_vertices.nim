import
  frag/graphics/two_d/texture,
  frag/graphics/two_d/vertex

type
  AttachmentVertices* = ref object
    texture*: Texture
    renderData*: RenderData

  RenderData* = ref object
    vertices*: seq[PosUVColorVertex]
    indices*: seq[uint16]