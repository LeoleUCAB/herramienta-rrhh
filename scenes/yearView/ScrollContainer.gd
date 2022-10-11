extends ScrollContainer

onready var vBoxContainer = $VBoxContainer
onready var scrollContainer = $"."
export var yearScene: PackedScene
export var loadingPlaceholderScene: PackedScene

var pagination = {} setget setPagination
var appointmentList = []
var newYearList: Array
var placeholderList: Array
var hoverValue = {
	"year": 1900,
	"month": -1
}
var clickValue = {
	"year": 1900,
	"month": -1,
	"day": -1
}

var swiping = false
var swipe_start
var swipe_mouse_start
var swipe_mouse_times = []
var swipe_mouse_positions = []

signal updateHover(hoverValue)
signal updateClick(clickValue)

const RANGE = 5
const MAX_SIZE = 100
const ITEM_HEIGHT = 23000
const ITEM_WIDTH = 35850
const ITEM_MONTH_HEIGHT = 3000
const YEAR_LABEL_HEIGHT = 2483

func _ready():
	for i in range(MAX_SIZE):
		var year = 1950 + i
		var placeholder = loadingPlaceholderScene.instance()
		placeholder.setYear(year)
		placeholder.rect_min_size = Vector2(ITEM_WIDTH, ITEM_HEIGHT)
		placeholder.set_mouse_filter(Control.MOUSE_FILTER_PASS)
		placeholderList.append(placeholder)
		
		var newYear = yearScene.instance()
		newYear.setYear(year)
		newYear.rect_min_size = Vector2(ITEM_WIDTH, ITEM_HEIGHT)
		newYear.set_mouse_filter(Control.MOUSE_FILTER_PASS)
		newYear.connect("updateYearHover", self, "updateYearHover")
		newYear.connect("updateYearClick", self, "updateYearClick")
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
	pass
	
static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)

# I really don't ike this implementation BUT IT WORKS
# This stops the scroll window from scrolling if you're using the wheel for anything else.
func _input(ev: InputEvent) -> void:
	if (ev is InputEventMouseButton and (ev.button_index == BUTTON_WHEEL_DOWN || ev.button_index == BUTTON_WHEEL_UP)) and Input.is_action_pressed("zoom_toggle"):
		set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	else:
		set_mouse_filter(Control.MOUSE_FILTER_STOP)
	
#	if ev is InputEventMouseButton:
#		if ev.pressed:
#			swiping = true
#			swipe_start = Vector2(get_h_scroll(), get_v_scroll())
#			swipe_mouse_start = ev.position
#			swipe_mouse_times = [OS.get_ticks_msec()]
#			swipe_mouse_positions = [swipe_mouse_start]
#		else:
#			swipe_mouse_times.append(OS.get_ticks_msec())
#			swipe_mouse_positions.append(ev.position)
#			var source = Vector2(get_h_scroll(), get_v_scroll())
#			var idx = swipe_mouse_times.size() - 1
#			var now = OS.get_ticks_msec()
#			var cutoff = now - 100
#			for i in range(swipe_mouse_times.size() - 1, -1, -1):
#				if swipe_mouse_times[i] >= cutoff: idx = i
#				else: break
#			var flick_start = swipe_mouse_positions[idx]
#			var flick_dur = min(0.3, (ev.position - flick_start).length() / 1000)
#			if flick_dur > 0.0:
#				var tween = Tween.new()
#				add_child(tween)
#				var delta = ev.position - flick_start
#				var target = (source - delta * flick_dur * 15.0)
#				tween.interpolate_method(self, 'set_h_scroll', source.x, target.x, flick_dur, Tween.TRANS_LINEAR, Tween.EASE_OUT)
#				tween.interpolate_method(self, 'set_v_scroll', source.y, target.y, flick_dur, Tween.TRANS_LINEAR, Tween.EASE_OUT)
#				tween.interpolate_callback(tween, flick_dur, 'queue_free')
#				tween.start()
#				_on_scroll_ended()
#			swiping = false
#	elif swiping and ev is InputEventMouseMotion:
#		var delta = ev.position - swipe_mouse_start
#		set_h_scroll(swipe_start.x - delta.x)
#		set_v_scroll(swipe_start.y - delta.y)
#		swipe_mouse_times.append(OS.get_ticks_msec())
#		swipe_mouse_positions.append(ev.position)

func updateYearHover(value):
	if value.year != hoverValue.year or value.month != hoverValue.month:
		hoverValue.year = value.year
		hoverValue.month = value.month
		emit_signal("updateHover", hoverValue)
		
func updateYearClick(value):
	if value.year != clickValue.year or value.month != clickValue.month or value.day != clickValue.day:
		clickValue.year = value.year
		clickValue.month = value.month
		clickValue.day = value.day
		emit_signal("updateClick", clickValue)
		
func goToDate(date):
	set_v_scroll(ITEM_HEIGHT*(date.year-1950) - YEAR_LABEL_HEIGHT / 7 * 4 + ITEM_MONTH_HEIGHT * floor((date.month - 1) / 4))
	pass

func setPagination(value, default=true):
	pagination = value
	
	var yearPagination = {}
	for yearItem in newYearList:
		var year = yearItem.year
		if pagination.has(year):
			for page in pagination[year]:
				yearItem.appointmentList.append(appointmentList[page])
				var index = yearItem.appointmentList.size() - 1
				for month in range(appointmentList[page].start.month(), appointmentList[page].end.month() + 1):
					if !yearPagination.has(month):
						yearPagination[month] = [index]
						continue
					yearPagination[month].append(index)
			yearItem.pagination = yearPagination
		if !default:
			yearItem.setPagination()
