extends Area2D
var vel = 150
var dir = Vector2(0,-1) # direçao  do tiro para cima


func _ready():
	add_to_group("ship_shot")
	set_process(true) # chama funçao _process(delta) a cada quadro

func _process(delta):
	translate(dir * vel * delta)
	# APAGA OBJETO TIRO 
	if get_global_pos().y < 0:
		queue_free()
	# FIM - APAGA OBJETO TIRO 

# FUNCAO QUE DESTOI O OBJETO QUE COLIDIU
func _on_ship_shot_area_enter(area):
	# print(area)
	if area.has_method("destroy"): # verifica se area possui methodo destroy
		area.destroy(self)
		destroy(self)# destroi o tiro junto com o objeto inimigo
# nesta funçao pode colocar efeitos de explosao
func destroy(obj):
	queue_free()
# FIM - FUNCAO QUE DESTOI O OBJETO QUE COLIDIU