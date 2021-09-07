extends CanvasLayer

signal Continue
signal ResetGame
signal Return


func _on_Continue_pressed():
	Music.get_node("ButtonPress").play()
	emit_signal("Continue")


func _on_RestartButton_pressed():
	Music.get_node("ButtonPress").play()
	emit_signal("ResetGame")


func _on_MainMenu_pressed():
	Music.get_node("ButtonPress").play()
	emit_signal("Return")
