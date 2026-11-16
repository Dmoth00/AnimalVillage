extends CharacterBody3D

@onready var anim=$drowner/AnimationPlayer
@onready var mesh=$drowner/ArmDrown

@onready var target : Node3D

var state=0
var t = 0.0
var speed = 6.0

func _ready() -> void:
	anim.speed_scale=speed/2

func _physics_process(delta: float) -> void:
	
	if !is_on_floor():
		velocity.y -= gvars.gravity * delta * 8
	
	match state:
		0:
			velocity=basis.z*speed
			var col= move_and_collide(delta*velocity)
			if col:
				velocity.bounce(col.get_normal())
				var ldir=NewFunc.flat(velocity)
				look_at(ldir+global_position,Vector3.UP)
				
			t+=delta
			if t>0.5:
				t=0
				rotate_y(deg_to_rad(15))

func _on_seek_player_timeout() -> void:
	target=NewFunc.nearest_in_group("Player",transform.origin)
	pass # Replace with function body.
