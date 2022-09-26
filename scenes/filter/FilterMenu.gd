extends ColorRect

export var filterItem: PackedScene

onready var grid = $FilterGrid

var currentMenu: bool = false
var defaultPosition
var userList = [] setget setUserList
var filterItemList = []

signal checkBoxToggle(toggleValue)

# Called when the node enters the scene tree for the first time.

func _ready():
	defaultPosition = rect_position.x - rect_size.x
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

func deleteUserList():
	for item in filterItemList:
		grid.remove_child(item)
		item.queue_free()
	filterItemList = []

func setUserList(value):
	userList = value # {name: String, id: int}
	
	for user in userList:
		var newFilterItem = filterItem.instance()
		newFilterItem.setName(user.name)
		newFilterItem.setColor(user.color)
		newFilterItem.id = user.id
		newFilterItem.rect_min_size.y = 24
		newFilterItem.connect("checkBoxToggle", self, "checkBoxToggle")
		filterItemList.append(newFilterItem)
		grid.add_child(newFilterItem)
	
func checkBoxToggle(toggleValue):
	emit_signal("checkBoxToggle", toggleValue)
