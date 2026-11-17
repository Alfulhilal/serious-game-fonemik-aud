class_name KebunVokal
extends Control

## Mini-Game 1: Kebun Vokal (Mekanika Isolasi Bunyi Vokal Awal)
## Pemain mendengarkan bunyi vokal (/a/, /i/, /u/, /e/, /o/) dan memilih objek dengan bunyi awal serupa.
## Dilengkapi Scaffolding Adaptif otomatis & Logging Data Riset.

@onready var label_instruction: Label = $VBoxContainer/LabelInstruction
@onready var btn_replay_audio: Button = $VBoxContainer/BtnReplayAudio
@onready var options_container: HBoxContainer = $OptionsContainer
@onready var btn_back: Button = $BtnBack
@onready var label_feedback: Label = $LabelFeedback

var current_task: Dictionary = {}
var start_time_ms: int = 0
var attempt_count: int = 1
var is_answering_locked: bool = false
var buttons_map: Array[Button] = []

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
	
	# Ambil soal dari basis data fonem
	current_task = PhonemeDatabase.get_random_vowel_task()
	var sound_label: String = current_task.get("sound_label", "/a/")
	label_instruction.text = "Sentuh gambar yang berbunyi awal: " + sound_label
	
	# Siapkan tombol pilihan
	_setup_option_buttons()
	
	# Mulai timer waktu respon & pemantauan scaffolding
	start_time_ms = Time.get_ticks_msec()
	ScaffoldingController.start_monitoring()
	
	# Putar audio instruksi awal
	_play_target_audio()

func _setup_option_buttons() -> void:
	buttons_map.clear()
	# Bersihkan tombol sebelumnya jika ada
	for child in options_container.get_children():
		child.queue_free()
	
	var options: Array = current_task.get("options", [])
	for opt in options:
		var btn: Button = Button.new()
		btn.custom_minimum_size = Vector2(260, 260)
		btn.theme_override_font_sizes/font_size = 28
		btn.text = opt["word"].capitalize()
		btn.set_meta("opt_data", opt)
		btn.pressed.connect(func(): _on_option_selected(btn, opt))
		
		options_container.add_child(btn)
		buttons_map.append(btn)

func _play_target_audio() -> void:
	ScaffoldingController.reset_idle_timer()
	var audio_path: String = current_task.get("audio_phoneme_path", "")
	AudioManager.play_voice(audio_path, current_task.get("phoneme", ""))

func _on_option_selected(btn: Button, opt: Dictionary) -> void:
	if is_answering_locked:
		return
	
	var reaction_time: float = (Time.get_ticks_msec() - start_time_ms) / 1000.0
	var is_correct: bool = opt.get("is_correct", false)
	var scaffolding_status: String = "NONE"
	if ScaffoldingController.visual_hint_given:
		scaffolding_status = "VISUAL_WIGGLE"
	elif ScaffoldingController.audio_hint_given:
		scaffolding_status = "AUDIO_REPEAT"
	
	# Catat data ke modul riset
	ResearchEventLogger.log_interaction(
		"KEBUN_VOKAL",
		1,
		current_task.get("phoneme", ""),
		opt.get("word", ""),
		is_correct,
		reaction_time,
		scaffolding_status,
		attempt_count
	)
	
	if is_correct:
		is_answering_locked = true
		ScaffoldingController.stop_monitoring()
		label_feedback.text = "🎉 Hebat Sekali! (" + opt["word"].capitalize() + ")"
		AudioManager.play_sfx("res://assets/audio/sfx/cheer.wav")
		
		# Animasi apresiasi tombol
		var tw: Tween = create_tween()
		tw.tween_property(btn, "scale", Vector2(1.15, 1.15), 0.2)
		tw.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.2)
		
		GameManager.award_stars(3 if attempt_count == 1 else 2)
		
		# Jeda 1.8 detik sebelum lanjut ke babak berikutnya
		get_tree().create_timer(1.8).timeout.connect(load_new_round)
	else:
		attempt_count += 1
		ScaffoldingController.register_mistake()
		label_feedback.text = "Ayo dengarkan bunyinya lagi ya..."
		AudioManager.play_sfx("res://assets/audio/sfx/gentle_miss.wav")
		
		# Goyangan lembut menandakan pilihan belum tepat tanpa hukuman nilai
		var tw: Tween = create_tween()
		tw.tween_property(btn, "rotation_degrees", -6.0, 0.08)
		tw.tween_property(btn, "rotation_degrees", 6.0, 0.08)
		tw.tween_property(btn, "rotation_degrees", 0.0, 0.08)

func _on_audio_hint() -> void:
	# Bantuan Tingkat 1: Ulangi suara fonem
	_play_target_audio()

func _on_visual_hint() -> void:
	# Bantuan Tingkat 2: Berikan efek goyangan/sorotan pada tombol jawaban benar
	for btn in buttons_map:
		var data: Dictionary = btn.get_meta("opt_data", {})
		if data.get("is_correct", false):
			var tw: Tween = create_tween().set_loops(3)
			tw.tween_property(btn, "scale", Vector2(1.08, 1.08), 0.25)
			tw.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.25)

func _on_back_pressed() -> void:
	ScaffoldingController.stop_monitoring()
	GameManager.change_state(GameManager.State.MAIN_MENU)
	get_tree().change_scene_to_file("res://src/scenes/main_menu/MainMenu.tscn")
