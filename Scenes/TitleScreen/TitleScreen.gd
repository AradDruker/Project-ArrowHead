extends Control

#onready var PlayServices = get_node("res://Integrations/GooglePlay.gd")

var highScore = 0
var muteMusic_state
var muteSFX_state
var skin_1; var skin_2;
var skin_1_use; var skin_2_use;
var coin_total
var save_path = "user://data.save"


func _ready():
	get_tree().paused = false
	load_file()
	$Menu/HighScore.text = "Highscore: " + str(int(highScore))

	for button in $Menu/CenterRow/Buttons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])




func load_file():
	var file = File.new()
	if file.file_exists(save_path):
		file.open_encrypted_with_pass(save_path, File.READ, "Porfpo12")
		highScore = file.get_var()
		muteMusic_state = file.get_var()
		muteSFX_state = file.get_var()
		coin_total = file.get_var()
		skin_1 = file.get_var()
		skin_1_use = file.get_var()
		skin_2 = file.get_var()
		skin_2_use = file.get_var()
		file.close()


func _on_Button_pressed(scene_to_load):
	Music.get_node("ButtonPress").play()
# warning-ignore:return_value_discarded
# warning-ignore:return_value_discarded
	get_tree().change_scene(scene_to_load)
