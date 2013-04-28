ig.module(
  'game.main'
)
.requires(
  'impact.game'
  'game.entities.planet'
  'game.entities.star'
  'impact.debug.debug'
)
.defines =>
  @MyGame = ig.Game.extend

    playerFont: new ig.Font "media/player_font.png"
    enemyFont: new ig.Font "media/enemy_font.png"

    planets: []

    init: ->
      ig.input.bind ig.KEY.MOUSE1, 'click'
      @spawnEntity EntityStar for num in [1..150]
      @spawnEntity EntityPlanet, enemy: false, ship: "destroyer" for num in [1..3]
      @spawnEntity EntityPlanet, enemy: false, ship: "fighter" for num in [1..3]
      @spawnEntity EntityPlanet, enemy: true, ship: "destroyer" for num in [1..3]
      @spawnEntity EntityPlanet, enemy: true, ship: "fighter" for num in [1..3]

    update: ->
      @parent()

    draw: ->
      @parent()
      playerPlanets = @getEntitiesByType(EntityPlanet).filter (planet) -> not planet.enemy
      playerShips = @getEntitiesByType(EntityShip).filter (ship) -> not ship.ki
      enemyPlanets = @getEntitiesByType(EntityPlanet).filter (planet) -> planet.enemy
      enemyShips = @getEntitiesByType(EntityShip).filter (ship) -> ship.ki

      @playerFont.draw playerPlanets.length, 2, 2, ig.Font.ALIGN.LEFT
      @enemyFont.draw enemyPlanets.length, ig.system.width-2, 2, ig.Font.ALIGN.RIGHT

      if playerPlanets.length is 0
        @enemyFont.draw "You have been annihilated.", ig.system.width/2, ig.system.height/2, ig.Font.ALIGN.CENTER
      if enemyPlanets.length is 0
        @playerFont.draw "You have won the war.", ig.system.width/2, ig.system.height/2, ig.Font.ALIGN.CENTER
      if playerShips.length is 0 and enemyShips.length is 0
        if playerPlanets.length > enemyPlanets.length
          @playerFont.draw "You have won the war.", ig.system.width/2, ig.system.height/2, ig.Font.ALIGN.CENTER
        if playerPlanets.length < enemyPlanets.length
          @enemyFont.draw "You have lost the war.", ig.system.width/2, ig.system.height/2, ig.Font.ALIGN.CENTER
        if playerPlanets.length is enemyPlanets.length
          @playerFont.draw "The war is over. Draw.", ig.system.width/2, ig.system.height/2, ig.Font.ALIGN.CENTER

  ig.main '#canvas', MyGame, 60, 400, 300, 2
