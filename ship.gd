
extends Area2D

# member variables here, example:
# var a=2
# var b="textvar"
var icecube = preload("res://icecube.tscn")
var shooting_time = 0
var shooting = false
var killed = false
var COOLDOWN = 0.3

func _ready():
	set_process(true)

func _process(delta):
	var pos = get_viewport().get_mouse_pos()
	var shoot = Input.is_mouse_button_pressed(BUTTON_LEFT)
	var sprite = get_node("sprite")

	if pos != Vector2():
		if (pos.x > get_pos().x):
			sprite.set_frame(1)
			sprite.set_flip_h(false)
		elif (pos.x < get_pos().x):
			sprite.set_frame(1)
			sprite.set_flip_h(true)
		else:
			sprite.set_frame(0)
		set_pos(pos)

	if shoot and shooting_time > COOLDOWN:
		shooting = false
		shooting_time = 0

	if shoot and not shooting:
		shooting = true
		var cube = icecube.instance()
		pos.y -= 10
		cube.set_pos(pos)
		get_parent().add_child(cube)
		get_node("sfx").play("shoot")
	
	if shooting:
		shooting_time += delta
		
	# Update points counter
	get_node("../hud/score").set_text(str(get_node("/root/game_state").points))

func _hit_something():
	if (killed):
		return
	killed = true
	get_node("explosion").set_emitting(true)
	get_node("sprite").set_modulate(Color(0, 0, 0, 1))
	get_node("sfx").play("explosion")
	get_node("sfx").play("lose")
	get_node("../hud/game_over").show()
	get_node("/root/game_state").game_over()
	get_parent().stop()
	set_process(false)

func _on_ship_area_enter(area):
	if (area.has_method("is_enemy") and area.is_enemy()):
		_hit_something()
