extends Node


export (PackedScene) var Player
export (PackedScene) var Enemy


var messages = ["The Arrowhead will follow your finger", "Lets try!"]
var stage = 1
var kinetics = []

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
				else:
					$Dialog.hide()
					next_stage()
			else:
				$Dialog.visible_characters = len($Dialog.text)

func stop_movement(objects):
	for obj in objects:
		obj.set_physics_process(false)
func start_movement(objects):
	for obj in objects:
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
	
	if stage == 3:
#		Enemy tutorial
		var enemy = create_enemy()
		kinetics.append(enemy)
		$Enemies.add_child(enemy)
		stage += 1
		$PauseTime.start()
	
	if stage == 5:
#		Enemy starts chasing the player
		start_movement(kinetics)
		stage += 1
	
	


func _on_PauseTime_timeout():
	if stage == 2:
#		Enemies spawns
		messages = ["Enemies will spawn randomly around the map"]
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
		
		
func create_enemy():
#	Generate a single enemy at random location
	randomize()
	var size = get_viewport().size
	var x_pos = randi() % int(size.x)
	var y_pos = randi() % int(size.y)
	x_pos = clamp(x_pos, 100, size.x - 100)
	y_pos = clamp(y_pos, 100, size.y - 100)
	var enemy = Enemy.instance()
	enemy.position.x = x_pos
	enemy.position.y = y_pos
	return enemy
