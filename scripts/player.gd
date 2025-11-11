extends CharacterBody2D

@export var logs: Label
@export var sprite: AnimatedSprite2D

func player():
	pass

@export var WALK_SPEED: float
@export var RUN_SPEED: float

var is_interacting := false
var is_running := false
var absolute_velocity := Vector2()


func _physics_process(delta: float) -> void:
	var direction_x : float = 0
	var direction_y : float = 0

	if not is_interacting:
		direction_x = Input.get_axis('left', 'right')
		direction_y = Input.get_axis('up', 'down')
		
	is_running = Input.is_action_pressed('run')

	var target_speed := RUN_SPEED if is_running else WALK_SPEED

	var target_speed_vector := {x = direction_x * target_speed, y = direction_y * target_speed}

	absolute_velocity.x = move_toward(absolute_velocity.x, target_speed_vector.x, target_speed / 5)
	absolute_velocity.y = move_toward(absolute_velocity.y, target_speed_vector.y, target_speed / 5)

	velocity = absolute_velocity * delta * 60

	if velocity.x < 0:
		sprite.flip_h = false
	elif velocity.x > 0:
		sprite.flip_h = true

	var speed := velocity.length()
	if speed > 75:
		sprite.play('run')
	elif speed > 10:
		sprite.play('walk')
	else:
		sprite.play('idle')

	move_and_slide()

func _process(delta: float) -> void:
	logs.text = ('{pos}\n{vel}').format({'pos': position, 'vel': velocity})
	pass
