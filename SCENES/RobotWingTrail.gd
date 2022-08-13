extends Line2D

export(NodePath) var target_path
export var trail_length = 10

onready var target = get_node(target_path)

func _physics_process(delta):
	global_position = Vector2(0,0)
	rotation_degrees = 0
	add_point(target.global_position)
	while get_point_count() > trail_length:
		remove_point(0)
	
