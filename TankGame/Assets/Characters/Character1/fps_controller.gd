extends CharacterBody3D


#const SPEED = 5.0
#const JUMP_VELOCITY = 4.5

# use and set the variable on the character controller
# (useful for using adjustable variables for the character script)
@export var mouse_look_sensitivity : float = 0.006
#@export var jump_velocity : float = 6.0 # 6.0
@export var jump_velocity : float = 300.0

@export var auto_bhop : bool = true # auto bunny hopping
@export var walk_speed : float = 700 # 7.0
@export var sprint_speed : float = 850 # 8.5 # fast movement speed

var wish_dir := Vector3.ZERO # to store the input direction that we are pressing

# at the start of the game (this is called only once)
func _ready() -> void:
	#pass
	
	# set max fps in a Scene
	Engine.max_fps = 60 # testing 15, 30, 60
	
	# for every child under 'WorldModelNode'
	for child in %WorldModelNode.find_children("*", "VisualInstance3D"):
		child.set_layer_mask_value(1, false) # move from visual layer 1
		child.set_layer_mask_value(2, true) # to visual layer 2 (AND hide visual layer 2 for the camera)

# to handle player inputs
func _unhandled_input(event: InputEvent) -> void:
	#pass
	
	# if the mouse is clicked
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # move the camera around
		
	# if the escape key is pressed
	#elif event.is_action_pressed("ui_cancel"): 
	#	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # release the mouse
	
	# if key is pressed, exit the game
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()


	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion: # if the mouse is in motion
			rotate_y(-event.relative.x * mouse_look_sensitivity) # move the camera and look around, rotate the character body 3D on the Y axis
			%Camera3D.rotate_x(-event.relative.y * mouse_look_sensitivity) # rotate the camera on the X axis
			%Camera3D.rotation.x = clamp(%Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90)) # restrict the camera rotation on the X axis

#func _process(delta: float) -> void:
	#pass

func _handle_air_physics(delta: float) -> void:
	#pass
	
	# use the settings from here: Project -- > Project Settings -- > Physics -- > 3D -- > Default Gravity (default: 9.8)
	# speed and acceleration (delta) to make velocity
	#self.velocity.y = (- ProjectSettings.get_setting("physics/3d/default_gravity")) * delta # gravity = 12
		# delta: the amount of seconds passed since the last (process or physics) frame drawn
	
	# testing the gravity (gravity used here: 675)
	self.velocity.y = (- ProjectSettings.get_setting("physics/3d/default_gravity")) * delta

#func _handle_ground_physics() -> void:
func _handle_ground_physics(delta: float) -> void:
	#pass
	
	self.velocity.x = wish_dir.x * walk_speed * delta # to move on X axis
	self.velocity.z = wish_dir.z * walk_speed * delta # to move on Z axis


func _physics_process(delta: float) -> void:
	#pass
	
	# show current FPS on console
	#print(str(Engine.get_frames_per_second()))
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back").normalized()
	# (this should be adjusted to the way the character is facing)
	wish_dir = self.global_transform.basis * Vector3(input_dir.x, 0.0, input_dir.y) # ('transform basis' is needed so the character 3D model follows camera movement)

	# to call the air and ground physics functions
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):	# to make the character jump
			#self.velocity.y = jump_velocity
			
			# testing the jump
			# ~
			#while(self.position.y == (self.position.y + 5)):
			#	self.position.y = self.position.y + 1
			#
			#self.position.y = self.position.y + 5
			
			self.velocity.y = self.velocity.y + jump_velocity
			
		
		_handle_ground_physics(delta)
		
	else:
		_handle_air_physics(delta) # handle if the player is not on the floor
		
	move_and_slide() # to make the character 3D body move

#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
#
	#move_and_slide()
