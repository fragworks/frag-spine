import
  bgfxdotnim as bgfx

import
  frag/logger,
  frag/math/fpu_math as fpumath,
  frag/modules/graphics,
  frag/graphics/types,
  frag/graphics/two_d/texture,
  frag/graphics/two_d/texture_atlas,
  frag/graphics/two_d/texture_region,
  frag/graphics/two_d/vertex,
  frag/util
  
when defined(windows):
  import
    frag/graphics/two_d/dx/fs_default_dx11,
    frag/graphics/two_d/dx/vs_default_dx11

else:
  import
    frag/graphics/two_d/gl/fs_default,
    frag/graphics/two_d/gl/vs_default

type
  SpineSpriteBatch* = ref object
    vertices: seq[PosUVColorVertex]
    indices: seq[uint16]
    maxSprites: int
    lastTexture: Texture
    drawing: bool
    programHandle: bgfx_program_handle_t
    tibh: bgfx_index_buffer_handle_t
    vDecl: ptr bgfx_vertex_decl_t
    texHandle: bgfx_uniform_handle_t
    view: uint8
    blendSrcFunc*, blendDstFunc*: BlendFunc
    blendingEnabled*: bool
    projectionMatrix*: fpumath.Mat4

proc setProjectionMatrix*(batch: SpineSpriteBatch, projectionMatrix: fpumath.Mat4) =
  discard
  batch.projectionMatrix = projectionMatrix
  bgfx_set_view_transform(batch.view, nil, addr batch.projectionMatrix[0])

proc flush(spineSpriteBatch: SpineSpriteBatch) =
  if spineSpriteBatch.lastTexture.isNil:
    return

  discard bgfx_touch(0)

  var vb : bgfx_transient_vertex_buffer_t
  bgfx_alloc_transient_vertex_buffer(addr vb, uint32 spineSpriteBatch.vertices.len, spineSpriteBatch.vDecl);
  copyMem(vb.data, addr spineSpriteBatch.vertices[0], sizeof(PosUVColorVertex) * spineSpriteBatch.vertices.len)

  bgfx_set_texture(0, spineSpriteBatch.texHandle, spineSpriteBatch.lastTexture.handle, high(uint32))
  bgfx_set_transient_vertex_buffer(addr vb, 0u32, uint32 spineSpriteBatch.vertices.len)

  if spineSpriteBatch.indices.len > 0:
    var tib : bgfx_transient_index_buffer_t
    bgfx_alloc_transient_index_buffer(addr tib, spineSpriteBatch.indices.len.uint32)
    copyMem(tib.data, addr spineSpriteBatch.indices[0], sizeof(uint16) * spineSpriteBatch.indices.len)
    bgfx_set_transient_index_buffer(addr tib, 0, spineSpriteBatch.indices.len.uint32)
  
  var mtx: fpumath.Mat4
  mtxIdentity(mtx)

  discard bgfx_set_transform(addr mtx[0], 1)

  if spineSpriteBatch.blendingEnabled:
    bgfx_set_state(0'u64 or BGFX_STATE_RGB_WRITE or BGFX_STATE_ALPHA_WRITE or BGFX_STATE_BLEND_FUNC(BGFX_STATE_BLEND_SRC_ALPHA
      , BGFX_STATE_BLEND_INV_SRC_ALPHA), 0)

  discard bgfx_submit(spineSpriteBatch.view, spineSpriteBatch.programHandle, 0, false)

  spineSpriteBatch.vertices.setLen(0)
  spineSpriteBatch.indices.setLen(0)

proc switchTexture(SpineSpriteBatch: SpineSpriteBatch, texture: Texture) =
  flush(SpineSpriteBatch)
  SpineSpriteBatch.lastTexture = texture

proc draw*(spineSpriteBatch: SpineSpriteBatch, texture: Texture, vertices: seq[PosUVColorVertex], indices: var seq[uint16]) =
  if not spineSpriteBatch.drawing:
    logError "SpineSpriteBatch not in drawing mode. Call begin before calling draw."
    return

  #if texture != spineSpriteBatch.lastTexture:
  #  echo "SWITCHING TEXTURE!"
  #  switchTexture(spineSpriteBatch, texture)

  spineSpriteBatch.lastTexture = texture
  
  if spineSpriteBatch.indices.len == 0:
    spineSpriteBatch.indices.add(indices)
  
  #if spineSpriteBatch.vertices.len == 0:
  spineSpriteBatch.vertices.add(vertices)


proc init*(spineSpriteBatch: SpineSpriteBatch, maxSprites: int, view: uint8) =
  spineSpriteBatch.drawing = false
  spineSpriteBatch.maxSprites = maxSprites
  spineSpriteBatch.vertices = @[]
  spineSpriteBatch.indices = @[]
  
  spineSpriteBatch.view = view
   
  mtxIdentity(spineSpriteBatch.projectionMatrix)

  spineSpriteBatch.vDecl = workaround_createShared[bgfx_vertex_decl_t]()

  bgfx_vertex_decl_begin(spineSpriteBatch.vDecl, BGFX_RENDERER_TYPE_NOOP)
  bgfx_vertex_decl_add(spineSpriteBatch.vDecl, BGFX_ATTRIB_POSITION, 3, BGFX_ATTRIB_TYPE_FLOAT, false, false)
  bgfx_vertex_decl_add(spineSpriteBatch.vDecl, BGFX_ATTRIB_TEXCOORD0, 2, BGFX_ATTRIB_TYPE_FLOAT, false, false)
  bgfx_vertex_decl_add(spineSpriteBatch.vDecl, BGFX_ATTRIB_COLOR0, 4, BGFX_ATTRIB_TYPE_UINT8, true, false)
  bgfx_vertex_decl_end(spineSpriteBatch.vDecl)

  spineSpriteBatch.texHandle = bgfx_create_uniform("s_texColor", BGFX_UNIFORM_TYPE_INT1, 1)

  var vsh, fsh : bgfx_shader_handle_t
  when defined(windows):
    case bgfx_get_renderer_type()
    of BGFX_RENDERER_TYPE_DIRECT3D11:
      vsh = bgfx_create_shader(bgfx_make_ref(addr vs_default_dx11.vs[0], uint32 sizeof(vs_default_dx11.vs)))
      fsh = bgfx_create_shader(bgfx_make_ref(addr fs_default_dx11.fs[0], uint32 sizeof(fs_default_dx11.fs)))
    else:
      discard
  else:
    vsh = bgfx_create_shader(bgfx_make_ref(addr vs_default.vs[0], uint32 sizeof(vs_default.vs)))
    fsh = bgfx_create_shader(bgfx_make_ref(addr fs_default.fs[0], uint32 sizeof(fs_default.fs)))
  spineSpriteBatch.programHandle = bgfx_create_program(vsh, fsh, true)

proc begin*(SpineSpriteBatch: SpineSpriteBatch) =
  if SpineSpriteBatch.drawing:
    logError "SpineSpriteBatch is already in drawing mode. Call end before calling begin."
    return

  SpineSpriteBatch.drawing = true

proc `end`*(SpineSpriteBatch: SpineSpriteBatch) =
  if not SpineSpriteBatch.drawing:
    logError "SpineSpriteBatch is not currently in drawing mode. Call begin before calling end."
    return

  if SpineSpriteBatch.vertices.len > 0:
    flush(SpineSpriteBatch)

  SpineSpriteBatch.lastTexture = nil
  SpineSpriteBatch.drawing = false

proc dispose*(spineSpriteBatch: SpineSpriteBatch) =
  bgfx_destroy_uniform(spineSpriteBatch.texHandle)
  let rendererType = bgfx_get_renderer_type()
  if rendererType in [BGFX_RENDERER_TYPE_OPENGL, BGFX_RENDERER_TYPE_OPENGLES]:
    bgfx_destroy_program(spineSpriteBatch.programHandle)
  
  freeShared(spineSpriteBatch.vDecl)