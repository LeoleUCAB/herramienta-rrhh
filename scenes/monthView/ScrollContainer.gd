extends ScrollContainer

onready var vBoxContainer = $VBoxContainer
export var monthScene: PackedScene
export var loadingPlaceholderScene: PackedScene

var newMonthList: Array
var placeholderList: Array

const RANGE = 1
const MAX_SIZE = 100
const MONTHS_IN_YEAR = 12
const WEEKS_IN_YEAR = 52
const AVERAGE_WEEKS_IN_YEAR = 52.21	
const ITEM_HEIGHT = 933
const ITEM_WIDTH = 8876

func _ready():
	for i in range(MAX_SIZE):
		var newYear = Array()
		var newPlaceholderYear = Array()
		for j in MONTHS_IN_YEAR:
			var newMonthDate: Dictionary = {
				"year": 1950 + i,
				"month": j + 1,
				"day": 1,
				"hour": 12,
				"minute": 0,
				"second": 0
			}
			var daysInMonth = getDaysInMonth(newMonthDate.year, newMonthDate.month)
			var weekStart = OS.get_datetime_from_unix_time(OS.get_unix_time_from_datetime(newMonthDate)).weekday #sunday = 0
			var maxWeek = (weekStart + daysInMonth) / 7 
			
			var placeholder = loadingPlaceholderScene.instance()
			placeholder.setWeeks(maxWeek)
			placeholder.setMonth(j)
			if j % 2:
				placeholder.setColor(Color("bfbfbf"))
			placeholder.rect_min_size = Vector2(ITEM_WIDTH, ITEM_HEIGHT * (maxWeek))
			placeholder.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
			newPlaceholderYear.append(placeholder)
			
			var newMonth = monthScene.instance()
			newMonth.setWeekStart(weekStart)
			newMonth.setDaysInMonth(daysInMonth)
			newMonth.setWeeks(maxWeek)
			newMonth.setMonth(j)
			newMonth.rect_min_size = Vector2(ITEM_WIDTH, ITEM_HEIGHT * (maxWeek))
			newMonth.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
			newYear.append(newMonth)
		placeholderList.append(newPlaceholderYear)
		newMonthList.append(newYear)
	
	for placeholderYear in placeholderList:
		for item in placeholderYear:
			vBoxContainer.add_child(item)
		
	yield(get_tree(), "idle_frame") #wait one frame to set scroll, it just works
	
	set_v_scroll(ITEM_HEIGHT*(2021-1950)*AVERAGE_WEEKS_IN_YEAR)
	_on_scroll_ended()
	pass

func _on_scroll_ended():
	var currentVPos = get_v_scroll()
	var lowerLimit = currentVPos / (ITEM_HEIGHT * WEEKS_IN_YEAR) - (RANGE / 2)
	lowerLimit = 0 if lowerLimit < 0 else lowerLimit
	var higherLimit = lowerLimit + RANGE if lowerLimit + RANGE < MAX_SIZE else MAX_SIZE
	var scrollList = Array() + placeholderList
	for i in range(lowerLimit, higherLimit):
		scrollList.remove(i)
		scrollList.insert(i, newMonthList[i])
	
	delete_children(vBoxContainer)
	for scrollYear in scrollList:
		for item in scrollYear:
			vBoxContainer.add_child(item)
	prints("ended", lowerLimit, higherLimit, currentVPos / (ITEM_HEIGHT * WEEKS_IN_YEAR))
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
		
func getDaysInMonth(year, month):
	var isLeapYear: bool
	var daysInMonth: int
	if (year % 4 == 0):
		if (year % 100 == 0):
			if(year % 400 == 0):
				isLeapYear = true
			else:
				isLeapYear = false
		else:
			isLeapYear = true
	else:
		isLeapYear = false
	if month == 2:
		daysInMonth = 28 + isLeapYear as int
	else:
		daysInMonth = 31 - ((month - 1) % 7 % 2) #it just works don't worry about it: http://www.dispersiondesign.com/articles/time/number_of_days_in_a_month
	return daysInMonth
