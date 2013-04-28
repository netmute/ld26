ig.module(
  'game.entities.star'
)
.requires(
  'impact.entity'
)
.defines =>
  @EntityStar = ig.Entity.extend

    type: ig.Entity.TYPE.NONE
    checkAgainst: ig.Entity.TYPE.NONE
    collides: ig.Entity.COLLIDES.NEVER

    size: x: 3, y: 3
    animSheet: new ig.AnimationSheet 'media/stars.png', 3, 3

    init: (x, y, settings) ->
      x = ig.system.width * Math.random()
      y = ig.system.height * Math.random()
      @parent x, y
      image = [0,0,0,0,2,1,1,1,1,3].random()
      @addAnim 'idle', 1, [image]
      @currentAnim.alpha = Math.random().limit .7, 1
