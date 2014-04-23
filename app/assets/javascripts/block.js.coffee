class @Block
  initialPosition = 10
  numberOfParts = 6
  partAngle = Math.PI / numberOfParts * 2
  blockWidth = 0.8
  speed = 0.08

  heightForPosition = (position) ->
    Math.tan(partAngle / 2) * position

  constructor: ->
    @position = 0
    @blocks = [
      [ 1, 2, 4, 5 ]
      [ 1, 2, 4, 5 ]
      [ 1, 2, 4, 5 ]
      [ 1, 2, 4, 5 ]
    ]
    for i in [1..Math.round(initialPosition / blockWidth)]
      @blocks.unshift([])
    @renderParts = []
    @callNumber = 0

  setUp: (gWorld, bRotate) ->
    @updatePosition()
    cRotate = mat4.multiply(mat4.create(), gWorld, bRotate)
    @renderParts = []
    for v, i in @blocks
      position = @position + blockWidth * i
      blTranslate = mat4.translate(mat4.create(), mat4.create(), vec3.fromValues(position, 0, 0))
      blScale1 = mat4.scale(mat4.create(), mat4.create(), vec3.fromValues(1, heightForPosition(position), 1))
      blScale2 = mat4.scale(mat4.create(), mat4.create(), vec3.fromValues(1, heightForPosition(position + blockWidth), 1))
      for part in v
        if part == 0
          additionalRotation = cRotate
        else
          additionalRotation = mat4.rotateZ(mat4.create(), cRotate, partAngle * part)
        blPipe1 = mat4.multiply(mat4.create(), mat4.multiply(mat4.create(), additionalRotation, blTranslate), blScale1)
        blPipe2 = mat4.multiply(mat4.create(), mat4.multiply(mat4.create(), additionalRotation, blTranslate), blScale2)
        @renderParts.push [blPipe1, blPipe2]

  parts: ->
    @renderParts

  updatePosition: ->
    @position -= speed
    if @position <= 0.2
      @callNumber++
      @blocks.push([1, 2, 4, 5 ]) if @callNumber % 1 == 0
#      console.log @blocks.length
      @blocks.shift()
      @position += blockWidth

  isPositionValid: (position) ->
    part = Math.floor(Math.abs(position) / partAngle) - 1
    part = 6 + part if part < 0
    console.log "position=#{position} part=#{part}"
    part not in @blocks[0]
