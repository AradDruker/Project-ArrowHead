extends Control

var highScore
var muteMusic_state
var muteSFX_state
var coin_total = int(0)
var save_path = "user://data.save"

func _ready():
	load_file()

	$CoinNumber.text = "Coins: " + str(coin_total)
	
	
func _process(_delta):
	pass

func load_file():
	var file = File.new()
	if file.file_exists(save_path):
		file.open_encrypted_with_pass(save_path, File.READ, "Porfpo12")
		highScore = file.get_var()
		muteMusic_state = file.get_var()
		muteSFX_state = file.get_var()
		coin_total = file.get_var()
		file.close()


func _on_BackButton_pressed():
	Music.get_node("ButtonPress").play()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/TitleScreen/TitleScreen.tscn")
	
