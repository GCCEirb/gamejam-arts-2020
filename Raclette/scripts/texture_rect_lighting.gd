extends TextureRect

export var _ambient: float;
export var _specular: float;
export var _lightDir: Vector3;

var _totalTime;

func _ready():
	_totalTime = 0.0

func _process(delta):
	_lightDir.x = 0.2*cos(_totalTime)
	_lightDir.y = 1.0
	_lightDir.z = 0.5
	_lightDir = _lightDir.normalized()
	get_material().set_shader_param("lightDir", _lightDir)
	get_material().set_shader_param("ambient", _ambient)
	get_material().set_shader_param("specular", _specular)
	_totalTime += delta
