extends CharacterBody3D

@onready var camera = $Camera

const SPEED = 30.0
const ROTATE_SPEED = 0.003
const JUMP_VELOCITY = 15.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var theta:float = 0
var direction = Vector2(0, 1)

func _process(_delta):
	if Input.is_action_just_pressed("left"):
		theta += PI / 2
	if Input.is_action_just_pressed("right"):
		theta += -PI / 2
		
	self.rotation.y = lerp_angle(self.rotation.y, theta, ROTATE_SPEED * SPEED)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("left"):
		direction = direction.rotated(-PI/2)
	if Input.is_action_just_pressed("right"):
		direction = direction.rotated(PI/2)
		
	velocity.x = direction.x * SPEED
	velocity.z = direction.y * SPEED
	
	move_and_slide()


func _on_swipe_controls_swiped(sig):
	print(sig)
	if sig == "jump":
		velocity.y = JUMP_VELOCITY
	if sig == "left":
		direction = direction.rotated(-PI/2)
	if sig == "right":
		direction = direction.rotated(PI/2)
	if sig == "down":
		pass
