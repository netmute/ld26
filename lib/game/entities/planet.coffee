ig.module(
  'game.entities.planet'
)
.requires(
  'impact.entity'
  'game.entities.ship'
  'game.entities.fighter'
  'game.entities.explosion'
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
      randomPos = @findPosition(settings)
      @parent randomPos.x, randomPos.y, settings

      color = settings.enemy ? 1 : 0
      @addAnim 'idle', 1, [color]

      @marker = new ig.Animation @markerSheet, 1, [0]
      @ship = if settings.ship is "destroyer"
        ig.game.spawnEntity EntityShip, @pos.x, @pos.y+4, ki: settings.enemy
      else
        ig.game.spawnEntity EntityFighter, @pos.x+4, @pos.y+5, ki: settings.enemy

      ig.game.planets.push this

    findPosition: (settings) ->
      half = ig.system.width / 2
      x = half * Math.random()
      x = x + (half - @size.x) if settings.enemy
      y = (ig.system.height - @size.y) * Math.random()
      works = yes
      for planet in ig.game.planets
        px = planet.pos.x.ceil()
        xBlocked = x.ceil() in [px-32..px+48]
        py = planet.pos.y.ceil()
        yBlocked = y.ceil() in [py-32..py+48]
        works = no if xBlocked and yBlocked
      if works
        {x:x, y:y}
      else
        @findPosition(settings)

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
      ig.game.spawnEntity EntityExplosion, @pos.x, @pos.y
      @parent()
