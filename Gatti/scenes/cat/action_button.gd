extends Button

@export var custom_icon : CompressedTexture2D

var cat_state

func _ready():
	$Icon.texture = custom_icon
