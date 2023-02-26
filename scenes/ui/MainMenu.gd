extends CanvasLayer


onready var p1 = $Menu/HBoxContainer/Pointer/selector1
onready var p2 = $Menu/HBoxContainer/Pointer/selector2
onready var p3 = $Menu/HBoxContainer/Pointer/selector3

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if globals.debug:
		_on_PLAY_pressed()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PLAY_pressed():
	#get_tree().change_scene("res://scenes/world/Level.tscn")
	self.visible = false


func _on_QUIT_pressed():
	get_tree().quit()


func _on_PLAY_mouse_entered():
	p1.modulate = Color(1,1,1,1)
	p2.modulate = Color(1,1,1,0)
	p3.modulate = Color(1,1,1,0)

func _on_OPTIONS_mouse_entered():
	p2.modulate = Color(1,1,1,1)
	p1.modulate = Color(1,1,1,0)
	p3.modulate = Color(1,1,1,0)
	
func _on_QUIT_mouse_entered():
	p3.modulate = Color(1,1,1,1)
	p1.modulate = Color(1,1,1,0)
	p2.modulate = Color(1,1,1,0)
	
func _on_PLAY_focus_entered():
	_on_PLAY_mouse_entered()
	
func _on_OPTIONS_focus_entered():
	_on_OPTIONS_mouse_entered()

func _on_QUIT_focus_entered():
	_on_QUIT_mouse_entered()
