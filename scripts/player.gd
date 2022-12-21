extends CharacterBody3D

@onready var camera = $Camera

const SPEED = 15.0
const JUMP_VELOCITY = 10.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var theta:float = 0

func _process(_delta):
	self.rotation.y = lerp_angle(self.rotation.y, theta, 0.1)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY


	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = -(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if Input.is_action_just_pressed("left"):
		theta += PI / 2
	if Input.is_action_just_pressed("right"):
		theta += -PI / 2
	
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	move_and_slide()
