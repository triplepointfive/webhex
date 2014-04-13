class @App

  @animate: ->
    @nagl += 0.01
    if KeyManager.isPressed(1)
      @angle -= 0.05
    if KeyManager.isPressed(3)
      @angle += 0.05

    @angle -= 2 * Math.PI if @angle > 10
    @nagl -= 2 * Math.PI if @nagl > 10
    @angle += 2 * Math.PI if @angle < -10
    @nagl += 2 * Math.PI if @nagl < -10

    gWorld = mat4.perspective(mat4.create(), 30, window.innerWidth / window.innerHeight, 0, 100)
    plRotated = mat4.rotateZ(mat4.create(), gWorld, @angle + @nagl)
    bRotated = mat4.rotateZ(mat4.create(), gWorld, @nagl)
    plRransl = mat4.translate(mat4.create(), plRotated, vec3.fromValues(0, 1.5, 0))

    @back.setGWorld(bRotated)
    @base.setGWorld(bRotated)
    @pl.setGWorld(plRransl)

    @GL.clear @GL.COLOR_BUFFER_BIT
    @back.render()
    @base.render()
    @pl.render()
    @GL.flush()

  @idle: () ->
    @angle = 0
    @nagl = 0
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
    @base = new BaseShader(@GL, new Base(@GL))
    @pl = new ColoredShader(@GL, new Player(@GL))

    @GL.clearColor 0.0, 0.0, 0.0, 0.0
    @idle()

window.main = ->
  App.init()
