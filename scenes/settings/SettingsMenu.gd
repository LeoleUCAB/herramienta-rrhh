extends ColorRect

var currentMenu: bool = false
var defaultPosition

onready var colorDropdown = $ColorOptions

# Called when the node enters the scene tree for the first time.

func _ready():
	defaultPosition = rect_position.x - rect_size.x
	colorDropdown.add_item("Default", 0)
	colorDropdown.add_item("Colorblind (Wong)", 1)
	colorDropdown.add_item("Colorblind (Tol Bright)", 2)
	pass # Replace with function body.


func _process(delta):
	if currentMenu:
		if rect_position.x > defaultPosition:
			var newPosition = rect_position.x - 200 * delta
			if newPosition < defaultPosition:
				rect_position.x = defaultPosition
			else:
				rect_position.x = newPosition
	else:
		if rect_position.x < defaultPosition + rect_size.x:
			rect_position.x += 200 * delta
	pass

func changeState(value):
	currentMenu = value
