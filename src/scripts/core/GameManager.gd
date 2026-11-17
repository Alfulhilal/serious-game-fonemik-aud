class_name GameManager
extends Node

## GameManager: State Machine & Pengatur Siklus Game Utama
## Mengatur navigasi antar layar, batasan waktu layar sehat (Screen Time Limiter),
## dan sistem reward bintang/stiker.

enum State {
	SPLASH,
	MAIN_MENU,
	LEVEL_SELECT,
	PLAYING,
	SUCCESS_CHEER,
	STICKER_ALBUM,
	BREAK_TIME,
	TEACHER_PANEL
}

signal state_changed(new_state: State)
signal screen_time_limit_reached()

var current_state: State = State.MAIN_MENU
var current_mini_game: String = ""
var active_student_name: String = "Siswa A"
var total_stars: int = 0
var unlocked_stickers: Array[String] = []

# Pembatasan Screen-Time Ramah AUD (15 menit = 900 detik)
const MAX_SESSION_DURATION_SEC: float = 900.0
var session_elapsed_time: float = 0.0
var is_break_triggered: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	if current_state == State.PLAYING and not is_break_triggered:
		session_elapsed_time += delta
		if session_elapsed_time >= MAX_SESSION_DURATION_SEC:
			is_break_triggered = true
			screen_time_limit_reached.emit()
			change_state(State.BREAK_TIME)

## Transisi State Game
func change_state(new_state: State) -> void:
	if current_state == new_state:
		return
	
	current_state = new_state
	state_changed.emit(new_state)

## Tambahkan bintang penghargaan (Apresiasi Fail-Soft: minimal selalu dapat 1 bintang)
func award_stars(stars_count: int) -> void:
	var valid_stars: int = clampi(stars_count, 1, 3)
	total_stars += valid_stars

## Buka stiker baru untuk album
func unlock_sticker(sticker_id: String) -> void:
	if not unlocked_stickers.has(sticker_id):
		unlocked_stickers.append(sticker_id)

## Reset penghitung waktu layar (misal setelah anak selesai istirahat)
func reset_break_timer() -> void:
	session_elapsed_time = 0.0
	is_break_triggered = false
	change_state(State.MAIN_MENU)

## Beralih ke adegan tertentu secara aman
func load_scene(scene_path: String) -> void:
	get_tree().change_scene_to_file(scene_path)
