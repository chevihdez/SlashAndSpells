extends KinematicBody2D

export var target_height = 0
onready var start_height = self.position

var state = "Idle"
var height = "Start"


func _on_Area2D_body_entered(body):
	$Lever.modulate = Color(1.4,1.4,1.4)


func _on_Area2D_body_exited(body):
	$Lever.modulate = Color(1,1,1)

func _physics_process(delta):
	$Label.text = state
	if $Lever.modulate == Color(1.4,1.4,1.4) and Input.is_action_just_pressed("Use_Interact"):
		if state == "Idle":
			if height == "Start":
				state = "MovingUp"
			elif height == "Target":
				state = "MovingDown"
	
	if state == "MovingUp":
		get_node("/root/Main/Player").position.y = position.y
		while position.y > target_height:
			position.y -= 1

	if target_height == position.y:
		state = "Idle"
		height = "Target"
