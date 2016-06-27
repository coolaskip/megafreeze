extends Node2D

var meteor = preload("res://meteor.tscn")
var big_meteor = preload("res://big_meteor.tscn")
var inter_level = preload("res://inter_level.tscn")
var level = 1
var global_y = 0

func _enter_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_viewport().set_size_override(true, Vector2(200, 320), Vector2(0, 0))
	get_viewport().set_size_override_stretch(true)

func add_meteor(pos, velocity):
	var m = meteor.instance()
	m.get_node("meteor").direction = velocity
	add_child(m)
	m.set_pos(pos)

func add_big_meteor(pos):
	var m = big_meteor.instance()
	var size = m.get_node("sprite").get_texture().get_size()
	add_child(m)
	pos += Vector2((67-size.x)/2, -(100-size.y)/2)
	m.set_pos(pos)

func add_inter_level(y, level):
	var l = inter_level.instance()
	var lt = l.get_node("level_text")
	lt.set_text("Level " + str(level))
	add_child(l)
	var x = (200 - lt.get_size().x) / 2
	l.set_pos(Vector2(x, y))
	
func line(p1, p2, steps, direction):
	var dir = p2 - p1
	var increment = dir / (steps+1)
	var pos = p1
	for i in range(steps):
		pos += increment
		add_meteor(pos, direction)

func square(config, size, steps):
	var p1 = Vector2(config.x, config.y)
	for y in range(steps):
		var p2 = p1 + Vector2(size.x, 0)
		line(p1, p2, steps, config.velocity)
		p1 = p1 + Vector2(0, size.y/steps)

func random_rectangle(config, size, number):
	var x = config.x
	var y = config.y
	for n in range(number):
		var pos = Vector2(rand_range(x, x + size.x), rand_range(y, y + size.y))
		add_meteor(pos, config.velocity)

func row_unit(config, size):
	var i = randi() % 5
	if i == 0:
		square(config, size, 3)
	elif i == 1: 
		random_rectangle(config, size, 3)
	elif i == 2:
		line(Vector2(config.x, config.y) , Vector2(config.x + size.x, config.y + size.y), 5, config.velocity)
	elif i == 3:
		add_big_meteor(Vector2(config.x, config.y))
	else:
		pass
	
func row(config):
	var size = Vector2(67, -100)
	row_unit(config, size)
	config.x += 67
	row_unit(config, size)
	config.x += 67
	row_unit(config, size)

func wave(level):
	randomize()
	var config = {
		x = 0,
		y = global_y,
		velocity = Vector2(0, 0)
	}

	for y in range(0, -600, -100):
		config.x = 0
		config.y -= 100
		row(config)
	
	global_y = config.y-200
	add_inter_level(global_y + 50, level)
	get_node("level_ending").set_pos(Vector2(0, config.y-100))
	
func _ready():
	pass

func _on_level_ending_enter_screen():
	level += 1
	get_node("rail").speed += 10
	wave(level)
