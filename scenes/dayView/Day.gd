extends Control

var appointmentList: Array = Array()

onready var hours = [
	$Hours/AllDay/Content/GridContainer,
	$Hours/'0h'/Content/GridContainer,
	$Hours/'8h'/Content/GridContainer,
	$Hours/'9h'/Content/GridContainer,
	$Hours/'10h'/Content/GridContainer,
	$Hours/'11h'/Content/GridContainer,
	$Hours/'12h'/Content/GridContainer,
	$Hours/'13h'/Content/GridContainer,
	$Hours/'14h'/Content/GridContainer,
	$Hours/'15h'/Content/GridContainer,
	$Hours/'16h'/Content/GridContainer,
	$Hours/'17h'/Content/GridContainer,
	$Hours/'24h'/Content/GridContainer,
]
const GRID_WIDTH = 945
const GRID_HEIGHT = 67
const GRID_MARGIN = 5
const GRID_H_SEPARATION = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	generateRandomAppointments()
	appointmentList.sort_custom(sortAppointments, "sortByWeight")
	for i in hours.size():
		var hourAppointments = Array()
		var hour = hours[i]
		var currentTime = i + 6
		if i == 0:
			continue
		for appointment in appointmentList:
			if i == 1 && appointment.start <= 8:
				hourAppointments.append(appointment)
			elif i == hours.size() - 1 && appointment.end > 17:
				hourAppointments.append(appointment)
			elif currentTime >= appointment.start && currentTime <= appointment.end:
				hourAppointments.append(appointment)
		if !hourAppointments.empty():
			addAppointment(hour, hourAppointments)
	pass # Replace with function body.
	
func maxColumns():
	pass

func addAppointment(hour, appointments):
	var size = appointments.size()
	var rectWidth = ((GRID_WIDTH - GRID_MARGIN) / size) - (GRID_H_SEPARATION)
	var rectHeight = GRID_HEIGHT - GRID_MARGIN
	hour.columns = size #change this, has to be global
	for appointment in appointments:
		var newAppointment = ColorRect.new()
		newAppointment.color = appointment.color
		newAppointment.rect_min_size = Vector2(rectWidth, rectHeight)
		hour.add_child(newAppointment)

func generateRandomAppointments():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var colorList = [
		Color.aqua,
		Color.coral,
		Color.indigo,
		Color.orangered,
		Color.orchid,
		Color.gold
	]
	for i in range(rng.randi_range(0, 6)):
		var start = rng.randi_range(0, 24)
		var end = rng.randi_range(start, 24)
		var color = colorList[i]
		var newAppointment = {
			"start": start,
			"end": end,
			"color": color,
			"weight": null,
			"level": null
		}
		appointmentList.append(newAppointment)
	var debugAppointment = [
		{
			"start": 2,
			"end": 24,
			"color": colorList[0],
			"weight": null,
			"level": null
		},
		{
			"start": 2,
			"end": 13,
			"color": colorList[1],
			"weight": null,
			"level": null
		},
		{
			"start": 2,
			"end": 12,
			"color": colorList[2],
			"weight": null,
			"level": null
		},
		{
			"start": 2,
			"end": 11,
			"color": colorList[3],
			"weight": null,
			"level": null
		},
		{
			"start": 2,
			"end": 10,
			"color": colorList[4],
			"weight": null,
			"level": null
		},
		{
			"start": 2,
			"end": 9,
			"color": colorList[5],
			"weight": null,
			"level": null
		}
	]
	appointmentList.append_array(debugAppointment)
	
func setWeight(appointments):
	for appointment in appointments:
		var dateRange = Vector2(0, 24)
		if dateRange[0] < appointment.start: 
			dateRange[0] = appointment.start
		if dateRange[1] > appointment.end:
			dateRange[1] = appointment.end
		var weight = dateRange[1] - dateRange[0] + 1
		if weight > 12: 
			weight = 12
		appointment.weight = weight

class sortAppointments:
	static func sortByStartDate(a, b):
		if a.start <= b.start:
			return true
		return false
	
	static func sortByWeight(a, b):
		if a.weight > b.weight:
			return true
		elif a.weight == b.weight:
			return sortByStartDate(a, b)
		return false
		
	static func sortByLevel(a, b):
		if a.level < b.level:
			return true
		if a.level == b.level:
			return sortByStartDate(a, b)
		return false
