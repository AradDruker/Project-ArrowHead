extends Node

var savegame = File.new() #file
var save_path = "user://data.save" #place of the file
var highScore = 0


func _ready():
	if not savegame.file_exists(save_path):
		create_save()


func create_save():
   savegame.open_encrypted_with_pass(save_path, File.WRITE, "Porfpo12")
   savegame.store_var(highScore)
   savegame.close()


#func save(high_score):    
#   save_data["highscore"] = high_score #data to save
#   savegame.open(save_path, File.WRITE) #open file to write
#   savegame.store_var(save_data) #store the data
#   savegame.close() # close the file
#
#
#func read_savegame():
#   savegame.open(save_path, File.READ) #open the file
#   save_data = savegame.get_var() #get the value
#   savegame.close() #close the file
#   return save_data["highscore"] #return the value
