extends CanvasLayer

signal ResetGame
signal Return

func _on_MainMenu_pressed():
	Music.get_node("ButtonPress").play()
# warning-ignore:return_value_discarded
	emit_signal("Return")


func _on_RestartButton_pressed():
	Music.get_node("ButtonPress").play()
	emit_signal("ResetGame")

