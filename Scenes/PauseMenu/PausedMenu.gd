extends CanvasLayer

signal Continue
signal ResetGame
signal Return


func _on_Continue_pressed():
	emit_signal("Continue")


func _on_RestartButton_pressed():
	emit_signal("ResetGame")


func _on_MainMenu_pressed():
	emit_signal("Return")
