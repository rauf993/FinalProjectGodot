extends KinematicBody

var curHp : int = 10
var maxHP : int = 10
var damage : int = 1

var gold : int = 0

var attackRate : float = .3
var lastAttackTime : int = 0

var moveSpeed : float = 5.0
var jumpForce : float = 10.0
var gravity : float = 15.0

var vel = Vector3()

var total_coins : int = 0
var collected_coins : int = 0

onready var camera = $Pivote
onready var attackCast = $AttackRayCast
onready var ui = $CanvasLayer/UI

func _ready() -> void:
	ui.update_gold_text(gold)
	ui.update_health_bar(curHp, maxHP)
	total_coins = get_total_coins()
	collected_coins = 0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		try_attack()

func try_attack():
	if OS.get_ticks_msec() - lastAttackTime < attackRate * 1000:
		return
	
	lastAttackTime = OS.get_ticks_msec()
	
	$WeaponHolder/SwordAnimator.stop()
	$WeaponHolder/SwordAnimator.play("attack")
	
	if attackCast.is_colliding():
		if attackCast.get_collider().has_method("take_damage"):
			attackCast.get_collider().take_damage(damage)

func _physics_process(delta: float) -> void:
	vel.x = 0
	vel.z = 0
	
	var input = Vector3()
	
	if Input.is_action_pressed("ui_up"):
		input.z +=1
	
	if Input.is_action_pressed("ui_down"):
		input.z -=1

	if Input.is_action_pressed("ui_left"):
		input.x +=1
		
	if Input.is_action_pressed("ui_right"):
		input.x -=1
	
	input = input.normalized()
	
	var dir = (transform.basis.z * input.z + transform.basis.x * input.x)
	
	vel.x = dir.x * moveSpeed
	vel.z = dir.z * moveSpeed
	
	vel.y -= gravity * delta
	
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		vel.y = jumpForce
	
	vel = move_and_slide(vel, Vector3.UP)

func give_gold(goldToGive):
	gold += goldToGive
	ui.update_gold_text(gold)

func take_damage(damage):
	curHp -= damage
	ui.update_health_bar(curHp, maxHP)
	
	if curHp <= 0:
		die()

func die():
	get_tree().change_scene("res://HUB3.tscn")

func collect_coin():
	collected_coins += 1
	give_gold(1)  # Asumiendo que recoger una moneda te da 1 de oro
	if collected_coins >= total_coins:
		end_game()

func end_game():
	# Aquí puedes cambiar a una escena de victoria o mostrar un mensaje de victoria
	get_tree().change_scene("res://Mundo/Mundo1.tscn")

func get_total_coins() -> int:
	var coin_count = 0
	for coin in get_tree().get_nodes_in_group("coins"):
		coin_count += 1
	return coin_count
