extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENS = 0.002

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var current_interactable: Interactable = null

var in_table_view := false

@onready var camera_pivot = $CameraPivot
@onready var interaction_prompt = $"/root/Main/CanvasLayer/InteractionPanel/InteractionPrompt"

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	interaction_prompt.visible = false

func _unhandled_input(event):
	if in_table_view: return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENS)
		camera_pivot.rotate_x(-event.relative.y * MOUSE_SENS)

		camera_pivot.rotation.x = clamp(
			camera_pivot.rotation.x,
			deg_to_rad(-89),
			deg_to_rad(89)
		)
		
func _process(_delta):
	if in_table_view: return
	if current_interactable and current_interactable.active:
		if Input.is_action_just_pressed("interact"):
			current_interactable.interact(self)
	
func _physics_process(delta):
	if in_table_view: return
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
        "move_back"
	)

	var direction = (
		transform.basis *
		Vector3(input_dir.x, 0, input_dir.y)
	).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _on_interact_area_body_entered(body: Node3D) -> void:
	if body is Interactable:
		if current_interactable == null: 
			current_interactable = body
			
			current_interactable.state_changed.connect(_on_interactable_state_changed)
			
			var key = InputMap.action_get_events("interact")[0].as_text().split(" ")[0]
			interaction_prompt.text = "[%s] %s" % [key,current_interactable.interaction_text]
			interaction_prompt.modulate = Color.WHITE if current_interactable.active else Color.GRAY
			interaction_prompt.visible = true
			
func _on_interact_area_body_exited(body: Node3D) -> void:
	if body is Interactable:
		if current_interactable == body:
			current_interactable.state_changed.disconnect(_on_interactable_state_changed)
			current_interactable = null
			
			interaction_prompt.text = ""
			interaction_prompt.visible = false
			
func _on_interactable_state_changed(active: bool):
	interaction_prompt.modulate = Color.WHITE if active else Color.GRAY

func enter_table_view(target_transform: Transform3D):
	in_table_view = true

	set_process(false)
	set_physics_process(false)
	
	interaction_prompt.visible = false
	move_camera_to(target_transform, 0.6)
	
func exit_table_view():
	in_table_view = false

	set_process(true)
	set_physics_process(true)

	if current_interactable: interaction_prompt.visible = true
	move_camera_to($CameraPivot.global_transform, 0.6)
	
func move_camera_to(transform: Transform3D, duration: float):
	var tween = create_tween()

	tween.tween_property($CameraPivot/Camera3D, "global_transform", transform, duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
