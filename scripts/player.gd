extends CharacterBody2D

@export var logs: Label
@export var sprite: AnimatedSprite2D

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

	if velocity.x < 0:
		sprite.flip_h = false
	elif velocity.x > 0:
		sprite.flip_h = true

	var speed = velocity.length()
	if speed <= 0:
		sprite.play('idle')
	elif speed <= 80:
		sprite.play('walk')
	else:
		#sprite.play('run')
		pass

	move_and_slide()

func _process(delta: float) -> void:
	logs.text = ('{pos}\n{vel}').format({'pos': position, 'vel': velocity})
	pass
