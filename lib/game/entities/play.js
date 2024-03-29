//@ sourceMappingURL=play.map
// Generated by CoffeeScript 1.6.1
(function() {
  var _this = this,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  ig.module('game.entities.play').requires('impact.entity').defines(function() {
    return _this.EntityPlay = ig.Entity.extend({
      type: ig.Entity.TYPE.NONE,
      checkAgainst: ig.Entity.TYPE.NONE,
      collides: ig.Entity.COLLIDES.NEVER,
      size: {
        x: 49,
        y: 14
      },
      animSheet: new ig.AnimationSheet('media/play.png', 49, 14),
      init: function(x, y, settings) {
        x = x - this.size.x / 2;
        this.parent(x, y, settings);
        this.addAnim('idle', 1, [0]);
        return this.addAnim('selected', 1, [1]);
      },
      update: function() {
        if (this.marked()) {
          this.currentAnim = this.anims.selected;
        } else {
          this.currentAnim = this.anims.idle;
        }
        this.parent();
        if (this.marked() && ig.input.pressed("click")) {
          return ig.system.setGame(MyGame);
        }
      },
      marked: function() {
        var _i, _j, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _results, _results1;
        return (_ref = ig.input.mouse.x.floor(), __indexOf.call((function() {
          _results = [];
          for (var _i = _ref1 = this.pos.x.floor(), _ref2 = (this.pos.x + this.size.x).ceil(); _ref1 <= _ref2 ? _i <= _ref2 : _i >= _ref2; _ref1 <= _ref2 ? _i++ : _i--){ _results.push(_i); }
          return _results;
        }).apply(this), _ref) >= 0) && (_ref3 = ig.input.mouse.y.floor(), __indexOf.call((function() {
          _results1 = [];
          for (var _j = _ref4 = this.pos.y.floor(), _ref5 = (this.pos.y + this.size.y).ceil(); _ref4 <= _ref5 ? _j <= _ref5 : _j >= _ref5; _ref4 <= _ref5 ? _j++ : _j--){ _results1.push(_j); }
          return _results1;
        }).apply(this), _ref3) >= 0);
      }
    });
  });

}).call(this);
