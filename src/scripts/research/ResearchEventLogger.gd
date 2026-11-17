class_name ResearchEventLogger
extends Node

## ResearchEventLogger: Modul Pencatatan Data Eksperimen Akademik
## Mencatat log waktu reaksi anak, pilihan jawaban, kesalahan, dan pemicu scaffolding.
## Data diekspor dalam format CSV standar (RFC 4180) untuk analisis SPSS / Excel.

signal log_recorded(entry: Dictionary)

var current_session_id: String = ""
var current_student_id: String = "SISWA_ANONIM"
var in_memory_logs: Array[Dictionary] = []

const LOG_DIR: String = "user://research_logs/"

func _ready() -> void:
	start_new_session()

## Memulai sesi baru (biasanya dipanggil saat anak mulai bermain atau berganti siswa)
func start_new_session(student_id: String = "") -> void:
	if not student_id.is_empty():
		current_student_id = student_id
	
	var unix_time: int = int(Time.get_unix_time_from_system())
	current_session_id = "SESI_%s_%d" % [current_student_id, unix_time]
	in_memory_logs.clear()
	
	# Pastikan folder log lokal ada
	if not DirAccess.dir_exists_absolute(LOG_DIR):
		DirAccess.make_dir_recursive_absolute(LOG_DIR)

## Catat event interaksi uji coba fonemik
func log_interaction(
	game_mode: String,
	level_index: int,
	target_item: String,
	selected_item: String,
	is_correct: bool,
	reaction_time_sec: float,
	scaffolding_triggered: String = "NONE",
	attempt_number: int = 1
) -> void:
	var entry: Dictionary = {
		"session_id": current_session_id,
		"student_id": current_student_id,
		"timestamp": Time.get_datetime_string_from_system(false, true),
		"game_mode": game_mode,
		"level_index": level_index,
		"target_item": target_item,
		"selected_item": selected_item,
		"is_correct": is_correct,
		"reaction_time_sec": snappedf(reaction_time_sec, 0.01),
		"scaffolding_triggered": scaffolding_triggered,
		"attempt_number": attempt_number
	}
	
	in_memory_logs.append(entry)
	log_recorded.emit(entry)
	
	# Simpan berkas inkremental agar data tidak hilang bila game tiba-tiba ditutup
	_append_log_to_file(entry)

func _append_log_to_file(entry: Dictionary) -> void:
	var file_path: String = "%s%s.csv" % [LOG_DIR, current_session_id]
	var file_exists: bool = FileAccess.file_exists(file_path)
	
	var file: FileAccess = FileAccess.open(file_path, FileAccess.WRITE_READ if file_exists else FileAccess.WRITE)
	if not file:
		push_error("[ResearchEventLogger] Gagal membuka file log untuk ditulis: %s" % file_path)
		return
	
	if not file_exists:
		# Tulis Header CSV
		var header: String = "session_id,student_id,timestamp,game_mode,level_index,target_item,selected_item,is_correct,reaction_time_sec,scaffolding_triggered,attempt_number\n"
		file.store_string(header)
	else:
		file.seek_end()
	
	# Format Baris CSV
	var row: String = "%s,%s,%s,%s,%d,%s,%s,%s,%.2f,%s,%d\n" % [
		entry["session_id"],
		entry["student_id"],
		entry["timestamp"],
		entry["game_mode"],
		entry["level_index"],
		entry["target_item"],
		entry["selected_item"],
		"1" if entry["is_correct"] else "0",
		entry["reaction_time_sec"],
		entry["scaffolding_triggered"],
		entry["attempt_number"]
	]
	
	file.store_string(row)
	file.close()

## Mendapatkan daftar seluruh berkas log tersimpan
func get_saved_log_files() -> PackedStringArray:
	if not DirAccess.dir_exists_absolute(LOG_DIR):
		return PackedStringArray()
	var dir: DirAccess = DirAccess.open(LOG_DIR)
	return dir.get_files()

## Ekspor isi log ke path tertentu atau kembalikan string CSV utuh
func get_current_csv_content() -> String:
	var csv_text: String = "session_id,student_id,timestamp,game_mode,level_index,target_item,selected_item,is_correct,reaction_time_sec,scaffolding_triggered,attempt_number\n"
	for e in in_memory_logs:
		csv_text += "%s,%s,%s,%s,%d,%s,%s,%s,%.2f,%s,%d\n" % [
			e["session_id"],
			e["student_id"],
			e["timestamp"],
			e["game_mode"],
			e["level_index"],
			e["target_item"],
			e["selected_item"],
			"1" if e["is_correct"] else "0",
			e["reaction_time_sec"],
			e["scaffolding_triggered"],
			e["attempt_number"]
		]
	return csv_text
