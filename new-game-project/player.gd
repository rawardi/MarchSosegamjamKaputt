extends CharacterBody2D



const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var DoubleJump= 0
var Dash=0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = get_node("AnimationPlayer")

func _physics_process(delta):
	
	if is_on_wall_only() :
		velocity.y += gravity * delta  
		velocity.y = velocity.y *0.8
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	# Handle Jump.
	if Input.is_action_just_pressed("ui_up") and DoubleJump <= 1 :
		velocity.y = JUMP_VELOCITY
		DoubleJump+=1
	if is_on_floor() :
		DoubleJump=0
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")

	if direction == -1:
		get_node("Sprite2D").flip_h = true
	elif direction == 1:
		get_node("Sprite2D").flip_h = false
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	
