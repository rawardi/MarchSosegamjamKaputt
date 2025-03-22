extends Node2D

@export var leaderboard="res://Scenes/Leaderboardtest.tscn"
@export var level="res://Scenes/level_1.tscn"

func _on_start_pressed() -> void:
	var loadlevel= load(level)
	get_tree().change_scene_to_packed(loadlevel)




func _on_leaderboard_pressed() -> void:
	var loadleaderboard= load(leaderboard)
	get_tree().change_scene_to_packed(loadleaderboard)
