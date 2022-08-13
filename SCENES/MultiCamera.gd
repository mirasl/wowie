extends Camera2D


const MOVE_SPEED = 0.5
const ZOOM_SPEED = 0.05
const MIN_ZOOM = 1
const MAX_ZOOM = 3
const MARGIN = Vector2(50, 50)

var targets = []
var launching : bool = false

onready var screen_size = get_viewport_rect().size / 4


func _process(delta):
	if !targets:
		return
	
	# Keep the camera centered between the targets
	var p = Vector2.ZERO
	for target in targets:
		p += target.position
	p /= targets.size()
	position = lerp(position, p, MOVE_SPEED)
	
	# Find the zoom that will contain all targets
	var r = Rect2(position, Vector2.ONE)
	for target in targets:
		r = r.expand(target.position)
	r = r.grow_individual(MARGIN.x, MARGIN.y, MARGIN.x, MARGIN.y)
	var d = max(r.size.x, r.size.y)
	var z
	if r.size.x > r.size.y * screen_size.aspect():
		z = clamp(r.size.x / screen_size.x, MIN_ZOOM, MAX_ZOOM)
	else:
		z = clamp(r.size.y / screen_size.y, MIN_ZOOM, MAX_ZOOM)
	if not launching:
		zoom = lerp(zoom, Vector2.ONE * z, ZOOM_SPEED)


func add_target(t):
	if not t in targets:
		targets.append(t)

func remove_target(t):
	if t in targets:
		targets.erase(t)
