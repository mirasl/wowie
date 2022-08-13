extends KinematicBody2D


var velocity : Vector2
const ACCELERATION = 1000*4
const DECELERATION = 1000*4
const WALK_SPEED = 150*4
const RUN_SPEED = 220*4
const WALK_ANIM_FPS = 3.5
const RUN_ANIM_FPS = 5
const HEY_DURATION = 0.5

var current_max_speed
var calling_enabled : bool = true

onready var animation_tree = $AnimatedSprite/AnimationTree
onready var state_machine = animation_tree.get("parameters/playback")


func _ready():
	$Hey.hide()


func _physics_process(delta):
	var input_vector : Vector2
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
#	if Input.is_action_pressed("run"):
#		current_max_speed = RUN_SPEED
#		for i in 4:
#			animation_tree.set("parameters/Walk/" + str(i) + "/TimeScale/scale", RUN_ANIM_FPS)
#
#	else:
#		current_max_speed = WALK_SPEED
#		for i in 4:
#			animation_tree.set("parameters/Walk/" + str(i) + "/TimeScale/scale", WALK_ANIM_FPS)
#			print(animation_tree.get("parameters/Walk/0/TimeScale/scale"))
	current_max_speed = WALK_SPEED
	for i in 4:
		animation_tree.set("parameters/Walk/" + str(i) + "/TimeScale/scale", WALK_ANIM_FPS)
	
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Walk/blend_position", input_vector)
		state_machine.travel("Walk")
		velocity = velocity.move_toward(input_vector * current_max_speed, ACCELERATION * delta)
	
	else:
		state_machine.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, DECELERATION * delta)
	
	if Input.is_action_just_pressed("call") and calling_enabled:
		$Hey.show()
		yield(get_tree().create_timer(HEY_DURATION), "timeout")
		$Hey.hide()
	
	velocity = move_and_slide(velocity)
	
