extends KinematicBody2D

const FOLLOWING_SPEED = 50*4
const WAVE_OFFSET_MAGNITUDE = 20*4
const WAVE_OFFSET_COEFFICIENT = PI
const WALK_ANIM_FPS = 3.5

enum {
	ROAMING,
	FOLLOWING
}

var velocity : Vector2
var state = ROAMING
var delta_time : float = 0

onready var animation_tree = $AnimatedSprite/AnimationTree
onready var state_machine = animation_tree.get("parameters/playback")


func _ready():
	$Explosion.hide()


func _physics_process(delta):
	if state == ROAMING:
		_roaming_process(delta)
	elif state == FOLLOWING:
		_following_process(delta)
	
	delta_time += delta
	
	# animation:
	var input_vector : Vector2 = velocity.normalized()
	for i in 4:
		animation_tree.set("parameters/Walk/" + str(i) + "/TimeScale/scale", 
				WALK_ANIM_FPS)
	
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Walk/blend_position", input_vector)
		state_machine.travel("Walk")
	
	else:
		state_machine.travel("Idle")
	


func _roaming_process(delta):
	pass


func _following_process(delta):
	var player_position = get_parent().get_parent().get_node("Player").position # fantastic coding
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
	Audio.play("MetalBang")
	Engine.time_scale = 0.5
	$AnimatedSprite.hide()
	$Explosion.show()
	$Explosion.play("default")
	get_parent().get_parent().get_node("CanvasLayer/Overlay").show()


func _on_Explosion_animation_finished():
	Engine.time_scale = 1
	Global.kills += 1
	queue_free()
	get_parent().get_parent().get_node("CanvasLayer/Overlay").hide()


func _on_VisibilityNotifier2D_screen_entered():
	state = FOLLOWING
