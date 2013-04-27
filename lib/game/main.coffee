ig.module(
  'game.main'
)
.requires(
  'impact.game'
  'game.entities.planet'
  'game.entities.ship'
  'impact.debug.debug'
)
.defines =>
  @MyGame = ig.Game.extend

    init: ->
      ig.input.bind ig.KEY.MOUSE1, 'click'
      @spawnEntity EntityPlanet, enemy: false for num in [1..6]
      @spawnEntity EntityPlanet, enemy: true for num in [1..6]

    update: ->
      @parent()

  ig.main '#canvas', MyGame, 60, 400, 300, 2
