extends CharacterBody3D


#@onready var playerBean = self
@onready var spring_arm_pivot = $SpringArmPivot
@onready var spring_arm = $SpringArmPivot/SpringArm3D

const SPEED = 5.0
#const JUMP_VELOCITY = 4.5
#const LERP_VAL = 0.15 # used for player rotation

func _ready():
	pass
	
	# bind mouse to player camera
	# Captures the mouse. The mouse will be hidden and its position locked at the center of the window manager's window.
	#Input.MOUSE_MODE_CAPTURED # not working
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	# if key is pressed, exit the game
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

	# rotate camera with player rotation (rotate with mouse movement)
	if event is InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-event.relative.x * 0.005) # (rotation in radians)
		spring_arm.rotate_x(-event.relative.y * 0.005)
		# restrict the amount of rotation (look up, look down)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	# if the camera is rotated adjust movement
	direction = direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		
		# to do: 3D model rotation!
		
		# bug 01 # error
		#playerBean.rotation.y = lerp_angle(playerBean.rotation.y, atan2(-velocity.x, -velocity.z), LERP_VAL)
		
		# bug 02 # error
		#var objectRotation = lerp_angle(playerBean.rotation.y, atan2(-velocity.x, -velocity.z), LERP_VAL)
		#rotate_object_local(Vector3(0,1,0), objectRotation)
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
