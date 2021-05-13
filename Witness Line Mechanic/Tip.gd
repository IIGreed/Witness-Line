extends Position2D

#Turn Line2D visibility on in the Editor
#This is the Version using a Line2D the movement is smoother but I'm having trouble 
#snapping the line to a single axis and implementing the backtrack ;(  

onready var map  :TileMap = get_parent()
onready var line :Line2D  = get_parent().get_node("Line2D")

const DIRECTIONS :Array = [Vector2.UP,Vector2.LEFT,Vector2.DOWN,Vector2.RIGHT]

var bounding_box :Array = [Vector2.ZERO,Vector2.ZERO,Vector2.ZERO,Vector2.ZERO] 

var RAYS   :Array

var curr_mouse_pos :Vector2
var last_mouse_pos :Vector2

var last_tile   :Vector2 = Vector2(0,2)
var target_tile :Vector2
var route       :Array = [Vector2(0,2)]

var active = false

func _ready():
	last_mouse_pos = get_global_mouse_position()

	for child in get_children():
		RAYS.append(child)
		child.get_collision_point()

#	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func get_mouse_dir(vector):
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

	return dir

static func invert_vector(vector:Vector2):
	return Vector2(int(vector.x*-1),int(vector.y*-1))


func _input(event):
	if event.is_action_pressed("ui_accept"):
		print(bounding_box)
	
	if event is InputEventMouseMotion:
		var tile_pos = map.world_to_map(position)
		var dir      = get_mouse_dir(event.relative)
		var ray_id   = DIRECTIONS.find(dir)

		for x in DIRECTIONS.size():
			var ray :RayCast2D = RAYS[x]
			var normal = ray.get_collision_point() + ray.get_collision_normal()*16
			bounding_box[x] = normal - global_position

		if bounding_box[ray_id] == Vector2.ZERO:
			return
		
		match dir:
			Vector2.RIGHT:
				position += Vector2(clamp(event.relative.x,0,bounding_box[ray_id].x),0)
			Vector2.LEFT:
				position += Vector2(clamp(event.relative.x,bounding_box[ray_id].x,0),0)
			Vector2.DOWN:
				position += Vector2(0,clamp(event.relative.y,0,bounding_box[ray_id].y))
			Vector2.UP:
				position += Vector2(0,clamp(event.relative.y,bounding_box[ray_id].y,0))
		
		get_tip_tile(dir)

func get_tip_tile(dir):
	var curr_tile = map.world_to_map(global_position)
	var tile_pos  = map.map_to_world(curr_tile)

	if route.has(curr_tile):
		var last_point_id :int = line.get_point_count()-1
		line.set_point_position(last_point_id,global_position)
		
	else:
		
		if curr_tile != route[-1]:
#			line.add_point(tile_pos)
			line.add_point(global_position)
			route.append(curr_tile)
		
		
			last_tile = curr_tile
