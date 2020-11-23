extends TextureRect

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
	get_material().set_shader_param("lightDir", _lightDir)
	get_material().set_shader_param("ambient", _ambient)
	get_material().set_shader_param("specular", _specular)
	_totalTime += delta
