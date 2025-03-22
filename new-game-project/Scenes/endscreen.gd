extends Control

var playername :String
var playertime :float

func _on_line_edit_text_submitted(new_text: String) -> void:
	playername = new_text
	playertime = Global.speed_runtime
	playertime *= 1000
	int(playertime)
	playertime /= 1000
	await Leaderboards.post_guest_score("marchsosegamejam2025-leaderboard-G93R", playertime, playername)
	Global.speed_runtime=0
	get_tree().reload_current_scene()
	$HBoxContainer/LineEdit.text = ""


func _on_show_pressed() -> void:
	$LeaderboardUI.show()


func _on_hide_pressed() -> void:
	$LeaderboardUI.hide()
