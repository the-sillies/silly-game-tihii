extends CharacterBody2D

@export var logs: Label
@export var sprite: AnimatedSprite2D
@export var shadow: Sprite2D
@export var interaction_tooltip: PackedScene

@export var WALK_SPEED: float
@export var RUN_SPEED: float

var is_interacting := false
var is_running := false
var is_flipped := false
var absolute_velocity := Vector2()
var interactable_nodes: Array[Node2D] = []

var shadow_coords := Vector2()
var shadow_coords_flipped := Vector2()

var interaction_tooltip_instance

func set_shadow_coords(x: float, y: float):
	shadow_coords = Vector2(x, y)
	shadow_coords_flipped = Vector2(-x, y)

func player():
	pass

func _ready():
	set_shadow_coords(1, 2)
	interaction_tooltip_instance = interaction_tooltip.instantiate()

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
		is_flipped = false
	elif velocity.x > 0:
		is_flipped = true

	move_and_slide()

func _process(delta: float) -> void:
	if logs:
		logs.text = ('{pos}\n{vel}\n{interact}').format({'pos': position, 'vel': velocity, 'interact': '\n'.join(interactable_nodes)})

	var speed := velocity.length()
	if speed > 75:
		sprite.play('run')
	elif speed > 10:
		sprite.play('walk')
	else:
		sprite.play('idle')

	if not is_flipped:
		sprite.flip_h = false
		shadow.position = shadow_coords
	else:
		sprite.flip_h = true
		shadow.position = shadow_coords_flipped

	if Input.is_action_just_pressed("interact"):
		if interactable_nodes[0].has_method('handle_interaction'):
			interactable_nodes[0].handle_interaction()
		else:
			push_warning('%s has no method "handle_interaction"' % interactable_nodes[0])
		print('interacted')

func add_interactable(node: Node2D):
	interactable_nodes.append(node)
	print('added: ', node)

func remove_interactable(node: Node2D):
	var id := node.get_instance_id()
	interactable_nodes = interactable_nodes.filter(func(item): return item.get_instance_id() != id)
	node.remove_child(interaction_tooltip_instance)
	print('removed: ', node)

func sort_interactable_by_distance():
	return quicksort(interactable_nodes, func(a,b): return position.distance_squared_to(a.position) < position.distance_squared_to(b.position))

func update_closest_interactable():
	var sorted: Array[Node2D] = []
	sorted.assign(sort_interactable_by_distance())
	interactable_nodes = sorted
	if interactable_nodes.size() > 0:
		for node in interactable_nodes:
			if node.get_children().has(interaction_tooltip_instance):
				node.remove_child(interaction_tooltip_instance)
		interactable_nodes[0].add_child(interaction_tooltip_instance)

func _on_find_closest_timeout() -> void:
	update_closest_interactable()

func quicksort(array: Array, callable: Callable):
	if array.size() <= 1:
		return array

	var pivot = array[0]

	var left = []
	var right = []

	for i in range(1, array.size()):
		if callable.call(array[i], pivot):
			left.append(array[i])
		else:
			right.append(array[i])

	var result: Array = quicksort(left, callable)
	result.append(pivot)
	result.append_array(quicksort(right, callable))

	return result
