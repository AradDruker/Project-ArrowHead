extends Node

var savegame = File.new() #file
var save_path = "user://data.save" #place of the file
var highScore = int(0)
var muteMusic_state = int(1)
var muteSFX_state = int(1)
var coin_total = int(1000)
var skin_1 = int(0); var skin_2 = int(0);
var skin_1_use = int(0); var skin_2_use = int(0);
var bonus_points = 100


func _ready():
	if not savegame.file_exists(save_path):
		create_save()

	load_file()
	


	if muteMusic_state == 0:
		AudioServer.set_bus_mute(2, not AudioServer.is_bus_mute(2))
		
	if muteSFX_state == 0:
		AudioServer.set_bus_mute(1, not AudioServer.is_bus_mute(1))


func create_save():
	savegame.open_encrypted_with_pass(save_path, File.WRITE, "Porfpo12")
	savegame.store_var(highScore)
	savegame.store_var(muteMusic_state)
	savegame.store_var(muteSFX_state)
	savegame.store_var(coin_total)
	savegame.store_var(skin_1)
	savegame.store_var(skin_1_use)
	savegame.store_var(skin_2)
	savegame.store_var(skin_2_use)
	savegame.close()



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

func save(_global):
	var file = File.new()
	file.open_encrypted_with_pass(save_path, File.WRITE, "Porfpo12")
	file.store_var(highScore)
	file.store_var(muteMusic_state)
	file.store_var(muteSFX_state)
	file.store_var(coin_total)
	file.store_var(skin_1)
	file.store_var(skin_1_use)
	file.store_var(skin_2)
	file.store_var(skin_2_use)
	file.close()
