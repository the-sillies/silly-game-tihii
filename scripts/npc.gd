extends CharacterBody2D

@onready var player: CharacterBody2D = $'../Player'

func _ready() -> void:
	print(player)

func _on_interact_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method('player'):
		player.add_interactable(self)

func _on_interact_detection_area_body_exited(body: Node2D) -> void:
	if body.has_method('player'):
		player.remove_interactable(self)
