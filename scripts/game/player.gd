extends CharacterBody3D

@onready var INIT_POS = self.global_position

const ROTATE_SPEED:float = 0.0025
const JUMP_VELOCITY:float = 10.0
const FAST_FALL:float = -20.0

var speed = 15.0 # probably cap at 25-30
const ACCEL:float = 0.5
const MAX_VEL:float = 27.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var theta:float = 0
const INIT_DIR = Vector2(0, 1)
var direction = INIT_DIR


@onready var gamebus = get_node("/root/gamebus") 

func _ready():
	gamebus.portal_entered.connect(_on_portal_entered)
	
	
func _on_portal_entered():
	self.global_position = Vector3(0, 3, 3)
	direction = INIT_DIR
	theta = 0
	speed += ACCEL
	
	print("portal entered -> player")
	
	gamebus.stage_number += 1
	gamebus.base_scale = clampf(
		gamebus.INIT_PLAT_SIZE - gamebus.stage_number * 0.1, \
		gamebus.MIN_PLAT_SIZE, gamebus.INIT_PLAT_SIZE)
	
func spawn_player():
	self.global_position = INIT_POS
	direction = Vector2(0, 1)
	theta = 0

func _process(_delta):
	if self.global_position.y < gamebus.out_of_bounds_y_pos:
		if gamebus.INFINITE_LIVES:
			spawn_player()
		else:
			gamebus.stage_number = 1
			gamebus.base_scale = 1.5
			get_tree().change_scene_to_file("res://scenes/menu_scene/menu.tscn")
	
	if Input.is_action_just_pressed("left"):
		theta += PI / 2
	if Input.is_action_just_pressed("right"):
		theta += -PI / 2
		
	self.rotation.y = lerp_angle(self.rotation.y, theta, ROTATE_SPEED * speed)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	# jump uses a single firework
	if Input.is_action_just_pressed("jump") && gamebus.collected_fireworks > 0:
		gamebus.collected_fireworks -= 1
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("down") and !is_on_floor():
		velocity.y = FAST_FALL
	
	
	if Input.is_action_just_pressed("left"):
		direction = direction.rotated(-PI/2)
	if Input.is_action_just_pressed("right"):
		direction = direction.rotated(PI/2)
		
	velocity.x = direction.x * speed
	velocity.z = direction.y * speed
	
	move_and_slide()
