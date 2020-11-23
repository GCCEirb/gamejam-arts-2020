extends TextureRect

export var m_currentCameraPath: String;

var m_currentCamera: Camera2D;

# Called when the node enters the scene tree for the first time.
func _ready():
	m_currentCamera = get_node(m_currentCameraPath) as Camera2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var viewDir = (get_transform().get_origin() - m_currentCamera.get_camera_position()).normalized()
	get_material().set_shader_param("viewDir", viewDir)
