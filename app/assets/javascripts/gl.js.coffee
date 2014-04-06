class App

  @animate: ->
    @GL.viewport 0.0, 0.0, @CANVAS.width, @CANVAS.height
    @GL.clear @GL.COLOR_BUFFER_BIT
    @GL.vertexAttribPointer Shader.getInstance()._position, 2, @GL.FLOAT, false, 4 * 2, 0
    @GL.bindBuffer @GL.ARRAY_BUFFER, Shader.getInstance().TRIANGLE_VERTEX
    @GL.bindBuffer @GL.ELEMENT_ARRAY_BUFFER, Shader.getInstance().TRIANGLE_FACES
    @GL.drawElements @GL.TRIANGLES, 36, @GL.UNSIGNED_SHORT, 0
    @GL.flush()

  @idle: () ->
    setInterval ( => @animate()), 100

  @init: () ->
    @CANVAS = document.getElementById("your_canvas")
    @CANVAS.width = window.innerWidth
    @CANVAS.height = window.innerHeight

    try
      @GL = @CANVAS.getContext("experimental-webgl", { antialias: false } )
    catch e
      alert "You are not webgl compatible :("
      return false

    shader = Shader.initalize(@GL)
    shader.initalizeBuffers()

    @GL.clearColor 0.0, 0.0, 0.0, 0.0
    @idle()

window.main = ->
  App.init()
