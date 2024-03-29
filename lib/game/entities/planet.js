//@ sourceMappingURL=planet.map
// Generated by CoffeeScript 1.6.1
(function() {
  var _this = this,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  ig.module('game.entities.planet').requires('impact.entity', 'game.entities.ship', 'game.entities.fighter', 'game.entities.explosion').defines(function() {
    return _this.EntityPlanet = ig.Entity.extend({
      type: ig.Entity.TYPE.NONE,
      checkAgainst: ig.Entity.TYPE.NONE,
      collides: ig.Entity.COLLIDES.NEVER,
      markerSheet: new ig.AnimationSheet("media/planet_marker.png", 24, 24),
      size: {
        x: 16,
        y: 16
      },
      animSheet: new ig.AnimationSheet('media/planet.png', 16, 16),
      zIndex: 1,
      init: function(settings) {
        var color, randomPos, _ref;
        randomPos = this.findPosition(settings);
        this.parent(randomPos.x, randomPos.y, settings);
        color = (_ref = settings.enemy) != null ? _ref : {
          1: 0
        };
        this.addAnim('idle', 1, [color]);
        this.marker = new ig.Animation(this.markerSheet, 1, [0]);
        this.ship = settings.ship === "destroyer" ? ig.game.spawnEntity(EntityShip, this.pos.x, this.pos.y + 4, {
          ki: settings.enemy
        }) : ig.game.spawnEntity(EntityFighter, this.pos.x + 4, this.pos.y + 5, {
          ki: settings.enemy
        });
        return ig.game.planets.push(this);
      },
      findPosition: function(settings) {
        var half, planet, px, py, works, x, xBlocked, y, yBlocked, _i, _j, _k, _len, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6, _results, _results1;
        half = ig.system.width / 2;
        x = half * Math.random();
        if (settings.enemy) {
          x = x + (half - this.size.x);
        }
        y = (ig.system.height - this.size.y) * Math.random();
        works = true;
        _ref = ig.game.planets;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          planet = _ref[_i];
          px = planet.pos.x.ceil();
          xBlocked = (_ref1 = x.ceil(), __indexOf.call((function() {
            _results = [];
            for (var _j = _ref2 = px - 32, _ref3 = px + 48; _ref2 <= _ref3 ? _j <= _ref3 : _j >= _ref3; _ref2 <= _ref3 ? _j++ : _j--){ _results.push(_j); }
            return _results;
          }).apply(this), _ref1) >= 0);
          py = planet.pos.y.ceil();
          yBlocked = (_ref4 = y.ceil(), __indexOf.call((function() {
            _results1 = [];
            for (var _k = _ref5 = py - 32, _ref6 = py + 48; _ref5 <= _ref6 ? _k <= _ref6 : _k >= _ref6; _ref5 <= _ref6 ? _k++ : _k--){ _results1.push(_k); }
            return _results1;
          }).apply(this), _ref4) >= 0);
          if (xBlocked && yBlocked) {
            works = false;
          }
        }
        if (works) {
          return {
            x: x,
            y: y
          };
        } else {
          return this.findPosition(settings);
        }
      },
      update: function() {
        if (this.marked() && ig.input.pressed('click')) {
          ig.game.confirmSound.play();
          this.sendShip();
        }
        return this.parent();
      },
      sendShip: function() {
        var nearestShip, ships,
          _this = this;
        ships = ig.game.getEntitiesByType(EntityShip).filter(function(ship) {
          return !ship.ki && (!ship.target || ship.target._killed);
        });
        ships.sort(function(a, b) {
          return _this.distanceTo(a) - _this.distanceTo(b);
        });
        if (nearestShip = ships[0]) {
          nearestShip.target = this;
          return nearestShip.arriveActive = true;
        }
      },
      draw: function() {
        this.parent();
        if (this.marked()) {
          return this.marker.draw(this.pos.x - 4, this.pos.y - 4);
        }
      },
      marked: function() {
        var _i, _j, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _results, _results1;
        return this.enemy && (_ref = ig.input.mouse.x.floor(), __indexOf.call((function() {
          _results = [];
          for (var _i = _ref1 = this.pos.x.floor(), _ref2 = (this.pos.x + this.size.x).ceil(); _ref1 <= _ref2 ? _i <= _ref2 : _i >= _ref2; _ref1 <= _ref2 ? _i++ : _i--){ _results.push(_i); }
          return _results;
        }).apply(this), _ref) >= 0) && (_ref3 = ig.input.mouse.y.floor(), __indexOf.call((function() {
          _results1 = [];
          for (var _j = _ref4 = this.pos.y.floor(), _ref5 = (this.pos.y + this.size.y).ceil(); _ref4 <= _ref5 ? _j <= _ref5 : _j >= _ref5; _ref4 <= _ref5 ? _j++ : _j--){ _results1.push(_j); }
          return _results1;
        }).apply(this), _ref3) >= 0);
      },
      kill: function() {
        this.ship.kill();
        ig.game.spawnEntity(EntityExplosion, this.pos.x, this.pos.y);
        return this.parent();
      }
    });
  });

}).call(this);
