class @Block
  initialPosition = 10
  numberOfParts = 6
  partAngle = Math.PI / numberOfParts
  blockWidth = 0.8

  heightForPosition = (position) ->
    Math.tan(partAngle) * position

  constructor: ->
    @blocks = [
      position: initialPosition
      parts: [ 0, 1, 3, 4, 5 ]
    ,
      position: initialPosition + 5 * blockWidth
      parts: [ 0, 2, 3, 5 ]
    ,
      position: initialPosition + 6 * blockWidth
      parts: [ 0, 3]
    ,
      position: initialPosition + 7 * blockWidth
      parts: [ 1, 4 ]
    ,
      position: initialPosition + 8 * blockWidth
      parts: [ 1, 2, 4, 5 ]
    ]
    @renderParts = []

  setUp: (gWorld, time, bRotate) ->
    @updatePosition(time)
    cRotate = mat4.multiply(mat4.create(), gWorld, bRotate)
    @renderParts = @blocks.map (layer) ->
      blTranslate = mat4.translate(mat4.create(), mat4.create(), vec3.fromValues(layer.position, 0, 0))
      blScale1 = mat4.scale(mat4.create(), mat4.create(), vec3.fromValues(1, heightForPosition(layer.position), 1))
      blScale2 = mat4.scale(mat4.create(), mat4.create(), vec3.fromValues(1, heightForPosition(layer.position + 0.8), 1))
      for i in layer.parts
        if i == 0
          additionalRotation = cRotate
        else
          additionalRotation = mat4.rotateZ(mat4.create(), cRotate, partAngle * i * 2)
        blPipe1 = mat4.multiply(mat4.create(), mat4.multiply(mat4.create(), additionalRotation, blTranslate), blScale1)
        blPipe2 = mat4.multiply(mat4.create(), mat4.multiply(mat4.create(), additionalRotation, blTranslate), blScale2)
        [blPipe1, blPipe2]
    .flatten(1)

  parts: ->
    console.log @renderParts
    @renderParts

  updatePosition: (time) ->
    @blocks = @blocks.map (layer) ->
      position = layer.position - 0.08
      if position <= 0.2
        null
      else
        position: position
        parts: layer.parts
    .filter (layer) -> layer isnt null
