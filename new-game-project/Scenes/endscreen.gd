extends Control

var playername :String
var playertime :float

@onready var endtext = $RichTextLabel

func _ready() -> void:
	playertime = Global.speed_runtime
	playertime *= 1000
	playertime = int(playertime)
	playertime /= 1000
<<<<<<< Updated upstream
	await Leaderboards.post_guest_score("marchsosegamejam2025-leaderboard-G93R", playertime, playername)
=======
	endtext.text = "[center][font_size=128]WICKED FINISH![/font_size][p][center][font_size=32]Your Time: " + str(playertime) + " seconds"
	$LineEdit.placeholder_text = "SUBMIT NAME"
	$LineEdit.grab_focus()

func _on_line_edit_text_submitted(new_text: String) -> void:
	playername = new_text
	await Leaderboards.post_guest_score("marchsosegamejam2025-leaderboard-GU3d", playertime, playername)
>>>>>>> Stashed changes
	Global.speed_runtime=0
	$LineEdit.text = ""
	$LineEdit.queue_free()
	$Button.visible = true

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Start.tscn")
