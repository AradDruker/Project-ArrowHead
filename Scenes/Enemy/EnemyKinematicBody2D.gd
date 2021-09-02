extends KinematicBody2D


var velocity = Vector2(1.0, 1.0)
var MAX_SPEED
var ACCELERATION
var player_pos
# warning-ignore:unused_signal
signal enemy_collide
var MOVE = false


func _ready():
	randomize()
	ACCELERATION = randi() % 10 + 5
	MAX_SPEED = randi() % 251 + 250
	var _visibility_notifier = $VisibilityNotifier2D

func player_details(pos):
	player_pos = pos

func _physics_process(_delta):
	if MOVE:
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
	# warning-ignore:return_value_discarded
			if move_and_slide(velocity):
				pass

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()



func _on_AnimationPlayer_animation_finished(_anim_name):
	MOVE = true
