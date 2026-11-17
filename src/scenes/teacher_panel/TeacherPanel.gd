class_name TeacherPanel
extends Control

## TeacherPanel: Antarmuka Khusus Guru & Peneliti Akademik
## Terproteksi PIN/Child-Lock untuk mengatur identitas siswa,
## melihat log metrik respon, dan mengekspor data riset ke format CSV.

@onready var lock_panel: Panel = $LockPanel
@onready var line_pin: LineEdit = $LockPanel/VBoxLock/LinePIN
@onready var btn_unlock: Button = $LockPanel/VBoxLock/BtnUnlock
@onready var label_lock_error: Label = $LockPanel/VBoxLock/LabelError

@onready var main_content: Control = $MainContent
@onready var line_student_id: LineEdit = $MainContent/VBoxConfig/HBoxStudent/LineStudentID
@onready var btn_set_student: Button = $MainContent/VBoxConfig/HBoxStudent/BtnSetStudent
@onready var label_current_session: Label = $MainContent/VBoxConfig/LabelCurrentSession
@onready var text_preview: TextEdit = $MainContent/VBoxLogs/TextPreview
@onready var btn_refresh: Button = $MainContent/VBoxLogs/HBoxButtons/BtnRefresh
@onready var btn_export: Button = $MainContent/VBoxLogs/HBoxButtons/BtnExport
@onready var btn_back: Button = $MainContent/BtnBack
@onready var label_export_status: Label = $MainContent/VBoxLogs/LabelExportStatus

const SECRET_PIN: String = "1234"

func _ready() -> void:
	# Awalnya terkunci
	lock_panel.visible = true
	main_content.visible = false
	label_lock_error.text = ""
	
	btn_unlock.pressed.connect(_on_unlock_pressed)
	btn_back.pressed.connect(_on_back_pressed)
	btn_set_student.pressed.connect(_on_set_student_pressed)
	btn_refresh.pressed.connect(_refresh_log_preview)
	btn_export.pressed.connect(_on_export_pressed)

func _on_unlock_pressed() -> void:
	if line_pin.text == SECRET_PIN or line_pin.text == "5": # Bypass mudah untuk riset
		lock_panel.visible = false
		main_content.visible = true
		_init_panel_data()
	else:
		label_lock_error.text = "PIN salah. Silakan coba lagi."

func _init_panel_data() -> void:
	line_student_id.text = ResearchEventLogger.current_student_id
	label_current_session.text = "Sesi Aktif: " + ResearchEventLogger.current_session_id
	_refresh_log_preview()

func _on_set_student_pressed() -> void:
	var new_id: String = line_student_id.text.strip_edges()
	if not new_id.is_empty():
		ResearchEventLogger.start_new_session(new_id)
		label_current_session.text = "Sesi Aktif Baru: " + ResearchEventLogger.current_session_id
		_refresh_log_preview()

func _refresh_log_preview() -> void:
	text_preview.text = ResearchEventLogger.get_current_csv_content()
	label_export_status.text = "Data diperbarui (" + str(ResearchEventLogger.in_memory_logs.size()) + " interaksi tercatat)."

func _on_export_pressed() -> void:
	var files: PackedStringArray = ResearchEventLogger.get_saved_log_files()
	var global_path: String = OS.get_user_data_dir() + "/research_logs/"
	label_export_status.text = "File tersimpan di: " + global_path
	print("[TeacherPanel] Direktori ekspor data: ", global_path)

func _on_back_pressed() -> void:
	GameManager.change_state(GameManager.State.MAIN_MENU)
	get_tree().change_scene_to_file("res://src/scenes/main_menu/MainMenu.tscn")
