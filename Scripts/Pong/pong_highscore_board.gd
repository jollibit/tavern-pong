extends Node3D


@onready var pongs = get_tree().get_nodes_in_group("pong")
@onready var label = $HighscoreLabel.mesh
 
var highscore := 0

func _ready() -> void:
	for pong in pongs: 
		if pong.highscore > highscore: 
			highscore = pong.highscore
		pong.highscore_changed.connect(_on_highscore_changed)
	
	_update_label()

func _on_highscore_changed(new_highscore: int) -> void:
	if new_highscore > highscore:
		highscore = new_highscore
	
	_update_label()
	
func _update_label() -> void:
	label.text = str(highscore)
