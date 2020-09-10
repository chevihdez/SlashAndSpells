extends KinematicBody2D

var speed = 100
var friction = 0.3
var acceleration = 0.1
var velocity = Vector2.ZERO

var spell = "Light"
var selected_slot = "SpellSlots1"
var slots = ["SpellSlots1","SpellSlots2","SpellSlots3"]

var HP = 100
var MaxHP = 100

var Stamina = 100
var MaxST = 100

var combo = false

var stop = false
var rolling = false
var jumping = false
var direction = "right"

func _ready():
	$UI/HPBar.max_value = MaxHP
	$UI/STBar.max_value = MaxST
func _physics_process(_delta):
	print($"Ground Detection".is_colliding())
	var input_velocity = Vector2.ZERO

	$UI/HPBar.value = HP
	$UI/STBar.value = Stamina
	
	for i in get_tree().get_nodes_in_group("Spells"):
		if selected_slot == i.name:
			i.self_modulate = Color(5,5,5)
			i.get_child().play()
			
		else:
			i.self_modulate = Color(1,1,1)
			i.get_child().stop()
	if $Body/ArmR/ForeArmR/HandR/Weapon/Area2D/CollisionShape2D.disabled == false:
		$Body/ArmR/ForeArmR/HandR/Weapon.modulate = Color(1,10,1)
	else:
		$Body/ArmR/ForeArmR/HandR/Weapon.modulate = Color(10,1,1)
	if stop == false:
		if Input.is_action_pressed("Move_Right"):
			input_velocity.x += 1
			$Body.scale.x = 1
			direction = "right"
			if not spell == "none":
				$AnimationPlayer.play("Walk (Spell)")
			else:
				$AnimationPlayer.play("Walk")
		elif Input.is_action_pressed("Move_Left"):
			input_velocity.x -= 1
			$Body.scale.x = -1
			direction = "left"
			if not spell == "none":
				$AnimationPlayer.play("Walk (Spell)")
			else:
				$AnimationPlayer.play("Walk")
		
				
		else:
			$AnimationPlayer.play("Idle")
			
		if Input.is_action_just_pressed("Move_Jump"):
			if $"Ground Detection".is_colliding() and jumping == false:
				jumping = true
				$Jump.start()
			
		
		if Input.is_action_just_pressed("Attack_Light") and Stamina >= 20:
			stop = true
			$Body/ArmR/ForeArmR/HandR/Weapon/Area2D/CollisionShape2D.disabled = false
			Stamina -= 20
			$ComboEnd.start()
			
			if combo == false:
				$AnimationPlayer.play("Attack2")
			else:
				$AnimationPlayer.play("LightAttack")
			combo = true
		if Input.is_action_just_pressed("Move_Roll") and Stamina >= 25:
			rolling = true
			stop = true
			set_collision_layer_bit(1, false)
			set_collision_mask_bit(1, false)
			$Body/Body/HurtBox.set_collision_mask_bit(3, false)
			$AnimationPlayer.play("Roll")
			Stamina -= 25
	input_velocity = input_velocity.normalized() * speed
	
	if rolling == true:
		if direction == "right":
			velocity.x += 60
		else:
			velocity.x -= 60
		
	
	elif $AnimationPlayer.current_animation == "LightAttack":
		
		if direction == "right":
			velocity.x += 15
		else:
			velocity.x -= 15
	else:
		Stamina += .3
		
	if jumping == true:
		velocity.y -= 35
	
	elif $"Ground Detection".is_colliding() == false:
		velocity.y += 65
	
	# If there's input, accelerate to the input velocity
	if input_velocity.length() > 0:
		velocity = velocity.linear_interpolate(input_velocity, acceleration)
		
	else:
		# If there's no input, slow down to (0, 0)
		velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
	
	velocity = move_and_slide(velocity)
	if HP <= 0:
		queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Attack2" or  anim_name == "LightAttack":
		stop = false
		$Body/ArmR/ForeArmR/HandR/Weapon/Area2D/CollisionShape2D.disabled = true
	if anim_name == "Roll":
		rolling = false
		stop = false
		set_collision_layer_bit(1, true)
		set_collision_mask_bit(1, true)
		$Body/Body/HurtBox.set_collision_mask_bit(3, true)


func _on_Area2D_area_entered(_area):
	$Body/ArmR/ForeArmR/HandR/Weapon/Area2D/CollisionShape2D.call_deferred("set", "disabled", true)


func _on_Stun_timeout():
	pass # Replace with function body.

func _on_HurtBox_area_entered(area):
	HP -= 15
	


func _on_ComboEnd_timeout():
	combo = false


func _input(event):
	if Input.is_key_pressed(KEY_H):
		HP +=15
		
	if Input.is_key_pressed(KEY_1):
		selected_slot = "SpellSlots1"

	elif Input.is_key_pressed(KEY_2):
		selected_slot = "SpellSlots2"
		
	elif Input.is_key_pressed(KEY_3):
		selected_slot = "SpellSlots3"
func _on_Jump_timeout():
	jumping = false
