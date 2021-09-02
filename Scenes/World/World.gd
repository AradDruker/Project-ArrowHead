extends Node

export (PackedScene) var Enemy

func _ready():
	randomize()

func calc_position(ratio):
	# Get the number of slice to slice the screen
	# Exmaple: Input 3 returns a random place within the 1/3 to 2/3 of the border
	# Generates a random position within 1/3 to 2/3 of the screen
	randomize()
	var size = get_viewport().size
	var x_pos = randi() % int(size.x)
	var y_pos = randi() % int(size.y)
	x_pos = clamp(x_pos, 100, size.x - 100)
	y_pos = clamp(y_pos, 100, size.y - 100)
	
	return [x_pos, y_pos]

func _physics_process(_delta):
	var enemies = $Enemies.get_children()
	for en in enemies:
		if en:
			en.player_details($PlayerKinematicBody2D.position)
	
	
#First spawn before the spawn intervals.
func _on_EnemySpawnInstant_timeout():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var my_random_number = rng.randf_range(4,5)
	for _i in my_random_number:
		var enemy = Enemy.instance()
		var enemy_pos = calc_position(0.5)
		enemy.position.x = enemy_pos[0]
		enemy.position.y = enemy_pos[1]
		$Enemies.add_child(enemy)
		
		
func _on_EnemySpawn_timeout():
	for _i in range(randi() % 5 + 2):
		var enemy = Enemy.instance()
		var enemy_position = calc_position(0.5)
		enemy.position.x = enemy_position[0]
		enemy.position.y = enemy_position[1]
		$Enemies.add_child(enemy)
	
	
	
	
	
	
