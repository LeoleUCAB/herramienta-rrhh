extends Camera2D

const MAX_ZOOM_LEVEL = 0.5
const MIN_ZOOM_LEVEL = 28
const ZOOM_INCREMENT = 0.05
const CALENDAR_WIDTH = 1280
const CALENDAR_HEIGHT = 720

#signal moved()
signal yearZoomed(zoomLevel)

var deltaValue = 0

var _current_zoom_level = 28
var _drag = false

func _ready():
	pass

func _process(delta):
	deltaValue = delta
	
	## If camera moves out of bounds, it moves it back in bounds.
	if get_offset()[0] < 0:
		set_offset(Vector2(0, get_offset()[1]))
	elif get_offset()[0] > CALENDAR_WIDTH * ZOOM_INCREMENT * ((MIN_ZOOM_LEVEL - zoom[0]) * 20):
		set_offset(Vector2(CALENDAR_WIDTH * ZOOM_INCREMENT * ((MIN_ZOOM_LEVEL - zoom[0]) * 20), get_offset()[1]))
	if get_offset()[1] < 0:
		set_offset(Vector2(get_offset()[0], 0))
	elif get_offset()[1] > CALENDAR_HEIGHT * ZOOM_INCREMENT * ((MIN_ZOOM_LEVEL - zoom[0]) * 20):
		set_offset(Vector2(get_offset()[0], CALENDAR_HEIGHT * ZOOM_INCREMENT * ((MIN_ZOOM_LEVEL - zoom[0]) * 20)))

func _input(event):
	if current:
		if event.is_action_pressed("cam_drag"):
			_drag = true
		elif event.is_action_released("cam_drag"):
			_drag = false
		elif Input.is_action_pressed("zoom_toggle"):
			if event.is_action("cam_zoom_in"):
				_update_zoom(-ZOOM_INCREMENT * deltaValue * 100, get_local_mouse_position())
			elif event.is_action("cam_zoom_out"):
				_update_zoom(ZOOM_INCREMENT * deltaValue * 100, get_local_mouse_position())
			elif event is InputEventMouseMotion && _drag:
				set_offset(Vector2(get_offset()[0] - event.relative[0]*_current_zoom_level, get_offset()[1]))
			
		if event.is_action_pressed("sector_1"):
			set_offset(Vector2(0, get_offset()[1]))
		elif event.is_action_pressed("sector_2"):
			set_offset(Vector2(CALENDAR_WIDTH / 3.2 * ZOOM_INCREMENT * ((MIN_ZOOM_LEVEL - zoom[0]) * 20), get_offset()[1]))
		elif event.is_action_pressed("sector_3"):
			set_offset(Vector2(CALENDAR_WIDTH / 1.45 * ZOOM_INCREMENT * ((MIN_ZOOM_LEVEL - zoom[0]) * 20), get_offset()[1]))
		elif event.is_action_pressed("sector_4"):
			set_offset(Vector2(CALENDAR_WIDTH * ZOOM_INCREMENT * ((MIN_ZOOM_LEVEL - zoom[0]) * 20), get_offset()[1]))

func _update_zoom(incr, zoom_anchor):
	var old_zoom = _current_zoom_level
	_current_zoom_level += incr
	if _current_zoom_level < MAX_ZOOM_LEVEL:
		_current_zoom_level = MAX_ZOOM_LEVEL
	elif _current_zoom_level > MIN_ZOOM_LEVEL:
		_current_zoom_level = MIN_ZOOM_LEVEL
	if old_zoom == _current_zoom_level:
		return
	
	var zoom_center = zoom_anchor - get_offset()
	var ratio = 1-_current_zoom_level/old_zoom
	set_offset(get_offset() + zoom_center*ratio)
	if _current_zoom_level <= 8:
		_current_zoom_level = 13
		emit_signal("yearZoomed", _current_zoom_level)
	set_zoom(Vector2(_current_zoom_level, _current_zoom_level))

func moveCamera(date):
	var offset = Vector2(0, get_offset()[1])
	var sector = (date.month % 4)
	match sector:
		1:
			offset[0] = 0
		2:
			offset[0] = CALENDAR_WIDTH / 3.2 * ZOOM_INCREMENT * ((MIN_ZOOM_LEVEL - zoom[0]) * 20)
		3:
			offset[0] = CALENDAR_WIDTH / 1.45 * ZOOM_INCREMENT * ((MIN_ZOOM_LEVEL - zoom[0]) * 20)
		0:
			offset[0] = CALENDAR_WIDTH * ZOOM_INCREMENT * ((MIN_ZOOM_LEVEL - zoom[0]) * 20)
		_:
			offset[0] = get_offset()[0]
	set_offset(offset)
