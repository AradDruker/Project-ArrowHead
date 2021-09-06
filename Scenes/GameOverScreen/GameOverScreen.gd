extends CanvasLayer

signal ResetGame
signal Return

func _on_MainMenu_pressed():
# warning-ignore:return_value_discarded
	emit_signal("Return")


func _on_RestartButton_pressed():
	emit_signal("ResetGame")

