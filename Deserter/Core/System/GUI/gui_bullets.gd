extends RichTextLabel
@onready var cham=$chamber

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	cham.size.x=gvars.gun*32
	text= "[center]Bullets: "+str(gvars.bullets).pad_zeros(3)+"[/center]"
	pass
