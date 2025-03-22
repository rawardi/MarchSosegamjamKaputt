extends CharacterBody2D

signal granade
var detonating
var explosion_timer

func _physics_process(delta: float) -> void:
	#generates gravity for granade
	velocity += get_gravity() * delta
	
	#check for bounces
	if is_on_floor():
		detonating = true #starts detonation 

func _process(delta: float) -> void:
	if detonating: 
		explosion_timer += delta #detonation countdown
		if explosion_timer > 0.2:
			granade.emit(self) #emit granade signal when timer hits detonation timer
			#granade_sprite.play("detonation")
			#await granade_sprite.animation_finished
			#queue_free()




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		granade.connect(body.granade_boost)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		granade.disconnect(body.granade_boost)


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		granade.connect(body.granade_boost)

func _on_area_2d_2_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		granade.disconnect(body._one_shot)
