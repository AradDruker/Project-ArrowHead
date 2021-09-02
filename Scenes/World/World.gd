extends Node

export (PackedScene) var Enemy

func _ready():
	randomize()

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
		var size = get_viewport().size
		var x_pos = randi() % int(size.x) + 30
		var y_pos = randi() % int(size.y) + 30
		x_pos = clamp(x_pos, 30, size.x)
		y_pos = clamp(y_pos, 30, size.y)
		enemy.position.x = x_pos
		enemy.position.y = y_pos
		$Enemies.add_child(enemy)
		
		
func _on_EnemySpawn_timeout():
	for _i in range(randi() % 5 + 2):
		var enemy = Enemy.instance()
		var size = get_viewport().size
		var x_pos = randi() % int(size.x) + 30
		var y_pos = randi() % int(size.y) + 30
		x_pos = clamp(x_pos, 30, size.x)
		y_pos = clamp(y_pos, 30, size.y)
		enemy.position.x = x_pos
		enemy.position.y = y_pos
		$Enemies.add_child(enemy)
	
	
	
	
	
	
	
	
