extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(_delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
	#	velocity += get_gravity() * delta
	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")
	
	var targetspeed = {x = direction_x * SPEED, y = direction_y * SPEED}
	
	velocity.x = move_toward(velocity.x, targetspeed.x, SPEED / 3)
	velocity.y = move_toward(velocity.y, targetspeed.y, SPEED / 3)

	move_and_slide()
