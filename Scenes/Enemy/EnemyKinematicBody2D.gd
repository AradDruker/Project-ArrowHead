extends KinematicBody2D


var velocity = Vector2(1.0, 1.0)
var MAX_SPEED = 300
var ACCELERATION
var player_pos

export (NodePath) var visibility_notifier_path




func _ready():
	randomize()
	ACCELERATION = randi() % 10 + 5
	MAX_SPEED = randi() % 201 + 200
	var visibility_notifier = get_node(visibility_notifier_path)
	

func player_details(pos):
	player_pos = pos




func _physics_process(delta):
	# Mouse position for enemy to focus on
	
	# Vector towards the mouse
	#player_pos = get_viewport().get_mouse_position()
	var v = Vector2(position.x, position.y)
	v = v.direction_to(Vector2(player_pos))
	velocity +=  v * ACCELERATION
	velocity = velocity.clamped(MAX_SPEED)
	
	
	
	
	# Making ship point to the destination
	var ang = atan2(velocity.x, velocity.y)
	$EnemySprite.rotation = PI - ang
	
	if pow(pow(position.x - player_pos.x, 2) + pow(position.y - player_pos.y, 2), 0.5) > 3:
		move_and_slide(velocity)




func _on_VisibilityNotifier2D_screen_exited():
	hide()
