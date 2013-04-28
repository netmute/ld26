ig.module(
  'game.entities.fighter'
)
.requires(
  'game.entities.explosion'
  'plugins.steering-behaviors'
)
.defines =>
  @EntityFighter = SteeringBehaviorsEntity.extend

    type: ig.Entity.TYPE.NONE
    checkAgainst: ig.Entity.TYPE.NONE
    collides: ig.Entity.COLLIDES.NEVER

    size: x: 6, y: 6
    animSheet: new ig.AnimationSheet 'media/fighter.png', 6, 6
    zIndex: 3

    maxForce: 30
    maxSpeed: 50

    init: (x, y, settings) ->
      @parent x, y, settings
      @addAnim 'idle', 1, [@ki ? 1 : 0]
      if @ki
        @kiTimer = new ig.Timer 1
      @shootTimer = new ig.Timer 1
      ig.game.sortEntitiesDeferred()

    update: ->
      if @ki
        @handleKI()
      @currentAnim.angle = Math.atan2(@vel.y, @vel.x)
      if @target
        @vArriveTo.set
          x: @target.pos.x + @target.size.x / 2
          y: @target.pos.y + @target.size.y / 2
      @parent()

    draw: ->
      @parent()
      if @target and not @target._killed and @distanceTo(@target) < 40
        @shoot()

    shoot: ->
      if @shootTimer.delta() > 0
        ig.system.context.strokeStyle = "#0f0"
        ig.system.context.lineWidth = 1.0
        ig.system.context.beginPath()
        ig.system.context.moveTo(
          ig.system.getDrawPos(@vEntityCenter.x - ig.game.screen.x)
          ig.system.getDrawPos(@vEntityCenter.y - ig.game.screen.y)
        )
        ig.system.context.lineTo(
          ig.system.getDrawPos(@target.vEntityCenter.x - ig.game.screen.x)
          ig.system.getDrawPos(@target.vEntityCenter.y - ig.game.screen.y)
        )
        ig.system.context.stroke()
        ig.system.context.closePath()
      if @shootTimer.delta() > 0.2
        @target.receiveDamage 1
        @shootTimer.reset()

    handleKI: ->
      if @kiTimer.delta() > 0
        if not @target or @target._killed
          entities = ig.game.getEntitiesByType(EntityShip).filter (ship) =>
            not ship.ki
          entities.sort (a,b) =>
            @distanceTo(a) - @distanceTo(b)
          @target = entities[0]
          @arriveActive = true
        @kiTimer.reset()

    kill: ->
      if not @_killed
        ig.game.spawnEntity EntityExplosion, @pos.x-5, @pos.y-5
      @parent()
