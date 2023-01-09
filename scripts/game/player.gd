extends CharacterBody3D

@onready var INIT_POS = self.global_position
@onready var camera = $camera_arm
@onready var body = $CollisionShape3D
@onready var gamebus = get_node("/root/gamebus") 

# maybe have the player accelerate when in freefall

const ROTATE_SPEED:float = 0.0023
const JUMP_VELOCITY:float = 15.0
const FAST_FALL:float = -20.0

const INIT_SPEED:float = 14.0
const ACCEL:float = 0.1
const MAX_SPEED:float = 22.0
var min_speed:float = INIT_SPEED
var total_speed:float = min_speed

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var theta:float = 0

const INIT_DIR = Vector2(0, 1)
var direction = INIT_DIR

func _ready():
	gamebus.portal_entered.connect(_on_portal_entered)
	
func spawn_player():
	self.global_position = INIT_POS
	direction = Vector2(0, 1)
	theta = 0

func _process(_delta):
	if Input.is_action_just_pressed("left"):
		theta += PI / 2
	if Input.is_action_just_pressed("right"):
		theta += -PI / 2
		
	camera.rotation.y = lerp_angle(camera.rotation.y, theta, ROTATE_SPEED * total_speed)
	body.rotation.y = lerp_angle(body.rotation.y, theta, 0.5)
	

var collision_vel_gain:float = 0.0 # how fast were we falling before hitting the ground
const COLLISION_ENERGY_LOSS = 0.08 # how much velocity is retained from collision w/ ground
var gained_speed:float = 0.0 # the amount of speed gained from falling -> applied to player
const FRICTION:float = 0.05
const TERM_GAIN:float = 10.0 # limit on how much speed we can gain from falling
const MIN_GAIN:float = 0.2 # implement slowing down a little when going uphill
func _physics_process(delta):
	# controls
	if Input.is_action_just_pressed("jump") && gamebus.collected_fireworks > 0:
		gamebus.collected_fireworks -= 1
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("down") and !is_on_floor():
		velocity.y = FAST_FALL
	if Input.is_action_just_pressed("left"):
		direction = direction.rotated(-PI/2)
	if Input.is_action_just_pressed("right"):
		direction = direction.rotated(PI/2)
		
	#physics
	if not is_on_floor():
		velocity.y -= gravity * delta
		# probably change to non-linear func
		collision_vel_gain = -velocity.y * COLLISION_ENERGY_LOSS
	else:
		gained_speed += collision_vel_gain
		gained_speed = clampf(gained_speed - FRICTION, 0, TERM_GAIN)
		collision_vel_gain = 0.0
		
	total_speed = min_speed + gained_speed	
	velocity.x = direction.x * total_speed
	velocity.z = direction.y * total_speed
	
	move_and_slide()
	
	
# signals
func _on_portal_entered():
	self.global_position = Vector3(0, 3, 3)
	direction = INIT_DIR
	theta = 0
	gained_speed = 0
	min_speed = clampf(min_speed + ACCEL, 0, MAX_SPEED)
	
	gamebus.stage_number += 1
	gamebus.base_scale = clampf(
		gamebus.INIT_PLAT_SIZE - gamebus.stage_number * 0.03, \
		gamebus.MIN_PLAT_SIZE, gamebus.INIT_PLAT_SIZE)
