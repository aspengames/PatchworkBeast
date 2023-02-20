extends CanvasLayer


const CHAR_READ_RATE = 0.05
var speed = 100

onready var textbox_container = $TextboxContainer
onready var start_symbol = $TextboxContainer/MarginContainer/HBoxContainer/Start
onready var end_symbol = $TextboxContainer/MarginContainer/HBoxContainer/End
onready var label = $TextboxContainer/MarginContainer/HBoxContainer/Label

enum State {
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue = []
var all_finished = false

onready var player = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	#print("Starting in READY")
	all_finished = true
	hide_textbox() # Replace with function body.
	#queue_text("Hey dude")
	#pass
	
func _process(delta):
	match current_state:
		State.READY:
			if !text_queue.empty():
				speed = 0
				display_text()
		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				label.percent_visible = 1.0
				$Tween.stop_all()
				end_symbol.text = "v"
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				change_state(State.READY)
				if text_queue.empty():
					all_finished = true
					#print("ALL FINISHED")
				hide_textbox()

func queue_text(next_text):
	text_queue.push_back(next_text)
	
	
func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	if all_finished == true:
		textbox_container.hide()
		$Textbox.hide()
		$TalkNPC.hide()
		$Overlay.hide()
		speed = 160
	
func show_textbox():
	all_finished = false
	start_symbol.text = "*"
	textbox_container.show()
	$Textbox.show()
	$TalkNPC.show()
	$Overlay.show()
	
func display_text():
	var next_text = text_queue.pop_front()
	label.text = next_text
	label.percent_visible = 0.0
	change_state(State.READING)
	show_textbox()
	$Tween.interpolate_property(label, "percent_visible", 0.0, 1.0, len(next_text) * CHAR_READ_RATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Tween_tween_all_completed():
	end_symbol.text = "v"
	change_state(State.FINISHED)

func change_state(next_state):
	current_state = next_state
	#match current_state:
	#	State.READY:
	#		print("changing to READY")
	#	State.READING:
	#		print("changing to READING")
	#	State.FINISHED:
	#		print("changing to FINISHED")
			
