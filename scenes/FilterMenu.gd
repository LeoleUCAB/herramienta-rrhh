extends ColorRect


var toggled: bool = false
var defaultPosition

# Called when the node enters the scene tree for the first time.
func _ready():
	defaultPosition = rect_position.x
	pass # Replace with function body.


func _process(delta):
	if toggled:
		if rect_position.x >= defaultPosition - rect_size.x + 5:
			rect_position.x -= 200 * delta
	else:
		if rect_position.x < defaultPosition:
			rect_position.x += 200 * delta
	pass


func _on_FilterButton_pressed():
	toggled = !toggled
