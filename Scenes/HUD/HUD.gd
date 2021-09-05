extends CanvasLayer

signal ResetGame

func _on_ResetButton_pressed():
	emit_signal("ResetGame")
