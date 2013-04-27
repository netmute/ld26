ig.module(
  'game.entities.ship'
)
.requires(
  'plugins.steering-behaviors'
)
.defines =>
  @EntityShip = SteeringBehaviorsEntity.extend

    type: ig.Entity.TYPE.NONE
    checkAgainst: ig.Entity.TYPE.NONE
    collides: ig.Entity.COLLIDES.NEVER

    size: x: 16, y: 8
    animSheet: new ig.AnimationSheet 'media/destroyer.png', 16, 8
    zIndex: 2

    maxForce: 10
    maxSpeed: 20

    init: (x, y, settings) ->
      @parent x, y, settings
      @addAnim 'idle', 1, [0]
      if @ki
        @kiTimer = new ig.Timer 4
      ig.game.sortEntitiesDeferred()

    update: ->
      if @ki
        @handleKI()
      if @target and @touches(@target)
        @target.kill()
        @target = false
      @currentAnim.angle = Math.atan2(@vel.y, @vel.x)
      if @target
        @vArriveTo.set
          x: @target.pos.x + @target.size.x / 2
          y: @target.pos.y + @target.size.y / 2
      @parent()

    handleKI: ->
      if @kiTimer.delta() > 0
        if not @target or @target._killed
          entities = ig.game.getEntitiesByType(EntityPlanet).filter (planet) =>
            not planet.enemy
          entities.sort (a,b) =>
            @distanceTo(a) - @distanceTo(b)
          @target = entities[0]
          @arriveActive = true
        @kiTimer.reset()
