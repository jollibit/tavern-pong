extends MeshInstance3D

@onready var viewport := $PongViewport

func _ready():
	var pong = preload("res://Pong.tscn").instantiate()
	viewport.add_child(pong)

	await get_tree().process_frame

	var mat := StandardMaterial3D.new()
	mat.albedo_texture = viewport.get_texture()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	
	set_surface_override_material(0, mat)
