extends CharacterBody2D

@onready var animation =  $AnimatedSprite2D

signal inner_granade
signal outer_granade

var detonating = false
var explosion_timer = 0
var body_ = null
var direction
var first_time = true
var life_time = 0.0

func _physics_process(delta: float) -> void:
	if detonating != true:
		velocity += direction * 100
	
	if is_on_ceiling() or is_on_floor() or is_on_wall():
		detonating = true #starts detonation 
		velocity = Vector2(0,0)
	
	move_and_slide()

func _process(delta: float) -> void:
	if detonating: 
		explosion_timer += delta #detonation countdown
		if explosion_timer > 0.4:
			animation.play("detonation")
			if inner_granade.is_connected(body_.granade_boost):
				inner_granade.emit(global_position, 40) #emit granade signal when timer hits detonation timer
			else:
				outer_granade.emit(global_position, 20)
			await animation.animation_finished
			
			self.queue_free()
	
	life_time += delta
	
	if life_time > 1000:
		self.queue_free()




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		inner_granade.connect(body.granade_boost)
		body_ = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		inner_granade.disconnect(body.granade_boost)


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		outer_granade.connect(body.granade_boost)

func _on_area_2d_2_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		outer_granade.disconnect(body.granade_boost)
