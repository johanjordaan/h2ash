movement =

  Movable : class Movable
    constructor : (@position,@direction,@max_speed,@max_angular_speed,@last_update) ->
      @speed = 0            # m/s
      @angular_speed = 0    # rad/s

    set_speed : (@speed) ->
      if @speed>@max_speed
        @speed = @max_speed
      if @speed<0
        @speed = 0

    set_angular_speed : (@angular_speed) ->
      if @angular_speed>@max_angular_speed
        @angular_speed = @max_angular_speed
      if @angular_speed<0
        @angular_speed = 0

    set_target_position : (@target_position) ->
      @target = null
      @target_direction = null

    set_target : (@target) ->
      @target_position = null
      @target_direction = null  

    _get_target_direction : () ->
      if @target?
        return @target.position.clone().sub(@position).normalize()
      else if @target_position?
        return @target_position.clone().sub(@position).normalize()
      else 
        return @direction.clone()

    _get_target_position : () ->
      if @target?
        return @target.position
      else if @target_position?
        return @target_position
      else
        return @position

    rotation_granularity : 1000 # in ms
    position_accuracy : 0.01 # in m 


    _update_translation : (delta) ->
      if @speed <=0
        return

      distance_to_target = Math.abs(@position.distanceTo(@_get_target_position()))
      if distance_to_target < @position_accuracy
        # If we are close enough to the target then do not update the position
        #
      else 
        # Make sure we do not overshoot the target by adjusting the time sothat we get to exactly 
        # the target 
        #
        max_delta = distance_to_target/@speed * 1000
        if max_delta<delta
          delta = max_delta

        # Apply the speed for the delta time in the direction and apply this to the position  
        #
        delta_position = @direction.clone().multiplyScalar(@speed*delta/1000) 
        @position.add(delta_position)


    _update_direction : (delta) ->
      # We are going to rotate our direction by using Rodrigues' rotation formula
      # http://en.wikipedia.org/wiki/Axis-angle_representation
      # http://en.wikipedia.org/wiki/Rodrigues%27_rotation_formula
      # Vrot = V*cos(theta) + (KxV)Sin(theta) + k(k.v)(1-cos(theta))
      #
      theta = @angular_speed * delta/1000   # In Radians

      # Unit vector describing the exis of rotation the vector
      #
      k = @direction.clone().cross(@_get_target_direction()).normalize()
      #k = @_get_target_direction().cross(@direction).normalize()

      # Calculate all the constants
      #
      cos_theta = Math.cos(theta)
      sin_theta = Math.sin(theta)
      k_dot_v = k.clone().dot(@direction)
      k_cross_v_sin_theta = k.clone().cross(@direction).normalize().multiplyScalar(sin_theta)

      # Apply Rodrigues' rotation formula
      #
      @direction.multiplyScalar(cos_theta)
      @direction.add(k_cross_v_sin_theta)
      @direction.add(k.clone().multiplyScalar(k_dot_v*(1-cos_theta)))



    update : (time,_target_time) ->
      # Recursion exit
      #
      if !_target_time?
        _target_time = time

      if time > _target_time
        return  

      # Calculate how much time has passed since the last update
      #
      delta = time - @last_update     # in ms
      # Calculate the curent direction to the target
      #
      current_target_direction = @_get_target_direction()
      angular_distance = @direction.angleTo(current_target_direction)

      #console.log @position,@direction,current_target_direction,angular_distance
      #console.log '----',time,_target_time

      # If we are not pointed in the direction of the target then rotate towards
      # the target
      #
      if angular_distance>0.01 and @angular_speed>0 
        # If the angular distance is smaller than the amount of rotation in the 
        # rotational granularity then only rotate to the direction and then translate
        #


        # If delta is larger rotational granularity then we need to update in smaller steps
        #
        if delta > @rotation_granularity
          @_update_translation(@rotation_granularity)
          @_update_direction(@rotation_granularity)
          @last_update += @rotation_granularity
          @update(@last_update+@rotation_granularity,_target_time)
        else
          @_update_translation(delta)
          @_update_direction(delta)
          @last_update += delta
          @update(@last_update+delta,_target_time)

      # We are pointed in the direction of the target so apply the required translation
      #    
      else
        if @speed >0   
          @last_update += delta 
          @_update_translation(delta)
        else
          @last_update = _target_time
        
      




  get_velocity : (direction,speed) ->
    return direction.clone().multiplyScalar(speed)

  update_position : (position,direction,speed,delta_time) ->
    delta_position = @get_velocity(direction,speed).multiplyScalar(delta_time)
    return position.add(delta_position)

  update_rotation : (direction,target_direction,angular_speed,delta_time) ->
    #v1 = (new THREE.Vector3(3,0,0)).normalize()
    #v2 = (new THREE.Vector3(3,3,0)).normalize()
      
    k = direction.clone().cross(target_direction).normalize()
    #theta = direction.clone().angleTo(target_direction)   # Angle between
    theta = angular_speed*delta_time

    # Calculate the components of http://en.wikipedia.org/wiki/Rodrigues'_rotation_formula
    #
    vr_1 = direction.clone().multiplyScalar(Math.cos(theta)) 
    vr_2 = (k.clone().cross(direction)).multiplyScalar(Math.sin(theta))
    kdotv = k.clone().dot(direction)
    vr_3 = k.clone().multiplyScalar(kdotv*(1-Math.cos(theta)))

    vr = vr_1.clone().add(vr_2).add(vr_3)




if module?
  _ = require 'underscore'
  THREE = require 'three'
  module.exports = movement

if define?
  define ['underscore','THREE'],(_,THREE)->
    return movement
