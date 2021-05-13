extends Node2D

#Draw the Grid

func _draw():
	for x in 21:
		# Draw x
		draw_line(Vector2(position.x,x*32),Vector2(32*20,x*32),Color(0.5, 0.5, 0.5, 0.25),0.5)
		# Draw y
		draw_line(Vector2(x*32,position.y),Vector2(x*32,32*20),Color(0.5, 0.5, 0.5, 0.25),0.5)
