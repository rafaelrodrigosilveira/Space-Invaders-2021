extends Node2D

const vel = Vector2(6,0)# usado pelo func _on_timer_move_timeout():
var pre_alien_shot = preload("res://cenas/alien_shot.tscn")
var pre_alien_explosion = preload("res://cenas/alien_explosion.tscn")
var pre_mother_ship = preload("res://cenas/mother_ship.tscn")
var dir = 1 # usado pelo func _on_timer_move_timeout():

signal enemy_down(obj) #necessario para pontuaçao
signal ready 

func _ready():
	# get_node("timer_shot").start()
	
	restart_timer_mother_ship() # chama o metodo que sorteia o tempo para aparecer a mother ship
	
	# CONECTA COM DESTROYED PARA AVISAR QUE DESTRUIU OBJ
	for alien in get_node("aliens").get_children():
		alien.hide() #esconde os aliens
		alien.connect("destroyed",self,"on_alien_destroied")
		# FIM - CONECTA COM DESTROYED PARA AVISAR QUE DESTRUIU
		
	# EFEITO DE APARECER ALIENS
	for alien in get_node("aliens").get_children():
		get_node("timer_pause").start()
		yield(get_node("timer_pause"), "timeout")
		alien.show() #esconde os aliens
	
	emit_signal("ready")
	start_all()
	
func shoot():
	var n_aliens = get_node("aliens").get_child_count()# conta os aliens
	var alien = get_node("aliens").get_child(randi()% n_aliens) # sorteia o alien que ira atirar
	var alien_shot = pre_alien_shot.instance() # instancia novo tiro do alien
	get_parent().add_child(alien_shot) # coloca o tiro no alien que foi escolhido
	alien_shot.set_global_pos(alien.get_global_pos())# coloca o tiro no alien que foi escolhido

func _on_Timer_shot_timeout():
	get_node("timer_shot").set_wait_time(rand_range(.5,2))#sorteia entre 0.5 a 2 seg
	shoot() # a cada 1 seg chama o metodo shot (Timer_shot)


func _on_timer_move_timeout():
	var border = false
	
	for alien in get_node("aliens").get_children(): # checa se aliens toca a borda
		alien.next_frame()
		if alien.get_global_pos().x > 170 and dir > 0:
			dir =-1
			border = true
		if alien.get_global_pos().x < 10 and dir < 0:
			dir =1
			border = true
	if border:
		translate(Vector2(0,8))
		# acelera os movimentos dos aliens a cada descida
		if get_node("timer_move").get_wait_time() > .11:
			get_node("timer_move").set_wait_time(get_node("timer_move").get_wait_time()-.1)
			# FIM - acelera os movimentos dos aliens a cada descida
	else:
		translate(vel * dir)


func on_alien_destroied(alien):
	# print(alien.get_name()) # descobre o nome do alien que foi destruido
	emit_signal("enemy_down",alien) # necessario para pontuaçao
	
	# adiciona explosao no local do alien atingido
	var alien_exp = pre_alien_explosion.instance()
	get_parent().add_child(alien_exp)
	alien_exp.set_global_pos(alien.get_global_pos())
	# FIM - adiciona explosao no local do alien atingido

func _on_timer_mother_ship_timeout():
	var mother_ship = pre_mother_ship.instance() # instancia nother ship
	mother_ship.connect("destroyed",self,"on_alien_destroied") # conecta mother ship para contagem de pontos
	get_parent().add_child(mother_ship)

func restart_timer_mother_ship():
	get_node("timer_mother_ship").set_wait_time(rand_range(6,15)) #sorteia a frequencia em que aparece a mothership
	get_node("timer_mother_ship").start() #inicia a contagem de tempo

# parar o jogo quando a nave explodir
func stop_all():
	get_node("timer_mother_ship").stop()
	get_node("timer_shot").stop()
	get_node("timer_move").stop()
# FIM - parar o jogo quando a nave explodir

# respawn
func start_all():
	get_node("timer_mother_ship").start()
	get_node("timer_shot").start()
	get_node("timer_move").start()
# FIM - respawn

