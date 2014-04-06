class @Shader
  shaderVertexSource: """
    attribute vec2 position; //the position of the point
    void main(void) { //pre-built function
      gl_Position = vec4(position, 0., 1.); //0. is the z, and 1 is w
    }
    """
  shaderFragmentSource: """
    precision mediump float;
    void main(void) {
      gl_FragColor = vec4(0.,0.,0., 1.); //black color
    }
    """

  get_shader: (source, type, typeString) ->
    shader = @GL.createShader(type)
    @GL.shaderSource shader, source
    @GL.compileShader shader
    unless @GL.getShaderParameter(shader, @GL.COMPILE_STATUS)
      alert "ERROR IN " + typeString + " SHADER : " + @GL.getShaderInfoLog(shader)
      return false
    shader

  @getInstance: () ->
    @_instance ?= new @

  @initalize: (GL) ->
    @_instance = new @(GL)

  constructor: (@GL) ->
    shader_vertex = @get_shader(@shaderVertexSource, @GL.VERTEX_SHADER, "VERTEX")
    shader_fragment = @get_shader(@shaderFragmentSource, @GL.FRAGMENT_SHADER, "FRAGMENT")
    SHADER_PROGRAM = @GL.createProgram()
    @GL.attachShader SHADER_PROGRAM, shader_vertex
    @GL.attachShader SHADER_PROGRAM, shader_fragment
    @GL.linkProgram SHADER_PROGRAM
    @_position = @GL.getAttribLocation(SHADER_PROGRAM, "position")
    @GL.enableVertexAttribArray @_position
    @GL.useProgram SHADER_PROGRAM

  initalizeBuffers: ->
    #POINTS :
    triangle_vertex = [
      0, 0.8,
      0, 1,
      -0.692, 0.4,
      -1, 0.5,

      -0.692, -0.4,
      -1, -0.5,
      0, -0.8,
      0, -1,

      0.692, -0.4,
      1, -0.5,
      0.692, 0.4,
      1, 0.5,
    ]
    @TRIANGLE_VERTEX = @GL.createBuffer()
    @GL.bindBuffer @GL.ARRAY_BUFFER, @TRIANGLE_VERTEX
    @GL.bufferData @GL.ARRAY_BUFFER, new Float32Array(triangle_vertex), @GL.STATIC_DRAW

    #FACES :
    triangle_faces = [
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
    @TRIANGLE_FACES = @GL.createBuffer()
    @GL.bindBuffer @GL.ELEMENT_ARRAY_BUFFER, @TRIANGLE_FACES
    @GL.bufferData @GL.ELEMENT_ARRAY_BUFFER, new Uint16Array(triangle_faces), @GL.STATIC_DRAW

