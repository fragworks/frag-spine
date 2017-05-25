import
  colors,
  events,
  hashes,
  strutils

import 
  bgfxdotnim,
  bgfxextrasdotnim,
  chipmunk,
  sdl2 as sdl

import
  frag,
  frag/config,
  frag/graphics/camera,
  frag/graphics/two_d/spritebatch,
  frag/graphics/two_d/vertex,
  frag/graphics/window,
  frag/logger,
  frag/maps/tiled_map,
  frag/modules/assets,
  frag/modules/graphics

import
  frag_spine/attachment_loader,
  frag_spine/attachment_vertices,
  frag_spine/spine,
  frag_spine/frag_spine,
  frag_spine/spine_spritebatch

import
  player/player

type
  App = ref object
    nvgCtx: ptr NVGContext
    batch: SpineSpriteBatch
    mapBatch: SpriteBatch
    camera: Camera
    animState: AnimationState
    player: Player
    space: chipmunk.Space
    playerBody: chipmunk.Body
    playerShape: chipmunk.Shape
    playerVelocity: chipmunk.Vect
    grounded: bool
    remainingBoost: float
    map: TiledMap


  AnimationState = enum
    IDLE, WALK, RUN

  WeaponState = enum
    PISTOL, SNIPER, SHOTGUN, LAUNCHER, COUNT

var drawable : SkeletonDrawable
var skeletonData : ptr spSkeletonData
var atlas : ptr spAtlas
var worldVertices: seq[cfloat] = newSeq[cfloat](1000)
var vertexArray: seq[PosUvColorVertex] = @[]
var triangleArray: seq[uint16] = @[]
var lastBlendMode: spBlendMode
var a = App()
var mapId: Hash

const WIDTH = 960
const HEIGHT = 540
const
    PLAYER_VELOCITY = 500.0
    PLAYER_GROUND_ACCEL_TIME = 0.1
    PLAYER_GROUND_ACCEL = (PLAYER_VELOCITY / PLAYER_GROUND_ACCEL_TIME)
    PLAYER_AIR_ACCEL_TIME = 0.25
    PLAYER_AIR_ACCEL = (PLAYER_VELOCITY / PLAYER_AIR_ACCEL_TIME)
    JUMP_HEIGHT = 50.0
    JUMP_BOOST_HEIGHT = 55.0
    FALL_VELOCITY = 900.0
    GRAVITY = 2000.0
const
  GRABBABLE_MASK_BIT* = cuint(1 shl 31)
  CP_NO_GROUP* = cast[Group](0)
  NOT_GRABBABLE_FILTER* = ShapeFilter(
    group: CP_NO_GROUP,
    categories: not GRABBABLE_MASK_BIT,
    mask: not GRABBABLE_MASK_BIT
  )
  INF = 1e1000
  CHIPMUNK_DARK_GREY* = chipmunk.SpaceDebugColor(
      r:0.40, g:0.40, b:0.40, a:1.0
  )
  SHAPE_OUTLINE_COLOR = chipmunk.SpaceDebugColor(
      r: 200.0/255.0,
      g: 210.0/255.0,
      b: 230.0/255.0,
      a: 1.0
  )
  CONSTRAINT_COLOR = chipmunk.SpaceDebugColor(r:0.0, g:0.75, b:0.0, a:1.0)
  COLLISION_POINT_COLOR = chipmunk.SpaceDebugColor(r:1.0, g:0.0, b:0.0, a:1.0)

proc resize*(e: EventArgs) =
  let event = SDLEventMessage(e).event
  let sdlEventData = event.sdlEventData
  let graphics = event.graphics
  graphics.setViewRect(0, 0, 0, uint16 sdlEventData.window.data1, uint16 sdlEventData.window.data2)


proc la_color(l: cfloat; a: cfloat): SpaceDebugColor {.inline.} =
    result = chipmunk.SpaceDebugColor(r: l, g: l, b: l, a: a)

proc color_for_shape*(shape: Shape, data: DataPointer): SpaceDebugColor {.cdecl.} =
    if shape.sensor == true:
        result = la_color(1.0, 0.1)
    else:
        if shape.body.isSleeping():
            result = la_color(0.2, 1.0)
        elif shape.body.isSleeping():
            result = la_color(0.66, 1.0)
        elif shape.userData != nil:
            result = cast[ptr chipmunk.SpaceDebugColor](shape.userData)[]
        else:
            #result = chipmunk.SpaceDebugColor(r:1.0, g:0.5, b:1.0, a:1.0)
            result = CHIPMUNK_DARK_GREY



proc debug_draw_dot*(size: chipmunk.Float, position: chipmunk.Vect,
                     color: chipmunk.SpaceDebugColor,
                     data: chipmunk.DataPointer) {.cdecl.} =
                     discard
    #when DRAW_WITH_OPENGL == true:
    #    draw_dot_opengl(position, size, color)

proc debug_draw_polygon*(count: cint, verts: ptr chipmunk.Vect,
                         radius: chipmunk.Float,
                         outline_color: chipmunk.SpaceDebugColor,
                         fill_color: chipmunk.SpaceDebugColor,
                         data: chipmunk.DataPointer) {.cdecl.} =
    var 
        points: seq[chipmunk.Vect] = @[]
        verts_array = cast[ptr array[0, chipmunk.Vect]](verts)
    for i in 0..count-1:
        points.add(chipmunk.v(verts_array[i].x, verts_array[i].y))

    nvgBeginPath(a.nvgCtx)
    nvgMoveTo(a.nvgCtx, points[0].x, 540 - points[0].y)
    nvgLineTo(a.nvgCtx, points[1].x, 540 - points[1].y)
    nvgLineTo(a.nvgCtx, points[2].x, 540 - points[2].y)
    nvgLineTo(a.nvgCtx, points[3].x, 540 - points[3].y)
    nvgLineTo(a.nvgCtx, points[0].x, 540 - points[0].y)
    nvgStrokeColor(a.nvgCtx, nvgRGBA(255.cuchar,0.cuchar,0.cuchar,100.cuchar) )
    nvgStroke(a.nvgCtx)

    #when DRAW_WITH_OPENGL == true:
    #    if radius == 0.0:
    #        draw_filled_polygon_opengl(points, fill_color)
    #        draw_polygon_opengl(points, outline_color)

proc debug_draw_fat_segment*(p1: chipmunk.Vect, p2: chipmunk.Vect,
                             radius: chipmunk.Float,
                             outlineColor: chipmunk.SpaceDebugColor,
                             fillColor: chipmunk.SpaceDebugColor,
                             data: chipmunk.DataPointer) {.cdecl.} =
  nvgBeginPath(a.nvgCtx)
  nvgMoveTo(a.nvgCtx, p1.x, p1.y)
  nvgLineTo(a.nvgCtx, p2.x, p2.y)
  nvgStrokeColor(a.nvgCtx, nvgRGBA(255.cuchar,0.cuchar,0.cuchar,100.cuchar) )
  nvgStroke(a.nvgCtx)


    #when DRAW_WITH_OPENGL == true:
        #if radius < 2.0:
            #draw_line_opengl(a, b, outline_color)
        #else:
            #draw_thick_line_opengl(a, b, radius, outline_color, fill_color)

proc debug_draw_segment*(a: chipmunk.Vect, b: chipmunk.Vect,
                         color: chipmunk.SpaceDebugColor,
                         data: chipmunk.DataPointer) {.cdecl.} =
                         discard

proc debug_draw_circle*(position: chipmunk.Vect, angle: chipmunk.Float,
                        radius: chipmunk.Float,
                        outline_color: chipmunk.SpaceDebugColor,
                        fill_color: SpaceDebugColor,
                        data: DataPointer) {.cdecl.} =

  nvgCircle(a.nvgCtx, position.x,position.y, radius)
  nvgFillColor(a.nvgCtx, nvgRGBA(255.cuchar,192.cuchar,0.cuchar,255.cuchar))
  nvgFill(a.nvgCtx)
  #draw_filled_circle_opengl(position, radius, fill_color)
  #draw_circle_opengl(position, radius, angle, outline_color)

proc default_draw_implementation*(space: chipmunk.Space) =
    var draw_options = chipmunk.SpaceDebugDrawOptions(
            drawCircle: debug_draw_circle,
            drawSegment: debug_draw_segment,
            drawFatSegment: debug_draw_fat_segment,
            drawPolygon: debug_draw_polygon,
            drawDot: debug_draw_dot,
            flags: {
                SPACE_DEBUG_DRAW_SHAPES,
                SPACE_DEBUG_DRAW_CONSTRAINTS,
                SPACE_DEBUG_DRAW_COLLISION_POINTS
            },
            shapeOutlineColor: SHAPE_OUTLINE_COLOR,
            colorForShape: color_for_shape,
            constraintColor: CONSTRAINT_COLOR,
            collisionPointColor: COLLISION_POINT_COLOR,
            data: nil
        )
    space.debugDraw(addr(draw_options))

proc select_player_ground_normal(body: chipmunk.Body, arb: chipmunk.Arbiter,
                                 groundNormal: ptr chipmunk.Vect) {.cdecl.} =
    var n: chipmunk.Vect = vneg(arb.normal)
    if n.y > ground_normal.y:
        (ground_normal[]) = n

proc player_update_velocity(body: chipmunk.Body, gravity: chipmunk.Vect, 
  damping: chipmunk.Float, dt: chipmunk.Float) {.cdecl.} = 
    var jump_State: bool = (a.playerVelocity.y > 0.0)

    var ground_normal: chipmunk.Vect = chipmunk.vzero
    a.playerBody.eachArbiter(
        cast[BodyArbiterIteratorFunc](select_player_ground_normal),
        addr(ground_normal)
    )
    a.grounded = (ground_normal.y > 0.0)
    if ground_normal.y < 0.0: 
        a.remainingBoost = 0.0
    var 
        boost: bool = (jump_state and a.remainingBoost > 0.0)
        g: chipmunk.Vect = (if boost: chipmunk.vzero else: gravity)


    body.updateVelocity(gravity, damping, dt)

    var target_vx: chipmunk.Float = PLAYER_VELOCITY * a.playerVelocity.x
    # Update the surface velocity and friction
    # Note that the "feet" move in the opposite direction of the player.
    var surface_velocity = chipmunk.Vect(x: -target_vx, y: 0.0)
    #player_shape.surfaceVelocity = surface_velocity
    #player_shape.friction = (if grounded: PLAYER_GROUND_ACCEL/GRAVITY else: 0.0)
    # Apply air control if not grounded
    
    a.playerShape.surfaceVelocity = surface_velocity
    a.playerShape.friction = (if a.grounded: PLAYER_GROUND_ACCEL/GRAVITY else: 0.0)
    if a.grounded == false: 
    # Smoothly accelerate the velocity
      a.playerBody.velocity = chipmunk.Vect(
          x: flerpconst(a.playerBody.velocity.x, 
                  target_vx, 
                  PLAYER_AIR_ACCEL * dt
              ),
          y: a.playerBody.velocity.y
      )
    body.velocity = chipmunk.Vect(
        x: body.velocity.x,
        y: fclamp(body.velocity.y, -FALL_VELOCITY, INF)
    )


proc init_space(app: App) =
  app.player = Player()
  app.player.init()
  app.space = chipmunk.newSpace()
  app.space.iterations = 1
  app.space.gravity = chipmunk.Vect(x: 0.0, y: -GRAVITY)

  var staticBody = app.space.staticBody()

  # Create segments around the edge of the screen.
  var shape = app.space.addShape(
              newSegmentShape(
                  static_body, 
                  chipmunk.Vect(x: 0, y: 0), 
                  chipmunk.Vect(x: 0, y: 540), 
                  0.0
              )
          )
  shape.elasticity = 1.0
  shape.friction = 1.0
  shape.filter = NOT_GRABBABLE_FILTER
  
  shape = app.space.addShape(
              newSegmentShape(
                  static_body, 
                  chipmunk.Vect(x: 960, y: 0), 
                  chipmunk.Vect(x: 960, y: 540), 
                  0.0
              )
          )
  shape.elasticity = 1.0
  shape.friction = 1.0
  shape.filter = NOT_GRABBABLE_FILTER
  
  shape = app.space.addShape(
              newSegmentShape(
                  static_body, 
                  chipmunk.Vect(x: 0, y: 0), 
                  chipmunk.Vect(x: 960, y: 0), 
                  0.0
              )
          )
  shape.elasticity = 1.0
  shape.friction = 1.0
  shape.filter = NOT_GRABBABLE_FILTER
  
  shape = app.space.addShape(
              newSegmentShape(
                  static_body, 
                  chipmunk.Vect(x: 0, y: 540), 
                  chipmunk.Vect(x: 960, y: 540), 
                  0.0
              )
          )
  shape.elasticity = 1.0
  shape.friction = 1.0
  shape.filter = NOT_GRABBABLE_FILTER


  # Player
  app.playerBody = app.space.addBody(chipmunk.newBody(1.0, INF))
  app.playerBody.position = chipmunk.Vect(
        x: (960/2), 
        y: (540/2)
    )
  app.playerBody.centerOfGravity = chipmunk.Vect(
        x: 0, 
        y: -120
    )
  app.playerBody.velocityUpdateFunc= player_update_velocity
  
  app.playerShape = app.space.addShape(
        newBoxShape(
            body=app.playerBody, 
            box=newBB(-50, 0, 55.0, 200.0),
            radius=10.0
        )
    )
  app.playerShape.elasticity = 0.0
  app.playerShape.friction = 0.0
  app.playerShape.collisionType = cast[CollisionType](1)

proc initApp(app: App, ctx: Frag) =
  logDebug "Initializing app..."

  mapId = ctx.assets.load("maps/map.json", AssetType.TiledMap)

  while not assets.update(ctx.assets):
    discard

  atlas = spAtlas_createFromFile("../spine-runtimes/examples/Gunman/Gunman.atlas", nil)
  let attachmentLoader = cast[ptr spAttachmentLoader](attachment_loader.create(atlas))


  let json = spSkeletonJson_createWithLoader(attachmentLoader)
  json.scale = 0.4
  skeletonData = spSkeletonJson_readSkeletonDataFile(json, "../spine-runtimes/examples/Gunman/Gunman.json")

  let skeleton = spSkeleton_create(skeletonData)
  echo sizeof(skeleton)

  drawable = SkeletonDrawable(
    skeleton: skeleton,
    animationState: spAnimationState_create(spAnimationStateData_create(skeletonData)),
    timeScale: 1,
    ownsAnimationData: true
  )

  drawable.skeleton.x = 960/2
  drawable.skeleton.y = 540/2

  spSkeleton_updateWorldTransform(drawable.skeleton)
  
  discard spAnimationState_setAnimationByName(drawable.animationState, 0, "Idle", 1)

  app.animState = IDLE
  #app.weapon = COUNT
  #app.lastWeapon = COUNT
  #discard spAnimationState_addAnimationByName(drawable.animationState, 1, "gungrab", 0, 2)

  #discard spAnimationState_addAnimationByName(drawable.animationState, 1, "Pistol_Idle", 0, 2)

  app.mapBatch = SpriteBatch(
    blendSrcFunc: BlendFunc.SrcAlpha,
    blendDstFunc: BlendFunc.InvSrcAlpha,
    blendingEnabled: true
  )
  app.mapBatch.init(1000, 0)

  app.batch = SpineSpriteBatch(
    blendSrcFunc: BlendFunc.SrcAlpha,
    blendDstFunc: BlendFunc.InvSrcAlpha,
    blendingEnabled: true
  )
  app.batch.init(1000, 0)

  app.camera = Camera()
  app.camera.init(0)
  app.camera.ortho(1.0, WIDTH, HEIGHT)

  init_space(app)

  app.nvgCtx = nvgCreate(1, 1.cuchar)
  bgfx_set_view_seq(1, true)
  
  echo nvgCreateFont(app.nvgCtx, "sans-bold", "roboto-bold.ttf")

  logDebug "App initialized."

proc updateApp(app:App, ctx: Frag, deltaTime: float) =
  app.camera.update()
  app.batch.setProjectionMatrix(app.camera.combined)
  
  drawable.skeleton.x = app.playerBody.position.x
  drawable.skeleton.y = app.playerBody.position.y

  if ctx.input.pressed("1"):
    app.player.weaponIndex = 0
  elif ctx.input.pressed("2"):
    app.player.weaponIndex = 1
  elif ctx.input.pressed("3"):
    app.player.weaponIndex = 2
  elif ctx.input.pressed("4"):
    app.player.weaponIndex = 3

  if ctx.input.pressed("f"):
    app.player.toggleAiming()

    var animationName = ""
    if app.player.aiming == true:
      case app.player.weaponIndex
      of 0:
        animationName = "Aim_Pistol"
      of 1:
        animationName = "Aim_Sniper"
      of 2:
        animationName = "Aim_Shotgun"
      of 3:
        animationName = "Aim_Launcher"
      else:
        animationName = "Idle"
    else:
       case app.player.weaponIndex
        of 0:
          animationName = "Idle_Pistol"
        of 1:
          animationName = "Idle_Sniper"
        of 2:
          animationName = "Idle_Shotgun"
        of 3:
          animationName = "Idle_Launcher"
        else:
          animationName = "Idle"
    
    discard spAnimationState_setAnimationByName(drawable.animationState, 1, animationName, 1)

  if ctx.input.down("d"):
    drawable.skeleton.flipX = 0
    var speed = 1.0

    if ctx.input.down("left shift"):
      if app.animState == WALK or app.animState == IDLE:
        app.animState = RUN
        discard spAnimationState_setAnimationByName(drawable.animationState, 0, "Run", 1)
      speed = 2.0
    elif app.animState == RUN:
      app.animState = WALK
      discard spAnimationState_setAnimationByName(drawable.animationState, 0, "Walk", 1)
    else:
      if app.animState == IDLE:
        app.animState = WALK
        discard spAnimationState_setAnimationByName(drawable.animationState, 0, "Walk", 1)
    
    app.playerVelocity.x = speed
  elif ctx.input.down("a"):
    drawable.skeleton.flipX = 1
    var speed = -1.0
    
    if ctx.input.down("left shift"):
      if app.animState == WALK or app.animState == IDLE:
        app.animState = RUN
        discard spAnimationState_setAnimationByName(drawable.animationState, 0, "Run", 1)
      speed = -2.0
    elif app.animState == RUN:
      app.animState = WALK
      discard spAnimationState_setAnimationByName(drawable.animationState, 0, "Walk", 1)
    else:
      if app.animState == IDLE:
        app.animState = WALK
        discard spAnimationState_setAnimationByName(drawable.animationState, 0, "Walk", 1)

    app.playerVelocity.x = speed
  else:
    if app.animState == WALK or app.animState == RUN:
      app.animState = IDLE

      discard spAnimationState_setAnimationByName(drawable.animationState, 0, "Idle", 1)
      app.playerVelocity.x = 0

  case app.player.weaponIndex
  of 0:
    if app.player.lastWeaponIndex != 0:
      app.player.stopAiming()
      let setupAnimation = skeletonData.spSkeletonData_findAnimation("Setup_Pistol")
      setupAnimation.spAnimation_apply(drawable.skeleton, 0.0, 1.0, 1, nil, nil, 1.0, 1, 0)
      discard spAnimationState_setAnimationByName(drawable.animationState, 1, "Idle_Pistol", 1)
      app.player.lastWeaponIndex = 0
  of 1:
    if app.player.lastWeaponIndex != 1:
      app.player.stopAiming()
      let setupAnimation = skeletonData.spSkeletonData_findAnimation("Setup_Sniper")
      setupAnimation.spAnimation_apply(drawable.skeleton, 0.0, 1.0, 1, nil, nil, 1.0, 1, 0)
      discard spAnimationState_setAnimationByName(drawable.animationState, 1, "Idle_Sniper", 1)
      app.player.lastWeaponIndex = 1
  of 2:
    if app.player.lastWeaponIndex != 2:
      app.player.stopAiming()
      let setupAnimation = skeletonData.spSkeletonData_findAnimation("Setup_Shotgun")
      setupAnimation.spAnimation_apply(drawable.skeleton, 0.0, 1.0, 1, nil, nil, 1.0, 1, 0)
      discard spAnimationState_setAnimationByName(drawable.animationState, 1, "Idle_Shotgun", 1)
      app.player.lastWeaponIndex = 2
  of 3:
    if app.player.lastWeaponIndex != 3:
      app.player.stopAiming()
      let setupAnimation = skeletonData.spSkeletonData_findAnimation("Setup_Launcher")
      setupAnimation.spAnimation_apply(drawable.skeleton, 0.0, 1.0, 1, nil, nil, 1.0, 1, 0)
      discard spAnimationState_setAnimationByName(drawable.animationState, 1, "Idle_Launcher", 1)
      app.player.lastWeaponIndex = 3
  else:
    discard
        
      

  #else:
  #  discard spAnimationState_setAnimationByName(drawable.animationState, 0, "Idle", 1)

  if not drawable.isNil:
    spSkeleton_update(drawable.skeleton, deltaTime)
    spAnimationState_update(drawable.animationState, deltaTime * drawable.timeScale)
    spAnimationState_apply(drawable.animationState, drawable.skeleton)
    spSkeleton_updateWorldTransform(drawable.skeleton)

  app.space.step(1.0/60)

proc renderApp(app: App, ctx: Frag, deltaTime: float) =
  ctx.graphics.clearView(0, ClearMode.Color.ord or ClearMode.Depth.ord, colors.Color(0x303030ff), 1.0, 0)
  
  var texture: Texture
  var attachmentVertices : AttachmentVertices
  if not drawable.isNil:
    for i in 0..<skeletonData.slotsCount:
      let slot = drawable.skeleton.drawOrder.offset(i)[0]
      let attachment = slot.attachment

      if attachment.isNil:
        continue

      if attachment.`type` == SP_ATTACHMENT_REGION:
        let regionAttachment = cast[ptr spRegionAttachment](attachment)
        attachmentVertices = cast[AttachmentVertices]
        (regionAttachment.rendererObject)
        texture = attachmentVertices.texture
        spRegionAttachment_computeWorldVertices(regionAttachment, slot.bone, addr worldVertices[0])

        if attachmentVertices.renderData.isNil:
          return

        var w = 0
        for i in 0..<4:
          if worldVertices.len > w + 1:
            attachmentVertices.renderData.vertices[i].x = worldVertices[w]
            attachmentVertices.renderData.vertices[i].y = worldVertices[w + 1]
            attachmentVertices.renderData.vertices[i].abgr = 0xFFFFFFFF.uint32
            inc(w, 2)
        
      elif attachment.`type` == SP_ATTACHMENT_MESH:
        let meshAttachment = cast[ptr spMeshAttachment](attachment)
          
        attachmentVertices = cast[AttachmentVertices](meshAttachment.rendererObject)
        spMeshAttachment_computeWorldVertices(meshAttachment, slot, addr worldVertices[0])

        var w = 0
        var i = 0
        while w < meshAttachment.super.worldVerticesLength:
          attachmentVertices.renderData.vertices[i].x = worldVertices[w]
          attachmentVertices.renderData.vertices[i].y = worldVertices[w + 1]
          attachmentVertices.renderData.vertices[i].abgr = 0xFFFFFFFF.uint32
          inc(w, 2)
          inc(i)
      
      app.batch.begin()
      app.batch.draw(attachmentVertices.texture, attachmentVertices.renderData.vertices, attachmentVertices.renderData.indices)
      attachmentVertices = nil
      app.batch.`end`()

  let map = assets.get[TiledMap](ctx.assets, mapId)
  
  map.render(app.mapBatch, app.camera)

      #nvgBeginFrame(app.nvgCtx, 960, 540, 1.0f)
      #app.space.default_draw_implementation()
      #nvgEndFrame(app.nvgCtx)

proc shutdownApp(app: App, ctx: Frag) =
  logDebug "Shutting down app..."
  logDebug "App shut down."

startFrag(a, Config(
  rootWindowTitle: "Your Spine integrated game name",
  rootWindowPosX: window.posUndefined, rootWindowPosY: window.posUndefined,
  rootWindowWidth: 960, rootWindowHeight: 540,
  resetFlags: ResetFlag.VSync,
  logFileName: "your_game_name.log",
  assetRoot: "../assets",
  debugMode: BGFX_DEBUG_NONE
))
