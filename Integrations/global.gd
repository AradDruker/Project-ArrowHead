extends Node

var savegame = File.new() #file
var save_path = "user://data.save" #place of the file
var highScore = 0
var muteMusic_state = 1
var muteSFX_state = 1
var coins_collected = 0



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
	savegame.close()



func load_file():
	var file = File.new()
	if file.file_exists(save_path):
		file.open_encrypted_with_pass(save_path, File.READ, "Porfpo12")
		highScore = file.get_var()
		muteMusic_state = file.get_var()
		muteSFX_state = file.get_var()
		file.close()
