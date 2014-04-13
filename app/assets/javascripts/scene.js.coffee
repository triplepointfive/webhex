class @Scene
  
  constructor: (@GL) ->
    @vertex_buffer = @GL.createBuffer()
    @GL.bindBuffer @GL.ARRAY_BUFFER, @vertex_buffer
    @GL.bufferData @GL.ARRAY_BUFFER, new Float32Array(@vertexes), @GL.STATIC_DRAW
    @vertex_buffer.itemSize = @itemSize
    @vertex_buffer.numItems = @size()
    @setAdditionalBuffers()

  setAdditionalBuffers: () ->
