class_name MainMenu
extends Control

## MainMenu: Antarmuka Beranda Ramah Anak (Aesthetics: Joy, Warmth, & Safety)
## Tombol berukuran besar (> 200px lebar, 180px tinggi) dengan teks tebal dan ikon intuitif.

@onready var btn_kebun_vokal: Button = $MenuGrid/BtnKebunVokal
@onready var btn_balon_rima: Button = $MenuGrid/BtnBalonRima
@onready var btn_rumah_huruf: Button = $MenuGrid/BtnRumahHuruf
@onready var btn_album_stiker: Button = $MenuGrid/BtnAlbumStiker
@onready var btn_teacher_panel: Button = $BtnTeacherPanel

func _ready() -> void:
	btn_kebun_vokal.pressed.connect(_on_kebun_vokal_pressed)
	btn_balon_rima.pressed.connect(_on_balon_rima_pressed)
	btn_rumah_huruf.pressed.connect(_on_rumah_huruf_pressed)
	btn_album_stiker.pressed.connect(_on_album_stiker_pressed)
	btn_teacher_panel.pressed.connect(_on_teacher_panel_pressed)

func _on_kebun_vokal_pressed() -> void:
	AudioManager.play_sfx("res://assets/audio/sfx/click.wav")
	GameManager.current_mini_game = "KEBUN_VOKAL"
	GameManager.change_state(GameManager.State.PLAYING)
	get_tree().change_scene_to_file("res://src/scenes/mini_games/KebunVokal.tscn")

func _on_balon_rima_pressed() -> void:
	AudioManager.play_sfx("res://assets/audio/sfx/click.wav")
	GameManager.current_mini_game = "BALON_RIMA"
	GameManager.change_state(GameManager.State.PLAYING)
	get_tree().change_scene_to_file("res://src/scenes/mini_games/BalonRima.tscn")

func _on_rumah_huruf_pressed() -> void:
	AudioManager.play_sfx("res://assets/audio/sfx/click.wav")
	GameManager.current_mini_game = "RUMAH_HURUF"
	GameManager.change_state(GameManager.State.PLAYING)
	print("[MainMenu] Masuk ke Rumah Huruf")

func _on_album_stiker_pressed() -> void:
	AudioManager.play_sfx("res://assets/audio/sfx/click.wav")
	GameManager.change_state(GameManager.State.STICKER_ALBUM)
	print("[MainMenu] Buka Album Stiker")

func _on_teacher_panel_pressed() -> void:
	AudioManager.play_sfx("res://assets/audio/sfx/click.wav")
	GameManager.change_state(GameManager.State.TEACHER_PANEL)
	get_tree().change_scene_to_file("res://src/scenes/teacher_panel/TeacherPanel.tscn")
