extends "res://SCENES/Enemies/Enemy.gd"


export var interval = 1
var time : float = 0


func _physics_process(delta):
	if state == FOLLOWING:
		time += delta
		if time >= interval:
			time = 0
			shoot_randomly()


func shoot_randomly():
	randomize()
	shoot(Vector2(randf() - 0.5, randf() - 0.5))


func shoot(direction : Vector2, num_projectiles : int = 1, speed : int = 360):
	direction = direction.normalized()
	var rotated = Vector2(direction.y, -direction.x) # 90 degrees clockwise
	var arc = atan2(rotated.y, rotated.x) # angle (radians) of terminal arc
	var interval = 180.0 / (num_projectiles + 1) # angle between projectiles
	interval = deg2rad(interval)
	
	for a in num_projectiles:
		var angle = interval * (a + 1) # radians
		var total_arc = arc + angle
		var new_direction = Vector2(cos(total_arc), sin(total_arc))
		
		# Create new projectile that follows new_direction's trajectory:
		var projectile = preload("res://SCENES/ElectroBall.tscn")
		projectile = projectile.instance()
		projectile.direction = new_direction
		projectile.speed = speed
		get_parent().get_parent().add_child(projectile)
		projectile.global_position = global_position
