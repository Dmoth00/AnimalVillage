extends CanvasLayer

#blood meter variables
@onready var blood=$blood
@onready var bld=gvars.blood

#gun HUD variables
@onready var bullets=$bullets
@onready var cham=$bullets/chamber
@onready var reload=$bullets/reload

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#blood meter
	bld=lerp(bld,gvars.blood,delta*4)
	blood.text="Blood: "+str(snapped(bld,0.01)).pad_decimals(2)+" Lts"
	
	#gun HUD
	cham.size.x=gvars.gun*32
	if gvars.gun>0: reload.visible=false
	else: reload.visible=true
	bullets.text= "[center]Bullets: "+str(gvars.bullets).pad_zeros(3)+"[/center]"
	
