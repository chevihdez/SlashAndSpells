extends KinematicBody2D

var speed = 75
var friction = 0.3
var acceleration = 0.1
var velocity = Vector2.ZERO

var HP = 50
export var Max_HP = 50
var stop = false
var dead = false
var agro = false



var direction = "right"
func _ready():
	$UI/HPBar.max_value = Max_HP
	HP = Max_HP
func _physics_process(_delta):
	if $Body/Body/ArmR/ForeArmR/HandR/Weapon/Area2D/CollisionShape2D.disabled == false:
		$Body/Body/ArmR/ForeArmR/HandR/Weapon.modulate = Color(1,10,1)
	else:
		$Body/Body/ArmR/ForeArmR/HandR/Weapon.modulate = Color(10,1,1)
	$UI/HPBar.value = HP
	var input_velocity = Vector2.ZERO
	var distance_to_player = sqrt(pow((self.position.x-$'/root/Main/Player'.position.x), 2) + pow((self.position.y-$'/root/Main/Player'.position.y),2))
	
	# Check input for "desired" velocity
	if stop == false:
		if distance_to_player <= 120 or agro == true:
			if distance_to_player <= 30:
				stop = true
				$AnimationTree.set("parameters/States/current", 4)
				$Body/Body/ArmR/ForeArmR/HandR/Weapon/Area2D/CollisionShape2D.disabled = false
				if direction == "right":
					velocity.x += 15
				else:
					velocity.x -= 15

			if $'/root/Main/Player'.position.x > self.position.x:
				input_velocity.x += 1
				$Body.scale.x = 1
				direction = "right"
				$AnimationTree.set("parameters/States/current", 1)
			elif $'/root/Main/Player'.position.x < self.position.x:
				input_velocity.x -= 1
				$Body.scale.x = -1
				direction = "left"
				$AnimationTree.set("parameters/States/current", 1)
			if $"Wall DetectionL".is_colliding() or $"Wall DetectionR".is_colliding():
				velocity.y -= 200
			if distance_to_player >= 240:
				agro = false
		else:
			$AnimationTree.set("parameters/States/current", 0)
			


	else:
		return
	input_velocity = input_velocity.normalized() * speed

	# If there's input, accelerate to the input velocity
	if input_velocity.length() > 0:
		velocity = velocity.linear_interpolate(input_velocity, acceleration)
		
	else:
		# If there's no input, slow down to (0, 0)
		velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
	if $AnimationPlayer.current_animation == "LightAttack":
		
		if direction == "right":
			velocity.x += 15
		else:
			velocity.x -= 15
	if not $AnimationPlayer.current_animation == "LightAttack":
		$Body/Body/ArmR/ForeArmR/HandR/Weapon/Area2D/CollisionShape2D.disabled = true
	velocity = move_and_slide(velocity)
	if HP <= 0:
		$AnimationTree.set("parameters/States/current", 2)
		$CollisionShape2D.disabled = true
		stop = true
		dead = true
		HP = 0
		$UI/HPBar.visible = false
		
	else:
		if HP < Max_HP:
			$UI/HPBar.visible = true
			agro = true
	if dead == true:
		$Body/Body/ArmR/ForeArmR/HandR/Weapon/Area2D/CollisionShape2D.call_deferred("set", "disabled", true)
	if $"Ground Detection".is_colliding() == false:
		velocity.y += 45
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "LightAttack":
		stop = false
		$Body/Body/ArmR/ForeArmR/HandR/Weapon/Area2D/CollisionShape2D.disabled = true


func _on_HurtBox_area_entered(_area):
	if dead == false:
		$AnimationTree.set("parameters/States/current", 3)
		stop = true
		$Stun.start()
		HP -= 15
	
	


func _on_Stun_timeout():
	modulate = Color(1,1,1)
	stop = false


func _on_Area2D_area_entered(_area):
	$Body/Body/ArmR/ForeArmR/HandR/Weapon/Area2D/CollisionShape2D.call_deferred("set", "disabled", true)
	
