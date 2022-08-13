extends KinematicBody2D

const FOLLOWING_SPEED = 50*4
const WAVE_OFFSET_MAGNITUDE = 20*4
const WAVE_OFFSET_COEFFICIENT = PI

enum {
	ROAMING,
	FOLLOWING
}

var velocity : Vector2
var state = ROAMING
var delta_time : float = 0

func _physics_process(delta):
	if state == ROAMING:
		_roaming_process(delta)
	elif state == FOLLOWING:
		_following_process(delta)
	
	delta_time += delta


func _roaming_process(delta):
	pass


func _following_process(delta):
	var player_position = get_parent().get_node("Player").position
	var direction : Vector2 = player_position - position
	direction = direction.normalized()
	velocity = direction * FOLLOWING_SPEED
	
	var wave_offset : float = sin(delta_time*WAVE_OFFSET_COEFFICIENT)
	var offset_vector = Vector2(direction.y, -direction.x)
	offset_vector = offset_vector.normalized()
	offset_vector *= wave_offset * WAVE_OFFSET_MAGNITUDE
	velocity += offset_vector
	velocity = move_and_slide(velocity)


func _on_SightArea_body_entered(body):
	if body.get_filename() == "res://SCENES/Player.tscn":
		state = FOLLOWING


func _on_Hurtbox_area_entered(area):
	if area.get_collision_layer_bit(4): # sword
		ouch()


func ouch():
	queue_free()
