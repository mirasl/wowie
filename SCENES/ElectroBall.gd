extends KinematicBody2D


var velocity : Vector2
var direction : Vector2 = Vector2.UP
var speed : int = 60


func _ready():
	$Explosion.hide()


func _physics_process(delta):
	velocity = speed * direction.normalized()
	velocity = move_and_slide(velocity)


func _on_Hitbox_body_entered(body):
	if body.get_collision_layer_bit(3) or body.get_collision_layer_bit(0): # platform or player
		yield(get_tree().create_timer(0.1), "timeout")
		queue_free()



func _on_Explosion_animation_finished():
	queue_free()


func _on_Hitbox_area_entered(area):
	if area.get_collision_layer_bit(4): # sword
		$AnimatedSprite.hide()
		$Explosion.show()
		$Explosion.play("default")
