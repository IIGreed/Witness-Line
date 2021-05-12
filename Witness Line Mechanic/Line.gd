extends TileMap


onready var map = get_parent()
onready var line = get_node("Line2D")
var tiles
var active :bool = true

var start_tile  :Vector2 = Vector2(0,2)

var curr_tile   :Vector2 = start_tile
var last_tile   :Vector2
var target_tile :Vector2
var route:Array

var vector  :Vector2 = Vector2.ZERO
var point_v :Vector2


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	tiles = map.get_used_cells()

func get_mouse_dir():
	var dir :Vector2
	
	if abs(vector.x) > abs(vector.y):
		if vector.x > 0:
			dir = Vector2.RIGHT
		else:
			dir = Vector2.LEFT

	else:
		if vector.y > 0:
			dir = Vector2.DOWN
		else:
			dir = Vector2.UP

	vector = Vector2.ZERO

	return dir


func _input(event):
	if event is InputEventMouseMotion:
		var tile_pos = map.world_to_map(position)
		var dir

		vector += event.relative

		if vector.length() >= 32:
			dir = get_mouse_dir()

			if not tiles.has(curr_tile + dir):
				return

			if route.has(curr_tile+dir) && curr_tile != start_tile:
				if curr_tile + dir == route[-2]:
					set_cellv(curr_tile,-1)
					route.erase(curr_tile)
				else:
					return

			else:
				set_cellv(curr_tile + dir, 0)
				route.append(curr_tile + dir)
			
			last_tile = curr_tile
			curr_tile += dir
