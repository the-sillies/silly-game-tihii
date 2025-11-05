extends CharacterBody2D

func player():
	pass

const SPEED = 100.0

var is_interacting = false

var absolute_velocity := Vector2()


func _physics_process(delta: float) -> void:
	var direction_x : float = 0
	var direction_y : float = 0
	
	if not is_interacting:
		direction_x = Input.get_axis("left", "right")
		direction_y = Input.get_axis("up", "down")
	
	var targetspeed = {x = direction_x * SPEED, y = direction_y * SPEED}
	
	absolute_velocity.x = move_toward(absolute_velocity.x, targetspeed.x, SPEED / 5)
	absolute_velocity.y = move_toward(absolute_velocity.y, targetspeed.y, SPEED / 5)
	
	velocity = absolute_velocity * delta * 60

	move_and_slide()
