extends KinematicBody2D


var velocity = Vector2(1.0, 1.0)
var MAX_SPEED
var ACCELERATION
var player_pos
# warning-ignore:unused_signal
signal enemy_collide
var MOVE = false
signal exploded
signal game_over

func _ready():
	randomize()
	ACCELERATION = randi() % 10 + 5
	MAX_SPEED = randi() % 251 + 250
	$AnimationPlayer.play("Spawn")
	

func player_details(pos):
	player_pos = pos

func _physics_process(delta):
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
			
			var enemy_collided = move_and_collide(velocity * delta)
			if enemy_collided:
				
				#Hold the object the enemy collided with
				var collided_shape = enemy_collided.get_collider_shape()
				# This if will only happen if the enemy collided with the border
				# as the borders has now collision shape
				if collided_shape == null:
					explode()
					emit_signal("exploded")
				else:
					if "KinematicBody2D" in collided_shape.get_parent():
						emit_signal("game_over")
			

func explode():
	MOVE = false
	$AnimationPlayer.play("Explosion")

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Spawn":
		MOVE = true
	if anim_name == "Explosion":
		queue_free()
