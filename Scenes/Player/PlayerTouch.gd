extends Node

signal swiped(direction)
signal swiped_canceled(start_position)

export(float, 1.0, 1.5) var MAX_DIAGONAL_SLOPE = 1.3

onready var timer = $Timer
var swipe_start_position = Vector2()
var active_swipe = false

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and not active_swipe:
			if event.position.distance_to(get_parent().position) < 200:
				print("hello")
				active_swipe = true
		if not event.pressed and active_swipe:
			print("released")
			active_swipe = false
		
			
				
	
