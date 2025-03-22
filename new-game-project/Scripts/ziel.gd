extends Area2D

var leaderboard = "res://Scenes/endscreen.tscn"

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var load = load(leaderboard)
		get_tree().call_deferred("change_scene_to_file", leaderboard)
