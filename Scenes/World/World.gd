extends Node

export (PackedScene) var Enemy
var enemies = []

func _ready():
	randomize()

func _physics_process(_delta):
	for en in enemies:
		en.get_node("EnemyKinematic").player_details($Player/PlayerKinematicBody2D.position)
	

func _on_EnemySpawn_timeout():
	for i in range(randi() % 4):
		$EnemyPath/EnemySpawnLocation.offset = randi()
		var enemy = Enemy.instance()
		add_child(enemy)
		enemy.get_node("EnemyKinematic").position = $EnemyPath/EnemySpawnLocation.position
		enemies.append(enemy)
		
	
