extends Node

signal portal_entered()
signal game_over()

var stage_number:int = 0
var out_of_bounds_y: float = -50
var current_collected_coins:int = 0
var total_collected_coins:int = 0
