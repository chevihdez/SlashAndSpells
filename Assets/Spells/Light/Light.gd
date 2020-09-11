extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var TweenNode = get_node("Tween")
onready var player = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("spell_casted",self,"on_spell_casted")
	player.connect("spell_switched",self,"on_spell_switched")
	TweenNode.interpolate_property($Light2D, "scale", $Light2D.scale, Vector2(1, 1), 5,Tween.TRANS_LINEAR, Tween.EASE_IN)
	TweenNode.start()
	
func on_spell_casted(spell):
	if spell == self.name:
		visible = true

		
func on_spell_switched(spell):
	if not spell == self.name:
		visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.




func _on_Tween_tween_all_completed():
	if $Light2D.scale.x == 2:
		TweenNode.interpolate_property($Light2D, "scale", $Light2D.scale, Vector2(1, 1), 5,Tween.TRANS_LINEAR, Tween.EASE_IN)
		TweenNode.start()
	if $Light2D.scale.x == 1:
		TweenNode.interpolate_property($Light2D, "scale", $Light2D.scale, Vector2(2,2), 5,Tween.TRANS_LINEAR, Tween.EASE_IN)
		TweenNode.start()
