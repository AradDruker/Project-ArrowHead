extends CanvasLayer

signal pause_pressed
signal CountDownStop

func _on_PauseButton_button_down():
	Music.get_node("ButtonPress").play()
	emit_signal("pause_pressed")


func _on_AnimationPlayer_animation_finished(_show_Continue):
	emit_signal("CountDownStop")
	get_tree().paused = false
