extends Label

@onready var pong = $".."

func _ready() -> void:
	text = str(pong.current_score)
	pong.score_changed.connect(_on_score_changed)
	
func _on_score_changed(score: int) -> void:
	text = str(score)
