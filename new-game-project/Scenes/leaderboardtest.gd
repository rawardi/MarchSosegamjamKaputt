extends Control

@onready var outputname= $PanelContainer/MarginContainer/VBoxContainer/Output/VBoxContainer/HBoxContainer/playername
@onready var outputtime= $PanelContainer/MarginContainer/VBoxContainer/Output/VBoxContainer/HBoxContainer/Label
func _on_line_edit_text_submitted(new_text: String) -> void:
	outputname.set_text(new_text)
	outputtime.set_text(Global.speed_runtime)
	Global.speed_runtime=0
