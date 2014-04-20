class @Shader

  @setColor1: (@color1) ->
  @setColor2: (@color2) ->
  @setColor3: (@color3) ->

  prepareShader: (source, type, typeString) ->
    shader = @GL.createShader(type)
    @GL.shaderSource shader, source
    @GL.compileShader shader
    unless @GL.getShaderParameter(shader, @GL.COMPILE_STATUS)
      alert "ERROR IN #{typeString} SHADER : #{@GL.getShaderInfoLog(shader)}"
      return false
    shader

  constructor: (@GL, @scene) ->
    shader_vertex = @prepareShader(@shaderVertexSource(), @GL.VERTEX_SHADER, "VERTEX")
    shader_fragment = @prepareShader(@shaderFragmentSource(), @GL.FRAGMENT_SHADER, "FRAGMENT")
    @SHADER_PROGRAM = @GL.createProgram()
    @GL.attachShader @SHADER_PROGRAM, shader_vertex
    @GL.attachShader @SHADER_PROGRAM, shader_fragment
    @GL.linkProgram @SHADER_PROGRAM
    @prepareAttribLocations()
    @setupUniformVars()

  setGWorld: (@gWorld) ->

  use: () ->
    @GL.useProgram @SHADER_PROGRAM
    @GL.enableVertexAttribArray @_position
    @prepareUniformVars()

  shutdown: () ->
    @GL.disableVertexAttribArray @_position

  vertexBuffer: () ->
    @scene.vertex_buffer

  shaderVertexSource: () ->
  shaderFragmentSource: () ->
  setupUniformVars: () ->
  prepareUniformVars: () ->
  render: () ->

  prepareAttribLocations: () ->
    @_position = @GL.getAttribLocation(@SHADER_PROGRAM, 'position')

class @BaseShader extends  @Shader

  shaderVertexSource: () ->
    """
    attribute vec2 position;

    uniform mat4 gWorld;
    uniform vec3 bColor3;

    varying vec3 vColor;
    void main(void) {
      gl_Position = gWorld * vec4( position, -5.0, 1.);
      vColor = bColor3;
    }
    """

  shaderFragmentSource: () ->
    """
    precision mediump float;

    varying vec3 vColor;
    void main(void) {
      gl_FragColor = vec4(vColor, 1.);
    }
    """

  prepareUniformVars: () ->
    @GL.uniformMatrix4fv(@gWorldLoc, false, @gWorld)
    @GL.uniform3fv(@bColor3Loc, Shader.color3)

  setupUniformVars: () ->
    @gWorldLoc = @GL.getUniformLocation(@SHADER_PROGRAM, 'gWorld')
    @bColor3Loc = @GL.getUniformLocation(@SHADER_PROGRAM, 'bColor3')

  faceBuffer: () ->
    @scene.face_buffer

  render: () ->
    @GL.bindBuffer @GL.ARRAY_BUFFER, @vertexBuffer()
    @GL.vertexAttribPointer @_position, @vertexBuffer().itemSize, @GL.FLOAT, false, 0, 0
    @GL.bindBuffer @GL.ELEMENT_ARRAY_BUFFER, @faceBuffer()

    @use()
    @GL.drawElements @GL.TRIANGLES, @scene.size(), @GL.UNSIGNED_SHORT, 0
    @shutdown()

class @ColoredShader extends @Shader

  shaderVertexSource: () ->
    """
    attribute vec3 position;

    uniform mat4 gWorld;
    uniform vec3 bColor1;
    uniform vec3 bColor2;
    uniform vec3 bColor3;

    varying vec3 vColor;
    void main(void) {
      gl_Position = gWorld * vec4( position.xy, -6.0, 1.);
      if (position.z == 0.0)
        vColor = bColor1;
      else if (position.z == 1.0)
        vColor = bColor2;
      else
        vColor = bColor3;
    }
    """
  shaderFragmentSource: () ->
    """
    precision mediump float;

    varying vec3 vColor;
    void main(void) {
      gl_FragColor = vec4(vColor, 1.);
    }
    """

  prepareUniformVars: () ->
    @GL.uniformMatrix4fv(@gWorldLoc, false, @gWorld)
    @GL.uniform3fv(@bColor1Loc, Shader.color1)
    @GL.uniform3fv(@bColor2Loc, Shader.color2)
    @GL.uniform3fv(@bColor3Loc, Shader.color3)

  setupUniformVars: () ->
    @gWorldLoc = @GL.getUniformLocation(@SHADER_PROGRAM, 'gWorld')
    @bColor1Loc = @GL.getUniformLocation(@SHADER_PROGRAM, 'bColor1')
    @bColor2Loc = @GL.getUniformLocation(@SHADER_PROGRAM, 'bColor2')
    @bColor3Loc = @GL.getUniformLocation(@SHADER_PROGRAM, 'bColor3')

  render: () ->
    @GL.bindBuffer @GL.ARRAY_BUFFER, @vertexBuffer()
    @GL.vertexAttribPointer @_position, @vertexBuffer().itemSize, @GL.FLOAT, false, 0, 0

    @use()
    @GL.drawArrays @GL.TRIANGLES, 0, @vertexBuffer().numItems
    @shutdown()

class @BlockShader extends @Shader

  shaderVertexSource: () ->
    """
    attribute vec4 position;

    uniform mat4 gWorld1;
    uniform mat4 gWorld2;
    uniform vec3 bColor3;

    varying vec3 vColor;
    void main(void) {
      if (position.z == 1.0)
        gl_Position = gWorld1 * vec4( position.xy, -6.0, 1.);
      else
        gl_Position = gWorld2 * vec4( position.xy, -6.0, 1.);
      vColor = bColor3;
    }
    """
  shaderFragmentSource: () ->
    """
    precision mediump float;

    varying vec3 vColor;
    void main(void) {
      gl_FragColor = vec4(vColor, 1.);
    }
    """
  prepareUniformVars: () ->
    @GL.uniform3fv(@bColor3Loc, Shader.color3)

  setupUniformVars: () ->
    @gWorld1Loc = @GL.getUniformLocation(@SHADER_PROGRAM, 'gWorld1')
    @gWorld2Loc = @GL.getUniformLocation(@SHADER_PROGRAM, 'gWorld2')
    @bColor3Loc = @GL.getUniformLocation(@SHADER_PROGRAM, 'bColor3')

  vertexBuffer: () ->
    @scene.vertex_buffer

  setBlock: (@block) ->

  render: () ->
    for layer in @block.parts()
      @GL.bindBuffer @GL.ARRAY_BUFFER, @vertexBuffer()
      @GL.vertexAttribPointer @_position, @vertexBuffer().itemSize, @GL.FLOAT, false, 0, 0

      @use()
      @GL.uniformMatrix4fv(@gWorld1Loc, false, layer[0])
      @GL.uniformMatrix4fv(@gWorld2Loc, false, layer[1])
      @GL.drawArrays @GL.TRIANGLES, 0, @vertexBuffer().numItems
      @shutdown()
