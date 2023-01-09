extends Node

#TODO
# 1. save game state
# 2. refactor for different game modes

# global signals
signal portal_entered()
signal game_over()


# testing macros
const INFINITE_LIVES:bool = false

# refactor into game class
# stage globals
var play_tutorial:bool = true
var stage_number:int = 1
var out_of_bounds_y_pos:float = -200

const INIT_PLAT_SIZE:float = 1.2
const MIN_PLAT_SIZE:float = 0.3
var base_scale:float = INIT_PLAT_SIZE
const OOB_DISPL:float = -50.0

# refactor into player
# player gobals
var current_collected_coins:int = 0
var total_collected_coins:int = 0
var collected_fireworks:int = 10
	
