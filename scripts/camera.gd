extends Camera2D


@export var player: CharacterBody2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	var direction_x := Input.get_axis("left", "right")
	var direction_y := Input.get_axis("up", "down")

	#position = player.velocity*0.2
	#print(player)

	#position.x = direction_x*20
	#position.y = direction_y*20
