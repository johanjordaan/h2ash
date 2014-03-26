// Generated by CoffeeScript 1.6.3
(function() {
  define(['underscore', 'THREE'], function(_, THREE) {
    var GameObject, GameScene, ret_val;
    GameObject = (function() {
      function GameObject(object, icon) {
        this.object = object;
        this.icon = icon;
        this.v = new THREE.Vector3();
        this.last_update = "";
        this.target = null;
        this.vector_to_target = new THREE.Vector3();
      }

      GameObject.prototype.set_target = function(target) {
        return call_backend(set_target, function() {
          return this.target = target;
        });
      };

      GameObject.prototype.set_velocity = function(velocity) {
        return call_backend(set_velocity, function() {
          return this.velocity = velocity;
        });
      };

      GameObject.prototype.update = function() {};

      GameObject.prototype.synch = function(position, velocity) {};

      return GameObject;

    })();
    GameScene = (function() {
      function GameScene(width, height) {
        this.width = width;
        this.height = height;
        this.renderer = new THREE.WebGLRenderer();
        this.renderer.setSize(width, height);
        this.renderer.setClearColor(0x000000, 1);
        this.renderer.autoClear = false;
        this.projector = new THREE.Projector();
        this.visual = {
          scene: new THREE.Scene(),
          camera: new THREE.PerspectiveCamera(60, this.width / this.height, 0.01, 100000)
        };
        this.overlay = {
          scene: new THREE.Scene(),
          camera: new THREE.OrthographicCamera(-this.width / 2, this.width / 2, this.height / 2, -this.height / 2, 0.01, 100000)
        };
        this.objects = [];
        this.focus = null;
        this.visual.camera.position.z = 130;
      }

      GameScene.prototype.attach_to_element = function(element) {
        return element.append(this.renderer.domElement);
      };

      GameScene.prototype.set_camera_focus = function(object) {
        if (this.focus != null) {
          this.focus.remove(this.visual.camera);
        }
        this.focus = object;
        return this.focus.add(this.visual.camera);
      };

      GameScene.prototype.add = function(object) {
        this.objects.push(object);
        this.visual.scene.add(object.object);
        if (object.icon != null) {
          return this.overlay.scene.add(object.icon);
        }
      };

      GameScene.prototype.update_overlay = function() {
        var object, v, _i, _len, _ref, _results;
        _ref = this.objects;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          object = _ref[_i];
          if (object.icon != null) {
            debugger;
            v = this.projector.projectVector(object.object.position.clone(), this.visual.camera);
            if (v.z > 0) {
              object.icon.position.x = (this.width / 2) * v.x;
              object.icon.position.y = (this.height / 2) * v.y;
              _results.push(object.icon.position.z = -20);
            } else {
              _results.push(void 0);
            }
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      };

      GameScene.prototype.render = function() {
        this.renderer.clear();
        this.renderer.render(this.visual.scene, this.visual.camera);
        this.update_overlay();
        this.renderer.clearDepth();
        return this.renderer.render(this.overlay.scene, this.overlay.camera);
      };

      GameScene.prototype.animate = function() {
        requestAnimationFrame(this.animate.bind(this));
        return this.render();
      };

      return GameScene;

    })();
    return ret_val = {
      GameScene: GameScene,
      GameObject: GameObject
    };
  });

}).call(this);
