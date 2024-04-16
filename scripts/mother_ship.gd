extends Area2D

signal destroyed(obj)
var score = 200 # nave vale em pontos

func _ready():
	get_node("AnimationPlayer").play("default") # movimenta nave para os lados
	yield(get_node("AnimationPlayer"), "finished") # remove a nave mae apos sair da tela
	queue_free()
	
func destroy(obj): # destroi a navem mae
	emite_signal("destroyed", self)
	queue_free()