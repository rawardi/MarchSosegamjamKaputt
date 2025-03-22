extends Area2D

@export var leaderboard = "res://Scenes/Leaderboardtest.tscn"

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" :
		var load=load(leaderboard)
		get_tree().change_scene_to_packed(load)
