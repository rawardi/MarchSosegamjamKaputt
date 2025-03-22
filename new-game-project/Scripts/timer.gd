extends Node2D

var time = 0

func _process(delta: float) -> void:
	time += delta
	print(time)
