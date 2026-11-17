class_name BalonRima
extends Control

## Mini-Game 2: Balon Rima (Mekanika Kepekaan Bunyi Akhir / Rima)
## Pemain mencocokkan kata dengan rima/bunyi akhir serupa (misal: Buku - Kuku, Mata - Bata).

@onready var label_target_word: Label = $VBoxHeader/LabelTargetWord
@onready var btn_replay_audio: Button = $VBoxHeader/BtnReplayAudio
@onready var balloon_container: HBoxContainer = $BalloonContainer
@onready var btn_back: Button = $BtnBack
@onready var label_feedback: Label = $LabelFeedback

var current_task: Dictionary = {}
var start_time_ms: int = 0
var attempt_count: int = 1
var is_answering_locked: bool = false
var balloon_buttons: Array[Button] = []

func _ready() -> void:
	btn_back.pressed.connect(_on_back_pressed)
	btn_replay_audio.pressed.connect(_play_target_audio)
	
	ScaffoldingController.audio_hint_requested.connect(_on_audio_hint)
	ScaffoldingController.visual_hint_requested.connect(_on_visual_hint)
	
	load_new_round()

func load_new_round() -> void:
	is_answering_locked = false
	attempt_count = 1
	label_feedback.text = ""
	
	current_task = PhonemeDatabase.get_random_rhyme_task()
	var target_word: String = current_task.get("target_word", "").to_upper()
	label_target_word.text = "Cari kata berima mirip: \"" + target_word + "\""
	
	_setup_balloons()
	
	start_time_ms = Time.get_ticks_msec()
	ScaffoldingController.start_monitoring()
	_play_target_audio()

func _setup_balloons() -> void:
	balloon_buttons.clear()
	for child in balloon_container.get_children():
		child.queue_free()
	
	var options: Array = current_task.get("options", [])
	var colors: Array[Color] = [
		Color(1.0, 0.45, 0.45, 1.0), # Merah muda
		Color(0.45, 0.75, 1.0, 1.0), # Biru langit
		Color(1.0, 0.85, 0.35, 1.0)  # Kuning ceria
	]
	
	for i in range(options.size()):
		var opt: Dictionary = options[i]
		var btn: Button = Button.new()
		btn.custom_minimum_size = Vector2(240, 300)
		btn.theme_override_font_sizes/font_size = 28
		btn.text = "🎈\n\n" + opt["word"].capitalize()
		btn.set_meta("opt_data", opt)
		
		# Efek mengambang lembut balon
		var tw: Tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE)
		var offset_y: float = randf_range(12.0, 24.0)
		tw.tween_property(btn, "position:y", -offset_y, 1.5 + (i * 0.2)).as_relative()
		tw.tween_property(btn, "position:y", offset_y, 1.5 + (i * 0.2)).as_relative()
		
		btn.pressed.connect(func(): _on_balloon_pressed(btn, opt))
		balloon_container.add_child(btn)
		balloon_buttons.append(btn)

func _play_target_audio() -> void:
	ScaffoldingController.reset_idle_timer()
	var audio_path: String = current_task.get("audio_target_path", "")
	AudioManager.play_voice(audio_path, current_task.get("target_word", ""))

func _on_balloon_pressed(btn: Button, opt: Dictionary) -> void:
	if is_answering_locked:
		return
	
	var reaction_time: float = (Time.get_ticks_msec() - start_time_ms) / 1000.0
	var is_correct: bool = opt.get("is_correct", false)
	var scaffolding_status: String = "NONE"
	if ScaffoldingController.visual_hint_given:
		scaffolding_status = "VISUAL_WIGGLE"
	elif ScaffoldingController.audio_hint_given:
		scaffolding_status = "AUDIO_REPEAT"
	
	ResearchEventLogger.log_interaction(
		"BALON_RIMA",
		2,
		current_task.get("target_word", ""),
		opt.get("word", ""),
		is_correct,
		reaction_time,
		scaffolding_status,
		attempt_count
	)
	
	if is_correct:
		is_answering_locked = true
		ScaffoldingController.stop_monitoring()
		label_feedback.text = "🎈 POP! \"" + opt["word"].capitalize() + "\" sama bunyi akhirnya!"
		AudioManager.play_sfx("res://assets/audio/sfx/balloon_pop.wav")
		
		# Animasi meletus balon
		var tw: Tween = create_tween()
		tw.tween_property(btn, "scale", Vector2(1.3, 1.3), 0.15)
		tw.tween_property(btn, "modulate:a", 0.0, 0.15)
		
		GameManager.award_stars(3 if attempt_count == 1 else 2)
		get_tree().create_timer(1.8).timeout.connect(load_new_round)
	else:
		attempt_count += 1
		ScaffoldingController.register_mistake()
		label_feedback.text = "Bunyi akhirnya berbeda, coba yang lain ya..."
		AudioManager.play_sfx("res://assets/audio/sfx/gentle_miss.wav")
		
		var tw: Tween = create_tween()
		tw.tween_property(btn, "rotation_degrees", -8.0, 0.08)
		tw.tween_property(btn, "rotation_degrees", 8.0, 0.08)
		tw.tween_property(btn, "rotation_degrees", 0.0, 0.08)

func _on_audio_hint() -> void:
	_play_target_audio()

func _on_visual_hint() -> void:
	for btn in balloon_buttons:
		var data: Dictionary = btn.get_meta("opt_data", {})
		if data.get("is_correct", false):
			var tw: Tween = create_tween().set_loops(3)
			tw.tween_property(btn, "scale", Vector2(1.12, 1.12), 0.25)
			tw.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.25)

func _on_back_pressed() -> void:
	ScaffoldingController.stop_monitoring()
	GameManager.change_state(GameManager.State.MAIN_MENU)
	get_tree().change_scene_to_file("res://src/scenes/main_menu/MainMenu.tscn")
