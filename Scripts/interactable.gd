class_name Interactable
extends StaticBody3D

signal state_changed(active: bool)

@export var interaction_text := "Interact"
@export var active := true:
	set(value):
		if active == value:
			return
		active = value
		state_changed.emit(active)

func interact(player):
	pass
