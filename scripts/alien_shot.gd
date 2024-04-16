extends Area2D

const vel = 120
const dir = Vector2(0,1)

func _ready():
	set_process(true)

func _process(delta):
	translate(dir * vel * delta)
	if get_global_pos().y > 290:# destroy tiro inimigo quando passar da nave principal
		destroy(self)

func destroy(obj): # destroy o tiro quando colide com o outro tiro
	queue_free()

func _on_alien_shot_area_enter( area ):
	# print(area)
	if area.has_method("destroy"): # verifica se area possui methodo destroy
		area.destroy(self)
		destroy(self)# destroi o tiro junto com o objeto inimigo
