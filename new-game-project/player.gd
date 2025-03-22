extends CharacterBody2D




const JUMP_VELOCITY = -500.0
var MAX_SPEED = 700.0
var SPEED = 200
var DoubleJump = 0
var Dash=0
var walldashtime = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var wjump = false


 
var cardtypes = {"double": 0, "walljump": 4, "explosion": 8}
var cardname_array = ["double", "walljump", "explosion"]
var i = 0
var current_cardtype = cardname_array[i]


func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	
	# Wall dash and wall slide control
	if is_on_wall() and Input.is_action_just_pressed("WallJump") :
		walldashtime=true
		$Timer.start()
	if is_on_wall() and walldashtime: 
		if Input.is_action_just_pressed("walldashleft"):
			print("jump dash left")
			walldashtime=false
			velocity.x  =500 
			velocity.y = JUMP_VELOCITY
			DoubleJump+=1
		if Input.is_action_just_pressed("walldashright"):
			print("jump dash right")
			velocity.x = -500
			velocity.y = JUMP_VELOCITY
			walldashtime=false
			DoubleJump+=1
	if walldashtime== true :
		velocity.x=0
		velocity.y=0

#aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa  the wall dash is needs to be fixed but the the time stop function


	if not is_on_floor():
		velocity.y += gravity * delta
	# Handle Jump.
	if Input.is_action_just_pressed("ui_up") and DoubleJump <= 1 :
		velocity.y = JUMP_VELOCITY
		DoubleJump+=1
	if is_on_floor() :
		DoubleJump=0
#Jump and basic movement

	#new system for wall jump
	if Input.is_action_just_pressed("ui_accept"):
		var shoot_vector = global_position - get_global_mouse_position()
		shoot_vector.round()
		shoot_vector /= shoot_vector.length()
		velocity = shoot_vector * 825
		wjump = true
		await get_tree().create_timer(0.3).timeout
		wjump = false

	if direction == -1:
		get_node("Sprite2D").flip_h = true
	elif direction == 1:
		get_node("Sprite2D").flip_h = false
	if not wjump:
		if direction:
			velocity.x = direction * SPEED
			if (SPEED < MAX_SPEED):
				SPEED += 20
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			SPEED = 300
	move_and_slide()
	
	if is_on_wall():
		SPEED = 300
	


func _on_timer_timeout() -> void:
	walldashtime=false
#walldash control




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

func store_card(type):
	#stores a new card and equips it's effect 
	cardtypes[type] += 1
	i = cardname_array.find(type)
	current_cardtype = type
