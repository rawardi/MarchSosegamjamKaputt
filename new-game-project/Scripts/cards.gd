extends Area2D

@onready var animation = $AnimatedSprite2D

@export var cardtype = ""

signal collected

var up = true
var pos = 5

func _ready() -> void:
	#displays the correct sprite
	animation.play(cardtype)

func _on_body_entered(body: Node2D) -> void:
	#allerts body that a card has been collected
	if body.is_in_group("player"):
		collected.connect(body.store_card)
		collected.emit(cardtype)
		
		queue_free()

func _process(delta: float) -> void:
	if up:
		position.y -= 0.02
		pos -= 0.02
	else:
		position.y += 0.02
		pos += 0.02
		
	
	if pos >= 5:
		up = true
	if pos <= 0:
		up = false
