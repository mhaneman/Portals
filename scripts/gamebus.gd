extends Node

# global signals
signal portal_entered()
signal game_over()


# testing macros
const INFINITE_LIVES:bool = false

# stage globals
var play_tutorial:bool = false
var stage_number:int = 1
var out_of_bounds_y_pos:float = -200
var base_scale:float = 1.5

const INIT_PLAT_SIZE:float = 1.5
const MIN_PLAT_SIZE:float = 0.3
const OOB_DISPL:float = -50.0

# player gobals
var current_collected_coins:int = 0
var total_collected_coins:int = 0
var collected_fireworks:int = 0
	
