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
        @write "You've been annihilated.", @enemyFont
      if enemyPlanets.length is 0
        @write "You've won the war!", @playerFont
      if playerShips.length is 0 and enemyShips.length is 0
        if playerPlanets.length > enemyPlanets.length
          @write "You've won the war!", @playerFont
        if playerPlanets.length < enemyPlanets.length
          @write "You've lost the war.", @enemyFont
        if playerPlanets.length is enemyPlanets.length
          @write "The war is over. Tie.", @playerFont

    write: (text, font) ->
      font.draw text, ig.system.width/2, ig.system.height/2 - font.height, ig.Font.ALIGN.CENTER
      font.draw "Click to play again.", ig.system.width/2, ig.system.height/2, ig.Font.ALIGN.CENTER
      if ig.input.pressed 'click'
        ig.system.setGame MyGame

  ig.main '#canvas', MyGame, 60, 400, 300, 2
