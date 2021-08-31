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
	var my_random_number = rng.randf_range(3,4)
	for _i in my_random_number:
		$EnemyPath/EnemySpawnLocation.offset = randi()
		var enemy = Enemy.instance()
		$Enemies.add_child(enemy)
		enemy.position = $EnemyPath/EnemySpawnLocation.position
		
	
func _on_EnemySpawn_timeout():
	for _i in range(randi() % 4):
		$EnemyPath/EnemySpawnLocation.offset = randi()
		var enemy = Enemy.instance()
		$Enemies.add_child(enemy)
		enemy.position = $EnemyPath/EnemySpawnLocation.position
