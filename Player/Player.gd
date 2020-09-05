extends KinematicBody2D

var speed = 125
var friction = 0.3
var acceleration = 0.1
var velocity = Vector2.ZERO

func _physics_process(delta):
	var input_velocity = Vector2.ZERO
	# Check input for "desired" velocity
	if Input.is_action_pressed("Move_Right"):
		input_velocity.x += 1
		$Body.scale.x = 1
	if Input.is_action_pressed("Move_Left"):
		input_velocity.x -= 1
		$Body.scale.x = -1
	input_velocity = input_velocity.normalized() * speed

	# If there's input, accelerate to the input velocity
	if input_velocity.length() > 0:
		velocity = velocity.linear_interpolate(input_velocity, acceleration)
		$AnimationPlayer.play("Walk")
	else:
		# If there's no input, slow down to (0, 0)
		velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
		$AnimationPlayer.play("Idle")
	velocity = move_and_slide(velocity)
