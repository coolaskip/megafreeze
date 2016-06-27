extends Node2D

# Member variables
var speed = 60 setget speed_set,speed_get
var offset = 0 setget ,offset_get

func offset_get():
	return offset

func speed_set(s):
	speed = s
	
func speed_get():
	return speed

func stop():
	set_process(false)

func _process(delta):
	offset -= delta*speed
	set_pos(Vector2(0, offset))

func _ready():
	set_process(true)
