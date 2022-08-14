extends KinematicBody2D

signal get_player_position
signal launching

const LAUNCH_SPEED := 1080*4
const LERP_DECELERATION := 0.08
const ROTATION_DURATION := 0.3
const WINDUP_MAGNITUDE := 16*4
const WINDUP_DURATION := 0.5
const LAUNCH_FINISHED_THRESHOLD := 100*4
const TRIANGULATE_DURATION := 0.65

var velocity : Vector2

var player_position : Vector2

var winding_up : bool = false
var launching : bool = false
var back_sensor_platform_count = 0
var callable : bool = true


func _ready():
	$Swords.set_collision_layer_bit(4, false)
	$TargetRay.hide()
	$TargetRay2.hide()
	$AnimatedSprite.play("normal")
	$Node/LeftTrail.hide()
	$Node/RightTrail.hide()


func _physics_process(delta):
	velocity = lerp(velocity, Vector2.ZERO, LERP_DECELERATION)
	
	if (velocity.x < LAUNCH_FINISHED_THRESHOLD and velocity.y < 
			LAUNCH_FINISHED_THRESHOLD and not winding_up and launching):
		emit_signal("launching", false)
		launching = false
		$AnimatedSprite.stop()
		$AnimatedSprite.play("collapse")
		$Node/LeftTrail.hide()
		$Node/RightTrail.hide()
		queue_sword_disable()
		
	if Input.is_action_just_pressed("call") and callable:
		if (velocity.x < LAUNCH_FINISHED_THRESHOLD and velocity.y < 
				LAUNCH_FINISHED_THRESHOLD and not winding_up):
			launch()
	
	velocity = move_and_slide(velocity)


func queue_sword_disable():
	yield(get_tree().create_timer(0.5), "timeout")
	$Swords.set_collision_layer_bit(4, false)


func launch():
	# setup
	winding_up = true
	var direction : Vector2
	emit_signal("get_player_position")
	direction = player_position - position
	direction = direction.normalized()
	var rotated_direction = Vector2(-direction.y, direction.x)
	
	$AnimatedSprite.stop()
	$AnimatedSprite.play("expand")
	
	# target ray
	$TargetRay.show()
	$TargetRay.scale.y = player_position.distance_to(position) * 3
	$TargetRay2.show()
	$TargetRay2.scale.y = 0
	$TargetRay2.global_rotation_degrees = 0
	var target_ray_tween = get_tree().create_tween()
	target_ray_tween.tween_property($TargetRay2, "rotation_degrees", 180.0, 
			ROTATION_DURATION)
	
	var target_ray_tween2 = get_tree().create_tween()
	target_ray_tween2.tween_property($TargetRay2, "scale", Vector2(scale.x, 
			player_position.distance_to(position)) * 3, ROTATION_DURATION)
	
	target_ray_tween.tween_property($TargetRay2, "rotation_degrees", 
			$TargetRay.rotation_degrees, TRIANGULATE_DURATION)
	
	# windup
	Audio.play("RobotSFX")
	var t1 : = get_tree().create_tween()
	t1.tween_property(self, "rotation_degrees", rad2deg(atan2(
			rotated_direction.y, rotated_direction.x)), ROTATION_DURATION)
	var platform = 1
	if back_sensor_platform_count >= 1:
		platform = 0
	t1.tween_property(self, "position", position - direction*WINDUP_MAGNITUDE*
			platform, WINDUP_DURATION).set_trans(Tween.TRANS_SINE).set_ease(
			Tween.EASE_OUT)
	yield(get_tree().create_timer(ROTATION_DURATION + WINDUP_DURATION), 
			"timeout")
	winding_up = false
	
	# launch
	$Swords.set_collision_layer_bit(4, true)
	velocity = direction * LAUNCH_SPEED * (player_position.distance_to(
			position) / 120.0)
	emit_signal("launching", true)
	launching = true
	$TargetRay.hide()
	$TargetRay2.hide()
	$Node/LeftTrail.show()
	$Node/RightTrail.show()


func windup():
	# setup
	winding_up = true
	var direction : Vector2
	emit_signal("get_player_position")
	direction = player_position - position
	direction = direction.normalized()
	var rotated_direction = Vector2(-direction.y, direction.x)
	
	$AnimatedSprite.stop()
	$AnimatedSprite.play("expand")
	
	# target ray
	$TargetRay.show()
	$TargetRay.scale.y = player_position.distance_to(position) * 3
	$TargetRay2.show()
	$TargetRay2.scale.y = 0
	$TargetRay2.global_rotation_degrees = 0
	var target_ray_tween = get_tree().create_tween()
	target_ray_tween.tween_property($TargetRay2, "rotation_degrees", 180.0, 
			ROTATION_DURATION)
	
	var target_ray_tween2 = get_tree().create_tween()
	target_ray_tween2.tween_property($TargetRay2, "scale", Vector2(scale.x, 
			player_position.distance_to(position)) * 3, ROTATION_DURATION)
	
	target_ray_tween.tween_property($TargetRay2, "rotation_degrees", 
			$TargetRay.rotation_degrees, TRIANGULATE_DURATION)
	
	# windup
	Audio.play("RobotSFX")
	var t1 : = get_tree().create_tween()
	t1.tween_property(self, "rotation_degrees", rad2deg(atan2(
			rotated_direction.y, rotated_direction.x)), ROTATION_DURATION)
	var platform = 1
	if back_sensor_platform_count >= 1:
		platform = 0
	t1.tween_property(self, "position", position - direction*WINDUP_MAGNITUDE*
			platform, WINDUP_DURATION).set_trans(Tween.TRANS_SINE).set_ease(
			Tween.EASE_OUT)
	yield(get_tree().create_timer(ROTATION_DURATION + WINDUP_DURATION), 
			"timeout")
	winding_up = false
	



func _on_BackSensor_body_entered(body):
	if body.get_collision_layer_bit(3): # platform
		back_sensor_platform_count += 1


func _on_BackSensor_body_exited(body):
	if body.get_collision_layer_bit(3): # platform
		back_sensor_platform_count -= 1





















