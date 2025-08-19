extends RichTextLabel
@onready var cham=$chamber
@onready var reload=$reload

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	cham.size.x=gvars.gun*32
	if gvars.gun>0: reload.visible=false
	else: reload.visible=true
	text= "[center]Bullets: "+str(gvars.bullets).pad_zeros(3)+"[/center]"
	pass
