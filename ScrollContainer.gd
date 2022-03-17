extends ScrollContainer

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and (event.button_index == BUTTON_WHEEL_DOWN || event.button_index == BUTTON_WHEEL_UP):
		set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	else:
		set_mouse_filter(Control.MOUSE_FILTER_STOP)
