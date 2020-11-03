extends Tabs


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ItemList_item_selected(index):
	for i in $ItemList/Items.get_children():
		if $ItemList.get_item_text(index) == i.name:
			$Description/Text.text = i.Description
			$Description/Texture.texture = i.Portrait
