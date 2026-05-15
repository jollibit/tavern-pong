extends Label

@export var speed := 1.0
var hue := 0.0

func _process(delta):
	hue = fmod(hue + delta * speed, 1.0)
	add_theme_color_override("font_color", Color.from_hsv(hue, 1.0, 1.0))
