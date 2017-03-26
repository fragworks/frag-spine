type
  spTransformMode* = enum
    SP_TRANSFORMMODE_NORMAL, SP_TRANSFORMMODE_ONLYTRANSLATION,
    SP_TRANSFORMMODE_NOROTATIONORREFLECTION, SP_TRANSFORMMODE_NOSCALE,
    SP_TRANSFORMMODE_NOSCALEORREFLECTION

  spTimelineType* = enum
    SP_TIMELINE_ROTATE, SP_TIMELINE_TRANSLATE, SP_TIMELINE_SCALE,
    SP_TIMELINE_SHEAR, SP_TIMELINE_ATTACHMENT, SP_TIMELINE_COLOR,
    SP_TIMELINE_DEFORM, SP_TIMELINE_EVENT, SP_TIMELINE_DRAWORDER,
    SP_TIMELINE_IKCONSTRAINT, SP_TIMELINE_TRANSFORMCONSTRAINT,
    SP_TIMELINE_PATHCONSTRAINTPOSITION, SP_TIMELINE_PATHCONSTRAINTSPACING,
    SP_TIMELINE_PATHCONSTRAINTMIX

  spTimeline* = object
    `type`*: spTimelineType
    vtable*: pointer

  spSkeleton* = object
    data*: ptr spSkeletonData
    bonesCount*: cint
    bones*: ptr ptr spBone
    root*: ptr spBone
    slotsCount*: cint
    slots*: ptr ptr spSlot
    drawOrder*: ptr ptr spSlot
    ikConstraintsCount*: cint
    ikConstraints*: ptr ptr spIkConstraint
    transformConstraintsCount*: cint
    transformConstraints*: ptr ptr spTransformConstraint
    pathConstraintsCount*: cint
    pathConstraints*: ptr ptr spPathConstraint
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

  spBone* = object
    data*: ptr spBoneData
    skeleton*: ptr spSkeleton
    parent*: ptr spBone
    childrenCount*: cint
    children*: ptr ptr spBone
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

  spSkeletonData* = object
    version*: cstring
    hash*: cstring
    width*: cfloat
    height*: cfloat
    bonesCount*: cint
    bones*: ptr ptr spBoneData
    slotsCount*: cint
    slots*: ptr ptr spSlotData
    skinsCount*: cint
    skins*: ptr ptr spSkin
    defaultSkin*: ptr spSkin
    eventsCount*: cint
    events*: ptr ptr spEventData
    animationsCount*: cint
    animations*: ptr ptr spAnimation
    ikConstraintsCount*: cint
    ikConstraints*: ptr ptr spIkConstraintData
    transformConstraintsCount*: cint
    transformConstraints*: ptr ptr spTransformConstraintData
    pathConstraintsCount*: cint
    pathConstraints*: ptr ptr spPathConstraintData

  spSkin* = object
    name*: cstring

  IEntry* = object
    slotIndex*: cint
    name*: cstring
    attachment*: ptr spAttachment
    next*: ptr IEntry

  IspSkin* = object
    super*: spSkin
    entries*: ptr IEntry

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

  spBlendMode* = enum
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

  spAttachmentLoader* = object
  
  spAttachmentType* = enum
    SP_ATTACHMENT_REGION, SP_ATTACHMENT_BOUNDING_BOX, SP_ATTACHMENT_MESH,
    SP_ATTACHMENT_LINKED_MESH, SP_ATTACHMENT_PATH
  spAttachment* = object
    name*: cstring
    `type`*: spAttachmentType
    vtable*: pointer
    attachmentLoader*: ptr spAttachmentLoader

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

  spAnimation* = object
    name*: cstring
    duration*: cfloat
    timelinesCount*: cint
    timelines*: ptr ptr spTimeline

  spSkeletonBounds* = object
    count*: cint
    boundingBoxes*: ptr ptr spBoundingBoxAttachment
    polygons*: ptr ptr spPolygon
    minX*: cfloat
    minY*: cfloat
    maxX*: cfloat
    maxY*: cfloat

  spBaseTimeline* = object
    super*: spCurveTimeline
    framesCount*: cint
    frames*: ptr cfloat
    boneIndex*: cint

  spPathConstraintPositionTimeline* = object
    super*: spCurveTimeline
    framesCount*: cint
    frames*: ptr cfloat
    pathConstraintIndex*: cint

  spRotateTimeline* = spBaseTimeline
  spTranslateTimeline* = spBaseTimeline
  spScaleTimeline* = spBaseTimeline
  spShearTimeline* = spBaseTimeline

  spColorTimeline* = object
    super*: spCurveTimeline
    framesCount*: cint
    frames*: ptr cfloat
    slotIndex*: cint

  spCurveTimeline* = object
    super*: spTimeline
    curves*: ptr cfloat

  spAttachmentTimeline* = object
    super*: spTimeline
    framesCount*: cint
    frames*: ptr cfloat
    slotIndex*: cint
    attachmentNames*: cstringArray

  spDeformTimeline* = object
    super*: spCurveTimeline
    framesCount*: cint
    frames*: ptr cfloat
    frameVerticesCount*: cint
    frameVertices*: ptr ptr cfloat
    slotIndex*: cint
    attachment*: ptr spAttachment

  spEventTimeline* = object
    super*: spTimeline
    framesCount*: cint
    frames*: ptr cfloat
    events*: ptr ptr spEvent

  spDrawOrderTimeline* = object
    super*: spTimeline
    framesCount*: cint
    frames*: ptr cfloat
    drawOrders*: ptr ptr cint
    slotsCount*: cint

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

  spTransformConstraintData* = object
    name*: cstring
    order*: cint
    bonesCount*: cint
    bones*: ptr ptr spBoneData
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

  spIkConstraintData* = object
    name*: cstring
    order*: cint
    bonesCount*: cint
    bones*: ptr ptr spBoneData
    target*: ptr spBoneData
    bendDirection*: cint
    mix*: cfloat

  spPositionMode* = enum
    SP_POSITION_MODE_FIXED, SP_POSITION_MODE_PERCENT
  spSpacingMode* = enum
    SP_SPACING_MODE_LENGTH, SP_SPACING_MODE_FIXED, SP_SPACING_MODE_PERCENT
  spRotateMode* = enum
    SP_ROTATE_MODE_TANGENT, SP_ROTATE_MODE_CHAIN, SP_ROTATE_MODE_CHAIN_SCALE
  spPathConstraintData* = object
    name*: cstring
    order*: cint
    bonesCount*: cint
    bones*: ptr ptr spBoneData
    target*: ptr spSlotData
    positionMode*: spPositionMode
    spacingMode*: spSpacingMode
    rotateMode*: spRotateMode
    offsetRotation*: cfloat
    position*: cfloat
    spacing*: cfloat
    rotateMix*: cfloat
    translateMix*: cfloat

  spPolygon* = object
    vertices*: ptr cfloat
    count*: cint
    capacity*: cint

  spTransformConstraint* = object
    data*: ptr spTransformConstraintData
    bonesCount*: cint
    bones*: ptr ptr spBone
    target*: ptr spBone
    rotateMix*: cfloat
    translateMix*: cfloat
    scaleMix*: cfloat
    shearMix*: cfloat

  spIkConstraint* = object
    data*: ptr spIkConstraintData
    bonesCount*: cint
    bones*: ptr ptr spBone
    target*: ptr spBone
    bendDirection*: cint
    mix*: cfloat

  spVertexAttachment* = object
    super*: spAttachment
    bonesCount*: cint
    bones*: ptr cint
    verticesCount*: cint
    vertices*: ptr cfloat
    worldVerticesLength*: cint

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

  spAtlasFormat* = enum
    SP_ATLAS_UNKNOWN_FORMAT, SP_ATLAS_ALPHA, SP_ATLAS_INTENSITY,
    SP_ATLAS_LUMINANCE_ALPHA, SP_ATLAS_RGB565, SP_ATLAS_RGBA4444, SP_ATLAS_RGB888,
    SP_ATLAS_RGBA8888
  spAtlasFilter* = enum
    SP_ATLAS_UNKNOWN_FILTER, SP_ATLAS_NEAREST, SP_ATLAS_LINEAR, SP_ATLAS_MIPMAP,
    SP_ATLAS_MIPMAP_NEAREST_NEAREST, SP_ATLAS_MIPMAP_LINEAR_NEAREST,
    SP_ATLAS_MIPMAP_NEAREST_LINEAR, SP_ATLAS_MIPMAP_LINEAR_LINEAR
  spAtlasWrap* = enum
    SP_ATLAS_MIRROREDREPEAT, SP_ATLAS_CLAMPTOEDGE, SP_ATLAS_REPEAT

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

  spPathConstraint* = object
    data*: ptr spPathConstraintData
    bonesCount*: cint
    bones*: ptr ptr spBone
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

  spPathAttachment* = object
    super*: spVertexAttachment
    lengthsLength*: cint
    lengths*: ptr cfloat
    closed*: cint
    constantSpeed*: cint

  spVertexIndex* = enum
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
    uvs*: ptr cfloat
    trianglesCount*: cint
    triangles*: ptr cushort
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

  spAnimationStateData* = object
    skeletonData*: ptr spSkeletonData
    defaultMix*: cfloat
    entries*: pointer

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
    tracks*: ptr ptr spTrackEntry
    listener*: spAnimationStateListener
    timeScale*: cfloat
    rendererObject*: pointer

  IspEventQueueItem* = object {.union.}
    `type`*: cint
    entry*: ptr spTrackEntry
    event*: ptr spEvent

  IspEventQueue* = object
    state*: ptr IspAnimationState
    objects*: ptr IspEventQueueItem
    objectsCount*: cint
    objectsCapacity*: cint
    drainDisabled*: cint

  IspAnimationState* = object
    super*: spAnimationState
    eventsCount*: cint
    events*: ptr ptr spEvent
    queue*: ptr IspEventQueue
    propertyIDs*: ptr cint
    propertyIDsCount*: cint
    propertyIDsCapacity*: cint
    animationsChanged*: cint

  spAtlasAttachmentLoader* = object
    super*: spAttachmentLoader
    atlas*: ptr spAtlas

  spSkeletonBinary* = object
    scale*: cfloat
    attachmentLoader*: ptr spAttachmentLoader
    error*: cstring

  spSkeletonJson* = object
    scale*: cfloat
    attachmentLoader*: ptr spAttachmentLoader
    error*: cstring

  spEventType* = enum
    SP_ANIMATION_START, SP_ANIMATION_INTERRUPT, SP_ANIMATION_END,
    SP_ANIMATION_COMPLETE, SP_ANIMATION_DISPOSE, SP_ANIMATION_EVENT
  spAnimationStateListener* = proc (state: ptr spAnimationState; `type`: spEventType;
                                 entry: ptr spTrackEntry; event: ptr spEvent)

#[
proc spBoneData_create*(index: cint; name: cstring; parent: ptr spBoneData): ptr spBoneData
proc spBoneData_dispose*(self: ptr spBoneData)



proc spSlotData_create*(index: cint; name: cstring; boneData: ptr spBoneData): ptr spSlotData
proc spSlotData_dispose*(self: ptr spSlotData)
proc spSlotData_setAttachmentName*(self: ptr spSlotData; attachmentName: cstring)




proc spAttachment_dispose*(self: ptr spAttachment)



proc spSkin_create*(name: cstring): ptr spSkin
proc spSkin_dispose*(self: ptr spSkin)
proc spSkin_addAttachment*(self: ptr spSkin; slotIndex: cint; name: cstring;
                          attachment: ptr spAttachment)
proc spSkin_getAttachment*(self: ptr spSkin; slotIndex: cint; name: cstring): ptr spAttachment
proc spSkin_getAttachmentName*(self: ptr spSkin; slotIndex: cint;
                              attachmentIndex: cint): cstring
proc spSkin_attachAll*(self: ptr spSkin; skeleton: ptr spSkeleton;
                      oldspSkin: ptr spSkin)


proc spEventData_create*(name: cstring): ptr spEventData
proc spEventData_dispose*(self: ptr spEventData)
  


proc spEvent_create*(time: cfloat; data: ptr spEventData): ptr spEvent
proc spEvent_dispose*(self: ptr spEvent)
  
  


proc spAnimation_create*(name: cstring; timelinesCount: cint): ptr spAnimation
proc spAnimation_dispose*(self: ptr spAnimation)
proc spAnimation_apply*(self: ptr spAnimation; skeleton: ptr spSkeleton;
                       lastTime: cfloat; time: cfloat; loop: cint;
                       events: ptr ptr spEvent; eventsCount: ptr cint; alpha: cfloat;
                       setupPose: cint; mixingOut: cint)


proc spTimeline_dispose*(self: ptr spTimeline)
proc spTimeline_apply*(self: ptr spTimeline; skeleton: ptr spSkeleton;
                      lastTime: cfloat; time: cfloat; firedEvents: ptr ptr spEvent;
                      eventsCount: ptr cint; alpha: cfloat; setupPose: cint;
                      mixingOut: cint)
proc spTimeline_getPropertyId*(self: ptr spTimeline): cint


proc spCurveTimeline_setLinear*(self: ptr spCurveTimeline; frameIndex: cint)
proc spCurveTimeline_setStepped*(self: ptr spCurveTimeline; frameIndex: cint)
proc spCurveTimeline_setCurve*(self: ptr spCurveTimeline; frameIndex: cint;
                              cx1: cfloat; cy1: cfloat; cx2: cfloat; cy2: cfloat)
proc spCurveTimeline_getCurvePercent*(self: ptr spCurveTimeline; frameIndex: cint;
                                     percent: cfloat): cfloat


var
  ROTATE_PREV_TIME*: cint = - 2
  ROTATE_PREV_ROTATION*: cint = - 1

var ROTATE_ROTATION*: cint = 1

var ROTATE_ENTRIES*: cint = 2
  

proc spRotateTimeline_create*(framesCount: cint): ptr spRotateTimeline
proc spRotateTimeline_setFrame*(self: ptr spRotateTimeline; frameIndex: cint;
                               time: cfloat; angle: cfloat)
var TRANSLATE_ENTRIES*: cint = 3

proc spTranslateTimeline_create*(framesCount: cint): ptr spTranslateTimeline
proc spTranslateTimeline_setFrame*(self: ptr spTranslateTimeline; frameIndex: cint;
                                  time: cfloat; x: cfloat; y: cfloat)

proc spScaleTimeline_create*(framesCount: cint): ptr spScaleTimeline
proc spScaleTimeline_setFrame*(self: ptr spScaleTimeline; frameIndex: cint;
                              time: cfloat; x: cfloat; y: cfloat)

proc spShearTimeline_create*(framesCount: cint): ptr spShearTimeline
proc spShearTimeline_setFrame*(self: ptr spShearTimeline; frameIndex: cint;
                              time: cfloat; x: cfloat; y: cfloat)
var COLOR_ENTRIES*: cint = 5


proc spColorTimeline_create*(framesCount: cint): ptr spColorTimeline
proc spColorTimeline_setFrame*(self: ptr spColorTimeline; frameIndex: cint;
                              time: cfloat; r: cfloat; g: cfloat; b: cfloat; a: cfloat)


proc spAttachmentTimeline_create*(framesCount: cint): ptr spAttachmentTimeline
proc spAttachmentTimeline_setFrame*(self: ptr spAttachmentTimeline;
                                   frameIndex: cint; time: cfloat;
                                   attachmentName: cstring)


proc spEventTimeline_create*(framesCount: cint): ptr spEventTimeline
proc spEventTimeline_setFrame*(self: ptr spEventTimeline; frameIndex: cint;
                              event: ptr spEvent)


proc spDrawOrderTimeline_create*(framesCount: cint; slotsCount: cint): ptr spDrawOrderTimeline
proc spDrawOrderTimeline_setFrame*(self: ptr spDrawOrderTimeline; frameIndex: cint;
                                  time: cfloat; drawOrder: ptr cint)


proc spDeformTimeline_create*(framesCount: cint; frameVerticesCount: cint): ptr spDeformTimeline
proc spDeformTimeline_setFrame*(self: ptr spDeformTimeline; frameIndex: cint;
                               time: cfloat; vertices: ptr cfloat)
var IKCONSTRAINT_ENTRIES*: cint = 3


proc spIkConstraintTimeline_create*(framesCount: cint): ptr spIkConstraintTimeline
proc spIkConstraintTimeline_setFrame*(self: ptr spIkConstraintTimeline;
                                     frameIndex: cint; time: cfloat; mix: cfloat;
                                     bendDirection: cint)
var TRANSFORMCONSTRAINT_ENTRIES*: cint = 5


proc spTransformConstraintTimeline_create*(framesCount: cint): ptr spTransformConstraintTimeline
proc spTransformConstraintTimeline_setFrame*(
    self: ptr spTransformConstraintTimeline; frameIndex: cint; time: cfloat;
    rotateMix: cfloat; translateMix: cfloat; scaleMix: cfloat; shearMix: cfloat)
var PATHCONSTRAINTPOSITION_ENTRIES*: cint = 2


proc spPathConstraintPositionTimeline_create*(framesCount: cint): ptr spPathConstraintPositionTimeline
proc spPathConstraintPositionTimeline_setFrame*(
    self: ptr spPathConstraintPositionTimeline; frameIndex: cint; time: cfloat;
    value: cfloat)
var PATHCONSTRAINTSPACING_ENTRIES*: cint = 2


proc spPathConstraintSpacingTimeline_create*(framesCount: cint): ptr spPathConstraintSpacingTimeline
proc spPathConstraintSpacingTimeline_setFrame*(
    self: ptr spPathConstraintSpacingTimeline; frameIndex: cint; time: cfloat;
    value: cfloat)
var PATHCONSTRAINTMIX_ENTRIES*: cint = 3


proc spPathConstraintMixTimeline_create*(framesCount: cint): ptr spPathConstraintMixTimeline
proc spPathConstraintMixTimeline_setFrame*(self: ptr spPathConstraintMixTimeline;
    frameIndex: cint; time: cfloat; rotateMix: cfloat; translateMix: cfloat)


proc spIkConstraintData_create*(name: cstring): ptr spIkConstraintData
proc spIkConstraintData_dispose*(self: ptr spIkConstraintData)


proc spTransformConstraintData_create*(name: cstring): ptr spTransformConstraintData
proc spTransformConstraintData_dispose*(self: ptr spTransformConstraintData)





proc spPathConstraintData_create*(name: cstring): ptr spPathConstraintData
proc spPathConstraintData_dispose*(self: ptr spPathConstraintData)


proc spSkeletonData_create*(): ptr spSkeletonData
proc spSkeletonData_dispose*(self: ptr spSkeletonData)
proc spSkeletonData_findBone*(self: ptr spSkeletonData; boneName: cstring): ptr spBoneData
proc spSkeletonData_findBoneIndex*(self: ptr spSkeletonData; boneName: cstring): cint
proc spSkeletonData_findSlot*(self: ptr spSkeletonData; slotName: cstring): ptr spSlotData
proc spSkeletonData_findSlotIndex*(self: ptr spSkeletonData; slotName: cstring): cint
proc spSkeletonData_findSkin*(self: ptr spSkeletonData; skinName: cstring): ptr spSkin
proc spSkeletonData_findEvent*(self: ptr spSkeletonData; eventName: cstring): ptr spEventData
proc spSkeletonData_findAnimation*(self: ptr spSkeletonData; animationName: cstring): ptr spAnimation
proc spSkeletonData_findIkConstraint*(self: ptr spSkeletonData;
                                     constraintName: cstring): ptr spIkConstraintData
proc spSkeletonData_findTransformConstraint*(self: ptr spSkeletonData;
    constraintName: cstring): ptr spTransformConstraintData
proc spSkeletonData_findPathConstraint*(self: ptr spSkeletonData;
                                       constraintName: cstring): ptr spPathConstraintData


proc spBone_setYDown*(yDown: cint)
proc spBone_isYDown*(): cint
proc spBone_create*(data: ptr spBoneData; skeleton: ptr spSkeleton; parent: ptr spBone): ptr spBone
proc spBone_dispose*(self: ptr spBone)
proc spBone_setToSetupPose*(self: ptr spBone)
proc spBone_updateWorldTransform*(self: ptr spBone)
proc spBone_updateWorldTransformWith*(self: ptr spBone; x: cfloat; y: cfloat;
                                     rotation: cfloat; scaleX: cfloat;
                                     scaleY: cfloat; shearX: cfloat; shearY: cfloat)
proc spBone_getWorldRotationX*(self: ptr spBone): cfloat
proc spBone_getWorldRotationY*(self: ptr spBone): cfloat
proc spBone_getWorldScaleX*(self: ptr spBone): cfloat
proc spBone_getWorldScaleY*(self: ptr spBone): cfloat
proc spBone_worldToLocalRotationX*(self: ptr spBone): cfloat
proc spBone_worldToLocalRotationY*(self: ptr spBone): cfloat
proc spBone_rotateWorld*(self: ptr spBone; degrees: cfloat)
proc spBone_updateAppliedTransform*(self: ptr spBone)
proc spBone_worldToLocal*(self: ptr spBone; worldX: cfloat; worldY: cfloat;
                         localX: ptr cfloat; localY: ptr cfloat)
proc spBone_localToWorld*(self: ptr spBone; localX: cfloat; localY: cfloat;
                         worldX: ptr cfloat; worldY: ptr cfloat)


proc spSlot_create*(data: ptr spSlotData; bone: ptr spBone): ptr spSlot
proc spSlot_dispose*(self: ptr spSlot)
proc spSlot_setAttachment*(self: ptr spSlot; attachment: ptr spAttachment)
proc spSlot_setAttachmentTime*(self: ptr spSlot; time: cfloat)
proc spSlot_getAttachmentTime*(self: ptr spSlot): cfloat
proc spSlot_setToSetupPose*(self: ptr spSlot)
  


proc spIkConstraint_create*(data: ptr spIkConstraintData; skeleton: ptr spSkeleton): ptr spIkConstraint
proc spIkConstraint_dispose*(self: ptr spIkConstraint)
proc spIkConstraint_apply*(self: ptr spIkConstraint)
proc spIkConstraint_apply1*(bone: ptr spBone; targetX: cfloat; targetY: cfloat;
                           alpha: cfloat)
proc spIkConstraint_apply2*(parent: ptr spBone; child: ptr spBone; targetX: cfloat;
                           targetY: cfloat; bendDirection: cint; alpha: cfloat)


proc spTransformConstraint_create*(data: ptr spTransformConstraintData;
                                  skeleton: ptr spSkeleton): ptr spTransformConstraint
proc spTransformConstraint_dispose*(self: ptr spTransformConstraint)
proc spTransformConstraint_apply*(self: ptr spTransformConstraint)


proc spVertexAttachment_computeWorldVertices*(self: ptr spVertexAttachment;
    slot: ptr spSlot; worldVertices: ptr cfloat)
proc spVertexAttachment_computeWorldVertices1*(self: ptr spVertexAttachment;
    start: cint; count: cint; slot: ptr spSlot; worldVertices: ptr cfloat; offset: cint)


proc spAtlasPage_create*(atlas: ptr spAtlas; name: cstring): ptr spAtlasPage
proc spAtlasPage_dispose*(self: ptr spAtlasPage)


proc spAtlasRegion_create*(): ptr spAtlasRegion
proc spAtlasRegion_dispose*(self: ptr spAtlasRegion)

]#
proc spAtlas_create*(data: cstring; length: cint; dir: cstring; rendererObject: pointer): ptr spAtlas {.importc: "spAtlas_create".}
proc spAtlas_createFromFile*(path: cstring; rendererObject: pointer): ptr spAtlas {.importc: "spAtlas_createFromFile".}
proc spAtlas_dispose*(atlas: ptr spAtlas) {.importc: "spAtlas_dispose".}
proc spAtlas_findRegion*(self: ptr spAtlas; name: cstring): ptr spAtlasRegion {.importc: "spAtlas_findRegion".}

#[
proc spPathAttachment_create*(name: cstring): ptr spPathAttachment
proc spPathAttachment_computeWorldVertices*(self: ptr spPathAttachment;
    slot: ptr spSlot; worldVertices: ptr cfloat)
proc spPathAttachment_computeWorldVertices1*(self: ptr spPathAttachment;
    slot: ptr spSlot; start: cint; count: cint; worldVertices: ptr cfloat; offset: cint)


proc spPathConstraint_create*(data: ptr spPathConstraintData;
                             skeleton: ptr spSkeleton): ptr spPathConstraint
proc spPathConstraint_dispose*(self: ptr spPathConstraint)
proc spPathConstraint_apply*(self: ptr spPathConstraint)
proc spPathConstraint_computeWorldPositions*(self: ptr spPathConstraint;
    path: ptr spPathAttachment; spacesCount: cint; tangents: cint;
    percentPosition: cint; percentSpacing: cint): ptr cfloat


proc spSkeleton_create*(data: ptr spSkeletonData): ptr spSkeleton
proc spSkeleton_dispose*(self: ptr spSkeleton)
proc spSkeleton_updateCache*(self: ptr spSkeleton)
proc spSkeleton_updateWorldTransform*(self: ptr spSkeleton)
proc spSkeleton_setToSetupPose*(self: ptr spSkeleton)
proc spSkeleton_setBonesToSetupPose*(self: ptr spSkeleton)
proc spSkeleton_setSlotsToSetupPose*(self: ptr spSkeleton)
proc spSkeleton_findBone*(self: ptr spSkeleton; boneName: cstring): ptr spBone
proc spSkeleton_findBoneIndex*(self: ptr spSkeleton; boneName: cstring): cint
proc spSkeleton_findSlot*(self: ptr spSkeleton; slotName: cstring): ptr spSlot
proc spSkeleton_findSlotIndex*(self: ptr spSkeleton; slotName: cstring): cint
proc spSkeleton_setSkin*(self: ptr spSkeleton; skin: ptr spSkin)
proc spSkeleton_setSkinByName*(self: ptr spSkeleton; skinName: cstring): cint
proc spSkeleton_getAttachmentForSlotName*(self: ptr spSkeleton; slotName: cstring;
    attachmentName: cstring): ptr spAttachment
proc spSkeleton_getAttachmentForSlotIndex*(self: ptr spSkeleton; slotIndex: cint;
    attachmentName: cstring): ptr spAttachment
proc spSkeleton_setAttachment*(self: ptr spSkeleton; slotName: cstring;
                              attachmentName: cstring): cint
proc spSkeleton_findIkConstraint*(self: ptr spSkeleton; constraintName: cstring): ptr spIkConstraint
proc spSkeleton_findTransformConstraint*(self: ptr spSkeleton;
                                        constraintName: cstring): ptr spTransformConstraint
proc spSkeleton_findPathConstraint*(self: ptr spSkeleton; constraintName: cstring): ptr spPathConstraint
proc spSkeleton_update*(self: ptr spSkeleton; deltaTime: cfloat)


proc spAttachmentLoader_dispose*(self: ptr spAttachmentLoader)
proc spAttachmentLoader_createAttachment*(self: ptr spAttachmentLoader;
    skin: ptr spSkin; `type`: spAttachmentType; name: cstring; path: cstring): ptr spAttachment
proc spAttachmentLoader_configureAttachment*(self: ptr spAttachmentLoader;
    attachment: ptr spAttachment)
proc spAttachmentLoader_disposeAttachment*(self: ptr spAttachmentLoader;
    attachment: ptr spAttachment)



proc spRegionAttachment_create*(name: cstring): ptr spRegionAttachment
proc spRegionAttachment_setUVs*(self: ptr spRegionAttachment; u: cfloat; v: cfloat;
                               u2: cfloat; v2: cfloat; rotate: cint)
proc spRegionAttachment_updateOffset*(self: ptr spRegionAttachment)
proc spRegionAttachment_computeWorldVertices*(self: ptr spRegionAttachment;
    bone: ptr spBone; vertices: ptr cfloat)


proc spMeshAttachment_create*(name: cstring): ptr spMeshAttachment
proc spMeshAttachment_updateUVs*(self: ptr spMeshAttachment)
proc spMeshAttachment_computeWorldVertices*(self: ptr spMeshAttachment;
    slot: ptr spSlot; worldVertices: ptr cfloat)
proc spMeshAttachment_setParentMesh*(self: ptr spMeshAttachment;
                                    parentMesh: ptr spMeshAttachment)


proc spBoundingBoxAttachment_create*(name: cstring): ptr spBoundingBoxAttachment
proc spBoundingBoxAttachment_computeWorldVertices*(
    self: ptr spBoundingBoxAttachment; slot: ptr spSlot; worldVertices: ptr cfloat)


proc spAnimationStateData_create*(skeletonData: ptr spSkeletonData): ptr spAnimationStateData
proc spAnimationStateData_dispose*(self: ptr spAnimationStateData)
proc spAnimationStateData_setMixByName*(self: ptr spAnimationStateData;
                                       fromName: cstring; toName: cstring;
                                       duration: cfloat)
proc spAnimationStateData_setMix*(self: ptr spAnimationStateData;
                                 `from`: ptr spAnimation; to: ptr spAnimation;
                                 duration: cfloat)
proc spAnimationStateData_getMix*(self: ptr spAnimationStateData;
                                 `from`: ptr spAnimation; to: ptr spAnimation): cfloat

]#


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


proc malloc*(size: csize; file: cstring; line: cint): pointer {.importc: "_malloc".}
proc calloc*(num: csize; size: csize; file: cstring; line: cint): pointer {.importc: "_calloc".}
proc free*(`ptr`: pointer) {.importc: "_free".}
proc setMalloc*(malloc: proc (size: csize): pointer) {.importc: "_setMalloc".}
proc setDebugMalloc*(malloc: proc (size: csize; file: cstring; line: cint): pointer) {.importc: "_setDebugMalloc".}
proc setFree*(free: proc (`ptr`: pointer)) {.importc: "_setFree".}
proc readFile*(path: cstring; length: ptr cint): cstring {.importc: "_readFile".}


proc spAttachmentLoader_init*(self: ptr spAttachmentLoader;
                              dispose: proc (self: ptr spAttachmentLoader);
    createAttachment: proc (self: ptr spAttachmentLoader; skin: ptr spSkin;
                          `type`: spAttachmentType; name: cstring; path: cstring): ptr spAttachment;
    configureAttachment: proc (self: ptr spAttachmentLoader; a3: ptr spAttachment);
    disposeAttachment: proc (self: ptr spAttachmentLoader; a3: ptr spAttachment)) {.importc: "_spAttachmentLoader_init".}
proc spAttachmentLoader_deinit*(self: ptr spAttachmentLoader) {.importc: "_spAttachmentLoader_deinit".}
proc spAttachmentLoader_setError*(self: ptr spAttachmentLoader; error1: cstring;
                                  error2: cstring) {.importc: "_spAttachmentLoader_setError".}
proc spAttachmentLoader_setUnknownTypeError*(self: ptr spAttachmentLoader;
    `type`: spAttachmentType) {.importc: "_spAttachmentLoader_setUnknownTypeError".}
proc spAttachment_init*(self: ptr spAttachment; name: cstring;
                        `type`: spAttachmentType;
                        dispose: proc (self: ptr spAttachment)) {.importc: "_spAttachment_init".}
proc spAttachment_deinit*(self: ptr spAttachment) {.importc: "_spAttachment_deinit".}
proc spVertexAttachment_deinit*(self: ptr spVertexAttachment) {.importc: "_spVertexAttachment_deinit".}
proc spTimeline_init*(self: ptr spTimeline; `type`: spTimelineType;
                      dispose: proc (self: ptr spTimeline); apply: proc (
    self: ptr spTimeline; skeleton: ptr spSkeleton; lastTime: cfloat; time: cfloat;
    firedEvents: ptr ptr spEvent; eventsCount: ptr cint; alpha: cfloat; setupPose: cint;
    mixingOut: cint); getPropertyId: proc (self: ptr spTimeline): cint) {.importc: "_spTimeline_init".}
proc spTimeline_deinit*(self: ptr spTimeline) {.importc: "_spTimeline_deinit".}
proc spCurveTimeline_init*(self: ptr spCurveTimeline; `type`: spTimelineType;
                           framesCount: cint;
                           dispose: proc (self: ptr spTimeline); apply: proc (
    self: ptr spTimeline; skeleton: ptr spSkeleton; lastTime: cfloat; time: cfloat;
    firedEvents: ptr ptr spEvent; eventsCount: ptr cint; alpha: cfloat; setupPose: cint;
    mixingOut: cint); getPropertyId: proc (self: ptr spTimeline): cint) {.importc: "_spCurveTimeline_init".}
proc spCurveTimeline_deinit*(self: ptr spCurveTimeline) {.importc: "_spCurveTimeline_deinit".}
proc spCurveTimeline_binarySearch*(values: ptr cfloat; valuesLength: cint;
                                   target: cfloat; step: cint): cint {.importc: "_spCurveTimeline_binarySearch".}

proc spAtlasAttachmentLoader_create*(atlas: ptr spAtlas): ptr spAtlasAttachmentLoader {.importc: "spPolygon_create".}


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

when isMainModule:
  let atlas = spAtlas_createFromFile("../data/tank.atlas", nil)
  let json = spSkeletonJson_create(atlas)
  let skeletonData = spSkeletonJson_readSkeletonDataFile(json, "../data/tank.json")
  spSkeletonJson_dispose(json)

  echo repr skeletonData

  proc spAtlasPage_createTexture*(self: ptr spAtlasPage; path: cstring) {.exportc: "_spAtlasPage_createTexture".} =
    discard

  proc spAtlasPage_disposeTexture*(self: ptr spAtlasPage) {.exportc: "_spAtlasPage_disposeTexture".} =
    discard
  
  proc spUtil_readFile*(path: cstring; length: ptr cint): cstring {.exportc: "_spUtil_readFile".} =
    readFile(path, length)