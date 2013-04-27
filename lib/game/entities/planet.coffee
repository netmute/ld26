ig.module(
  'game.entities.planet'
)
.requires(
  'impact.entity'
  'game.entities.ship'
  'game.entities.fighter'
)
.defines =>
  @EntityPlanet = ig.Entity.extend

    type: ig.Entity.TYPE.NONE
    checkAgainst: ig.Entity.TYPE.NONE
    collides: ig.Entity.COLLIDES.NEVER

    markerSheet: new ig.AnimationSheet "media/planet_marker.png", 24, 24

    size: x: 16, y: 16
    animSheet: new ig.AnimationSheet 'media/planet.png', 16, 16
    zIndex: 1

    init: (settings) ->
      half = ig.system.width / 2
      x = half * Math.random()
      x = x + (half - @size.x) if settings.enemy
      y = (ig.system.height - @size.y) * Math.random()
      color = settings.enemy ? 1 : 0

      @marker = new ig.Animation @markerSheet, 1, [0]

      @parent x, y, settings
      @addAnim 'idle', 1, [color]
      @ship = if [true, false].random()
        ig.game.spawnEntity EntityShip, @pos.x, @pos.y+4, ki: settings.enemy
      else
        ig.game.spawnEntity EntityFighter, @pos.x+4, @pos.y+5, ki: settings.enemy

    update: ->
      if @marked() and ig.input.pressed 'click'
        @sendShip()
      @parent()

    sendShip: ->
      ships = ig.game.getEntitiesByType(EntityShip).filter (ship) ->
        not ship.ki and (not ship.target or ship.target._killed)
      ships.sort (a,b) =>
        @distanceTo(a) - @distanceTo(b)
      if nearestShip = ships[0]
        nearestShip.target = this
        nearestShip.arriveActive = true

    draw: ->
      @parent()
      if @marked()
        @marker.draw @pos.x - 4, @pos.y - 4

    marked: ->
      @enemy and
      ( ig.input.mouse.x.floor() in [@pos.x.floor()..(@pos.x+@size.x).ceil()] ) and
      ( ig.input.mouse.y.floor() in [@pos.y.floor()..(@pos.y+@size.y).ceil()] )

    kill: ->
      @ship.kill()
      @parent()
