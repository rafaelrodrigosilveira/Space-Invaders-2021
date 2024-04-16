extends Node2D



func _ready():
	get_node("AnimationPlayer").play("explosion")# chama a animaçao
	yield(get_node("AnimationPlayer"), "finished")# espera e finaliza animaçao sem parar o programa
	queue_free() # destroy objetos
