extends Camera2D

const MAX_ZOOM_LEVEL = 0.5
const MIN_ZOOM_LEVEL = 9
const ZOOM_INCREMENT = 0.05
const CALENDAR_WIDTH = 1280
const CALENDAR_HEIGHT = 720

#signal moved()
signal monthZoomed(zoomValue)
signal highQualityToggle(value)

var deltaValue = 0

var _current_zoom_level = 6.925
var _drag = false
var highQuality = false

func _ready():
	pass

func _process(delta):
	deltaValue = delta
	
	## If camera moves out of bounds, it moves it back in bounds.
	if get_offset()[0] < -1500:
		set_offset(Vector2(-1500, get_offset()[1]))
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
		elif event is InputEventMouseMotion && _drag:
			set_offset(Vector2(get_offset()[0] - event.relative[0]*_current_zoom_level, get_offset()[1]))
		elif Input.is_action_pressed("zoom_toggle"):
			if event.is_action("cam_zoom_in"):
				_update_zoom(-ZOOM_INCREMENT * deltaValue * 100, get_local_mouse_position())
			elif event.is_action("cam_zoom_out"):
				_update_zoom(ZOOM_INCREMENT * deltaValue * 100, get_local_mouse_position())

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
	var zoomLevel = Vector2(_current_zoom_level, _current_zoom_level)
	if _current_zoom_level >= 8.5:
		_current_zoom_level = 8
		emit_signal("monthZoomed", zoomLevel)
		
	var srLatch: bool = true if _current_zoom_level <= 5 else false
	if srLatch != highQuality:
		highQuality = srLatch
		emit_signal("highQualityToggle", highQuality)
		
	set_zoom(Vector2(_current_zoom_level, _current_zoom_level))
