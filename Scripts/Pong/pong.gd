extends Node2D

signal state_changed(state :bool)
signal score_changed(score: int)
signal highscore_changed(highscore: int)

@onready var cooldown_timer := Timer.new()

var active = false
var current_score := 0
var highscore := 0

func _ready() -> void:
	cooldown_timer.one_shot = true
	cooldown_timer.wait_time = 1
	cooldown_timer.timeout.connect(_on_cooldown_finished)
	add_child(cooldown_timer)
	
func activate() -> void:
	state_changed.emit(true)
	active = true

func deactivate() -> void:
	current_score = 0
	score_changed.emit(current_score)
	
	state_changed.emit(false)
	active = false

func _on_cooldown_finished():
	if !active: return
	state_changed.emit(false)
	state_changed.emit(true)

func _on_goal_left_body_entered(body: Node2D) -> void:
	if body is not Ball: return
	
	current_score += 1
	score_changed.emit(current_score)
	
	if(current_score > highscore): 
		highscore = current_score
		highscore_changed.emit(highscore)
		
	cooldown_timer.start()

func _on_goal_right_body_entered(body: Node2D) -> void:
	if body is not Ball: return
	
	current_score = 0
	score_changed.emit(current_score)
	cooldown_timer.start()
