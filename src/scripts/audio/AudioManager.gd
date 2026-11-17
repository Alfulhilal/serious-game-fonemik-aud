class_name AudioManager
extends Node

## AudioManager: Pengontrol Audio Terpusat untuk Serious Game AUD
## Mengimplementasikan Audio Ducking (BGM otomatis meredup saat suara fonem/instruksi diputar)
## dan prioritasi playback tanpa latensi.

signal phoneme_finished(phoneme_name: String)

@onready var bgm_player: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var voice_player: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var sfx_player: AudioStreamPlayer = AudioStreamPlayer.new()

var audio_cache: Dictionary = {}
var current_duck_tween: Tween

const BUS_MASTER: StringName = &"Master"
const BUS_MUSIC: StringName = &"Music"
const BUS_SFX: StringName = &"SFX"
const BUS_VOICE: StringName = &"Voice"

const BGM_NORMAL_DB: float = -6.0
const BGM_DUCKED_DB: float = -20.0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Inisialisasi Player
	add_child(bgm_player)
	bgm_player.bus = BUS_MUSIC
	bgm_player.volume_db = BGM_NORMAL_DB
	
	add_child(voice_player)
	voice_player.bus = BUS_VOICE
	voice_player.finished.connect(_on_voice_finished)
	
	add_child(sfx_player)
	sfx_player.bus = BUS_SFX

## Putar musik latar (BGM)
func play_bgm(stream: AudioStream) -> void:
	if bgm_player.stream == stream and bgm_player.playing:
		return
	bgm_player.stream = stream
	bgm_player.play()

## Putar bunyi fonem / instruksi audio (Voice Over) dengan prioritas tertinggi
func play_voice(stream_or_path: Variant, phoneme_tag: String = "") -> void:
	var stream: AudioStream = _resolve_stream(stream_or_path)
	if not stream:
		push_warning("[AudioManager] Stream audio tidak valid atau file belum tersedia: %s" % str(stream_or_path))
		# Tetap kirim signal selesai agar alur game tidak macet (fail-soft)
		phoneme_finished.emit(phoneme_tag)
		return
	
	_duck_bgm(true)
	voice_player.stop()
	voice_player.stream = stream
	voice_player.set_meta("tag", phoneme_tag)
	voice_player.play()

## Putar efek suara (SFX) seperti klik, koin bintang, atau letusan balon
func play_sfx(stream_or_path: Variant) -> void:
	var stream: AudioStream = _resolve_stream(stream_or_path)
	if not stream:
		return
	
	# Menggunakan instance one-shot agar SFX bertumpuk tanpa memotong audio sebelumnya
	var one_shot: AudioStreamPlayer = AudioStreamPlayer.new()
	one_shot.bus = BUS_SFX
	one_shot.stream = stream
	add_child(one_shot)
	one_shot.finished.connect(func(): one_shot.queue_free())
	one_shot.play()

## Ducking BGM (meredupkan BGM secara halus saat Voice aktif)
func _duck_bgm(duck: bool) -> void:
	if current_duck_tween and current_duck_tween.is_valid():
		current_duck_tween.kill()
	
	current_duck_tween = create_tween()
	var target_db: float = BGM_DUCKED_DB if duck else BGM_NORMAL_DB
	var duration: float = 0.2 if duck else 0.5
	current_duck_tween.tween_property(bgm_player, "volume_db", target_db, duration)

func _on_voice_finished() -> void:
	var tag: String = ""
	if voice_player.has_meta("tag"):
		tag = str(voice_player.get_meta("tag"))
	
	_duck_bgm(false)
	phoneme_finished.emit(tag)

func _resolve_stream(stream_or_path: Variant) -> AudioStream:
	if stream_or_path is AudioStream:
		return stream_or_path
	
	if stream_or_path is String and not (stream_or_path as String).is_empty():
		var path: String = stream_or_path
		if audio_cache.has(path):
			return audio_cache[path]
		
		if ResourceLoader.exists(path):
			var res: AudioStream = load(path)
			audio_cache[path] = res
			return res
	
	return null

## Pengaturan Mute Audio (Akses dari Panel Guru/Ortu)
func set_bus_mute(bus_name: StringName, is_muted: bool) -> void:
	var idx: int = AudioServer.get_bus_index(bus_name)
	if idx != -1:
		AudioServer.set_bus_mute(idx, is_muted)
