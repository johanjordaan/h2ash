// Generated by CoffeeScript 1.6.3
(function() {
  define(['underscore', 'THREE', 'OrbitControls'], function(_, THREE, OrbitControls) {
    var GameIcon, GameObject, GameScene, ret_val;
    GameIcon = (function() {
      function GameIcon(object) {
        this.object = object;
      }

      return GameIcon;

    })();
    GameObject = (function() {
      function GameObject(name, object, icon, update_fn) {
        this.name = name;
        this.object = object;
        this.update_fn = update_fn;
        if (icon != null) {
          this.icon = new GameIcon(icon);
        }
        this.position = this.object.position.clone();
        this.velocity = new THREE.Vector3();
        this.rotation = this.object.rotation.clone();
        this.angular_velocity = new THREE.Vector2();
        this.last_update = Date.now();
        this.target = null;
        this.direction = null;
        this.vector_to_target = new THREE.Vector3();
      }

      GameObject.prototype.set_direction = function(direction) {
        this.direction = direction;
        return this.target = null;
      };

      GameObject.prototype.set_target = function(target) {
        this.target = target;
      };

      GameObject.prototype.set_velocity = function(velocity) {};

      GameObject.prototype.update = function() {
        if (this.direction != null) {
          this.speed = 1;
          this.object.translateOnAxis(this.direction, this.speed * 1);
        }
        if (this.update_fn != null) {
          return this.update_fn();
        }
      };

      GameObject.prototype.orbit_target_at = function(target, distance) {};

      GameObject.prototype.synch = function(position, velocity) {};

      return GameObject;

    })();
    GameScene = (function() {
      function GameScene(width, height) {
        var axisHelper;
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
        this.controls = new THREE.OrbitControls(this.visual.camera, this.renderer.domElement);
        this.controls.addEventListener('change', this.render.bind(this));
        this.controls.addEventListener('mouseup', function(e) {
          return e.target.enabled = true;
        });
        axisHelper = new THREE.AxisHelper(500);
        this.visual.scene.add(axisHelper);
        this.controls.addEventListener('mousedblclick', this.dbl_click.bind(this));
      }

      GameScene.prototype.dbl_click = function(e) {
        var direction, v, x, y, z;
        x = e.target.event.layerX - (this.width / 2);
        y = e.target.event.layerY - (this.height / 2);
        z = (this.width / 2) / Math.tan(this.visual.camera.fov / 180 * Math.PI);
        v = new THREE.Vector3(x, -y, -z);
        direction = v.clone().normalize().applyQuaternion(this.visual.camera.quaternion);
        return this.active_object.set_direction(direction);
      };

      GameScene.prototype.attach_to_element = function(element) {
        return element.append(this.renderer.domElement);
      };

      GameScene.prototype.set_camera_focus = function(go) {
        if (this.focus != null) {
          this.focus.remove(this.visual.camera);
        }
        this.focus = go;
        return this.focus.object.add(this.visual.camera);
      };

      GameScene.prototype.set_active_object = function(active_object) {
        this.active_object = active_object;
      };

      GameScene.prototype.add = function(go, parent_go) {
        this.objects.push(go);
        if (parent_go != null) {
          parent_go.object.add(go.object);
        } else {
          this.visual.scene.add(go.object);
        }
        if (go.icon != null) {
          return this.overlay.scene.add(go.icon.object);
        }
      };

      GameScene.prototype.update_overlay = function() {
        var camera_direction, camera_object_direction, camera_object_vector, camera_position, object, object_position, v, _i, _len, _ref, _results;
        camera_direction = new THREE.Vector3(0, 0, -1);
        camera_direction.applyMatrix4(this.visual.camera.matrixWorld).normalize();
        camera_position = new THREE.Vector3(0, 0, 0);
        camera_position.applyMatrix4(this.visual.camera.matrixWorld);
        _ref = this.objects;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          object = _ref[_i];
          if (object.icon != null) {
            object_position = new THREE.Vector3(0, 0, 0);
            object_position.applyMatrix4(object.object.matrixWorld);
            camera_object_vector = object_position.clone().sub(camera_position);
            camera_object_direction = camera_object_vector.normalize();
            v = this.projector.projectVector(object_position.clone(), this.visual.camera);
            if (v.z < 1) {
              object.icon.object.visible = true;
              _results.push(object.icon.object.position.set((this.width / 2) * v.x, (this.height / 2) * v.y, -20));
            } else {
              _results.push(object.icon.object.visible = false);
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
        var object, _i, _len, _ref;
        requestAnimationFrame(this.animate.bind(this));
        _ref = this.objects;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          object = _ref[_i];
          object.update();
        }
        return this.render();
      };

      return GameScene;

    })();
    return ret_val = {
      GameScene: GameScene,
      GameObject: GameObject,
      GameIcon: GameIcon
    };
  });

}).call(this);
