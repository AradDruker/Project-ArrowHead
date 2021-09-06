extends CanvasLayer

signal pause_pressed

func _on_ResetButton_pressed():
	emit_signal("pause_pressed")
