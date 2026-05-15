extends StaticBody2D

@export var speed := 500.0

@onready var pong = $".."
@onready var starting_position := position

var active = false
var direction := 0.0

func _ready() -> void:
	pong.state_changed.connect(_on_state_changed)

func _process(delta):
	if !active: return
	
	if Input.is_action_pressed("move_up"):
		direction = -1.0
	elif Input.is_action_pressed("move_down"):
		direction = 1.0
	else:
		direction = 0.0
		
	position.y += direction * speed * delta
	
	position.y = max(-192, min(192, position.y))

func _on_state_changed(state :bool):
	active = state;
	if !active:
		position = starting_position
