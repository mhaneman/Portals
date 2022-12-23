extends CharacterBody3D


const ROTATE_SPEED = 0.003
const ACCEL = 0.5
const MAX_ACCEL = 27

# consider jump as a powerup item
var JUMP_VELOCITY = 10.0 # the more coins, the higher the jump -> 15 max
var speed = 10.0 # probably cap at 25-30
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var theta:float = 0
var direction = Vector2(0, 1)

@onready var gamebus = get_node("/root/gamebus") 

func _ready():
	gamebus.portal_entered.connect(_on_portal_entered)
	

func _on_portal_entered():
	self.global_position = Vector3(0, 3, 3)
	direction = Vector2(0, 1)
	theta = 0
	speed += ACCEL

func _process(_delta):
	if Input.is_action_just_pressed("left"):
		theta += PI / 2
	if Input.is_action_just_pressed("right"):
		theta += -PI / 2
		
	self.rotation.y = lerp_angle(self.rotation.y, theta, ROTATE_SPEED * speed)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	# jump uses a single firework
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("left"):
		direction = direction.rotated(-PI/2)
	if Input.is_action_just_pressed("right"):
		direction = direction.rotated(PI/2)
		
	velocity.x = direction.x * speed
	velocity.z = direction.y * speed
	
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
