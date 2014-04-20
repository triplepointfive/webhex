class @Block
  initialPosition = 10
  numberOfParts = 6

  heightForPosition = (position) ->
    Math.tan(Math.PI / numberOfParts) * position

  constructor: ->
    @blocks = [
      position: initialPosition
      parts: [ 0 ]
    ]
    @renderParts = []

  setUp: (gWorld, time, bRotate) ->
    @updatePosition(time)
    @renderParts = @blocks.map (layer) ->
      blTranslate = mat4.translate(mat4.create(), mat4.create(), vec3.fromValues(layer.position, 0, 0))
      blScale1 = mat4.scale(mat4.create(), mat4.create(), vec3.fromValues(1, heightForPosition(layer.position), 1))
      blScale2 = mat4.scale(mat4.create(), mat4.create(), vec3.fromValues(1, heightForPosition(layer.position + 0.8), 1))
      blPipe1 = mat4.multiply(mat4.create(), mat4.multiply(mat4.create(), mat4.multiply(mat4.create(), gWorld, bRotate), blTranslate), blScale1)
      blPipe2 = mat4.multiply(mat4.create(), mat4.multiply(mat4.create(), mat4.multiply(mat4.create(), gWorld, bRotate), blTranslate), blScale2)
      [blPipe1, blPipe2]

  parts: ->
    @renderParts

  updatePosition: (time) ->
    @blocks = @blocks.map (layer) ->
      position: 6 + 5 * Math.cos(time * 2)
      parts: layer.parts

