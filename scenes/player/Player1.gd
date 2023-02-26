extends KinematicBody2D

""" -------- DECLARATION -------- """
#input and direction
var horizontal_input
var vertical_input
var direction = Vector2()

#spacial speed
var horizontal_speed
var vertical_speed
var speed = Vector2()

#velocity vectors
var velocity = Vector2()
var delta_velocity = Vector2()

#speed managers
var max_speed = 40
var speed_multiplier = 1000
var true_max_speed = max_speed * speed_multiplier

#acceleration/deceleration lerping weight
const ACCEL_WEIGHT = .3

onready var atkTimer = $atkTimer
onready var hurtTimer = $hurtTimer
#init the nift
export(PackedScene) var NIFT: PackedScene = preload("res://projectiles/Nift.tscn")

""" -------- FUNCTIONS -------- """
#initialize variables
func _ready():
	horizontal_input = 0
	vertical_input = 0
	
	horizontal_speed = 0;
	vertical_speed = 0;
	pass

#executed each frame
func _physics_process(delta):
	#boolean returning if any moving key is pressed
	var is_moving = Input.is_action_pressed("move_up") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_down") or Input.is_action_pressed("move_left")
	
	""" Movement manager
	"    if is_moving
	"      then modify speed and inputs depending on player's request
	"    else
	"     conserve last direction inputs from the player and lerp speed to 0
	"""
	if is_moving:
		horizontal_input = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
		vertical_input = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
		
		horizontal_speed = lerp(horizontal_speed, abs(horizontal_input), ACCEL_WEIGHT)
		vertical_speed = lerp(vertical_speed, abs(vertical_input), ACCEL_WEIGHT)
	else:
		horizontal_speed = lerp(horizontal_speed, 0, ACCEL_WEIGHT)
		vertical_speed = lerp(vertical_speed, 0, ACCEL_WEIGHT)
	
	""" Direction and speed vectors assignement
	"    normalizing the direction vector to avoid diagonal super speed
	"    and creating a speed vector with both "spacialized" speed ; x and y axis
	"""
	direction = Vector2(horizontal_input, vertical_input).normalized()
	speed = Vector2(horizontal_speed, vertical_speed)
	
	#multiplying valors to get velocity vectors
	velocity = direction * speed
	delta_velocity = true_max_speed * velocity * delta
	
	if velocity == Vector2.ZERO:
		$AnimationTree.get("parameters/playback").travel("Idle")
	else:
		if not is_moving:
			$AnimationTree.get("parameters/playback").travel("Idle")
		else:
			$AnimationTree.get("parameters/playback").travel("Walk")
			$AnimationTree.set("parameters/Idle/blend_position", velocity)
			$AnimationTree.set("parameters/Walk/blend_position", velocity)
			
	if Input.is_action_just_pressed("action_attack") and atkTimer.is_stopped():
			#get_global_mouse_position() for shooting towards mouse
			#print("rotation is: ",  rotation)
			var nift_direction = self.global_position.direction_to(get_global_mouse_position())
			throw_nift(nift_direction)
	if enemyin and hurtTimer.is_stopped():
		enemyin = true
		health -= 1
		$ui/health.value = health
		print(health)
		hurtTimer.start()
	#applying the needed vector to the object, to make it move thanks to the move_and_slide function
	move_and_slide(delta_velocity)
	pass

var enemyin = false
var health = 80
func _on_HITBOX_body_entered(body):
	if body.is_in_group("charge_mob") and hurtTimer.is_stopped():
		enemyin = true
		health -= 5
		$ui/health.value = health
		print(health)
		hurtTimer.start()

func _on_HITBOX_body_exited(body):
	if body.is_in_group("charge_mob"):
		hurtTimer.stop()
		enemyin = false

func throw_nift(nift_direction: Vector2):
	if NIFT:
		var nift = NIFT.instance()
		get_tree().current_scene.get_node("YSort/projectiles").add_child(nift)
		nift.global_position = self.global_position#self.global_positions
		#nift.z_index = -1
		var nift_rotation = nift_direction.angle()
		nift.rotation = nift_rotation
		#$"../laserbgm".play()
		atkTimer.start()
		nift.get_node("pars").emitting = true
		#print(nift_direction)
		#var mouse_direction = Vector3(nift_direction.x, nift_direction.y, 0)
		#nift.get_node("pars").process_material.set("direction", mouse_direction)
		#print($pars.process_material.get("direction"))
#		var is_moving = Input.is_action_pressed("move_up") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_down") or Input.is_action_pressed("move_left")
#		if not is_moving:
#			$AnimationTree.get("parameters/playback").travel("Idle")
#		else:
#			$AnimationTree.get("parameters/playback").travel("Walk")
#			$AnimationTree.set("parameters/Idle/blend_position", get_global_mouse_position())
#			$AnimationTree.set("parameters/Walk/blend_position", get_global_mouse_position())


