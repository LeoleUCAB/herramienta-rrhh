extends ScrollContainer

func _ready() -> void:
	pass

# I really don't ike this implementation BUT IT WORKS
# This stops the scroll window from scrolling if you're using the wheel for anything else.
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and (event.button_index == BUTTON_WHEEL_DOWN || event.button_index == BUTTON_WHEEL_UP):
		set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	else:
		set_mouse_filter(Control.MOUSE_FILTER_STOP)
