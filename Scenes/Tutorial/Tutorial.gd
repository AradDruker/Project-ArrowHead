extends Node


export (PackedScene) var Player


var messages = ["The Arrowhead will follow your finger", "Lets try!"]
var stage = 0

func _ready():
	$Dialog.text = messages.pop_front()
	$Dialog.visible_characters = 0
	$PlayerKinematicBody2D.set_process_input(false)
	$PlayerKinematicBody2D.hide()
	$TypingTimer.start()


func _on_Label_message_done():
	pass # Replace with function body.


func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if $Dialog.visible_characters == 0:
				$TypingTimer.start()
			elif $Dialog.visible_characters == len($Dialog.text):
				if not messages.empty():
					$Dialog.text = messages.pop_front()
					$Dialog.visible_characters = 0
				else:
					$Dialog.hide()
					next_stage()
			else:
				$Dialog.visible_characters = len($Dialog.text)


func next_stage():
	$PlayerKinematicBody2D.set_physics_process(true)
	if stage == 0:
		$PlayerKinematicBody2D.show()
		$PlayerKinematicBody2D.set_process_input(true)
		$PauseTime.start()
		stage += 1
	
	


func _on_PauseTime_timeout():
	if stage == 1:
		messages = ["Enemies will spawn randomly around the map",\
		"after 4 seconds they will start following you"]
		$PlayerKinematicBody2D.set_physics_process(false)
		$Dialog.show()
		$Dialog.text = messages.pop_front()
