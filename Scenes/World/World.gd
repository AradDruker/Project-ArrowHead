extends Node

export (PackedScene) var Enemy

var score = 0

func _ready():
	randomize()

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

func _physics_process(delta):
	var enemies = $Enemies.get_children()
	
	#Increse score every second
	score += delta * 30
	
	#Score UI
	$HUD/ScoreBox/HBoxContainer/Score.text = str(int(score))
	$GameOverScreen/Popup/Menu/Details/Score.text = "Score: " + str(int(score))
	
	for en in enemies:
		if en:
			en.player_details($PlayerKinematicBody2D.position)
			
func _process(_delta):
	
	# Lets you exit the game with the escape key - Mainly for debugging comfort
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

#First spawn before the spawn intervals.
func _on_EnemySpawnInstant_timeout():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var my_random_number = rng.randf_range(4,6)
	for _i in my_random_number:
		var enemy = create_enemy()
		$Enemies.add_child(enemy)
		
		
func _on_EnemySpawn_timeout():
	for _i in range(randi() % 5 + 3):
		var enemy = create_enemy()
		$Enemies.add_child(enemy)
		
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
	

func _add_score():
	score += 100

func _game_over():
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
	
