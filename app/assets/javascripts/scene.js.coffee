class Scene
  
  constructor: (@GL) ->
    @vertex_buffer = @GL.createBuffer()
    @GL.bindBuffer @GL.ARRAY_BUFFER, @vertex_buffer
    @GL.bufferData @GL.ARRAY_BUFFER, new Float32Array(@vertexes), @GL.STATIC_DRAW
    @vertex_buffer.itemSize = @itemSize
    @vertex_buffer.numItems = @size()
    @setAdditionalBuffers()

  setAdditionalBuffers: () ->

class @Base extends Scene
  vertexes:
    [
      0, 0.8,
      0, 1,
      -0.692, 0.4,
      -0.866, 0.5,

      -0.692, -0.4,
      -0.866, -0.5,
      0, -0.8,
      0, -1,

      0.692, -0.4,
      0.866, -0.5,
      0.692, 0.4,
      0.866, 0.5,
    ]

  faces:
    [
      0, 1, 2,
      1, 2, 3,
      2, 3, 4,
      3, 4, 5,
      4, 5, 6,
      5, 6, 7,
      6, 7, 8,
      7, 8, 9,
      8, 9, 10,
      9, 10, 11,
      10, 11, 0
      11, 0, 1
    ]

  itemSize: 2
  size: () ->
    @faces.length

  setAdditionalBuffers: () ->
    @face_buffer = @GL.createBuffer()
    @GL.bindBuffer @GL.ELEMENT_ARRAY_BUFFER, @face_buffer
    @GL.bufferData @GL.ELEMENT_ARRAY_BUFFER, new Uint16Array(@faces), @GL.STATIC_DRAW
    @face_buffer.itemSize = 3
    @face_buffer.numItems = @faces.length

class @Background extends Scene
  vertexes:
    [
      0, 0, 1.0,
      0, 100, 1.0,
      -86.6, 50, 1.0,

      0, 0, 0.0,
      -86.6, 50, 0.0,
      -86.6, -50, 0.0,

      0, 0, 1.0,
      -86.6, -50, 1.0,
      0, -100, 1.0,

      0, 0, 0.0,
      0, -100, 0.0,
      86.6, -50, 0.0,

      0, 0, 1.0,
      86.6, -50, 1.0,
      86.6, 50, 1.0,

      0, 0, 0.0,
      86.6, 50, 0.0,
      0, 100, 0.0,
    ]

  itemSize: 3
  size: () ->
    @vertexes.length / 3

class @Player extends Scene
  a = 0.5
  r = (Math.sqrt(3) / 6 * a)
  R = (Math.sqrt(3) / 3 * a)

  vertexes:
    [
      0, R, 2.0,
      (-a / 2), (-r), 2.0,
      (a / 2), (-r), 2.0
    ]

  itemSize: 3
  size: () ->
    @vertexes.length / 3

class @Blocks extends Scene

  constructor: (@GL) ->
    @vBuffers = []
    for vertexes in @vertexes
      vertex_buffer = @GL.createBuffer()
      @GL.bindBuffer @GL.ARRAY_BUFFER, vertex_buffer
      @GL.bufferData @GL.ARRAY_BUFFER, new Float32Array(vertexes), @GL.STATIC_DRAW
      vertex_buffer.itemSize = 3
      vertex_buffer.numItems = vertexes.length / 3
      @vBuffers.push vertex_buffer

  vertexBuffers: () ->
    @vBuffers

  vertexes:
    [
      [
        0.0, 1, 1.0,
        0.8, 1, 2.0,
        0.0, -1, 1.0,
        0.8, 1, 2.0,
        0.0, -1, 1.0,
        0.8, -1, 2.0,
      ]
    ]
