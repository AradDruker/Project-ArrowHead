extends Node

export (PackedScene) var Enemy

var skin_1_sprite = preload("res://Assets/Characters/Player.png")
var skin_2_sprite = preload("res://Assets/Characters/spaceRockets_002.png")

var level = 1
var score = 0
var highScore = 0
var coin_total
var save_path = "user://data.save"
var highscore_been_called = false
var muteMusic_state
var muteSFX_state
var skin_1; var skin_2;
var skin_1_use; var skin_2_use;
var coinRand = 0
var lastCoinScore = 500
var coinSprite = preload("res://Scenes/Coin/Coin.tscn")

var player_pos

var rng = RandomNumberGenerator.new()



func _ready():
	randomize()
	load_file()
	#Sets mouse position to the center of the screen at game start
# warning-ignore:unused_variable
	var screen_size = get_viewport().size
# warning-ignore:shadowed_variable
	var start_pos = Vector2(640.0, 360.0)
	get_viewport().warp_mouse(start_pos)
	
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
	### Signals for Skins
# warning-ignore:return_value_discarded
	$Shop.connect("s_skin_1", self, "Current_Skin")
# warning-ignore:return_value_discarded
	$Shop.connect("s_skin_2", self, "Current_Skin")
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
#	if score >= lastCoinScore + coinRand * 100:
#		var coinChoices = [3, 5, 7]
#		var coin_instance = create_coin()
#		$Coins.add_child(coin_instance)
#		lastCoinScore = score
#		coinRand = coinChoices[randi() % coinChoices.size()]
	
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
	$PausedMenu/Popup/Menu/Coins.text = "Total Coins: " + str(coin_total)
	$GameOverScreen/Popup/Menu/Coins.text = "Total Coins: " + str(coin_total)
	




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
	rng.randomize()
	var my_random_number = rng.randf_range(2,3)
	for _i in my_random_number:
		var enemy = create_enemy()
		$Enemies.add_child(enemy)



func _on_EnemySpawn_timeout():
	rng.randomize()
	if score >= 0 and score <= 5000:
		var my_random_number = rng.randf_range(2,3)
		for _i in my_random_number:
			var enemy = create_enemy()
			$Enemies.add_child(enemy)
	if score > 5000 and score <= 10000:
		var my_random_number = rng.randf_range(3,4)
		for _i in my_random_number:
			var enemy = create_enemy()
			$Enemies.add_child(enemy)
	if score > 10000 and score <= 15000:
		var my_random_number = rng.randf_range(4,5)
		for _i in my_random_number:
			var enemy = create_enemy()
			$Enemies.add_child(enemy)
	if score > 15000 and score <= 20000:
		var my_random_number = rng.randf_range(5,6)
		for _i in my_random_number:
			var enemy = create_enemy()
			$Enemies.add_child(enemy)
	if score > 20000 and score <= 25000:
		var my_random_number = rng.randf_range(6,7)
		for _i in my_random_number:
			var enemy = create_enemy()
			$Enemies.add_child(enemy)
	if score > 25000:
		var my_random_number = rng.randf_range(7,8)
		for _i in my_random_number:
			var enemy = create_enemy()
			$Enemies.add_child(enemy)


func reset_game():
	# Reset the game method
	# Need to reset the score
	
	$LevelUp.stop()
	$EnemySpawn.stop()
	$EnemySpawnInstant.stop()
	$PlayerKinematicBody2D.position = Vector2(640.0, 360.0)
	var enemies = $Enemies.get_children()
	var coins = $Coins.get_children()
	score = 0
	for enemy in enemies:
		enemy.queue_free()
	for coin in coins:
		coin.queue_free()
	
	###
	
	$LevelUp.start()
	$EnemySpawn.start()
	$EnemySpawnInstant.start()
	$PausedMenu/Popup.hide()
	$PausedMenu/Background.hide()
	$GameOverScreen/Popup.hide()
	$HUD/ScoreBox.show()
	$HUD/PauseButton.show()
	
	level = 1
	Music.get_node("BackgoundMusic").pitch_scale = 1
	$Background.modulate = Color(2.31,1.77,0)
	$Borders.modulate = Color(2.5,0,0)
	
	# warning-ignore:shadowed_variable
	var screen_size = get_viewport().size
# warning-ignore:shadowed_variable
	var screen_mid = Vector2(screen_size.x / 2, screen_size.y / 2)
	get_viewport().warp_mouse(screen_mid)
	get_tree().paused = false
	

func create_coin():
	var coin = coinSprite.instance()
# warning-ignore:return_value_discarded
	randomize()
	var size = get_viewport().size
	var x_pos = randi() % int(size.x)
	var y_pos = randi() % int(size.y)
	x_pos = clamp(x_pos, 100, size.x - 100)
	y_pos = clamp(y_pos, 100, size.y - 100)
	coin.position.x = x_pos
	coin.position.y = y_pos
	return coin


func _on_CoinSpawn_timeout():
	if score >= lastCoinScore + coinRand * 100:
		var coinChoices = [3, 5, 7]
		var coin_instance = create_coin()
		$Coins.add_child(coin_instance)
		lastCoinScore = score
		coinRand = coinChoices[randi() % coinChoices.size()]


func _on_PlayerKinematicBody2D_coin_collected():
	coin_total += 1
	save(coin_total)


func _add_score():
	$BonusPointsTimer.start()
	score += Global.bonus_points
	Global.bonus_points += 50


func _game_over():
	Music.get_node("PlayerDeath").play()
	$PausedMenu/Background.show()
	$GameOverScreen/Popup.show()
	$HUD/ScoreBox.hide()
	$HUD/PauseButton.hide()
	Music.get_node("BackgoundMusic").pitch_scale = 1
	get_tree().paused = true


func _return_title():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/TitleScreen/TitleScreen.tscn")
	Music.get_node("BackgoundMusic").pitch_scale = 1


func _paused_menu_pop():
	$PausedMenu/Popup.show()
	$PausedMenu/Background.show()
	player_pos = get_viewport().get_mouse_position()
	get_tree().paused = true


func _paused_menu_pop_close():
	$PausedMenu/Popup.hide()
	$PausedMenu/Background.hide()
	
	get_viewport().warp_mouse(player_pos)
	get_tree().paused = false
	

func Current_Skin():
	if skin_1_use == 1:
		$PlayerKinematicBody2D/PlayerSprite.set_texture(skin_1_sprite)
		$PlayerKinematicBody2D/PlayerSprite.scale = Vector2(1,1.2)
	elif skin_2_use ==1:
		$PlayerKinematicBody2D/PlayerSprite.set_texture(skin_2_sprite)
		$PlayerKinematicBody2D/PlayerSprite.scale = Vector2(0.30,0.20)


func save(_world):
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



func _on_BonusPointsTimer_timeout():
	Global.bonus_points = 100


func _on_LevelUp_timeout():
	if level == 1:
		level += 1
		Music.get_node("BackgoundMusic").pitch_scale = 1.02
		$AnimationPlayer.play("Background_change")
		Music.get_node("LevelUp").play()
		$Background.modulate = Color(1,1,1)
		$Borders.modulate = Color(1,1,1)
	elif level == 2:
		level += 1
		Music.get_node("BackgoundMusic").pitch_scale = 1.04
		$AnimationPlayer.play("Background_change")
		$Background.modulate = Color(2,1.5,2)
		$Borders.modulate = Color(2,1.5,2)
		Music.get_node("LevelUp").play()
	elif level == 3:
		level += 1
		Music.get_node("BackgoundMusic").pitch_scale = 1.06
		$AnimationPlayer.play("Background_change")
		$Background.modulate = Color(0.5,5,0.5)
		$Borders.modulate = Color(1,1,0.5)
		Music.get_node("LevelUp").play()
	elif level == 4:
		level += 1
		Music.get_node("BackgoundMusic").pitch_scale = 1.08
		$AnimationPlayer.play("Background_change")
		$Background.modulate = Color(5,1.5,1)
		$Borders.modulate = Color(5,1.5,1)
		Music.get_node("LevelUp").play()
	elif level == 5:
		level += 1
		Music.get_node("BackgoundMusic").pitch_scale = 1.1
		$AnimationPlayer.play("Background_change")
		$Background.modulate = Color(0,0,1)
		$Borders.modulate = Color(0,0,1)
		Music.get_node("LevelUp").play()
	elif level == 6:
		level += 1
		Music.get_node("BackgoundMusic").pitch_scale = 1.12
		$AnimationPlayer.play("Background_change")
		$Background.modulate = Color(0.58,0.64,0)
		$Borders.modulate = Color(2.31,1.77,0)
		Music.get_node("LevelUp").play()
	elif level == 7:
		level += 1
		Music.get_node("BackgoundMusic").pitch_scale = 1.14
		$AnimationPlayer.play("Background_change")
		$Background.modulate = Color(0,1,0)
		$Borders.modulate = Color(0,1,0)
		Music.get_node("LevelUp").play()
	elif level == 8:
		level += 1
		Music.get_node("BackgoundMusic").pitch_scale = 1.14
		$AnimationPlayer.play("Background_change")
		$AnimationPlayer2.play("last_level")
		Music.get_node("LevelUp").play()


func _on_AnimationPlayer_animation_finished(_Background_change):
	$HUD/AnimationPlayer.play("show_LevelUp")
