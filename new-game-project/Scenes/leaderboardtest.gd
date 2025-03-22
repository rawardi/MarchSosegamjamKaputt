extends Control

var playername :String
var playertime :float

func _on_line_edit_text_submitted(new_text: String) -> void:
	playername = new_text
	Global.PlayerName = playername
	print(playername)



func _on_button_pressed() -> void:
	print(Global.speed_runtime)
	
	await Leaderboards.post_guest_score("marchsosegamejam2025-leaderboard-GU3d",Global.speed_runtime*100,playername)
	Global.speed_runtime=0
	get_tree().reload_current_scene()


func _on_show_pressed() -> void:
	$LeaderboardUI.show()



func _on_hide_pressed() -> void:
	$LeaderboardUI.hide()
