extends Node

export (PackedScene) var Enemy

var score = 0
var highScore = 0
var coin_total = 0
var save_path = "user://data.save"
var highscore_been_called = false
var muteMusic_state
var muteSFX_state
var coinRand = 0
var lastCoinScore = 500
var coinSprite = preload("res://Scenes/Coin/Coin.tscn")

var rng = RandomNumberGenerator.new()



func _ready():
	randomize()
	load_file()
	### Signals for buttons
# warning-ignore:return_value_discarded
	$HUD.connect("pause_pressed", self,"_paused_menu_pop")
# warning-ignore:return_value_discarded
	$PausedMenu.connect("Continue", self, "_paused_menu_pop_close")
# warning-ignore:return_value_discarded
	$PausedMenu.connect("ResetGame", self, "reset_game")
# warning-ignore:return_value_discarded
	$GameOverScreen.connect("ResetGame", self, "reset_game")
# warning-ignore:return_value_discarded
	$PausedMenu.connect("Return", self, "_return_title")
# warning-ignore:return_value_discarded
	$GameOverScreen.connect("Return", self, "_return_title")
# warning-ignore:return_value_discarded
	$PlayerKinematicBody2D.connect("game_over", self, "_game_over")
	###

	
func _physics_process(delta):
	var enemies = $Enemies.get_children()
	
	#Increse score every second
	score += delta * 30
	if highScore < score:
		highScore = score
		save(highScore)
		if !highscore_been_called:
			$HUD/AnimationPlayer.play("show_HighScore")
			highscore_been_called = true
	if score >= lastCoinScore + coinRand * 100:
		var coinChoices = [3, 5, 7]
		var coin_instance = create_coin()
		$Coins.add_child(coin_instance)
		lastCoinScore = score
		coinRand = coinChoices[randi() % coinChoices.size()]
	
	for en in enemies:
		if en:
			en.player_details($PlayerKinematicBody2D.position)



func _process(_delta):
	
	# Lets you exit the game with the escape key - Mainly for debugging comfort
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	#Score UI
	$HUD/ScoreBox/HBoxContainer/Score.text = str(int(score))
	$GameOverScreen/Popup/Menu/Score.text = "Score: " + str(int(score))
	#Coins UI
	$PausedMenu/Popup/Menu/Coins.text = "Total Coins: " + str(int(coin_total))
	$GameOverScreen/Popup/Menu/Coins.text = "Total Coins: " + str(int(coin_total))



func create_enemy():
	# Get the number of slice to slice the screen
	# Exmaple: Input 3 returns a random place within the 1/3 to 2/3 of the border
	# Generates a random position within 1/3 to 2/3 of the screen
	randomize()
	var size = get_viewport().size
	var x_pos = randi() % int(size.x)
	var y_pos = randi() % int(size.y)
	x_pos = clamp(x_pos, 100, size.x - 100)
	y_pos = clamp(y_pos, 100, size.y - 100)
	var enemy = Enemy.instance()
	enemy.connect("exploded", self, "_add_score" )
	enemy.position.x = x_pos
	enemy.position.y = y_pos
	return enemy
	
	
#First spawn before the spawn intervals.
func _on_EnemySpawnInstant_timeout():
#	rng.randomize()
#	var my_random_number = rng.randf_range(4,6)
#	for _i in my_random_number:
#		var enemy = create_enemy()
#		$Enemies.add_child(enemy)
	pass
		
		
		
func _on_EnemySpawn_timeout():
#	for _i in range(randi() % 5 + 3):
#		var enemy = create_enemy()
#		$Enemies.add_child(enemy)
	pass


func reset_game():
	# Reset the game method
	# Need to reset the score
	
	$EnemySpawn.stop()
	$EnemySpawnInstant.stop()
	$PlayerKinematicBody2D.position = Vector2(640.0, 360.0)
	var enemies = $Enemies.get_children()
	score = 0
	for enemy in enemies:
		enemy.queue_free()
	
	###
	$EnemySpawn.start()
	$EnemySpawnInstant.start()
	$PausedMenu/Popup.hide()
	$PausedMenu/Background.hide()
	$GameOverScreen/Popup.hide()
	$HUD/ScoreBox.show()
	$HUD/Reset/HBoxContainer/PauseButton.show()
	get_tree().paused = false
	

func create_coin():
	var coin = coinSprite.instance()
	coin.connect("coin_collected", self, "_add_coin")
	randomize()
	var size = get_viewport().size
	var x_pos = randi() % int(size.x)
	var y_pos = randi() % int(size.y)
	x_pos = clamp(x_pos, 100, size.x - 100)
	y_pos = clamp(y_pos, 100, size.y - 100)
	coin.position.x = x_pos
	coin.position.y = y_pos
	return coin



func _add_score():
	score += 100

func _add_coin():
	#Add code here for what happens when player collects the coin
	# Play should add a coin to his coin_total
	pass

func _game_over():
	Music.get_node("PlayerDeath").play()
	$PausedMenu/Background.show()
	$GameOverScreen/Popup.show()
	$HUD/ScoreBox.hide()
	$HUD/Reset/HBoxContainer/PauseButton.hide()
	get_tree().paused = true


func _return_title():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/TitleScreen/TitleScreen.tscn")


func _paused_menu_pop():
	$PausedMenu/Popup.show()
	$PausedMenu/Background.show()
	get_tree().paused = true


func _paused_menu_pop_close():
	$PausedMenu/Popup.hide()
	$PausedMenu/Background.hide()
	get_tree().paused = false


func save(_high_score):
	var file = File.new()
	file.open_encrypted_with_pass(save_path, File.WRITE, "Porfpo12")
	file.store_var(highScore)
	file.store_var(muteMusic_state)
	file.store_var(muteSFX_state)
	file.store_var(coin_total)
	file.close()
	
	
func load_file():
	var file = File.new()
	if file.file_exists(save_path):
		file.open_encrypted_with_pass(save_path, File.READ, "Porfpo12")
		highScore = file.get_var()
		muteMusic_state = file.get_var()
		muteSFX_state = file.get_var()
		coin_total = file.get_var()
		file.close()
