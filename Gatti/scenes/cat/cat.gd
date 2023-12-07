extends CharacterBody2D

class_name Cat

signal cat_update_ui(cat_values: Cat)
signal cat_show_ui()

@export var SPEED = 200.0

@export var sleep_value  : int
@export var toilet_value : int
@export var love_value   : int
@export var food_value   : int
@export var play_value   : int

@export var cat_state : CAT_STATE

@onready var animation_player = $AnimationPlayer
@onready var timer_update_values = $UpdateValues
@onready var timer_timeout_action = $TimeoutAction
@onready var action_container = $ActionContainer
@onready var speech_sound = preload("res://Assets/audio/SFX/speech_sound.wav")

var rng = RandomNumberGenerator.new()
var target = position
var screen_size

var cat_values: Array[int] = [
	sleep_value,
	love_value,
	food_value,
	play_value
]


const lines: Array[String] = [
	"Hellow!",
	"Sono il tuo gatto!",
	"Meowhhh"
]


enum CAT_STATE {
	SLEEP,
	TOILET,
	LOVE,
	EAT,
	PLAY,
	IDLE
}


func _ready() -> void:
	screen_size = get_viewport_rect().size


func start(pos) -> void:
	position = pos


func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * SPEED


func _input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		action_container.hide()
	if event.is_action_pressed("click"):
		target = get_global_mouse_position()


func update_animation() -> void:
	var direction = "down"
	if velocity.x < 0: direction = "left"
	elif velocity.x > 0: direction = "right"
	elif velocity.y < 0: direction = "up"
	
	if velocity.length() == 0:
		animation_player.play("idle")
	else:
		animation_player.play("walk_"+direction)


func _physics_process(delta) -> void:
	get_input()
	move_and_slide()
	update_animation()
	
	position = position.clamp(Vector2.ZERO, screen_size)

func update_values() -> void:
	var cat_values = Cat.new()
	
	cat_values.sleep_value = sleep_value
	cat_values.toilet_value = toilet_value
	cat_values.love_value   = love_value
	cat_values.food_value   = food_value
	cat_values.play_value   = play_value
	
	cat_update_ui.emit(cat_values)


func _on_action_timer_timeout() -> void:
	sleep_value  -= randi_range(0, 10)
	toilet_value -= randi_range(0, 10)
	love_value   -= randi_range(0, 10)
	food_value   -= randi_range(0, 10)
	play_value   -= randi_range(0, 10)
	
	update_values()


func _input_event(viewport, event, shape_idx):
	if event.is_action_released("click"):
		if timer_timeout_action.time_left == 0:
			update_values()
			cat_show_ui.emit()
			action_container.show()
			timer_update_values.start()
			DialogManager.start_dialog(global_position, lines, speech_sound)

func calculate_new_values() -> void:
	match cat_state:
		CAT_STATE.SLEEP:
			sleep_value = 100	
		CAT_STATE.TOILET:
			toilet_value = 100
		CAT_STATE.LOVE:
			love_value = 100
		CAT_STATE.EAT:
			food_value = 100
		CAT_STATE.PLAY:
			play_value = 100


func manage_action_button(state_type: CAT_STATE):
	cat_state = state_type
	calculate_new_values()
	update_values()
	action_container.hide()
	timer_timeout_action.start()


func _on_sleep_pressed():
	manage_action_button(CAT_STATE.SLEEP)


func _on_toilet_pressed():
	manage_action_button(CAT_STATE.TOILET)


func _on_love_pressed():
	manage_action_button(CAT_STATE.LOVE)


func _on_eat_pressed():
	manage_action_button(CAT_STATE.EAT)


func _on_play_pressed():
	manage_action_button(CAT_STATE.PLAY)


