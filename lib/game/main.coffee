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

    laserSound: new ig.Sound "media/laser.ogg", false
    explosionSound: new ig.Sound "media/explosion.ogg", false
    confirmSound: new ig.Sound "media/confirm.ogg"

    planets: []

    init: ->
      ig.input.bind ig.KEY.MOUSE1, 'click'
      @spawnEntity EntityStar for num in [1..150]
      @spawnEntity EntityPlanet, enemy: false, ship: "destroyer" for num in [1..3]
      @spawnEntity EntityPlanet, enemy: false, ship: "fighter" for num in [1..3]
      @spawnEntity EntityPlanet, enemy: true, ship: "destroyer" for num in [1..3]
      @spawnEntity EntityPlanet, enemy: true, ship: "fighter" for num in [1..3]
      @laserSound.volume = .3
      @explosionSound.volume = .5
      @confirmSound.volume = .2
      ig.music.add "media/music.ogg"
      ig.music.play()

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

  @Tutorial = ig.Game.extend

    font: new ig.Font "media/player_font.png"

    planet: new ig.Image "media/planet.png"
    battleship: new ig.Image "media/destroyer.png"
    fighter: new ig.Image "media/fighter.png"

    init: ->
      ig.input.bind ig.KEY.MOUSE1, 'click'
      @spawnEntity EntityStar for num in [1..150]
      @tutorialSection = 1

    draw: ->
      @parent()

      if @tutorialSection is 1
        @renderFirstSection()
      if @tutorialSection is 2
        @renderSecondSection()
      if @tutorialSection is 3
        @renderThirdSection()
      if @tutorialSection is 4
        @renderFourthSection()
      if @tutorialSection is 5
        ig.system.setGame MyGame

      @font.draw "Click to continue", ig.system.width/2, ig.system.height-(6+@font.height), ig.Font.ALIGN.CENTER

      if ig.input.pressed "click"
        @tutorialSection++

    renderFirstSection: ->
      @font.draw "Units in the game", ig.system.width/2, 6, ig.Font.ALIGN.CENTER
      @font.draw "Planet", 30, 45, ig.Font.ALIGN.LEFT
      @planet.drawTile 60, 45+28, 0, 16
      @font.draw "Don't let the enemy\ndestroy them", 110, 45+22, ig.Font.ALIGN.LEFT
      @font.draw "Battleship", 30, 115, ig.Font.ALIGN.LEFT
      @battleship.drawTile 60, 115+32, 0, 16, 8
      @font.draw "Attacks and destroys\nplanets", 110, 115+22, ig.Font.ALIGN.LEFT
      @font.draw "Fighter", 30, 185, ig.Font.ALIGN.LEFT
      @fighter.drawTile 63, 185+35, 0, 6
      @font.draw "Attacks and destroys\nBattleships", 110, 185+22, ig.Font.ALIGN.LEFT

    renderSecondSection: ->
      @font.draw "Gameplay", ig.system.width/2, 6, ig.Font.ALIGN.CENTER
      @font.draw "Each side has 6 planets.", ig.system.width/2, 6+2*@font.height, ig.Font.ALIGN.CENTER
      @font.draw "3 Planets with Battleships,", ig.system.width/2, 6+4*@font.height, ig.Font.ALIGN.CENTER
      @font.draw "and 3 Planets with Fighters.", ig.system.width/2, 6+5*@font.height, ig.Font.ALIGN.CENTER
      @font.draw "If a ships planet is destroyed,", ig.system.width/2, 6+7*@font.height, ig.Font.ALIGN.CENTER
      @font.draw "the ship will also be destroyed.", ig.system.width/2, 6+8*@font.height, ig.Font.ALIGN.CENTER

    renderThirdSection: ->
      @font.draw "Controls", ig.system.width/2, 6, ig.Font.ALIGN.CENTER
      @font.draw "You only have indirect control.", ig.system.width/2, 6+2*@font.height, ig.Font.ALIGN.CENTER
      @font.draw "Click on enemy planet:", ig.system.width/2, 6+3*@font.height, ig.Font.ALIGN.CENTER
      @font.draw "Nearest free Battleship attacks.", ig.system.width/2, 6+4*@font.height, ig.Font.ALIGN.CENTER
      @font.draw "Click on enemy Battleship:", ig.system.width/2, 6+5*@font.height, ig.Font.ALIGN.CENTER
      @font.draw "Nearest free Fighter attacks.", ig.system.width/2, 6+6*@font.height, ig.Font.ALIGN.CENTER
      @font.draw "Once a ship has orders, the\n orders can't be changed until\n the ships target is destroyed.", ig.system.width/2, 6+8*@font.height, ig.Font.ALIGN.CENTER

    renderFourthSection: ->
      @font.draw "Goal", ig.system.width/2, 6, ig.Font.ALIGN.CENTER
      @font.draw "The game ends if all Battleships\n are destroyed, or if one side\n has no planets left.", ig.system.width/2, 6+2*@font.height, ig.Font.ALIGN.CENTER
      @font.draw "The side with the most planets\n left wins the game.", ig.system.width/2, 6+6*@font.height, ig.Font.ALIGN.CENTER

  ig.main '#canvas', Tutorial, 60, 400, 300, 2
