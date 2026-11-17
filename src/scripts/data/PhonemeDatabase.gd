class_name PhonemeDatabase
extends Node

## Basis Data Fonemik untuk Serious Game AUD
## Mengatur taksonomi bunyi fonem, kata asosiasi, rima, dan referensi aset audio.

# --- VOKAL DASAR (Tingkat 1: Isolasi Bunyi Vokal Awal) ---
const VOWELS: Array[Dictionary] = [
	{
		"phoneme": "a",
		"sound_label": "/a/",
		"primary_word": "apel",
		"audio_phoneme_path": "res://assets/audio/phonemes/vowel_a.wav",
		"audio_word_path": "res://assets/audio/words/word_apel.wav",
		"icon_path": "res://assets/sprites/items/apel.png",
		"distractors": ["ikan", "udang", "ember"]
	},
	{
		"phoneme": "i",
		"sound_label": "/i/",
		"primary_word": "ikan",
		"audio_phoneme_path": "res://assets/audio/phonemes/vowel_i.wav",
		"audio_word_path": "res://assets/audio/words/word_ikan.wav",
		"icon_path": "res://assets/sprites/items/ikan.png",
		"distractors": ["apel", "obor", "ulat"]
	},
	{
		"phoneme": "u",
		"sound_label": "/u/",
		"primary_word": "udang",
		"audio_phoneme_path": "res://assets/audio/phonemes/vowel_u.wav",
		"audio_word_path": "res://assets/audio/words/word_udang.wav",
		"icon_path": "res://assets/sprites/items/udang.png",
		"distractors": ["ember", "ikan", "ayam"]
	},
	{
		"phoneme": "e",
		"sound_label": "/e/",
		"primary_word": "ember",
		"audio_phoneme_path": "res://assets/audio/phonemes/vowel_e.wav",
		"audio_word_path": "res://assets/audio/words/word_ember.wav",
		"icon_path": "res://assets/sprites/items/ember.png",
		"distractors": ["obor", "apel", "ulat"]
	},
	{
		"phoneme": "o",
		"sound_label": "/o/",
		"primary_word": "obor",
		"audio_phoneme_path": "res://assets/audio/phonemes/vowel_o.wav",
		"audio_word_path": "res://assets/audio/words/word_obor.wav",
		"icon_path": "res://assets/sprites/items/obor.png",
		"distractors": ["ikan", "udang", "ayam"]
	}
]

# --- RIMA / BUNYI AKHIR SAMA (Tingkat 2: Kepekaan Rima) ---
const RHYME_SETS: Array[Dictionary] = [
	{
		"target_word": "buku",
		"ending_sound": "-ku",
		"audio_target_path": "res://assets/audio/words/word_buku.wav",
		"correct_match": "kuku",
		"audio_match_path": "res://assets/audio/words/word_kuku.wav",
		"wrong_options": ["bola", "mata", "sapi"]
	},
	{
		"target_word": "mata",
		"ending_sound": "-ta",
		"audio_target_path": "res://assets/audio/words/word_mata.wav",
		"correct_match": "bata",
		"audio_match_path": "res://assets/audio/words/word_bata.wav",
		"wrong_options": ["buku", "ikan", "topi"]
	},
	{
		"target_word": "tari",
		"ending_sound": "-ri",
		"audio_target_path": "res://assets/audio/words/word_tari.wav",
		"correct_match": "jari",
		"audio_match_path": "res://assets/audio/words/word_jari.wav",
		"wrong_options": ["apel", "kuda", "meja"]
	},
	{
		"target_word": "sapi",
		"ending_sound": "-pi",
		"audio_target_path": "res://assets/audio/words/word_sapi.wav",
		"correct_match": "topi",
		"audio_match_path": "res://assets/audio/words/word_topi.wav",
		"wrong_options": ["bata", "buku", "ayam"]
	}
]

# --- KONSONAN & ASOSIASI HURUF (Tingkat 3: Pengenalan Bunyi Konsonan & Grafem) ---
const CONSONANTS: Array[Dictionary] = [
	{
		"letter": "B",
		"phoneme": "/b/",
		"keyword": "bola",
		"audio_phoneme": "res://assets/audio/phonemes/cons_b.wav",
		"audio_word": "res://assets/audio/words/word_bola.wav"
	},
	{
		"letter": "M",
		"phoneme": "/m/",
		"keyword": "mata",
		"audio_phoneme": "res://assets/audio/phonemes/cons_m.wav",
		"audio_word": "res://assets/audio/words/word_mata.wav"
	},
	{
		"letter": "S",
		"phoneme": "/s/",
		"keyword": "sapi",
		"audio_phoneme": "res://assets/audio/phonemes/cons_s.wav",
		"audio_word": "res://assets/audio/words/word_sapi.wav"
	},
	{
		"letter": "K",
		"phoneme": "/k/",
		"keyword": "kuda",
		"audio_phoneme": "res://assets/audio/phonemes/cons_k.wav",
		"audio_word": "res://assets/audio/words/word_kuda.wav"
	}
]

func get_all_vowels() -> Array[Dictionary]:
	return VOWELS

func get_random_vowel_task() -> Dictionary:
	var index: int = randi() % VOWELS.size()
	var selected: Dictionary = VOWELS[index].duplicate(true)
	
	# Siapkan opsi jawaban: 1 jawaban benar + 2 distractor
	var options: Array[Dictionary] = []
	options.append({
		"word": selected["primary_word"],
		"is_correct": true,
		"audio": selected["audio_word_path"]
	})
	
	var distractors: Array = selected["distractors"].duplicate()
	distractors.shuffle()
	for i in range(mini(2, distractors.size())):
		options.append({
			"word": distractors[i],
			"is_correct": false,
			"audio": ""
		})
	
	options.shuffle()
	selected["options"] = options
	return selected

func get_random_rhyme_task() -> Dictionary:
	var index: int = randi() % RHYME_SETS.size()
	var selected: Dictionary = RHYME_SETS[index].duplicate(true)
	
	var options: Array[Dictionary] = []
	options.append({
		"word": selected["correct_match"],
		"is_correct": true,
		"audio": selected["audio_match_path"]
	})
	
	var wrong: Array = selected["wrong_options"].duplicate()
	wrong.shuffle()
	for i in range(mini(2, wrong.size())):
		options.append({
			"word": wrong[i],
			"is_correct": false,
			"audio": ""
		})
	
	options.shuffle()
	selected["options"] = options
	return selected
