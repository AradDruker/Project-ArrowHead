extends Node

signal player_position


func _physics_process(delta):
	emit_signal("player_position", self.position)
