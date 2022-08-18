extends ColorRect

export var filterItem: PackedScene

onready var grid = $FilterGrid

var toggled: bool = false
var defaultPosition
var userList = [] setget setUserList

signal checkBoxToggle(toggleValue)

# Called when the node enters the scene tree for the first time.

func _ready():
	defaultPosition = rect_position.x - rect_size.x
	pass # Replace with function body.


func _process(delta):
	if toggled:
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


func _on_FilterButton_pressed():
	toggled = !toggled

func setUserList(value):
	userList = value # {name: String, id: int}
	
	for user in userList:
		var newFilterItem = filterItem.instance()
		newFilterItem.setName(user.name)
		newFilterItem.setColor(user.color)
		newFilterItem.id = user.id
		newFilterItem.rect_min_size.y = 24
		newFilterItem.connect("checkBoxToggle", self, "checkBoxToggle")
		grid.add_child(newFilterItem)
	
func checkBoxToggle(toggleValue):
	emit_signal("checkBoxToggle", toggleValue)
