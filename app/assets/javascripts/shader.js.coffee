class @Shader

  prepareShader: (source, type, typeString) ->
    shader = @GL.createShader(type)
    @GL.shaderSource shader, source
    @GL.compileShader shader
    unless @GL.getShaderParameter(shader, @GL.COMPILE_STATUS)
      alert "ERROR IN #{typeString} SHADER : #{@GL.getShaderInfoLog(shader)}"
      return false
    shader

  constructor: (@GL, @scene) ->
    shader_vertex = @prepareShader(@scene.shaderVertexSource, @GL.VERTEX_SHADER, "VERTEX")
    shader_fragment = @prepareShader(@scene.shaderFragmentSource, @GL.FRAGMENT_SHADER, "FRAGMENT")
    @SHADER_PROGRAM = @GL.createProgram()
    @GL.attachShader @SHADER_PROGRAM, shader_vertex
    @GL.attachShader @SHADER_PROGRAM, shader_fragment
    @GL.linkProgram @SHADER_PROGRAM
    @prepareAttribLocations()
    @gWorldLoc = @GL.getUniformLocation(@SHADER_PROGRAM, 'gWorld')

  setGWorld: (@gWorld) ->

  use: () ->
    @GL.useProgram @SHADER_PROGRAM
    @GL.enableVertexAttribArray @_position
    @GL.uniformMatrix4fv(@gWorldLoc, false, @gWorld) if @gWorld

  shutdown: () ->
    @GL.disableVertexAttribArray @_position

  render: () ->
    @GL.bindBuffer @GL.ARRAY_BUFFER, @vertexBuffer()
    @GL.vertexAttribPointer @_position, @vertexBuffer().itemSize, @GL.FLOAT, false, 0, 0
    @GL.bindBuffer @GL.ELEMENT_ARRAY_BUFFER, @faceBuffer()

    @use()
    @GL.drawElements @GL.TRIANGLES, @scene.size(), @GL.UNSIGNED_SHORT, 0
    @shutdown()

  vertexBuffer: () ->
    @scene.vertex_buffer

  faceBuffer: () ->
    @scene.face_buffer

  prepareAttribLocations: () ->
    @_position = @GL.getAttribLocation(@SHADER_PROGRAM, 'position')


class @ColoredShader extends @Shader

  render: () ->
    @GL.bindBuffer @GL.ARRAY_BUFFER, @vertexBuffer()
    @GL.vertexAttribPointer @_position, @vertexBuffer().itemSize, @GL.FLOAT, false, 0, 0

    @use()
    @GL.drawArrays @GL.TRIANGLES, 0, @vertexBuffer().numItems
    @shutdown()

