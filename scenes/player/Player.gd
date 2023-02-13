extends KinematicBody2D

#export(PackedScene) var NIFT: PackedScene = preload("res://scemes/projectiles/Nift.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var atkTimer = $atkTimer

export(int) var speed = 80.0
onready var cam = $Camera2D
var on_stairs = false
var direction = "down"
var ground = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		direction = "right"
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		direction = "left"
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		direction = "down"
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		direction = "up"
	velocity = velocity.normalized()
	if velocity == Vector2.ZERO:
		$AnimationTree.get("parameters/playback").travel("Idle")
	else:
		if speed == 0:
			$AnimationTree.get("parameters/playback").travel("Idle")
		else:
			$AnimationTree.get("parameters/playback").travel("Walk")
			$AnimationTree.set("parameters/Idle/blend_position", velocity)
			$AnimationTree.set("parameters/Walk/blend_position", velocity)
			#SFX footsteps
			
		if on_stairs:
			#$AnimationPlayer.playback_speed = 0.5
			#print($AnimationPlayer.playback_speed)
			velocity.y /= 2
			velocity.x *= .75
		#else:
		#	$AnimationPlayer.playback_speed = 1
		move_and_slide(velocity * speed)
		#print(direction)
#	if Input.is_action_just_pressed("action_attack") and atkTimer.is_stopped():
#		var nift_direction = self.global_position.direction_to(get_global_mouse_position())
#		throw_nift(nift_direction)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#func throw_nift(nift_direction: Vector2):
#	if NIFT:
#		var nift = NIFT.instance()
#		get_tree().current_scene.add_child(nift)
#		nift.global_position = self.global_position
#		
#		var nift_rotation = nift_direction.angle()
#		nift.rotation = nift_rotation
#		
#		atkTimer.start()
		
