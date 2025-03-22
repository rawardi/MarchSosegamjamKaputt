extends Node2D

@export var leaderboard="res://Scenes/Leaderboardtest.tscn"
@export var level="res://Scenes/level_1.tscn"
var leaderboardisshown=false
func _on_start_pressed() -> void:
	var loadlevel= load(level)
	get_tree().change_scene_to_packed(loadlevel)




func _on_leaderboard_pressed() -> void:
	if leaderboardisshown :
		$LeaderboardUI.hide()
		leaderboardisshown=false
	else :
		$LeaderboardUI.show()
		leaderboardisshown=true
