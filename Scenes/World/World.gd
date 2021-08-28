extends Node

export (PackedScene) var Enemy

var enemies = []

func _physics_process(delta):
	for en in enemies:
		en.get_node("EnemyKinematic").player_details($Player/PlayerKinematicBody2D.position)
	

func _on_EnemySpawn_timeout():
	var enemy = Enemy.instance()
	add_child(enemy)
	enemies.append(enemy)
	
