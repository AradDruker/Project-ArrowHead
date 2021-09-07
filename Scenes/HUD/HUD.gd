extends CanvasLayer

signal pause_pressed

func _on_PauseButton_pressed():
	Music.get_node("ButtonPress").play()
	emit_signal("pause_pressed")
