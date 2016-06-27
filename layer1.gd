extends ParallaxLayer

var asteroid = preload("res://bg_asteroid.tscn")

func _ready():
	for i in range(40):
		var sprite = asteroid.instance()
		add_child(sprite)
		sprite.set_scale(Vector2(0.5, 0.5))
		var screen_size = get_viewport().get_size_override()
		var x = rand_range(-5, screen_size.x + 5)
		var y = rand_range(-5, screen_size.y + 5)
		sprite.set_pos(Vector2(x, y))
	


