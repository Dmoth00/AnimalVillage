extends RichTextLabel
@onready var bld=gvars.blood


func _process(delta: float) -> void:
	bld=lerp(bld,gvars.blood,delta*4)
	text="Blood: "+str(snapped(bld,0.01)).pad_decimals(2)+" Lts"
