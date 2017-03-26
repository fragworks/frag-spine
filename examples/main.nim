import
  events

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

  echo repr skeletonData

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
