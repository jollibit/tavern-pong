extends StaticBody2D

@export var speed := 0#420.0
@export var dead_zone := 10.0
@export var reaction_delay := 0.2

@onready var pong = $".."
@onready var ball := $"../Ball"
@onready var starting_position := position

var active = false
var target_y := 0.0
var timer := 0.0

func _ready() -> void:
	pong.state_changed.connect(_on_state_changed)

func _physics_process(delta):
	if !active: return
	
	if ball == null:
		return
	timer -= delta
	
	if timer <= 0.0:
		timer = reaction_delay
		target_y = ball.global_position.y + randf_range(-15.0, 15.0)
	
	var diff = target_y - global_position.y
	
	if abs(diff) < dead_zone:
		return
	
	position.y += sign(diff) * speed * delta
	
	position.y = max(-192, min(192, position.y))

func _on_state_changed(state :bool):
	active = state;
	if !active:
		position = starting_position
