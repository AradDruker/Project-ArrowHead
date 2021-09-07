extends Control

var highScore = 0
var save_path = "user://data.save"


func _ready():
	get_tree().paused = false
	load_file()
	$Menu/HighScore.text = "Highscore: " + str(int(highScore))
	
	
	for button in $Menu/CenterRow/Buttons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])



func _on_Button_pressed(scene_to_load):
# warning-ignore:return_value_discarded
	get_tree().change_scene(scene_to_load)
	
	
func load_file():
	var file = File.new()
	if file.file_exists(save_path):
		file.open_encrypted_with_pass(save_path, File.READ, "Porfpo12")
		highScore = file.get_var()
		file.close()
		print ("highscore loaded from file:")
		print (int(highScore))
		print ("\n")
