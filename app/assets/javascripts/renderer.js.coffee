class @Renderer
  @initialize: (@GL, @baseShader, @backgroundShader) ->

  @renderBackground: () ->
    @GL.bindBuffer @GL.ARRAY_BUFFER, @backgroundShader.vertexBuffer()
    @GL.bindBuffer @GL.ELEMENT_ARRAY_BUFFER, @backgroundShader.faceBuffer()

    @backgroundShader.use()
    @GL.vertexAttribPointer @backgroundShader._position, 2, @GL.FLOAT, false, 4 * 2, 0
    @GL.drawElements @GL.TRIANGLES, 18, @GL.UNSIGNED_SHORT, 0
    @backgroundShader.shutdown()

  @renderBase: () ->
    @GL.bindBuffer @GL.ARRAY_BUFFER, @baseShader.vertexBuffer()
    @GL.bindBuffer @GL.ELEMENT_ARRAY_BUFFER, @baseShader.faceBuffer()
    
    @baseShader.use()
    @GL.vertexAttribPointer @baseShader._position, 2, @GL.FLOAT, false, 4 * 2, 0
    @GL.drawElements @GL.TRIANGLES, 36, @GL.UNSIGNED_SHORT, 0
    @baseShader.shutdown()
    
  @renderScene: () ->

    @renderBackground()
    @renderBase()
