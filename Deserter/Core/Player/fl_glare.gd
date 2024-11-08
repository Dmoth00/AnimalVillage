extends MeshInstance3D
@onready var player=get_node("../../../..")
@onready var to = Vector3.FORWARD

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !visible: return
	var ang = to.angle_to(player.ldir)/PI
	var vis = max(0,ang-0.5)
	self.mesh.surface_get_material(0).albedo_color.a = vis
	
	pass
