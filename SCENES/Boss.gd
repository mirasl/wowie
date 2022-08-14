extends StaticBody2D


const ANIM_SWITCH_TIME : float = 8.0

var shoot_interval : float = 2.0
var shoot_time : float = 0
var anim_time : float = 0
var current_anim_1 : int
var current_anim_2 : int
var playing_anim_1 : bool = false
var hurting : bool = false
var health : int = 10


func _ready():
	new_animation()
	for child in $Explosions.get_children():
		child.hide()


func _physics_process(delta):
	anim_time += delta
	if anim_time >= ANIM_SWITCH_TIME:
		anim_time = 0
		new_animation()
	
	shoot_time += delta
	if shoot_time >= shoot_interval:
		shoot_time = 0
		randomize()
		shoot(Vector2(randf() - 0.5, randf() - 0.5), 6 + randi()%4, 300)


func new_animation():
	randomize()
	current_anim_1 = randi()%5 + 1
	current_anim_2 = randi()%5 + 1
	while current_anim_2 == current_anim_1:
		current_anim_2 = randi()%5 + 1
		

func _on_Timer_timeout():
	if not hurting:
		$Timer.start()
		if playing_anim_1:
			playing_anim_1 = false
			$AnimatedSprite.play(str(current_anim_2))
		else:
			playing_anim_1 = true
			$AnimatedSprite.play(str(current_anim_1))


func _on_Hurtbox_area_entered(area):
	if area.get_collision_layer_bit(4): # sword
		ouch()
		Audio.play("MetalBang")
		Engine.time_scale = 0.5
		yield(get_tree().create_timer(0.2), "timeout")
		Engine.time_scale = 1


func ouch():
	health -= 1
	if health <= 0:
		explode()
	elif health == 5:
		shoot_interval /= 2
		modulate = Color.red
	
	hurting = true
	for i in 5:
		$AnimatedSprite.play("hit")
		yield(get_tree().create_timer(0.05), "timeout")
		$AnimatedSprite.play(str(current_anim_1))
		yield(get_tree().create_timer(0.05), "timeout")
	hurting = false
	$Timer.start()


func explode():
	Audio.stop("Lab")
	Engine.time_scale = 0.01
	for child in $Explosions.get_children():
		Audio.play("MetalBang")
		child.show()
		child.play("default")
		yield(get_tree().create_timer(0.1), "timeout")
	Engine.time_scale = 1
	queue_free()


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




