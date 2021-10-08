extends Node


export (PackedScene) var Player
export (PackedScene) var Enemy
export (PackedScene) var Coin


var messages = ["The Arrowhead will follow your finger", "Lets try!"]
var stage = 1
var kinetics = []
var enemy_start_pos = Vector2(300, 300)
var enemy

func _ready():
	$Dialog.text = messages.pop_front()
	$Dialog.visible_characters = 0
	$PlayerKinematicBody2D.set_process_input(false)
	$PlayerKinematicBody2D.hide()
	$TypingTimer.start()
	
	
	
	$PlayerKinematicBody2D/CollisionPolygon2D_1.set_deferred("disabled", false)
	$PlayerKinematicBody2D/CollisionPolygon2D_2.set_deferred("disabled", true)

func _process(delta):
	for enemy in $Enemies.get_children():
		enemy.player_details($PlayerKinematicBody2D.position)

func _on_Label_message_done():
	pass # Replace with function body.


func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if $Dialog.visible_characters == 0:
				$TypingTimer.start()
			elif $Dialog.visible_characters == len($Dialog.text):
				if not messages.empty():
					$Dialog.text = messages.pop_front()
					$Dialog.visible_characters = 0
				elif $Dialog.visible:
					$Dialog.hide()
					next_stage()
			else:
				$Dialog.visible_characters = len($Dialog.text)

func stop_movement(objects):
	for obj in objects:
		if is_instance_valid(obj):
			obj.set_physics_process(false)
func start_movement(objects):
	for obj in objects:
		if is_instance_valid(obj):
			obj.set_physics_process(true)

func next_stage():
	$PlayerKinematicBody2D.set_physics_process(true)
	
	if stage == 1:
#		Start of tutorial player shows up
		$PlayerKinematicBody2D.show()
		$PlayerKinematicBody2D.set_process_input(true)
		kinetics.append($PlayerKinematicBody2D)
		$PauseTime.start()
		stage += 1
	
	elif stage == 3:
#		Enemy tutorial
		enemy = create_enemy()
		enemy_start_pos = enemy.position
		kinetics.append(enemy)
		$Enemies.add_child(enemy)
		stage += 1
		$PauseTime.start()
	elif stage == 4:
#		Ememeis start chasing the player
		messages = ["Enemies will explode when lured into the walls",\
					"Consecutive explosions will grant you more points"]
		stop_movement(kinetics)
		$Dialog.show()
		$Dialog.visible_characters = 0
		$Dialog.text = messages.pop_front()
		stage += 1
	
	elif stage == 5:
#		Enemy starts chasing the player
		start_movement(kinetics)
		stage += 1
	
	elif stage == 6:
		var coin = create_coin()
		$Coins.add_child(coin)
		messages = ["Coins will spawn as you progress through the game",\
		"You collect them by passing your ship through them",\
		"Coins are used to buy skins and shields"]
		stop_movement(kinetics)
		$Dialog.show()
		$Dialog.visible_characters = 0
		$Dialog.text = messages.pop_front()
		stage += 1


func _on_PauseTime_timeout():
	if stage == 2:
#		Enemies spawns
		messages = ["Enemies will spawn randomly around the map",\
		"After 4 seconds they will start to chase you",\
		"If they get you, you lose"]
		$PlayerKinematicBody2D.set_physics_process(false)
		$Dialog.show()
		$Dialog.visible_characters = 0
		$Dialog.text = messages.pop_front()
		stage += 1
	if stage == 4:
#		Ememeis start chasing the player
		messages = ["Enemies will explode when lured into the walls",\
					"Consecutive explosions will grant you more points"]
		stop_movement(kinetics)
		$Dialog.show()
		$Dialog.visible_characters = 0
		$Dialog.text = messages.pop_front()
		stage += 1
		
		
func _explode():
	yield(get_tree().create_timer(2.0), "timeout")
	stage = 6
	next_stage()



func create_enemy():
#	Generate a single enemy at random location
	randomize()
	var size = get_viewport().size
	var x_pos = randi() % int(size.x)
	var y_pos = randi() % int(size.y)
	x_pos = clamp(x_pos, 100, size.x - 100)
	y_pos = clamp(y_pos, 100, size.y - 100)
	var enemy = Enemy.instance()
	enemy.connect("exploded", self, "_explode" )
	enemy.position.x = x_pos
	enemy.position.y = y_pos
	return enemy

func create_coin():
#	Creates a single coin at random place
	var coin = Coin.instance()
	randomize()
	var size = get_viewport().size
	var x_pos = randi() % int(size.x)
	var y_pos = randi() % int(size.y)
	x_pos = clamp(x_pos, 100, size.x - 100)
	y_pos = clamp(y_pos, 100, size.y - 100)
	coin.position.x = x_pos
	coin.position.y = y_pos
	return coin



func _on_PlayerKinematicBody2D_game_over():
	$PlayerKinematicBody2D.position = Vector2(640.0, 360.0)
	enemy.position = enemy_start_pos
	messages = ["Lets try again!"]
	$Dialog.show()
	$Dialog.visible_characters = 0
	$Dialog.text = messages.pop_front()
	stop_movement(kinetics)
	stage = 4
	
