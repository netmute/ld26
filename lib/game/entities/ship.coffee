ig.module(
  'game.entities.ship'
)
.requires(
  'plugins.steering-behaviors'
  'game.entities.explosion'
)
.defines =>
  @EntityShip = SteeringBehaviorsEntity.extend

    type: ig.Entity.TYPE.NONE
    checkAgainst: ig.Entity.TYPE.NONE
    collides: ig.Entity.COLLIDES.NEVER

    size: x: 16, y: 8
    animSheet: new ig.AnimationSheet 'media/destroyer.png', 16, 8
    markerSheet: new ig.AnimationSheet "media/planet_marker.png", 24, 24
    zIndex: 2

    health: 20

    maxForce: 10
    maxSpeed: 20

    init: (x, y, settings) ->
      @parent x, y, settings
      @addAnim 'idle', 1, [@ki ? 1 : 0]
      if @ki
        @kiTimer = new ig.Timer 4
        @marker = new ig.Animation @markerSheet, 1, [0]
      ig.game.sortEntitiesDeferred()

    update: ->
      if @ki
        @handleKI()
      if @target and @touches(@target)
        @target.kill()
        @target = false
      if @marked() and ig.input.pressed 'click'
        @sendFighter()
      @currentAnim.angle = Math.atan2(@vel.y, @vel.x)
      if @target
        @vArriveTo.set
          x: @target.pos.x + @target.size.x / 2
          y: @target.pos.y + @target.size.y / 2
      @parent()

    sendFighter: ->
      fighters = ig.game.getEntitiesByType(EntityFighter).filter (fighter) ->
        not fighter.ki and (not fighter.target or fighter.target._killed)
      fighters.sort (a,b) =>
        @distanceTo(a) - @distanceTo(b)
      if nearestFighter = fighters[0]
        nearestFighter.target = this
        nearestFighter.arriveActive = true

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

    draw: ->
      @parent()
      if @marked()
        @marker.draw @pos.x - 4, @pos.y - 8

    marked: ->
      @ki and
      ( ig.input.mouse.x.floor() in [@pos.x.floor()..(@pos.x+@size.x).ceil()] ) and
      ( ig.input.mouse.y.floor() in [@pos.y.floor()..(@pos.y+@size.y).ceil()] )

    kill: ->
      if not @_killed
        ig.game.spawnEntity EntityExplosion, @pos.x, @pos.y
      @parent()
