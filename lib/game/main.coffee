ig.module(
  'game.main'
)
.requires(
  'impact.game'
  'game.entities.planet'
  'impact.debug.debug'
)
.defines =>
  @MyGame = ig.Game.extend

    playerFont: new ig.Font "media/player_font.png"
    enemyFont: new ig.Font "media/enemy_font.png"

    init: ->
      ig.input.bind ig.KEY.MOUSE1, 'click'
      @spawnEntity EntityPlanet, enemy: false for num in [1..6]
      @spawnEntity EntityPlanet, enemy: true for num in [1..6]

    update: ->
      @parent()

    draw: ->
      @parent()
      playerPlanets = @getEntitiesByType(EntityPlanet).filter (planet) ->
        not planet.enemy
      enemyPlanets = @getEntitiesByType(EntityPlanet).filter (planet) ->
        planet.enemy
      @playerFont.draw playerPlanets.length, 2, 2, ig.Font.ALIGN.LEFT
      @enemyFont.draw enemyPlanets.length, ig.system.width-2, 2, ig.Font.ALIGN.RIGHT

  ig.main '#canvas', MyGame, 60, 400, 300, 2
