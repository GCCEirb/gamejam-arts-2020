extends TileMap

export var _ambient: float;
export var _specular: float;
export var _lightDir: Vector3;

var _totalTime;

func _ready():
	_totalTime = 0.0

func _process(delta):
	_lightDir.x = cos(_totalTime)
	_lightDir.y = sin(_totalTime)
	_lightDir.z = 0.5
	_lightDir = _lightDir.normalized()
	var tile_ids = self.tile_set.get_tiles_ids()
	for tid in tile_ids:
		if (tile_set.tile_get_material(tid)):
			tile_set.tile_get_material(tid).set_shader_param("lightDir", _lightDir)
			tile_set.tile_get_material(tid).set_shader_param("ambient", _ambient)
			tile_set.tile_get_material(tid).set_shader_param("specular", _specular)
	_totalTime += delta
