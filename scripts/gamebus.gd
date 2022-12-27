extends Node

signal portal_entered()
signal game_over()
signal out_of_bounds_y()

var play_tutorial:bool = true

var stage_number:int = 0
var out_of_bounds_y_pos:float = -50
var current_collected_coins:int = 0
var total_collected_coins:int = 0
var collected_fireworks:int = 0
