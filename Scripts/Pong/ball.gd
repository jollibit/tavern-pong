class_name Ball
extends CharacterBody2D

@export var speed := 500.0
@export var accel := 1.03
@export var max_speed := 1200.0

@onready var pong = $".."

var direction := Vector2.ZERO

func _ready():
	pong.state_changed.connect(_on_state_changed)
	reset_ball()

func reset_ball():
	global_position = Vector2(0, 0)

	var angle = randf_range(-0.4, 0.4)
	var side = [-1, 1].pick_random()

	direction = Vector2(side, angle).normalized()

	speed = 0
	
func _physics_process(delta):
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		handle_collision(collision)
		
func handle_collision(collision: KinematicCollision2D):
	var normal = collision.get_normal()
	var collider = collision.get_collider()

	# If we hit a paddle → angle-based reflection
	if collider.name.contains("Paddle"):
		var offset = global_position.y - collider.global_position.y

		var paddle_height = 64.0
		var t = offset / paddle_height

		# clamp so it doesn't go crazy
		t = clamp(t, -1.0, 1.0)

		var angle = t * 0.75  # max bounce angle

		direction.x = -direction.x
		direction.y = angle
		direction = direction.normalized()

	else:
		direction = direction.bounce(normal)

	speed = min(speed * accel, max_speed)

func _on_state_changed(state :bool):
	if(state): speed = 500
	else: 
		reset_ball()
		speed = 0
