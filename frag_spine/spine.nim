 {.deadCodeElim: on.}

var
  ROTATE_PREV_TIME* {.importc: "ROTATE_PREV_TIME".}: cint
  ROTATE_PREV_ROTATION* {.importc: "ROTATE_PREV_ROTATION".}: cint

var ROTATE_ROTATION* {.importc: "ROTATE_ROTATION".}: cint

var ROTATE_ENTRIES* {.importc: "ROTATE_ENTRIES".}: cint

var PATHCONSTRAINTMIX_ENTRIES* {.importc: "PATHCONSTRAINTMIX_ENTRIES".}: cint

var PATHCONSTRAINTSPACING_ENTRIES* {.importc: "PATHCONSTRAINTSPACING_ENTRIES".}: cint

var PATHCONSTRAINTPOSITION_ENTRIES* {.importc: "PATHCONSTRAINTPOSITION_ENTRIES".}: cint

var TRANSFORMCONSTRAINT_ENTRIES* {.importc: "TRANSFORMCONSTRAINT_ENTRIES".}: cint

var IKCONSTRAINT_ENTRIES* {.importc: "IKCONSTRAINT_ENTRIES".}: cint

var COLOR_ENTRIES* {.importc: "COLOR_ENTRIES".}: cint

var TRANSLATE_ENTRIES* {.importc: "TRANSLATE_ENTRIES".}: cint

type
  UncheckedArray* {.unchecked.} [T] = array[1,T]
  
  spEventData* = object
    name*: cstring
    intValue*: cint
    floatValue*: cfloat
    stringValue*: cstring

  spEvent* = object
    data*: ptr spEventData
    time*: cfloat
    intValue*: cint
    floatValue*: cfloat
    stringValue*: cstring
  
  spAttachmentType* {.size: sizeof(cint).} = enum
    SP_ATTACHMENT_REGION, SP_ATTACHMENT_BOUNDING_BOX, SP_ATTACHMENT_MESH,
    SP_ATTACHMENT_LINKED_MESH, SP_ATTACHMENT_PATH
  spAttachment* = object
    name*: cstring
    `type`*: spAttachmentType
    vtable*: pointer
    attachmentLoader*: ptr spAttachmentLoader
  
  spAnimation* = object
    name*: cstring
    duration*: cfloat
    timelinesCount*: cint
    timelines*: ptr UncheckedArray[ptr spTimeline]

  spTimelineType* {.size: sizeof(cint).} = enum
    SP_TIMELINE_ROTATE, SP_TIMELINE_TRANSLATE, SP_TIMELINE_SCALE,
    SP_TIMELINE_SHEAR, SP_TIMELINE_ATTACHMENT, SP_TIMELINE_COLOR,
    SP_TIMELINE_DEFORM, SP_TIMELINE_EVENT, SP_TIMELINE_DRAWORDER,
    SP_TIMELINE_IKCONSTRAINT, SP_TIMELINE_TRANSFORMCONSTRAINT,
    SP_TIMELINE_PATHCONSTRAINTPOSITION, SP_TIMELINE_PATHCONSTRAINTSPACING,
    SP_TIMELINE_PATHCONSTRAINTMIX
  
  spTimeline* = object
    `type`*: spTimelineType
    vtable*: pointer
  
  spCurveTimeline* = object
    super*: spTimeline
    curves*: ptr cfloat

  spBaseTimeline* = object
    super*: spCurveTimeline
    framesCount*: cint
    frames*: ptr cfloat
    boneIndex*: cint
  
  spSkeletonJson* = object
    scale*: cfloat
    attachmentLoader*: ptr spAttachmentLoader
    error*: cstring

  spRotateTimeline* = spBaseTimeline

  spColorTimeline* = object
    super*: spCurveTimeline
    framesCount*: cint
    frames*: ptr cfloat
    slotIndex*: cint

  spAttachmentTimeline* = object
    super*: spTimeline
    framesCount*: cint
    frames*: ptr cfloat
    slotIndex*: cint
    attachmentNames*: cstringArray

  spEventTimeline* = object
    super*: spTimeline
    framesCount*: cint
    frames*: ptr cfloat
    events*: ptr UncheckedArray[ptr spEvent]

  spDrawOrderTimeline* = object
    super*: spTimeline
    framesCount*: cint
    frames*: ptr cfloat
    drawOrders*: ptr UncheckedArray[ptr cint]
    slotsCount*: cint

  spDeformTimeline* = object
    super*: spCurveTimeline
    framesCount*: cint
    frames*: ptr cfloat
    frameVerticesCount*: cint
    frameVertices*: ptr UncheckedArray[ptr cfloat]
    slotIndex*: cint
    attachment*: ptr spAttachment

  spIkConstraintTimeline* = object
    super*: spCurveTimeline
    framesCount*: cint
    frames*: ptr cfloat
    ikConstraintIndex*: cint

  spTransformConstraintTimeline* = object
    super*: spCurveTimeline
    framesCount*: cint
    frames*: ptr cfloat
    transformConstraintIndex*: cint

  spPathConstraintPositionTimeline* = object
    super*: spCurveTimeline
    framesCount*: cint
    frames*: ptr cfloat
    pathConstraintIndex*: cint

  spPathConstraintSpacingTimeline* = object
    super*: spCurveTimeline
    framesCount*: cint
    frames*: ptr cfloat
    pathConstraintIndex*: cint

  spPathConstraintMixTimeline* = object
    super*: spCurveTimeline
    framesCount*: cint
    frames*: ptr cfloat
    pathConstraintIndex*: cint

  spTransformMode* {.size: sizeof(cint).} = enum
    SP_TRANSFORMMODE_NORMAL, SP_TRANSFORMMODE_ONLYTRANSLATION,
    SP_TRANSFORMMODE_NOROTATIONORREFLECTION, SP_TRANSFORMMODE_NOSCALE,
    SP_TRANSFORMMODE_NOSCALEORREFLECTION
  
  spBoneData* = object
    index*: cint
    name*: cstring
    parent*: ptr spBoneData
    length*: cfloat
    x*: cfloat
    y*: cfloat
    rotation*: cfloat
    scaleX*: cfloat
    scaleY*: cfloat
    shearX*: cfloat
    shearY*: cfloat
    transformMode*: spTransformMode

  spBlendMode* {.size: sizeof(cint).} = enum
    SP_BLEND_MODE_NORMAL, SP_BLEND_MODE_ADDITIVE, SP_BLEND_MODE_MULTIPLY,
    SP_BLEND_MODE_SCREEN

  spSlotData* = object
    index*: cint
    name*: cstring
    boneData*: ptr spBoneData
    attachmentName*: cstring
    r*: cfloat
    g*: cfloat
    b*: cfloat
    a*: cfloat
    blendMode*: spBlendMode

  spSkin* = object
    name*: cstring

  Entry* = object
    slotIndex*: cint
    name*: cstring
    attachment*: ptr spAttachment
    next*: ptr Entry

  spIkConstraintData* = object
    name*: cstring
    order*: cint
    bonesCount*: cint
    bones*: ptr UncheckedArray[ptr spBoneData]
    target*: ptr spBoneData
    bendDirection*: cint
    mix*: cfloat
  
  spTransformConstraintData* = object
    name*: cstring
    order*: cint
    bonesCount*: cint
    bones*: ptr UncheckedArray[ptr spBoneData]
    target*: ptr spBoneData
    rotateMix*: cfloat
    translateMix*: cfloat
    scaleMix*: cfloat
    shearMix*: cfloat
    offsetRotation*: cfloat
    offsetX*: cfloat
    offsetY*: cfloat
    offsetScaleX*: cfloat
    offsetScaleY*: cfloat
    offsetShearY*: cfloat

  spPositionMode* {.size: sizeof(cint).} = enum
    SP_POSITION_MODE_FIXED, SP_POSITION_MODE_PERCENT
  spSpacingMode* {.size: sizeof(cint).} = enum
    SP_SPACING_MODE_LENGTH, SP_SPACING_MODE_FIXED, SP_SPACING_MODE_PERCENT
  spRotateMode* {.size: sizeof(cint).} = enum
    SP_ROTATE_MODE_TANGENT, SP_ROTATE_MODE_CHAIN, SP_ROTATE_MODE_CHAIN_SCALE
  spPathConstraintData* = object
    name*: cstring
    order*: cint
    bonesCount*: cint
    bones*: ptr UncheckedArray[ptr spBoneData]
    target*: ptr spSlotData
    positionMode*: spPositionMode
    spacingMode*: spSpacingMode
    rotateMode*: spRotateMode
    offsetRotation*: cfloat
    position*: cfloat
    spacing*: cfloat
    rotateMix*: cfloat
    translateMix*: cfloat

  spSkeletonData* = object
    version*: cstring
    hash*: cstring
    width*: cfloat
    height*: cfloat
    bonesCount*: cint
    bones*: ptr UncheckedArray[ptr spBoneData]
    slotsCount*: cint
    slots*: ptr UncheckedArray[ptr spSlotData]
    skinsCount*: cint
    skins*: ptr UncheckedArray[ptr spSkin]
    defaultSkin*: ptr spSkin
    eventsCount*: cint
    events*: ptr UncheckedArray[ptr spEventData]
    animationsCount*: cint
    animations*: ptr UncheckedArray[ptr spAnimation]
    ikConstraintsCount*: cint
    ikConstraints*: ptr UncheckedArray[ptr spIkConstraintData]
    transformConstraintsCount*: cint
    transformConstraints*: ptr UncheckedArray[ptr spTransformConstraintData]
    pathConstraintsCount*: cint
    pathConstraints*: ptr UncheckedArray[ptr spPathConstraintData]

  spAnimationStateData* = object
    skeletonData*: ptr spSkeletonData
    defaultMix*: cfloat
    entries*: pointer

  spEventType* {.size: sizeof(cint).} = enum
    SP_ANIMATION_START, SP_ANIMATION_INTERRUPT, SP_ANIMATION_END,
    SP_ANIMATION_COMPLETE, SP_ANIMATION_DISPOSE, SP_ANIMATION_EVENT
  spAnimationStateListener* = proc (state: ptr spAnimationState; `type`: spEventType;
                                 entry: ptr spTrackEntry; event: ptr spEvent)
  spTrackEntry* = object
    animation*: ptr spAnimation
    next*: ptr spTrackEntry
    mixingFrom*: ptr spTrackEntry
    listener*: spAnimationStateListener
    trackIndex*: cint
    loop*: cint
    eventThreshold*: cfloat
    attachmentThreshold*: cfloat
    drawOrderThreshold*: cfloat
    animationStart*: cfloat
    animationEnd*: cfloat
    animationLast*: cfloat
    nextAnimationLast*: cfloat
    delay*: cfloat
    trackTime*: cfloat
    trackLast*: cfloat
    nextTrackLast*: cfloat
    trackEnd*: cfloat
    timeScale*: cfloat
    alpha*: cfloat
    mixTime*: cfloat
    mixDuration*: cfloat
    mixAlpha*: cfloat
    timelinesFirst*: ptr cint
    timelinesFirstCount*: cint
    timelinesRotation*: ptr cfloat
    timelinesRotationCount*: cint
    rendererObject*: pointer
    userData*: pointer

  spAnimationState* = object
    data*: ptr spAnimationStateData
    tracksCount*: cint
    tracks*: ptr UncheckedArray[ptr spTrackEntry]
    listener*: spAnimationStateListener
    timeScale*: cfloat
    rendererObject*: pointer

  spAtlasFormat* {.size: sizeof(cint).} = enum
    SP_ATLAS_UNKNOWN_FORMAT, SP_ATLAS_ALPHA, SP_ATLAS_INTENSITY,
    SP_ATLAS_LUMINANCE_ALPHA, SP_ATLAS_RGB565, SP_ATLAS_RGBA4444, SP_ATLAS_RGB888,
    SP_ATLAS_RGBA8888
  spAtlasFilter* {.size: sizeof(cint).} = enum
    SP_ATLAS_UNKNOWN_FILTER, SP_ATLAS_NEAREST, SP_ATLAS_LINEAR, SP_ATLAS_MIPMAP,
    SP_ATLAS_MIPMAP_NEAREST_NEAREST, SP_ATLAS_MIPMAP_LINEAR_NEAREST,
    SP_ATLAS_MIPMAP_NEAREST_LINEAR, SP_ATLAS_MIPMAP_LINEAR_LINEAR
  spAtlasWrap* {.size: sizeof(cint).} = enum
    SP_ATLAS_MIRROREDREPEAT, SP_ATLAS_CLAMPTOEDGE, SP_ATLAS_REPEAT

  spAtlasPage* = object
    atlas*: ptr spAtlas
    name*: cstring
    format*: spAtlasFormat
    minFilter*: spAtlasFilter
    magFilter*: spAtlasFilter
    uWrap*: spAtlasWrap
    vWrap*: spAtlasWrap
    rendererObject*: pointer
    width*: cint
    height*: cint
    next*: ptr spAtlasPage

  spAtlasRegion* = object
    name*: cstring
    x*: cint
    y*: cint
    width*: cint
    height*: cint
    u*: cfloat
    v*: cfloat
    u2*: cfloat
    v2*: cfloat
    offsetX*: cint
    offsetY*: cint
    originalWidth*: cint
    originalHeight*: cint
    index*: cint
    rotate*: cint
    flip*: cint
    splits*: ptr cint
    pads*: ptr cint
    page*: ptr spAtlasPage
    next*: ptr spAtlasRegion

  spAtlas* = object
    pages*: ptr spAtlasPage
    regions*: ptr spAtlasRegion
    rendererObject*: pointer

  spAttachmentLoader* = object
    error1*: cstring
    error2*: cstring
    vtable*: pointer

  spAtlasAttachmentLoader* = object
    super*: spAttachmentLoader
    atlas*: ptr spAtlas

  spBone* = object
    data*: ptr spBoneData
    skeleton*: ptr spSkeleton
    parent*: ptr spBone
    childrenCount*: cint
    children*: ptr UncheckedArray[ptr spBone]
    x*: cfloat
    y*: cfloat
    rotation*: cfloat
    scaleX*: cfloat
    scaleY*: cfloat
    shearX*: cfloat
    shearY*: cfloat
    ax*: cfloat
    ay*: cfloat
    arotation*: cfloat
    ascaleX*: cfloat
    ascaleY*: cfloat
    ashearX*: cfloat
    ashearY*: cfloat
    appliedValid*: cint
    a*: cfloat
    b*: cfloat
    worldX*: cfloat
    c*: cfloat
    d*: cfloat
    worldY*: cfloat
    sorted*: cint

  spSlot* = object
    data*: ptr spSlotData
    bone*: ptr spBone
    r*: cfloat
    g*: cfloat
    b*: cfloat
    a*: cfloat
    attachment*: ptr spAttachment
    attachmentVerticesCapacity*: cint
    attachmentVerticesCount*: cint
    attachmentVertices*: ptr cfloat

  spVertexIndex* {.size: sizeof(cint).} = enum
    SP_VERTEX_X1 = 0, SP_VERTEX_Y1, SP_VERTEX_X2, SP_VERTEX_Y2, SP_VERTEX_X3,
    SP_VERTEX_Y3, SP_VERTEX_X4, SP_VERTEX_Y4
    
  spRegionAttachment* = object
    super*: spAttachment
    path*: cstring
    x*: cfloat
    y*: cfloat
    scaleX*: cfloat
    scaleY*: cfloat
    rotation*: cfloat
    width*: cfloat
    height*: cfloat
    r*: cfloat
    g*: cfloat
    b*: cfloat
    a*: cfloat
    rendererObject*: pointer
    regionOffsetX*: cint
    regionOffsetY*: cint
    regionWidth*: cint
    regionHeight*: cint
    regionOriginalWidth*: cint
    regionOriginalHeight*: cint
    offset*: array[8, cfloat]
    uvs*: array[8, cfloat]

  spVertexAttachment* = object
    super*: spAttachment
    bonesCount*: cint
    bones*: ptr cint
    verticesCount*: cint
    vertices*: ptr cfloat
    worldVerticesLength*: cint

  spMeshAttachment* = object
    super*: spVertexAttachment
    rendererObject*: pointer
    regionOffsetX*: cint
    regionOffsetY*: cint
    regionWidth*: cint
    regionHeight*: cint
    regionOriginalWidth*: cint
    regionOriginalHeight*: cint
    regionU*: cfloat
    regionV*: cfloat
    regionU2*: cfloat
    regionV2*: cfloat
    regionRotate*: cint
    path*: cstring
    regionUVs*: ptr cfloat
    uvs*: ptr UncheckedArray[cfloat]
    trianglesCount*: cint
    triangles*: ptr UncheckedArray[cushort]
    r*: cfloat
    g*: cfloat
    b*: cfloat
    a*: cfloat
    hullLength*: cint
    parentMesh*: ptr spMeshAttachment
    inheritDeform*: cint
    edgesCount*: cint
    edges*: ptr cint
    width*: cfloat
    height*: cfloat

  spBoundingBoxAttachment* = object
    super*: spVertexAttachment
  
  spIkConstraint* = object
    data*: ptr spIkConstraintData
    bonesCount*: cint
    bones*: ptr UncheckedArray[ptr spBone]
    target*: ptr spBone
    bendDirection*: cint
    mix*: cfloat

  spTransformConstraint* = object
    data*: ptr spTransformConstraintData
    bonesCount*: cint
    bones*: ptr UncheckedArray[ptr spBone]
    target*: ptr spBone
    rotateMix*: cfloat
    translateMix*: cfloat
    scaleMix*: cfloat
    shearMix*: cfloat

  spPathAttachment* = object
    super*: spVertexAttachment
    lengthsLength*: cint
    lengths*: ptr cfloat
    closed*: cint
    constantSpeed*: cint

  spPathConstraint* = object
    data*: ptr spPathConstraintData
    bonesCount*: cint
    bones*: ptr UncheckedArray[ptr spBone]
    target*: ptr spSlot
    position*: cfloat
    spacing*: cfloat
    rotateMix*: cfloat
    translateMix*: cfloat
    spacesCount*: cint
    spaces*: ptr cfloat
    positionsCount*: cint
    positions*: ptr cfloat
    worldCount*: cint
    world*: ptr cfloat
    curvesCount*: cint
    curves*: ptr cfloat
    lengthsCount*: cint
    lengths*: ptr cfloat
    segments*: array[10, cfloat]

  spSkeleton* = object
    data*: ptr spSkeletonData
    bonesCount*: cint
    bones*: ptr UncheckedArray[ptr spBone]
    root*: ptr spBone
    slotsCount*: cint
    slots*: ptr UncheckedArray[ptr spSlot]
    drawOrder*: ptr UncheckedArray[ptr spSlot]
    ikConstraintsCount*: cint
    ikConstraints*: ptr UncheckedArray[ptr spIkConstraint]
    transformConstraintsCount*: cint
    transformConstraints*: ptr UncheckedArray[ptr spTransformConstraint]
    pathConstraintsCount*: cint
    pathConstraints*: ptr UncheckedArray[ptr spPathConstraint]
    skin*: ptr spSkin
    r*: cfloat
    g*: cfloat
    b*: cfloat
    a*: cfloat
    time*: cfloat
    flipX*: cint
    flipY*: cint
    x*: cfloat
    y*: cfloat

  spPolygon* = object
    vertices*: ptr cfloat
    count*: cint
    capacity*: cint

  spSkeletonBounds* = object
    count*: cint
    boundingBoxes*: ptr UncheckedArray[ptr spBoundingBoxAttachment]
    polygons*: ptr UncheckedArray[ptr spPolygon]
    minX*: cfloat
    minY*: cfloat
    maxX*: cfloat
    maxY*: cfloat

  spSkeletonBinary* = object
    scale*: cfloat
    attachmentLoader*: ptr spAttachmentLoader
    error*: cstring

  spTranslateTimeline* = spBaseTimeline
  spScaleTimeline* = spBaseTimeline
  spShearTimeline* = spBaseTimeline


proc spEventData_create*(name: cstring): ptr spEventData {.importc: "spEventData_create".}
proc spEventData_dispose*(self: ptr spEventData) {.importc: "spEventData_dispose".}


proc spEvent_create*(time: cfloat; data: ptr spEventData): ptr spEvent {.importc: "spEvent_create".}
proc spEvent_dispose*(self: ptr spEvent) {.importc: "spEvent_dispose".}



proc spAttachment_dispose*(self: ptr spAttachment) {.importc: "spAttachment_dispose".}


proc spAnimation_create*(name: cstring; timelinesCount: cint): ptr spAnimation {.importc: "spAnimation_create".}
proc spAnimation_dispose*(self: ptr spAnimation) {.importc: "spAnimation_dispose".}
proc spAnimation_apply*(self: ptr spAnimation; skeleton: ptr spSkeleton;
                       lastTime: cfloat; time: cfloat; loop: cint;
                       events: ptr UncheckedArray[ptr spEvent]; eventsCount: ptr cint; alpha: cfloat;
                       setupPose: cint; mixingOut: cint) {.importc: "spAnimation_apply".}


proc spTimeline_dispose*(self: ptr spTimeline) {.importc: "spTimeline_dispose".}
proc spTimeline_apply*(self: ptr spTimeline; skeleton: ptr spSkeleton;
                      lastTime: cfloat; time: cfloat; firedEvents: ptr UncheckedArray[ptr spEvent];
                      eventsCount: ptr cint; alpha: cfloat; setupPose: cint;
                      mixingOut: cint) {.importc: "spTimeline_apply".}
proc spTimeline_getPropertyId*(self: ptr spTimeline): cint {.importc: "spTimeline_getPropertyId".}


proc spCurveTimeline_setLinear*(self: ptr spCurveTimeline; frameIndex: cint) {.importc: "spCurveTimeline_setLinear".}
proc spCurveTimeline_setStepped*(self: ptr spCurveTimeline; frameIndex: cint) {.importc: "spCurveTimeline_setStepped".}
proc spCurveTimeline_setCurve*(self: ptr spCurveTimeline; frameIndex: cint;
                              cx1: cfloat; cy1: cfloat; cx2: cfloat; cy2: cfloat) {.importc: "spCurveTimeline_setCurve".}
proc spCurveTimeline_getCurvePercent*(self: ptr spCurveTimeline; frameIndex: cint;
                                     percent: cfloat): cfloat {.importc: "spCurveTimeline_getCurvePercent".}

proc spRotateTimeline_create*(framesCount: cint): ptr spRotateTimeline {.importc: "spRotateTimeline_create".}
proc spRotateTimeline_setFrame*(self: ptr spRotateTimeline; frameIndex: cint;
                               time: cfloat; angle: cfloat) {.importc: "spRotateTimeline_setFrame".}


proc spTranslateTimeline_create*(framesCount: cint): ptr spTranslateTimeline {.importc: "spTranslateTimeline_create".}
proc spTranslateTimeline_setFrame*(self: ptr spTranslateTimeline; frameIndex: cint;
                                  time: cfloat; x: cfloat; y: cfloat) {.importc: "spTranslateTimeline_setFrame".}
  

proc spScaleTimeline_create*(framesCount: cint): ptr spScaleTimeline {.importc: "spScaleTimeline_create".}
proc spScaleTimeline_setFrame*(self: ptr spScaleTimeline; frameIndex: cint;
                              time: cfloat; x: cfloat; y: cfloat) {.importc: "spScaleTimeline_setFrame".}
  

proc spShearTimeline_create*(framesCount: cint): ptr spShearTimeline {.importc: "spShearTimeline_create".}
proc spShearTimeline_setFrame*(self: ptr spShearTimeline; frameIndex: cint;
                              time: cfloat; x: cfloat; y: cfloat) {.importc: "spShearTimeline_setFrame".}



proc spColorTimeline_create*(framesCount: cint): ptr spColorTimeline {.importc: "spColorTimeline_create".}
proc spColorTimeline_setFrame*(self: ptr spColorTimeline; frameIndex: cint;
                              time: cfloat; r: cfloat; g: cfloat; b: cfloat; a: cfloat) {.importc: "spColorTimeline_setFrame".}


proc spAttachmentTimeline_create*(framesCount: cint): ptr spAttachmentTimeline {.importc: "spAttachmentTimeline_create".}
proc spAttachmentTimeline_setFrame*(self: ptr spAttachmentTimeline;
                                   frameIndex: cint; time: cfloat;
                                   attachmentName: cstring) {.importc: "spAttachmentTimeline_setFrame".}


proc spEventTimeline_create*(framesCount: cint): ptr spEventTimeline {.importc: "spEventTimeline_create".}
proc spEventTimeline_setFrame*(self: ptr spEventTimeline; frameIndex: cint;
                              event: ptr spEvent) {.importc: "spEventTimeline_setFrame".}


proc spDrawOrderTimeline_create*(framesCount: cint; slotsCount: cint): ptr spDrawOrderTimeline {.importc: "spDrawOrderTimeline_create".}
proc spDrawOrderTimeline_setFrame*(self: ptr spDrawOrderTimeline; frameIndex: cint;
                                  time: cfloat; drawOrder: ptr cint) {.importc: "spDrawOrderTimeline_setFrame".}


proc spDeformTimeline_create*(framesCount: cint; frameVerticesCount: cint): ptr spDeformTimeline {.importc: "spDeformTimeline_create".}
proc spDeformTimeline_setFrame*(self: ptr spDeformTimeline; frameIndex: cint;
                               time: cfloat; vertices: ptr cfloat) {.importc: "spDeformTimeline_setFrame".}


proc spIkConstraintTimeline_create*(framesCount: cint): ptr spIkConstraintTimeline {.importc: "spIkConstraintTimeline_create".}
proc spIkConstraintTimeline_setFrame*(self: ptr spIkConstraintTimeline;
                                     frameIndex: cint; time: cfloat; mix: cfloat;
                                     bendDirection: cint) {.importc: "spIkConstraintTimeline_setFrame".}


proc spTransformConstraintTimeline_create*(framesCount: cint): ptr spTransformConstraintTimeline {.importc: "spTransformConstraintTimeline_create".}
proc spTransformConstraintTimeline_setFrame*(
    self: ptr spTransformConstraintTimeline; frameIndex: cint; time: cfloat;
    rotateMix: cfloat; translateMix: cfloat; scaleMix: cfloat; shearMix: cfloat) {.importc: "spTransformConstraintTimeline_setFrame".}


proc spPathConstraintPositionTimeline_create*(framesCount: cint): ptr spPathConstraintPositionTimeline {.
    importc: "spPathConstraintPositionTimeline_create".}
proc spPathConstraintPositionTimeline_setFrame*(
    self: ptr spPathConstraintPositionTimeline; frameIndex: cint; time: cfloat;
    value: cfloat) {.importc: "spPathConstraintPositionTimeline_setFrame".}


proc spPathConstraintSpacingTimeline_create*(framesCount: cint): ptr spPathConstraintSpacingTimeline {.importc: "spPathConstraintSpacingTimeline_create".}
proc spPathConstraintSpacingTimeline_setFrame*(
    self: ptr spPathConstraintSpacingTimeline; frameIndex: cint; time: cfloat;
    value: cfloat) {.importc: "spPathConstraintSpacingTimeline_setFrame".}



proc spPathConstraintMixTimeline_create*(framesCount: cint): ptr spPathConstraintMixTimeline {.importc: "spPathConstraintMixTimeline_create".}
proc spPathConstraintMixTimeline_setFrame*(self: ptr spPathConstraintMixTimeline;
    frameIndex: cint; time: cfloat; rotateMix: cfloat; translateMix: cfloat) {.importc: "spPathConstraintMixTimeline_setFrame".}


proc spBoneData_create*(index: cint; name: cstring; parent: ptr spBoneData): ptr spBoneData {.importc: "spBoneData_create".}
proc spBoneData_dispose*(self: ptr spBoneData) {.importc: "spBoneData_dispose".}


proc spSlotData_create*(index: cint; name: cstring; boneData: ptr spBoneData): ptr spSlotData {.importc: "spSlotData_create".}
proc spSlotData_dispose*(self: ptr spSlotData) {.importc: "spSlotData_dispose".}
proc spSlotData_setAttachmentName*(self: ptr spSlotData; attachmentName: cstring) {.importc: "spSlotData_setAttachmentName".}


proc spSkin_create*(name: cstring): ptr spSkin {.importc: "spSkin_create".}
proc spSkin_dispose*(self: ptr spSkin) {.importc: "spSkin_dispose".}
proc spSkin_addAttachment*(self: ptr spSkin; slotIndex: cint; name: cstring;
                          attachment: ptr spAttachment) {.importc: "spSkin_addAttachment".}
proc spSkin_getAttachment*(self: ptr spSkin; slotIndex: cint; name: cstring): ptr spAttachment {.importc: "spSkin_getAttachment".}
proc spSkin_getAttachmentName*(self: ptr spSkin; slotIndex: cint;
                              attachmentIndex: cint): cstring {.importc: "spSkin_getAttachmentName".}
proc spSkin_attachAll*(self: ptr spSkin; skeleton: ptr spSkeleton;
                      oldspSkin: ptr spSkin) {.importc: "spSkin_attachAll".}


proc spIkConstraintData_create*(name: cstring): ptr spIkConstraintData {.importc: "spIkConstraintData_create".}
proc spIkConstraintData_dispose*(self: ptr spIkConstraintData) {.importc: "spIkConstraintData_dispose".}
proc spTransformConstraintData_create*(name: cstring): ptr spTransformConstraintData {.importc: "spTransformConstraintData_create".}
proc spTransformConstraintData_dispose*(self: ptr spTransformConstraintData) {.importc: "spTransformConstraintData_dispose".}
proc spPathConstraintData_create*(name: cstring): ptr spPathConstraintData {.importc: "spPathConstraintData_create".}
proc spPathConstraintData_dispose*(self: ptr spPathConstraintData) {.importc: "spPathConstraintData_dispose".}
proc spSkeletonData_create*(): ptr spSkeletonData {.importc: "spSkeletonData_create".}
proc spSkeletonData_dispose*(self: ptr spSkeletonData) {.importc: "spSkeletonData_dispose".}
proc spSkeletonData_findBone*(self: ptr spSkeletonData; boneName: cstring): ptr spBoneData {.importc: "spSkeletonData_findBone".}
proc spSkeletonData_findBoneIndex*(self: ptr spSkeletonData; boneName: cstring): cint {.importc: "spSkeletonData_findBoneIndex".}
proc spSkeletonData_findSlot*(self: ptr spSkeletonData; slotName: cstring): ptr spSlotData {.importc: "spSkeletonData_findSlot".}
proc spSkeletonData_findSlotIndex*(self: ptr spSkeletonData; slotName: cstring): cint {.importc: "spSkeletonData_findSlotIndex".}
proc spSkeletonData_findSkin*(self: ptr spSkeletonData; skinName: cstring): ptr spSkin {.importc: "spSkeletonData_findSkin".}
proc spSkeletonData_findEvent*(self: ptr spSkeletonData; eventName: cstring): ptr spEventData {.importc: "spSkeletonData_findEvent".}
proc spSkeletonData_findAnimation*(self: ptr spSkeletonData; animationName: cstring): ptr spAnimation {.importc: "spSkeletonData_findAnimation".}
proc spSkeletonData_findIkConstraint*(self: ptr spSkeletonData;
                                     constraintName: cstring): ptr spIkConstraintData {.importc: "spSkeletonData_findIkConstraint".}
proc spSkeletonData_findTransformConstraint*(self: ptr spSkeletonData;
    constraintName: cstring): ptr spTransformConstraintData {.importc: "spSkeletonData_findTransformConstraint".}
proc spSkeletonData_findPathConstraint*(self: ptr spSkeletonData;
                                       constraintName: cstring): ptr spPathConstraintData {.importc: "spSkeletonData_findPathConstraint".}


proc spAnimationStateData_create*(skeletonData: ptr spSkeletonData): ptr spAnimationStateData {.importc: "spAnimationStateData_create".}
proc spAnimationStateData_dispose*(self: ptr spAnimationStateData) {.importc: "spAnimationStateData_dispose".}
proc spAnimationStateData_setMixByName*(self: ptr spAnimationStateData;
                                       fromName: cstring; toName: cstring;
                                       duration: cfloat) {.importc: "spAnimationStateData_setMixByName".}
proc spAnimationStateData_setMix*(self: ptr spAnimationStateData;
                                 `from`: ptr spAnimation; to: ptr spAnimation;
                                 duration: cfloat) {.importc: "spAnimationStateData_setMix".}
proc spAnimationStateData_getMix*(self: ptr spAnimationStateData;
                                 `from`: ptr spAnimation; to: ptr spAnimation): cfloat {.importc: "spAnimationStateData_getMix".}


proc spAnimationState_create*(data: ptr spAnimationStateData): ptr spAnimationState {.importc: "spAnimationState_create".}
proc spAnimationState_dispose*(self: ptr spAnimationState) {.importc: "spAnimationState_dispose".}
proc spAnimationState_update*(self: ptr spAnimationState; delta: cfloat) {.importc: "spAnimationState_update".}
proc spAnimationState_apply*(self: ptr spAnimationState; skeleton: ptr spSkeleton) {.importc: "spAnimationState_apply".}
proc spAnimationState_clearTracks*(self: ptr spAnimationState) {.importc: "spAnimationState_clearTracks".}
proc spAnimationState_clearTrack*(self: ptr spAnimationState; trackIndex: cint) {.importc: "spAnimationState_clearTrack".}
proc spAnimationState_setAnimationByName*(self: ptr spAnimationState;
    trackIndex: cint; animationName: cstring; loop: cint): ptr spTrackEntry {.importc: "spAnimationState_setAnimationByName".}
proc spAnimationState_setAnimation*(self: ptr spAnimationState; trackIndex: cint;
                                   animation: ptr spAnimation; loop: cint): ptr spTrackEntry {.importc: "spAnimationState_setAnimation".}
proc spAnimationState_addAnimationByName*(self: ptr spAnimationState;
    trackIndex: cint; animationName: cstring; loop: cint; delay: cfloat): ptr spTrackEntry {.importc: "spAnimationState_addAnimationByName".}
proc spAnimationState_addAnimation*(self: ptr spAnimationState; trackIndex: cint;
                                   animation: ptr spAnimation; loop: cint;
                                   delay: cfloat): ptr spTrackEntry {.importc: "spAnimationState_addAnimation".}
proc spAnimationState_setEmptyAnimation*(self: ptr spAnimationState;
                                        trackIndex: cint; mixDuration: cfloat): ptr spTrackEntry {.importc: "spAnimationState_setEmptyAnimation".}
proc spAnimationState_addEmptyAnimation*(self: ptr spAnimationState;
                                        trackIndex: cint; mixDuration: cfloat;
                                        delay: cfloat): ptr spTrackEntry {.importc: "spAnimationState_addEmptyAnimation".}
proc spAnimationState_setEmptyAnimations*(self: ptr spAnimationState;
    mixDuration: cfloat) {.importc: "spAnimationState_setEmptyAnimations".}
proc spAnimationState_getCurrent*(self: ptr spAnimationState; trackIndex: cint): ptr spTrackEntry {.importc: "spAnimationState_getCurrent".}
proc spAnimationState_clearListenerNotifications*(self: ptr spAnimationState) {.importc: "spAnimationState_clearListenerNotifications".}
proc spTrackEntry_getAnimationTime*(entry: ptr spTrackEntry): cfloat {.importc: "spTrackEntry_getAnimationTime".}
proc spAnimationState_disposeStatics*() {.importc: "spAnimationState_disposeStatics".}


proc spAtlasPage_create*(atlas: ptr spAtlas; name: cstring): ptr spAtlasPage {.
    importc: "spAtlasPage_create".}
proc spAtlasPage_dispose*(self: ptr spAtlasPage) {.importc: "spAtlasPage_dispose".}


proc spAtlasRegion_create*(): ptr spAtlasRegion {.importc: "spAtlasRegion_create".}
proc spAtlasRegion_dispose*(self: ptr spAtlasRegion) {.importc: "spAtlasRegion_dispose".}

proc spAtlas_create*(data: cstring; length: cint; dir: cstring; rendererObject: pointer): ptr spAtlas {.importc: "spAtlas_create".}
proc spAtlas_createFromFile*(path: cstring; rendererObject: pointer): ptr spAtlas {.importc: "spAtlas_createFromFile".}
proc spAtlas_dispose*(atlas: ptr spAtlas) {.importc: "spAtlas_dispose".}
proc spAtlas_findRegion*(self: ptr spAtlas; name: cstring): ptr spAtlasRegion {.importc: "spAtlas_findRegion".}


proc spAttachmentLoader_dispose*(self: ptr spAttachmentLoader) {.importc: "spAttachmentLoader_dispose".}
proc spAttachmentLoader_createAttachment*(self: ptr spAttachmentLoader;
    skin: ptr spSkin; `type`: spAttachmentType; name: cstring; path: cstring): ptr spAttachment {.importc: "spAttachmentLoader_createAttachment".}
proc spAttachmentLoader_configureAttachment*(self: ptr spAttachmentLoader;
    attachment: ptr spAttachment) {.importc: "spAttachmentLoader_configureAttachment".}
proc spAttachmentLoader_disposeAttachment*(self: ptr spAttachmentLoader;
    attachment: ptr spAttachment) {.importc: "spAttachmentLoader_disposeAttachment".}


proc spAtlasAttachmentLoader_create*(atlas: ptr spAtlas): ptr spAtlasAttachmentLoader {.importc: "spAtlasAttachmentLoader_create".}


proc spBone_setYDown*(yDown: cint) {.importc: "spBone_setYDown".}
proc spBone_isYDown*(): cint {.importc: "spBone_isYDown".}
proc spBone_create*(data: ptr spBoneData; skeleton: ptr spSkeleton; parent: ptr spBone): ptr spBone {.importc: "spBone_create".}
proc spBone_dispose*(self: ptr spBone) {.importc: "spBone_dispose".}
proc spBone_setToSetupPose*(self: ptr spBone) {.importc: "spBone_setToSetupPose".}
proc spBone_updateWorldTransform*(self: ptr spBone) {.importc: "spBone_updateWorldTransform".}
proc spBone_updateWorldTransformWith*(self: ptr spBone; x: cfloat; y: cfloat;
                                     rotation: cfloat; scaleX: cfloat;
                                     scaleY: cfloat; shearX: cfloat; shearY: cfloat) {.importc: "spBone_updateWorldTransformWith".}
proc spBone_getWorldRotationX*(self: ptr spBone): cfloat {.importc: "spBone_getWorldRotationX".}
proc spBone_getWorldRotationY*(self: ptr spBone): cfloat {.importc: "spBone_getWorldRotationY".}
proc spBone_getWorldScaleX*(self: ptr spBone): cfloat {.importc: "spBone_getWorldScaleX".}
proc spBone_getWorldScaleY*(self: ptr spBone): cfloat {.importc: "spBone_getWorldScaleY".}
proc spBone_worldToLocalRotationX*(self: ptr spBone): cfloat {.importc: "spBone_worldToLocalRotationX".}
proc spBone_worldToLocalRotationY*(self: ptr spBone): cfloat {.importc: "spBone_worldToLocalRotationY".}
proc spBone_rotateWorld*(self: ptr spBone; degrees: cfloat) {.importc: "spBone_rotateWorld".}
proc spBone_updateAppliedTransform*(self: ptr spBone) {.importc: "spBone_updateAppliedTransform".}
proc spBone_worldToLocal*(self: ptr spBone; worldX: cfloat; worldY: cfloat;
                         localX: ptr cfloat; localY: ptr cfloat) {.importc: "spBone_worldToLocal".}
proc spBone_localToWorld*(self: ptr spBone; localX: cfloat; localY: cfloat;
                         worldX: ptr cfloat; worldY: ptr cfloat) {.importc: "spBone_localToWorld".}


proc spSlot_create*(data: ptr spSlotData; bone: ptr spBone): ptr spSlot {.importc: "spSlot_create".}
proc spSlot_dispose*(self: ptr spSlot) {.importc: "spSlot_dispose".}
proc spSlot_setAttachment*(self: ptr spSlot; attachment: ptr spAttachment) {.importc: "spSlot_setAttachment".}
proc spSlot_setAttachmentTime*(self: ptr spSlot; time: cfloat) {.importc: "spSlot_setAttachmentTime".}
proc spSlot_getAttachmentTime*(self: ptr spSlot): cfloat {.importc: "spSlot_getAttachmentTime".}
proc spSlot_setToSetupPose*(self: ptr spSlot) {.importc: "spSlot_setToSetupPose".}



proc spRegionAttachment_create*(name: cstring): ptr spRegionAttachment {.importc: "spRegionAttachment_create".}
proc spRegionAttachment_setUVs*(self: ptr spRegionAttachment; u: cfloat; v: cfloat;
                               u2: cfloat; v2: cfloat; rotate: cint) {.importc: "spRegionAttachment_setUVs".}
proc spRegionAttachment_updateOffset*(self: ptr spRegionAttachment) {.importc: "spRegionAttachment_updateOffset".}
proc spRegionAttachment_computeWorldVertices*(self: ptr spRegionAttachment;
    bone: ptr spBone; vertices: ptr cfloat) {.importc: "spRegionAttachment_computeWorldVertices".}


proc spVertexAttachment_computeWorldVertices*(self: ptr spVertexAttachment;
    slot: ptr spSlot; worldVertices: ptr cfloat) {.importc: "spVertexAttachment_computeWorldVertices".}
proc spVertexAttachment_computeWorldVertices1*(self: ptr spVertexAttachment;
    start: cint; count: cint; slot: ptr spSlot; worldVertices: ptr cfloat; offset: cint) {.importc: "spVertexAttachment_computeWorldVertices1".}


proc spMeshAttachment_create*(name: cstring): ptr spMeshAttachment {.importc: "spMeshAttachment_create".}
proc spMeshAttachment_updateUVs*(self: ptr spMeshAttachment) {.importc: "spMeshAttachment_updateUVs".}
proc spMeshAttachment_computeWorldVertices*(self: ptr spMeshAttachment;
    slot: ptr spSlot; worldVertices: ptr cfloat) {.importc: "spMeshAttachment_computeWorldVertices".}
proc spMeshAttachment_setParentMesh*(self: ptr spMeshAttachment;
                                    parentMesh: ptr spMeshAttachment) {.importc: "spMeshAttachment_setParentMesh".}


proc spBoundingBoxAttachment_create*(name: cstring): ptr spBoundingBoxAttachment {.importc: "spBoundingBoxAttachment_create".}
proc spBoundingBoxAttachment_computeWorldVertices*(
    self: ptr spBoundingBoxAttachment; slot: ptr spSlot; worldVertices: ptr cfloat) {.importc: "spBoundingBoxAttachment_computeWorldVertices".}


proc spIkConstraint_create*(data: ptr spIkConstraintData; skeleton: ptr spSkeleton): ptr spIkConstraint {.importc: "spIkConstraint_create".}
proc spIkConstraint_dispose*(self: ptr spIkConstraint) {.importc: "spIkConstraint_dispose".}
proc spIkConstraint_apply*(self: ptr spIkConstraint) {.importc: "spIkConstraint_apply".}
proc spIkConstraint_apply1*(bone: ptr spBone; targetX: cfloat; targetY: cfloat;
                           alpha: cfloat) {.importc: "spIkConstraint_apply1".}
proc spIkConstraint_apply2*(parent: ptr spBone; child: ptr spBone; targetX: cfloat;
                           targetY: cfloat; bendDirection: cint; alpha: cfloat) {.importc: "spIkConstraint_apply2".}


proc spTransformConstraint_create*(data: ptr spTransformConstraintData;
                                  skeleton: ptr spSkeleton): ptr spTransformConstraint {.importc: "spTransformConstraint_create".}
proc spTransformConstraint_dispose*(self: ptr spTransformConstraint) {.importc: "spTransformConstraint_dispose".}
proc spTransformConstraint_apply*(self: ptr spTransformConstraint) {.importc: "spTransformConstraint_apply".}


proc spPathAttachment_create*(name: cstring): ptr spPathAttachment {.importc: "spPathAttachment_create".}
proc spPathAttachment_computeWorldVertices*(self: ptr spPathAttachment;
    slot: ptr spSlot; worldVertices: ptr cfloat) {.importc: "spPathAttachment_computeWorldVertices".}
proc spPathAttachment_computeWorldVertices1*(self: ptr spPathAttachment;
    slot: ptr spSlot; start: cint; count: cint; worldVertices: ptr cfloat; offset: cint) {.importc: "spPathAttachment_computeWorldVertices1".}


proc spPathConstraint_create*(data: ptr spPathConstraintData;
                             skeleton: ptr spSkeleton): ptr spPathConstraint {.importc: "spPathConstraint_create".}
proc spPathConstraint_dispose*(self: ptr spPathConstraint) {.importc: "spPathConstraint_dispose".}
proc spPathConstraint_apply*(self: ptr spPathConstraint) {.importc: "spPathConstraint_apply".}
proc spPathConstraint_computeWorldPositions*(self: ptr spPathConstraint;
    path: ptr spPathAttachment; spacesCount: cint; tangents: cint;
    percentPosition: cint; percentSpacing: cint): ptr cfloat {.importc: "spPathConstraint_computeWorldPositions".}


proc spSkeleton_create*(data: ptr spSkeletonData): ptr spSkeleton {.importc: "spSkeleton_create".}
proc spSkeleton_dispose*(self: ptr spSkeleton) {.importc: "spSkeleton_dispose".}
proc spSkeleton_updateCache*(self: ptr spSkeleton) {.importc: "spSkeleton_updateCache".}
proc spSkeleton_updateWorldTransform*(self: ptr spSkeleton) {.importc: "spSkeleton_updateWorldTransform".}
proc spSkeleton_setToSetupPose*(self: ptr spSkeleton) {.importc: "spSkeleton_setToSetupPose".}
proc spSkeleton_setBonesToSetupPose*(self: ptr spSkeleton) {.importc: "spSkeleton_setBonesToSetupPose".}
proc spSkeleton_setSlotsToSetupPose*(self: ptr spSkeleton) {.importc: "spSkeleton_setSlotsToSetupPose".}
proc spSkeleton_findBone*(self: ptr spSkeleton; boneName: cstring): ptr spBone {.importc: "spSkeleton_findBone".}
proc spSkeleton_findBoneIndex*(self: ptr spSkeleton; boneName: cstring): cint {.importc: "spSkeleton_findBoneIndex".}
proc spSkeleton_findSlot*(self: ptr spSkeleton; slotName: cstring): ptr spSlot {.importc: "spSkeleton_findSlot".}
proc spSkeleton_findSlotIndex*(self: ptr spSkeleton; slotName: cstring): cint {.importc: "spSkeleton_findSlotIndex".}
proc spSkeleton_setSkin*(self: ptr spSkeleton; skin: ptr spSkin) {.importc: "spSkeleton_setSkin".}
proc spSkeleton_setSkinByName*(self: ptr spSkeleton; skinName: cstring): cint {.importc: "spSkeleton_setSkinByName".}
proc spSkeleton_getAttachmentForSlotName*(self: ptr spSkeleton; slotName: cstring;
    attachmentName: cstring): ptr spAttachment {.importc: "spSkeleton_getAttachmentForSlotName".}
proc spSkeleton_getAttachmentForSlotIndex*(self: ptr spSkeleton; slotIndex: cint;
    attachmentName: cstring): ptr spAttachment {.importc: "spSkeleton_getAttachmentForSlotIndex".}
proc spSkeleton_setAttachment*(self: ptr spSkeleton; slotName: cstring;
                              attachmentName: cstring): cint {.importc: "spSkeleton_setAttachment".}
proc spSkeleton_findIkConstraint*(self: ptr spSkeleton; constraintName: cstring): ptr spIkConstraint {.importc: "spSkeleton_findIkConstraint".}
proc spSkeleton_findTransformConstraint*(self: ptr spSkeleton;
                                        constraintName: cstring): ptr spTransformConstraint {.importc: "spSkeleton_findTransformConstraint".}
proc spSkeleton_findPathConstraint*(self: ptr spSkeleton; constraintName: cstring): ptr spPathConstraint {.importc: "spSkeleton_findPathConstraint".}
proc spSkeleton_update*(self: ptr spSkeleton; deltaTime: cfloat) {.importc: "spSkeleton_update".}


proc spPolygon_create*(capacity: cint): ptr spPolygon {.importc: "spPolygon_create".}
proc spPolygon_dispose*(self: ptr spPolygon) {.importc: "spPolygon_dispose".}
proc spPolygon_containsPoint*(polygon: ptr spPolygon; x: cfloat; y: cfloat): cint {.importc: "spPolygon_containsPoint".}
proc spPolygon_intersectsSegment*(polygon: ptr spPolygon; x1: cfloat; y1: cfloat;
                                 x2: cfloat; y2: cfloat): cint {.importc: "spPolygon_intersectsSegment".}


proc spSkeletonBounds_create*(): ptr spSkeletonBounds {.importc: "spSkeletonBounds_create".}
proc spSkeletonBounds_dispose*(self: ptr spSkeletonBounds) {.importc: "spSkeletonBounds_dispose".}
proc spSkeletonBounds_update*(self: ptr spSkeletonBounds; skeleton: ptr spSkeleton;
                             updateAabb: cint) {.importc: "spSkeletonBounds_update".}
proc spSkeletonBounds_aabbContainsPoint*(self: ptr spSkeletonBounds; x: cfloat;
                                        y: cfloat): cint {.importc: "spSkeletonBounds_aabbContainsPoint".}
proc spSkeletonBounds_aabbIntersectsSegment*(self: ptr spSkeletonBounds; x1: cfloat;
    y1: cfloat; x2: cfloat; y2: cfloat): cint {.importc: "spSkeletonBounds_aabbIntersectsSegment".}
proc spSkeletonBounds_aabbIntersectsSkeleton*(self: ptr spSkeletonBounds;
    bounds: ptr spSkeletonBounds): cint {.importc: "spSkeletonBounds_aabbIntersectsSkeleton".}
proc spSkeletonBounds_containsPoint*(self: ptr spSkeletonBounds; x: cfloat; y: cfloat): ptr spBoundingBoxAttachment {.importc: "spSkeletonBounds_containsPoint".}
proc spSkeletonBounds_intersectsSegment*(self: ptr spSkeletonBounds; x1: cfloat;
                                        y1: cfloat; x2: cfloat; y2: cfloat): ptr spBoundingBoxAttachment {.importc: "spSkeletonBounds_intersectsSegment".}
proc spSkeletonBounds_getPolygon*(self: ptr spSkeletonBounds;
                                 boundingBox: ptr spBoundingBoxAttachment): ptr spPolygon {.importc: "spSkeletonBounds_getPolygon".}


proc spSkeletonBinary_createWithLoader*(attachmentLoader: ptr spAttachmentLoader): ptr spSkeletonBinary {.importc: "spSkeletonBinary_createWithLoader".}
proc spSkeletonBinary_create*(atlas: ptr spAtlas): ptr spSkeletonBinary {.importc: "spSkeletonBinary_create".}
proc spSkeletonBinary_dispose*(self: ptr spSkeletonBinary) {.importc: "spSkeletonBinary_dispose".}
proc spSkeletonBinary_readSkeletonData*(self: ptr spSkeletonBinary;
                                       binary: ptr cuchar; length: cint): ptr spSkeletonData {.importc: "spSkeletonBinary_readSkeletonData".}
proc spSkeletonBinary_readSkeletonDataFile*(self: ptr spSkeletonBinary;
    path: cstring): ptr spSkeletonData {.importc: "spSkeletonBinary_readSkeletonDataFile".}
  
  
  


proc spSkeletonJson_createWithLoader*(attachmentLoader: ptr spAttachmentLoader): ptr spSkeletonJson {.importc: "spSkeletonJson_createWithLoader".}
proc spSkeletonJson_create*(atlas: ptr spAtlas): ptr spSkeletonJson {.importc: "spSkeletonJson_create".}
proc spSkeletonJson_dispose*(self: ptr spSkeletonJson) {.importc: "spSkeletonJson_dispose".}
proc spSkeletonJson_readSkeletonData*(self: ptr spSkeletonJson; json: cstring): ptr spSkeletonData {.importc: "spSkeletonJson_readSkeletonData".}
proc spSkeletonJson_readSkeletonDataFile*(self: ptr spSkeletonJson; path: cstring): ptr spSkeletonData {.importc: "spSkeletonJson_readSkeletonDataFile".}

proc readFile*(path: cstring; length: ptr cint): cstring {.importc: "_readFile".}

proc spAttachmentLoader_init*(self: ptr spAttachmentLoader;
                              dispose: proc (self: ptr spAttachmentLoader) {.cdecl.};
    createAttachment: proc (self: ptr spAttachmentLoader; skin: ptr spSkin;
                          `type`: spAttachmentType; name: cstring; path: cstring): ptr spAttachment {.cdecl.};
    configureAttachment: proc (self: ptr spAttachmentLoader; a3: ptr spAttachment) {.cdecl.};
    disposeAttachment: proc (self: ptr spAttachmentLoader; a3: ptr spAttachment) {.cdecl.}) {.importc: "_spAttachmentLoader_init".}
proc spAttachmentLoader_deinit*(self: ptr spAttachmentLoader) {.importc: "_spAttachmentLoader_deinit".}

when isMainModule:
  let atlas = spAtlas_createFromFile("./spine-runtimes/spine-sfml/data/tank.atlas", nil)
  let json = spSkeletonJson_create(atlas)
  let skeletonData = spSkeletonJson_readSkeletonDataFile(json, "./spine-runtimes/spine-sfml/data/tank.json")
  spSkeletonJson_dispose(json)

  echo repr skeletonData

  proc spAtlasPage_createTexture*(self: ptr spAtlasPage; path: cstring) {.exportc: "_spAtlasPage_createTexture".} =
    discard

  proc spAtlasPage_disposeTexture*(self: ptr spAtlasPage) {.exportc: "_spAtlasPage_disposeTexture".} =
    discard
  
  proc spUtil_readFile*(path: cstring; length: ptr cint): cstring {.exportc: "_spUtil_readFile".} =
    readFile(path, length)