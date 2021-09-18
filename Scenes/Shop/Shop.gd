extends Control

var highScore
var muteMusic_state
var muteSFX_state
var coin_total
var skin_1; var skin_2;
var skin_1_use; var skin_2_use;
var save_path = "user://data.save"


signal s_skin_1
signal s_skin_2

func _ready():
	load_file()
	
	$CoinNumber.text = "Coins: " + str(coin_total)

	if skin_1 == 1:
		$ScrollContainer/HBoxContainer/Skin_1/Skin_1_Button/Label1.text = "Owned"
		$ScrollContainer/HBoxContainer/Skin_1/Skin_1_Button/Label1.get("custom_fonts/font").set_size(35)

	if skin_2 == 1:
		$ScrollContainer/HBoxContainer/Skin_2/Skin_2_Button/Label2.text = "Owned"
		$ScrollContainer/HBoxContainer/Skin_2/Skin_2_Button/Label2.get("custom_fonts/font").set_size(35)



func _process(_delta):
	if skin_1_use == 1:
		$AnimationPlayer.play("Skin_1_Use")
		emit_signal("s_skin_1")


	if skin_2_use == 1:
		$AnimationPlayer.play("Skin_2_Use")
		emit_signal("s_skin_2")


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

func save(_shop):
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



func _on_BackButton_pressed():
	Music.get_node("ButtonPress").play()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/TitleScreen/TitleScreen.tscn")
	
	
func _on_Skin_1_Button_pressed():
	if skin_1 == 1:
		if $ScrollContainer/HBoxContainer/Skin_1/Skin_1_Button/Label1.text == "Owned":
			skin_1_use = 1
			skin_2_use = 0
			save(skin_1_use)
			save(skin_2_use)
		else:
			pass
	elif coin_total >= 100:
		$ScrollContainer/HBoxContainer/Skin_1/Skin_1_Button/Label1.text = "Owned"
		$ScrollContainer/HBoxContainer/Skin_1/Skin_1_Button/Label1.get("custom_fonts/font").set_size(35)
		coin_total = coin_total - 100
		skin_1 = 1
		skin_1_use = 1
		skin_2_use = 0
		save(coin_total)
		save(skin_1)
		save(skin_1_use)
		save(skin_2_use)
		$CoinNumber.text = "Coins: " + str(coin_total)


func _on_Skin_2_Button_pressed():
	if skin_2 == 1:
		if $ScrollContainer/HBoxContainer/Skin_2/Skin_2_Button/Label2.text == "Owned":
			skin_1_use = 0
			skin_2_use = 1
			save(skin_1_use)
			save(skin_2_use)
		else:
			pass
	elif coin_total >= 200:
		$ScrollContainer/HBoxContainer/Skin_2/Skin_2_Button/Label2.text = "Owned"
		$ScrollContainer/HBoxContainer/Skin_2/Skin_2_Button/Label2.get("custom_fonts/font").set_size(35)
		coin_total = coin_total - 200
		skin_2 = 1
		skin_1_use = 0
		skin_2_use = 1
		save(coin_total)
		save(skin_2)
		save(skin_1_use)
		save(skin_2_use)
		$CoinNumber.text = "Coins: " + str(coin_total)
