extends Control

var highScore = 0
var save_path = "user://data.save"


func _ready():
	get_tree().paused = false
	load_file()
	$Menu/HighScore.text = "Highscore: " + str(int(highScore))




func load_file():
	var file = File.new()
	if file.file_exists(save_path):
		file.open_encrypted_with_pass(save_path, File.READ, "Porfpo12")
		highScore = file.get_var()
		file.close()
		print ("highscore loaded from file:")
		print (int(highScore))
		print ("\n")



func _on_LeaderboardsButton_pressed():
	Music.get_node("ButtonPress").play()


func _on_OptionsButton_pressed():
	Music.get_node("ButtonPress").play()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Options/Options.tscn")


func _on_NewGameButton_pressed():
	Music.get_node("ButtonPress").play()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/World/World.tscn")
