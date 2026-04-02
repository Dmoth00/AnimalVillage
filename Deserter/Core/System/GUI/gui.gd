extends CanvasLayer

#blood meter variables
@onready var blood=$blood
@onready var bmax=$blood/bmax
@onready var bld=gvars.blood
@onready var bbag=gvars.bloodBag

#gun HUD variables
@onready var bullets=$bullets
@onready var cham=$bullets/chamber
@onready var reload=$bullets/reload

#curse meter variables
@onready var curse=$blood/curse
@onready var crs=gvars.hatred

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#blood meter
	bld=lerp(bld,gvars.blood,delta*4)
	blood.text="Blood: "+str(snapped(bld,0.01)).pad_decimals(2)
	bmax.text="/"+str(gvars.bloodMax).pad_decimals(0)+"Lts"
	
	#gun HUD
	cham.size.x=gvars.gun*32
	if gvars.gun>0: reload.visible=false
	else: reload.visible=true
	bullets.text= "[center]Bullets: "+str(gvars.bullets).pad_zeros(3)+"[/center]"
	
	#secondary meters
	bbag=lerp(bbag,gvars.bloodBag,delta*4)
	crs=lerp(crs,gvars.hatred,delta*4)
	curse.text="Blood IV: "+str(snapped(bbag,0.01)).pad_decimals(2)+" Lts\nCurse: "+str(snapped(crs,0.01)).pad_decimals(2)+"%"
