extends StateMachine

var speed = 100
var friction = 0.3
var acceleration = 0.1
var velocity = Vector2.ZERO

func _state_logic(delta):
	add_state("Idle")
	add_state("Walk")
	call_deferred("set_state", states.Idle)

func _get_transition(delta):
	return null

func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass



func _physics_process(delta):
#	_get_input()
	pass

func _apply_gravity(delta):
	velocity.y += 5 * delta

func _apply_movement():
	var input_velocity = Vector2.ZERO

	# Check input for "desired" velocity
	if Input.is_action_pressed("Move_Right"):
		input_velocity.x += 1
		$Body.scale.x = 1
		$AnimationPlayer.play("Walk")
	elif Input.is_action_pressed("Move_Left"):
		input_velocity.x -= 1
		$Body.scale.x = -1
		$AnimationPlayer.play("Walk")
	else:
		$AnimationPlayer.play("Idle")
	input_velocity = input_velocity.normalized() * speed

	# If there's input, accelerate to the input velocity
	if input_velocity.length() > 0:
		velocity = velocity.linear_interpolate(input_velocity, acceleration)
		
	else:
		# If there's no input, slow down to (0, 0)
		velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
		
	velocity = move_and_slide(velocity)

func _handle_move_input():
	move_direction = -int(Input. is_action_pressed("Move_Left")) + int(Input.is_action_pressed("Move_Right"))
