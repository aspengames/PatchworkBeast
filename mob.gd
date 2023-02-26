extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var player = $"../Player"
var dist = 999999
var alive = true
var trulydead = false

var health = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_dir = self.global_position.direction_to(player.get_global_position())
	#print(player_dir)
	
	var mob_rot = player_dir.angle()
	#print(mob_rot)
	#print(PI)
	if -PI/4 < mob_rot:
		if mob_rot < PI/4:
			$anim.play("mob_right")
	if PI/4 < mob_rot:
		if mob_rot < 3*PI/4:
			$anim.play("mob_down")
	if -PI < mob_rot:
		if mob_rot < -3*PI/4:
			$anim.play("mob_left")
	if 3*PI/4 < mob_rot:
		if mob_rot < PI:
			$anim.play("mob_left")
	if -3*PI/4 < mob_rot:
		if mob_rot < -PI/4:
			$anim.play("mob_up")

	#print(globals.mobsight)
	#print(self.global_position.distance_to(player.get_global_position()))
	if (self.global_position.distance_to(player.get_global_position()) < 1000) and (self.global_position.distance_to(player.get_global_position()) > 100) and not trulydead:
		#self.global_position += player_dir
		self.move_and_slide(player_dir * 500)
		if not $anim.is_playing():
			$anim.play()
	else:
		$anim.stop()
		
	if health < 1 and alive:
		alive = false
		$deadanim.play("dead")
		$col.disabled = true
		
	if trulydead and $pars.emitting == false:
		$deathTimer.start()
		

#func _init(enemy, params):
#  enemy.dir = (enemy.target.position - enemy.position).normalized()
#
#func _physics_process(delta):
#  var motion = enemy.dir * enemy.speed
#  enemy.move_and_slide(motion)

func _on_deadanim_animation_finished(anim_name):
	trulydead = true

func _on_vis_screen_entered():
	globals.mobsight = true
func _on_vis_screen_exited():
	globals.mobsight = false


func _on_deathTimer_timeout():
	queue_free()
