extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	# Conectar la señal de presión del botón al método correspondiente
	$button.connect("pressed", self, "_on_button_pressed")
	# Conectar la señal timeout del Timer al método que cambia la escena
	$Timer.connect("timeout", self, "_change_to_game_scene")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_button_pressed():
	$button.hide()
	emit_signal("start_game")
	get_tree().change_scene("res://Mundo/Mundo1.tscn")
	$Timer.start(0.1)  # Espera 0.1 segundos antes de cambiar la escena

func _return_main():
	 get_tree().change_scene("res://HUB.tscn")
func _change_to_game_scene():
	get_tree().change_scene("res://Game.tscn")  # Cambia a la escena del juego



func _on_Button_pressed():
	pass # Replace with function body.
