extends Area2D
const vel=100
var left
var right
var dir
var lazer
var prev_shot = preload("res://cenas/ship_shot.tscn") # Seleciona modelo de objeto tiro lazer para instanciar
var prev_lazer = false # somente dispara quando pressiona tecla
var alive = true
signal destroied #sinal para emiir quando a nave explodir
signal respawn # necessario para respawn

func _ready():
	hide()
	# set_process(true) # chama funçao _process(delta) a cada quadro

func _process(delta): # FUNÇAO MOVIMENTA NAVE
	dir = 0
	right = Input.is_action_pressed("ui_right")
	left = Input.is_action_pressed("ui_left")
	lazer = Input.is_action_pressed("disparo")# necessario para disparar lazer
	if right:
		dir += 1
	if left:
		dir -= 1
	translate(Vector2(1,0)* vel * dir * delta)
	# FIM - FUNÇAO MOVIMENTA NAVE
	
	# FUNÇAO FIM TELA
	if get_global_pos().x < 7:
		set_global_pos(Vector2(7,get_global_pos().y))
	if get_global_pos().x > 173:
		set_global_pos(Vector2(173,get_global_pos().y))
	# FIM - FUNÇAO FIM TELA
	# print(lazer) # exibe a saida false ou true quando pressionado a tecla
	
	# INSTANCIA OBJETO TIRO LAZER
	# get_tree().get_nodes_in_group("ship_shot").size()==0 necessario para somente instanciar outro tiro quando o anterior morrer
	if lazer and not prev_lazer and get_tree().get_nodes_in_group("ship_shot").size()==0:
		var shot = prev_shot.instance()
		get_parent().add_child(shot)
		shot.set_global_pos(get_global_pos())
	
	prev_lazer = lazer # somente dispara quando pressiona tecla
	
func start():
	show()
	set_process(true)
	
	# INSTANCIA OBJETO TIRO LAZER
# DESTROI NAVE DO PLAYER QUANDO TIRO ACERTA
func destroy(obj):
	if alive:
		alive = false
		set_process(false)
		
		emit_signal("destroied") #emite sinal quando a nave e destuida
		get_node("AnimationPlayer").play("explode") # chama animaçao explosao
		yield(get_node("AnimationPlayer"),"finished")  # necessario para respawn
		emit_signal("respawn")
		set_process(true)
		alive = true
		get_node("sprite").set_frame(0) # devolve aparencia da nave