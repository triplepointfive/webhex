class @Background extends @Scene
  shaderVertexSource: """
    attribute vec3 position;

    uniform mat4 gWorld;

    varying vec3 vColor;
    void main(void) {
      gl_Position = gWorld * vec4( position.xy, -6.0, 1.);
      if (position.z == 0.0)
        vColor = vec3(1.0, 0.0, 0.0);
      else
        vColor = vec3(1.0, 1.0, 0.0);
    }
    """
  shaderFragmentSource: """
    precision mediump float;

    varying vec3 vColor;
    void main(void) {
      gl_FragColor = vec4(vColor, 1.);
    }
    """

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
