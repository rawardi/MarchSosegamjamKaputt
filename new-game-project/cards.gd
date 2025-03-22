extends Area2D

@onready var animation = $AnimatedSprite2D

@export var cardtype = ""

signal collected


func _ready() -> void:
	#displays the correct sprite
#	animation.play(cardtype)
	pass

func _on_body_entered(body: Node2D) -> void:
	#allerts body that a card has been collected
	if body.is_in_group("player"):
		collected.connect(body.store_card)
		collected.emit(cardtype)
		
		queue_free()
