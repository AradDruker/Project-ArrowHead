extends Control


var scene_path_to_load

#Hovering color change
func _on_NewGameButton_mouse_entered():
	$Menu/CenterRow/Buttons/NewGameButton/Label.add_color_override("font_color", Color("#808080"))
func _on_NewGameButton_mouse_exited():
	$Menu/CenterRow/Buttons/NewGameButton/Label.add_color_override("font_color", Color("#FFFFFF"))
func _on_LeaderboardsButton_mouse_entered():
	$Menu/CenterRow/Buttons/LeaderboardsButton/Label.add_color_override("font_color", Color("#808080"))
func _on_LeaderboardsButton_mouse_exited():
	$Menu/CenterRow/Buttons/LeaderboardsButton/Label.add_color_override("font_color", Color("#FFFFFF"))
func _on_OptionsButton_mouse_entered():
	$Menu/CenterRow/Buttons/OptionsButton/Label.add_color_override("font_color", Color("#808080"))
func _on_OptionsButton_mouse_exited():
	$Menu/CenterRow/Buttons/OptionsButton/Label.add_color_override("font_color", Color("#FFFFFF"))

func _ready():
	for button in $Menu/CenterRow/Buttons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])
		
func _on_Button_pressed(scene_to_load):
	scene_path_to_load = scene_to_load
	$FadeIn.show()
	$FadeIn.fade_in()

func _on_FadeIn_fade_finished():
# warning-ignore:return_value_discarded
	get_tree().change_scene(scene_path_to_load)
