class @App

  @animate: ->
    if KeyManager.isPressed(1)
      @angle -= 0.05
    if KeyManager.isPressed(3)
      @angle += 0.05

    gWorld = mat4.perspective(mat4.create(), 30, window.innerWidth / window.innerHeight, 0, 100)
    mat4.rotateZ(gWorld, gWorld, @angle)
    @back.setGWorld(gWorld)
    @base.setGWorld(gWorld)

#    @GL.viewport 0, 0, @GL.viewportWidth, @GL.viewportHeight
    @GL.clear @GL.COLOR_BUFFER_BIT
    Renderer.renderScene()
    @GL.flush()

  @idle: () ->
    @angle = 0
    setInterval ( => @animate()), 10

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

    @back = new ColoredShader(@GL, new Background(@GL) )
    @base = new Shader(@GL, new Base(@GL))
    Renderer.initialize(@GL, @base, @back)

    @GL.clearColor 0.0, 0.0, 0.0, 0.0
    @idle()

window.main = ->
  App.init()
