extends CharacterBody2D


func _on_interact_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method('player'):
		Dialogic.start('timeline')
