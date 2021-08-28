extends KinematicBody2D

var velocity = Vector2.ZERO


func _physics_process(delta):
	var inp = Vector2.ZERO
	inp.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inp.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if inp != Vector2.ZERO:
		velocity += inp
	else:
		velocity = Vector2.ZERO
	move_and_collide(velocity)
