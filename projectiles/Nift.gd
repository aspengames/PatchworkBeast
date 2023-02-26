extends Area2D

export (int) var SPEED: int = 500

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += SPEED * direction * delta
	
func destroy():
	queue_free()


func _on_Nift_area_entered(area):
	destroy()
	
func _on_Nift_body_entered(body):
	destroy()
	if body.is_in_group("charge_mob"):
		body.get_node("pars").emitting = true
		body.health -= 1
	#body.dead()
	#body.queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	# In future would set this to delete after 5 seconds if not coming into screen again
	destroy()
