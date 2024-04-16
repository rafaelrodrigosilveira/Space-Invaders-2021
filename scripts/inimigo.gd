tool # executa em modo editor.hint
extends Area2D

export(int,"A","B","C") var tipo = 0 setget set_tipo # VARIAVEL COM OPCAO A<B ou C
var score = 0
var frame =0

signal destroyed(obj) # cria sinal avisando que obj foi destruido

var atributos = [
	{
		texture = preload("res://Assets/sprites/InvaderA_sheet.png"),
		score = 20
	},
	{
		texture = preload("res://Assets/sprites/InvaderB_sheet.png"),
		score = 10
	},
	{
		texture = preload("res://Assets/sprites/InvaderC_sheet.png"),
		score = 30
	}
]

func _ready():
	pass

func _draw():
	var atributo = atributos[tipo]
	get_node("Sprite").set_texture(atributo.texture)
	score = atributos[tipo].score
	
func set_tipo(val):
	tipo = val
	if is_inside_tree() and get_tree().is_editor_hint(): # executa em modo editor
		update()

func destroy(obj):
	emit_signal("destroyed", self) # emite sinal avisando que obj foi destruido
	queue_free()

func next_frame(): # anima os aliens alterando os frames
	if frame == 0:
		frame =1
	else:
		frame =0
	get_node("Sprite").set_frame(frame)