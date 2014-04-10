class @KeyManager
  @init: ->
    @keys = [ false, false, false, false]
    $(document).keydown (e) ->
      KeyManager.setPressed(e.keyCode || e.which)
    $(document).keyup (e) ->
      KeyManager.setUnPressed(e.keyCode || e.which)

  keysMap =
    38: 0 # Up
    39: 1 # Right
    40: 2 # Down
    37: 3 # Left
    75: 0 # Vim up
    76: 1 # Vim right
    74: 2 # Vim down
    72: 3 # Vim left
    87: 0 # W
    68: 1 # D
    83: 2 # S
    65: 3  # A

  @setPressed: (keyCode) ->
    if ( key = keysMap[keyCode] )
      @keys[key] = true

  @setUnPressed: (keyCode) ->
    if ( key = keysMap[keyCode] )
      @keys[key] = false

  @isPressed: (key) ->
    if key in [0,1,2,3]
      @keys[key]
    else
      false
