class_name ScaffoldingController
extends Node

## ScaffoldingController: Sistem Bantuan Adaptif (Dynamics Layer)
## Memantau jeda kebingungan anak (inactivity) dan jumlah percobaan keliru berturut-turut.
## Memicu petunjuk bertingkat: Pengulangan Audio (Tingkat 1) -> Petunjuk Visual Goyangan (Tingkat 2).

signal audio_hint_requested()
signal visual_hint_requested()
signal scaffolding_reset()

@export var idle_audio_hint_delay: float = 5.0    # 5 detik tanpa sentuhan -> ulang instruksi suara
@export var idle_visual_hint_delay: float = 10.0   # 10 detik tanpa sentuhan -> goyangkan opsi yang benar
@export var max_consecutive_misses: int = 2       # 2 kali salah -> aktifkan bantuan visual

var idle_timer: float = 0.0
var is_active: bool = false
var consecutive_misses: int = 0
var audio_hint_given: bool = false
var visual_hint_given: bool = false

func _process(delta: float) -> void:
	if not is_active:
		return
	
	idle_timer += delta
	
	# Pemicu Petunjuk Tingkat 1: Audio Ulang
	if idle_timer >= idle_audio_hint_delay and not audio_hint_given:
		audio_hint_given = true
		audio_hint_requested.emit()
	
	# Pemicu Petunjuk Tingkat 2: Visual Wiggle
	if idle_timer >= idle_visual_hint_delay and not visual_hint_given:
		visual_hint_given = true
		visual_hint_requested.emit()

## Memulai pemantauan babak baru
func start_monitoring() -> void:
	reset_monitoring()
	is_active = true

## Menghentikan pemantauan (misal saat jeda atau transisi animasi perayaan)
func stop_monitoring() -> void:
	is_active = false

## Reset seluruh timer saat anak menyentuh layar
func reset_idle_timer() -> void:
	idle_timer = 0.0
	audio_hint_given = false
	visual_hint_given = false

## Catat jika anak memilih jawaban keliru (tanpa hukuman nilai)
func register_mistake() -> void:
	consecutive_misses += 1
	reset_idle_timer()
	
	# Jika berturut-turut salah mencapai batas, langsung berikan visual hint
	if consecutive_misses >= max_consecutive_misses:
		visual_hint_given = true
		visual_hint_requested.emit()

## Reset total ketika anak berhasil menyelesaikan tantangan
func reset_monitoring() -> void:
	idle_timer = 0.0
	consecutive_misses = 0
	audio_hint_given = false
	visual_hint_given = false
	scaffolding_reset.emit()
