class @Background extends @Scene
  shaderVertexSource: """
    attribute vec2 position;
    uniform mat4 gWorld;
    void main(void) {
      gl_Position = gWorld * vec4( position, -6.0, 1.);
    }
    """
  shaderFragmentSource: """
    precision mediump float;
    void main(void) {
      gl_FragColor = vec4(1.,1.,0., 1.);
    }
    """

  vertexes:
    [
      0, 0,
      0, 100,
      -86.6, 50,
      -86.6, -50,
      0, -100,
      86.6, -50,
      86.6, 50,
    ]

  faces:
    [
      0, 1, 2,
      0, 2, 3,
      0, 3, 4,
      0, 4, 5,
      0, 5, 6,
      0, 6, 1
    ]