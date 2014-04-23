hexToRgb = (hex) ->
    result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    [
      parseInt(result[1], 16) / 256,
      parseInt(result[2], 16) / 256,
      parseInt(result[3], 16) / 256
    ]

userSpeed = Math.PI / 30

class @App
  @swapColors: () ->
    @set = !@set

  @bColors1: ['1E7F7F', '7554A5', 'C75C92', 'B4E068', 'F2E470', '874BE6', 'F43F88', 'A5F840', 'FFEB42', '1E7F7F']
  @bColors2: ['0A5353', '52BFBF', '724F61', '728059', '8A8660', '7855AD', 'B8517A', '8CBB52', 'C0B455', '0A5353']
  @bColors3: ['296060', '1D0542', '50052B', '3B5A06', '615707', '4A1996', '9F154D', '63A215', 'A79716', '296060']

  @bColor1: () ->
    if @set
      @bColors1
    else
      @bColors2

  @bColor2: () ->
    if @set
      @bColors2
    else
      @bColors1

  @bColor3: () ->
    @bColors3

  @timeLine: [0, 5, 10, 20, 25, 30, 35, 40, 45, 50]

  @color: () ->
    @colorTime += 0.05
    @colorTime = 0 if @colorTime >= @timeLine[@timeLine.length - 1]
    for i in [@timeLine.length - 1..0]
      if @colorTime >= @timeLine[i]
        x = @colorTime - @timeLine[i]
        d = @timeLine[i+1] - @timeLine[i]
        la = x / d
        lb = 1 - la
        getColor = (colors) ->
          c1 = hexToRgb(colors[i+1])
          c2 = hexToRgb(colors[i])
          vec3.fromValues(
            (c1[0] * (la) + c2[0] * (lb)).toFixed(3),
            (c1[1] * (la) + c2[1] * (lb)).toFixed(3),
            (c1[2] * (la) + c2[2] * (lb)).toFixed(3)
          )
        Shader.setColor1 getColor(@bColor1())
        Shader.setColor2 getColor(@bColor2())
        Shader.setColor3 getColor(@bColor3())
        return

  @animate: ->
    return console.log 'nested' if @render
    @time += 0.01
    @color();

#    if @time > @rotDur
#      @rotDir = (0.5 - Math.random()) / 5
#      @rotDur = @time + 0.2 + Math.random() / 10

    @render = true
    @nagl += @rotDir
    if KeyManager.isPressed(1)
      @angle -= userSpeed if @block.isPositionValid(@angle - userSpeed)
    if KeyManager.isPressed(3)
      @angle += userSpeed if @block.isPositionValid(@angle + userSpeed)

    @angle -= 2 * Math.PI if @angle > 10
    @nagl -= 2 * Math.PI if @nagl > 10
    @angle += 2 * Math.PI if @angle < -10
    @nagl += 2 * Math.PI if @nagl < -10

    #    if Math.sin(@time*5) > 0.95
    #      shaking = mat4.scale(mat4.create(), mat4.create(), vec3.fromValues(Math.sin(@time*5) + 0.1, Math.sin(@time*5) + 0.1, 1))
    #      mat4.multiply(gWorld, shaking, gWorld)

    gWorld = mat4.perspective(mat4.create(), 30, window.innerWidth / window.innerHeight, 0, 100)
    bRotate = mat4.rotateZ(mat4.create(), mat4.create(), @nagl)

    plRotate = mat4.rotateZ(mat4.create(), mat4.create(), @angle + @nagl)
    plTranslate = mat4.translate(mat4.create(), mat4.create(), vec3.fromValues(0, 1.5, 0))

    bPipe = mat4.multiply(mat4.create(), gWorld, bRotate)
    pPipe = mat4.multiply(mat4.create(), mat4.multiply(mat4.create(), gWorld, plRotate), plTranslate)

    @block.setUp(gWorld, bRotate)

    @back.setGWorld(bPipe)
    @base.setGWorld(bPipe)
    @pl.setGWorld(pPipe)
    @bl.setBlock(@block)

    @GL.clear @GL.COLOR_BUFFER_BIT
    @back.render()
    @base.render()
    @pl.render()
    @bl.render()
    @GL.flush()
    @render = false

  @idle: () ->
    @angle = 0
    @nagl = 0
    @colorTime = 0
    @time = 0

#    @rotDir = (0.5 - Math.random()) / 5
#    @rotDur = 0.2 + Math.random() / 10
    @rotDir = 0.01
    @rotDur = 0

    @render = false
    @set = false
    setInterval ( => @swapColors()), 1000
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
    @bl = new BlockShader(@GL, new Blocks(@GL))

    @block = new Block()

    @GL.clearColor 0.0, 0.0, 0.0, 0.0
    @idle()

window.main = ->
  App.init()
