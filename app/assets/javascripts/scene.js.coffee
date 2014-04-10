class @Scene
  
  constructor: (@GL) ->
    @vertex_buffer = @GL.createBuffer()
    @GL.bindBuffer @GL.ARRAY_BUFFER, @vertex_buffer
    @GL.bufferData @GL.ARRAY_BUFFER, new Float32Array(@vertexes), @GL.STATIC_DRAW

    @face_buffer = @GL.createBuffer()
    @GL.bindBuffer @GL.ELEMENT_ARRAY_BUFFER, @face_buffer
    @GL.bufferData @GL.ELEMENT_ARRAY_BUFFER, new Uint16Array(@faces), @GL.STATIC_DRAW
