extends CanvasLayer


@onready var menu = %Menu
@onready var bar_container = $BarContainer

@onready var sleep_bar = $BarContainer/VerticalList/SleepBar
@onready var toilet_bar = $BarContainer/VerticalList/ToiletBar
@onready var love_bar = $BarContainer/VerticalList/LoveBar
@onready var food_bar = $BarContainer/VerticalList/FoodBar
@onready var play_bar = $BarContainer/VerticalList/PlayBar
@onready var day_label = $TimeContainer/MarginContainer/GridContainer/Day
@onready var time_label = $TimeContainer/MarginContainer/GridContainer/Time

@onready var MUSIC_BUS_IO = AudioServer.get_bus_index("Music") 
@onready var SFX_BUS_IO   = AudioServer.get_bus_index("SFX") 

@onready var bars_array = [
	{ "bar": sleep_bar, "value": "sleep_value" }, 
	{ "bar": toilet_bar, "value": "toilet_value" }, 
	{ "bar": love_bar, "value": "love_value" }, 
	{ "bar": food_bar, "value": "food_value" }, 
	{ "bar": play_bar, "value": "play_value" },
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	pass


func _input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		menu.visible = false;
		bar_container.visible = false;


func show_message(text) -> void:
	$Message.text = "Action" + str(text)
	$Message.show()


func _on_music_slider_value_changed(value) -> void:
	manage_audio_server(MUSIC_BUS_IO, value)


func _on_sfx_slider_value_changed(value) -> void:
	manage_audio_server(SFX_BUS_IO, value)


func manage_audio_server(bus_idx: int, volume_db: float) -> void:
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(volume_db))
	AudioServer.set_bus_mute(bus_idx, volume_db < 0.05)


func _on_menu_button_pressed() -> void:
	menu.visible = true


func update_bar(bar: ProgressBar, value: int) -> void:
	bar.value = value
	
	var stylebox = StyleBoxFlat.new()
	
	if bar.value < 20:
		stylebox.set_bg_color(Color("#f957387f"))
	elif bar.value < 60:
		stylebox.set_bg_color(Color("#ffbc429F"))
	else:
		stylebox.set_bg_color(Color("#b9fbc07f"))
	
	stylebox.set_corner_radius_all(5)
	bar.set("theme_override_styles/fill", stylebox)


func _on_cat_cat_update_ui(cat_values: Cat) -> void:
	for bar in bars_array:
		update_bar(bar.bar, cat_values.get(bar.value))


func _on_cat_cat_show_ui() -> void:
	bar_container.visible = true


func _on_canvas_modulate_time_tick(day, hour, minute):
	day_label.text = "Day %d" % day
	time_label.text = "%02d:%02d" % [hour, minute]
