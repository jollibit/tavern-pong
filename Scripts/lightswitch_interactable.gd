extends Interactable

@export var is_on := true
@export var transition_time := 1.0

@onready var cooldown_timer := Timer.new()
@onready var light := $Light

func _ready() -> void:
	interaction_text = "Toggle Light"
	
	cooldown_timer.one_shot = true
	cooldown_timer.wait_time = transition_time
	cooldown_timer.timeout.connect(_on_cooldown_finished)
	add_child(cooldown_timer)
	
	light.light_energy = 1.0 if is_on else 0

func interact(player):
	if !active:
		return

	active = false

	is_on = !is_on

	var target = 1.0 if is_on else 0.0
	fade_light(target, transition_time)

	cooldown_timer.start()

func _on_cooldown_finished():
	active = true
	
func fade_light(target_energy: float, duration: float) -> void:
	var tween = create_tween()

	tween.tween_property(
		light,
		"light_energy",
		target_energy,
		duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
