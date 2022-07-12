extends ScrollContainer

onready var vBoxContainer = $VBoxContainer
export var yearScene: PackedScene
export var loadingPlaceholderScene: PackedScene

var newYearList: Array
var placeholderList: Array
var hoverValue = {
	"year": 1900,
	"month": -1
}

signal updateHover(hoverValue)

const RANGE = 5
const MAX_SIZE = 100
const ITEM_HEIGHT = 23000
const ITEM_WIDTH = 35850
const ITEM_MONTH_HEIGHT = 3000
const YEAR_LABEL_HEIGHT = 2483

func _ready():
	for i in range(MAX_SIZE):
		var placeholder = loadingPlaceholderScene.instance()
		placeholder.setYear(1950 + i)
		placeholder.rect_min_size = Vector2(ITEM_WIDTH, ITEM_HEIGHT)
		placeholder.set_mouse_filter(Control.MOUSE_FILTER_PASS)
		placeholderList.append(placeholder)
		
		var newYear = yearScene.instance()
		newYear.setYear(1950 + i)
		newYear.rect_min_size = Vector2(ITEM_WIDTH, ITEM_HEIGHT)
		newYear.set_mouse_filter(Control.MOUSE_FILTER_PASS)
		newYear.connect("updateYearHover", self, "updateYearHover")
		newYearList.append(newYear)
	
	for item in placeholderList:
		vBoxContainer.add_child(item)
		
	yield(get_tree(), "idle_frame") #wait one frame to set scroll, it just works
	
	set_v_scroll(ITEM_HEIGHT*(2022-1950))
	_on_scroll_ended()
	pass

func _on_scroll_ended():
	var currentVPos = get_v_scroll()
	var lowerLimit = currentVPos / ITEM_HEIGHT - (RANGE / 2)
	lowerLimit = 0 if lowerLimit < 0 else lowerLimit
	var higherLimit = lowerLimit + RANGE if lowerLimit + RANGE < MAX_SIZE else MAX_SIZE
	
	var scrollList = Array() + placeholderList
	for i in range(lowerLimit, higherLimit):
		scrollList.remove(i)
		scrollList.insert(i, newYearList[i])
	
	delete_children(vBoxContainer)
	for item in scrollList:
		vBoxContainer.add_child(item)
	prints("ended", lowerLimit, higherLimit, currentVPos / ITEM_HEIGHT)
	pass
	
static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)

# I really don't ike this implementation BUT IT WORKS
# This stops the scroll window from scrolling if you're using the wheel for anything else.
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and (event.button_index == BUTTON_WHEEL_DOWN || event.button_index == BUTTON_WHEEL_UP):
		set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	else:
		set_mouse_filter(Control.MOUSE_FILTER_STOP)

func updateYearHover(value):
	if value.year != hoverValue.year or value.month != hoverValue.month:
		hoverValue.year = value.year
		hoverValue.month = value.month
		emit_signal("updateHover", hoverValue)
		
func goToDate(date):
	set_v_scroll(ITEM_HEIGHT*(date.year-1950) - YEAR_LABEL_HEIGHT / 7 * 4 + ITEM_MONTH_HEIGHT * floor((date.month - 1) / 4))
	pass
