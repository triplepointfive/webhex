class @Renderer
  @initialize: (@GL, @baseShader, @backgroundShader) ->

  @renderScene: () ->
    @backgroundShader.render()
    @baseShader.render()
