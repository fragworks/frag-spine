{.experimental.}
import
  events,
  strutils

import 
  bgfxdotnim,
  sdl2 as sdl,
  frag_spine/spine,
  frag_spine/frag_spine

import
  frag,
  frag/events/app_event_handler,
  frag/config,
  frag/graphics/window,
  frag/logger,
  frag/modules/graphics

type
  App = ref object
    eventHandler: AppEventHandler

proc offset*[A](some: ptr A; b: int): ptr A =
  result = cast[ptr A](cast[int](some) + (b * sizeof(A)))

proc resize*(e: EventArgs) =
  let event = SDLEventMessage(e).event
  let sdlEventData = event.sdlEventData
  # let app = cast[App](event.userData)
  let graphics = event.graphics
  graphics.setViewRect(0, 0, 0, uint16 sdlEventData.window.data1, uint16 sdlEventData.window.data2)

proc initializeApp(app: App, ctx: Frag) =
  logDebug "Initializing app..."
  app.eventHandler = AppEventHandler()
  app.eventHandler.init(resize)

  let atlas = spAtlas_createFromFile("../spine-runtimes/spine-sfml/data/tank.atlas", nil)
  let json = spSkeletonJson_create(atlas)
  let skeletonData = spSkeletonJson_readSkeletonDataFile(json, "../spine-runtimes/spine-sfml/data/tank.json")
  spSkeletonJson_dispose(json)

  let skeleton = spSkeleton_create(skeletonData)
  let animData = spAnimationStateData_create(skeletonData)
  let animState = spAnimationState_create(animData)
  discard spAnimationState_setAnimationByName(animState, 0, "drive", true.cint)

  var d = 3.cfloat
  for i in 0..<1:
    spSkeleton_update(skeleton, d)
    spAnimationState_update(animState, d)
    spAnimationState_apply(animState, skeleton)
    spSkeleton_updateWorldTransform(skeleton)
    
    for ii in 0..<skeleton.bonesCount:
      let bone = skeleton.bones.offset(ii)[0]
      logInfo "$1 $2 $3 $4 $5 $6 $7".format(bone.data.name, bone.a, bone.b, bone.c, bone.d, bone.worldX, bone.worldY)
    
    logInfo "========================================\n"
    d += 0.1f

  spSkeleton_dispose(skeleton)

  logDebug "App initialized."

proc updateApp(app:App, ctx: Frag, deltaTime: float) =
  discard

proc renderApp(app: App, ctx: Frag, deltaTime: float) =
  ctx.graphics.clearView(0, ClearMode.Color.ord or ClearMode.Depth.ord, 0x303030ff, 1.0, 0)

  let size = ctx.graphics.getSize()

proc shutdownApp(app: App, ctx: Frag) =
  logDebug "Shutting down app..."
  logDebug "App shut down."

startFrag[App](Config(
  rootWindowTitle: "Frag Example 00-hello-world",
  rootWindowPosX: window.posUndefined, rootWindowPosY: window.posUndefined,
  rootWindowWidth: 960, rootWindowHeight: 540,
  resetFlags: ResetFlag.VSync,
  logFileName: "example-00.log",
  assetRoot: "../assets",
  debugMode: BGFX_DEBUG_TEXT
))
