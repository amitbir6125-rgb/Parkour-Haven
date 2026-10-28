extends CharacterBody2D

var speed = 900
var jump = -900
var timer = 0.0
var game_over = false

func _physics_process(delta):
	if game_over:
		return

	# 1. Timer
	timer = timer + delta
	print("TIMER TICK: ", timer)
	if has_node("%Label"):
		%Label.text = "Time: " + str(snappedf(timer, 0.1)) + "s"

	# 2. Reached floor 9 (WIN)
	if position.y > 2000 and position.y < 3500 and is_on_floor():
		game_over = true
		velocity = Vector2.ZERO
		await get_tree().create_timer(2.0).timeout
		if has_node("%Label"):
			%Label.text = "YOU WIN! Time: " + str(snappedf(timer, 0.1)) + "s"
		await get_tree().create_timer(3.0).timeout
		get_tree().reload_current_scene()
		return

	# 3. Fell into void (LOSE)
	if position.y > 4500:
		game_over = true
		velocity = Vector2.ZERO
		if has_node("%Label"):
			%Label.text = "YOU LOSE!"
		await get_tree().create_timer(2.0).timeout
		get_tree().reload_current_scene()
		return

	# 4. Gravity & Movement
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump

	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = 0

	move_and_slide()
