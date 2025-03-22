extends CharacterBody2D


@onready var selected_card = $RichTextLabel

const JUMP_VELOCITY = -500.0
var MAX_SPEED = 700.0
var original_max_speed = MAX_SPEED
var Original 
var SPEED = 200
var can_jump = true
var coyote_timer = 0
var wallclutch = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var wjump = false
var stop_timer = 0


 
var cardtypes = {"double": 0, "walljump": 0, "explosion": 0}
var cardname_array = ["double", "walljump", "explosion"]
var i = 0
var current_cardtype = cardname_array[i]


#movement management
func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	

#start wall jump
	if is_on_wall() and Input.is_action_just_pressed("use_card") and current_cardtype == "walljump":
		wallclutch = true

#wall clutch when shift pressed
	if is_on_wall() and wallclutch: 
		velocity.x=0
		velocity.y=0

#launch when shift released
	if Input.is_action_just_released("use_card") and wallclutch:
		wallclutch = false
		var shoot_vector = global_position - get_global_mouse_position()
		shoot_vector.round()
		shoot_vector /= shoot_vector.length()
		velocity = shoot_vector * 825
		wjump = true
		await get_tree().create_timer(0.3).timeout
		wjump = false
		MAX_SPEED += 200


#implements gravity
	if not is_on_floor() and not wallclutch:
		velocity.y += gravity * delta


# Handle Jump.
	if Input.is_action_just_pressed("ui_up") and can_jump:
		velocity.y = JUMP_VELOCITY
		can_jump = false

#coyote timer for better game feel
	if is_on_floor():
		can_jump = true
		coyote_timer = 0
	else:
		coyote_timer += delta
		if coyote_timer > 0.1:
			can_jump = false


#flips charactersprite
	if direction == -1:
		get_node("Sprite2D").flip_h = true
	elif direction == 1:
		get_node("Sprite2D").flip_h = false


#walking
	if not wjump and not wallclutch:
		if direction:
			velocity.x = direction * SPEED
			if (SPEED < MAX_SPEED):
				SPEED += 20
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			SPEED = 300

#tracks time without directional imput, deletes buildup speed if stood still for too long
			stop_timer += delta
			if stop_timer < 1:
				MAX_SPEED = original_max_speed
			else:
				stop_timer = 0
	
	move_and_slide()


#tracks time while clutching, deletes buildup speed if stood still for too long
	if is_on_wall():
		SPEED = 300
		stop_timer += delta
		if stop_timer < 2:
			MAX_SPEED = original_max_speed
	else:
		stop_timer = 0


#cardmanagement
func _process(delta: float) -> void:
#switch selected card i
	if Input.is_action_just_pressed("left_mouse_button"):
		if i < cardtypes.size() - 1:
			i += 1
		else:
			i = 0
		current_cardtype = cardname_array[i]
	if Input.is_action_just_pressed("right_mouse_button"):
		if i == 0:
			i = cardtypes.size() - 1
		else:
			i -= 1
		current_cardtype = cardname_array[i]


#player uses card when he has the selected card (based on i)
	if Input.is_action_just_pressed("use_card") and cardtypes[cardname_array[i]] > 0:
		cardtypes[cardname_array[i]] -= 1


#displays selected card
	selected_card.text = current_cardtype
	if cardtypes[cardname_array[i]] != 0:
		selected_card.text = "[color=yellow]" + current_cardtype
	else:
		selected_card.text = "[color=gray]" + current_cardtype


func store_card(type):
#stores a new card and equips it's effect 
	cardtypes[type] += 1
	i = cardname_array.find(type)
	current_cardtype = type
