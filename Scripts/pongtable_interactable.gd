extends Interactable

@onready var camera_anchor := $Screen/CameraAnchor

var current_player

func interact(player):
	if !active:
		return

	active = false
	current_player = player
	current_player.enter_table_view(camera_anchor.global_transform)
	
	if($Screen/PongViewport/Pong): $Screen/PongViewport/Pong.activate()

func _process(delta):
	if !current_player: return

	if Input.is_action_pressed("cancel"):
		cancel()

func cancel():
	if($Screen/PongViewport/Pong): $Screen/PongViewport/Pong.deactivate()
	
	current_player.exit_table_view()
	current_player = null
	
	active = true
