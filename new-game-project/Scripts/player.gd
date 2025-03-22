extends CharacterBody2D


@onready var selected_card = $RichTextLabel
@onready var animation = $AnimatedSprite2D

const JUMP_VELOCITY = -500.0
var MAX_SPEED = 700.0
var original_max_speed = MAX_SPEED
var Original 
var SPEED = 200
var can_jump = true
var coyote_timer = 0
var wallclutch = false
var launched_to_ground = true
var direction
var loop_animation = true
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var stop_timer = 0

var launched = false
 
var cardtypes = {"double": 0, "walljump": 0, "explosion": 0}
var cardname_array = ["double", "walljump", "explosion"]
var i = 0
var current_cardtype = cardname_array[i]


#movement management
func _physics_process(delta):
	direction = Input.get_axis("ui_left", "ui_right")

#implements gravity
	if not is_on_floor() and not wallclutch:
		velocity.y += gravity * delta


#start wall jump
	if is_on_wall() and Input.is_action_just_pressed("use_card"):# and current_cardtype == "walljump" and cardtypes[cardname_array[i]] > 0:
		wallclutch = true

#wall clutch when shift pressed
	if is_on_wall() and wallclutch: 
		velocity.x=0
		velocity.y=0
		animation.play("wallclutch")
		loop_animation = false

#launch when shift released
	if Input.is_action_just_released("use_card") and wallclutch:
		MAX_SPEED += 200
		wallclutch = false
		var shoot_vector = global_position - get_global_mouse_position()
		shoot_vector.round()
		shoot_vector /= shoot_vector.length()
		velocity = shoot_vector * 825

		animation.play("walljump")

		launched_to_ground = false
		launched = true
		await get_tree().create_timer(0.5).timeout
		launched_to_ground = true
		await get_tree().create_timer(0.5).timeout
		launched = false

		loop_animation = true


# Handle Jump.
	if Input.is_action_just_pressed("ui_up") and can_jump:
		velocity.y = JUMP_VELOCITY
		can_jump = false

		loop_animation = false
		animation.play("jump")
		await animation.animation_finished
		loop_animation = true

#coyote timer for better game feel
	if is_on_floor():
		can_jump = true
		coyote_timer = 0
	else:
		coyote_timer += delta
		if coyote_timer > 0.1:
			can_jump = false


	if is_on_floor() and launched_to_ground:
		launched = false


#double jump ability
	if Input.is_action_just_pressed("use_card") and current_cardtype == "double" and cardtypes[cardname_array[i]] > 0:
		MAX_SPEED += 100
		if animation.flip_h == true:
			velocity.x += -MAX_SPEED/2
			velocity.y = JUMP_VELOCITY
		else:
			velocity.x += MAX_SPEED/2
			velocity.y = JUMP_VELOCITY

		cardtypes[cardname_array[i]] -= 1

		loop_animation = false
		animation.play("double")
		await animation.animation_finished
		loop_animation = true

		launched_to_ground = false
		launched = true
		await get_tree().create_timer(0.2).timeout
		launched_to_ground = true
		await get_tree().create_timer(1.0).timeout
		launched = false


	if not wallclutch:

#flips charactersprite
		if direction == -1:
			animation.flip_h = true
		elif direction == 1:
			animation.flip_h = false


#walking
		if direction:
			velocity.x = direction * SPEED
			if (SPEED < MAX_SPEED):
				SPEED += 20
		elif not launched:
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

#displays selected card
	selected_card.text = current_cardtype
	if cardtypes[cardname_array[i]] != 0:
		selected_card.text = "[color=yellow]" + current_cardtype
	else:
		selected_card.text = "[color=gray]" + current_cardtype



#animation manager
	if loop_animation == true:
		if direction and is_on_floor():
			animation.play("running")
		elif velocity == Vector2(0,0):
			animation.play("idle")
		elif not is_on_floor():
			animation.play("falling")


func store_card(type):
#stores a new card and equips it's effect 
	cardtypes[type] += 1
	i = cardname_array.find(type)
	current_cardtype = type
