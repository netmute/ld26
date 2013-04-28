ig.module(
  'game.entities.explosion'
)
.requires(
  'impact.entity'
)
.defines =>
  @EntityExplosion = ig.Entity.extend

    type: ig.Entity.TYPE.NONE
    checkAgainst: ig.Entity.TYPE.NONE
    collides: ig.Entity.COLLIDES.NEVER

    size: x: 16, y: 16
    animSheet: new ig.AnimationSheet 'media/explosion.png', 16, 16

    init: (x, y, settings) ->
      @parent x, y, settings
      @addAnim 'idle', .1, [0,1,2,3]
      @dieTimer = new ig.Timer .4

    update: ->
      @parent()
      if @dieTimer.delta() > 0
        @kill()
