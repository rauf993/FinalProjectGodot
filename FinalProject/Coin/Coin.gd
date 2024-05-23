extends Area

export var goldToGive : int = 1
var rotateSpeed :float =5.0

func _process(delta: float) -> void:
	rotate_y(rotateSpeed * delta)

func _on_Coin_body_entered(body: Node) -> void:
	if body.name == "Player":
		body.give_gold(goldToGive)
		print(body.gold)
		queue_free()
		if body.gold==6:
		   end_game()
		
		
func end_game():
	# Aquí puedes cambiar a una escena de victoria o mostrar un mensaje de victoria
	get_tree().change_scene("res://HUB2.tscn")
