class @Base extends @Scene
  shaderVertexSource: """
    attribute vec2 position;
    uniform mat4 gWorld;
    void main(void) {
      gl_Position = gWorld * vec4( position, -5.0, 1.);
    }
    """
  shaderFragmentSource: """
    precision mediump float;
    void main(void) {
      gl_FragColor = vec4(0.,0.,0., 1.);
    }
    """

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
