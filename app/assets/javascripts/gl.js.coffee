class @App

  @animate: ->
    if KeyManager.isPressed(1)
      @angle -= 0.05
    if KeyManager.isPressed(3)
      @angle += 0.05



    gWorld = mat4.perspective(mat4.create(), 30, window.innerWidth / window.innerHeight, 0, 100)
    mat4.rotateZ(gWorld, gWorld, @angle)

    @GL.uniformMatrix4fv(@world, false, gWorld);

#    @GL.viewport 0.0, 0.0, @CANVAS.width, @CANVAS.height
    @GL.clear @GL.COLOR_BUFFER_BIT
    @GL.vertexAttribPointer Shader.getInstance()._position, 2, @GL.FLOAT, false, 4 * 2, 0
    @GL.bindBuffer @GL.ARRAY_BUFFER, Shader.getInstance().TRIANGLE_VERTEX
    @GL.bindBuffer @GL.ELEMENT_ARRAY_BUFFER, Shader.getInstance().TRIANGLE_FACES
    @GL.drawElements @GL.TRIANGLES, 36, @GL.UNSIGNED_SHORT, 0
    @GL.flush()

  @idle: () ->
    @angle = 0
    setInterval ( => @animate()), 10
#    @animate()

  @init: () ->
    @CANVAS = document.getElementById("your_canvas")
    @CANVAS.width = window.innerWidth
    @CANVAS.height = window.innerHeight

    try
      @GL = @CANVAS.getContext("experimental-webgl", { antialias: false } )
    catch e
      alert "You are not webgl compatible :("
      return false

    KeyManager.init()
    shader = Shader.initalize(@GL)
    shader.initalizeBuffers()

    @world = shader.gWorld

    @GL.clearColor 0.0, 0.0, 0.0, 0.0
    @idle()

window.main = ->
  App.init()
