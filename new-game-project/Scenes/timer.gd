extends CanvasLayer

 
var time = Global.speed_runtime

var minutes: int = 0
var seconds: int = 0
var milliseconds: int = 0 


func _process(delta: float) -> void:
	time += delta
	
#	var formatted_time = str(time)
#	var decimal_index = formatted_time.find(".")
#	
#	if decimal_index > 0:
#		formatted_time = formatted_time.left(decimal_index + 3)  # Take only two decimal places
	Global.speed_runtime = time


#displaying 'time'by splitting it up in minutes, seconds, milliseconds
	milliseconds = fmod(time, 1) * 100
	seconds = fmod(time, 60)
	minutes = fmod(time,3600) / 60

#displaying time in labels
	var refresh_timer : int = time / delta
	if refresh_timer % 15 == 0:
		$Label.text = "%02d:" % minutes + "%02d:" % seconds + "%02d" % milliseconds
