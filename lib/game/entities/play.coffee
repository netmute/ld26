ig.module(
  'game.entities.play'
)
.requires(
  'impact.entity'
)
.defines =>
  @EntityPlay = ig.Entity.extend

    type: ig.Entity.TYPE.NONE
    checkAgainst: ig.Entity.TYPE.NONE
    collides: ig.Entity.COLLIDES.NEVER

    size: x: 49, y: 14
    animSheet: new ig.AnimationSheet 'media/play.png', 49, 14

    init: (x, y, settings) ->
      x = x - @size.x/2
      @parent x, y, settings
      @addAnim 'idle', 1, [0]
      @addAnim 'selected', 1, [1]

    update: ->
      if @marked()
        @currentAnim = @anims.selected
      else
        @currentAnim = @anims.idle
      @parent()
      if @marked() and ig.input.pressed "click"
        ig.system.setGame MyGame

    marked: ->
      ( ig.input.mouse.x.floor() in [@pos.x.floor()..(@pos.x+@size.x).ceil()] ) and
      ( ig.input.mouse.y.floor() in [@pos.y.floor()..(@pos.y+@size.y).ceil()] )

