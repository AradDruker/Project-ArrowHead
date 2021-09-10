extends Control

func _on_Button_pressed():
	Music.get_node("ButtonPress").play()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/TitleScreen/TitleScreen.tscn")
