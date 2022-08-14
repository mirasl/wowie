extends StaticBody2D

const SPINOUT_DURATION = 0.8

func _on_Area2D_area_entered(area):
	if area.get_collision_layer_bit(4): # sword
		$CollisionShape2D.set_deferred("disabled", true)
		var t1 = get_tree().create_tween()
		var t2 = get_tree().create_tween()
		t1.tween_property(self, "position", Vector2(-600, 600), SPINOUT_DURATION)
		t2.tween_property(self, "rotation_degrees", 720.0, SPINOUT_DURATION)
		yield(get_tree().create_timer(SPINOUT_DURATION + 0.01), "timeout")
		queue_free()
