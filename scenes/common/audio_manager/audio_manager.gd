extends Node

# ------------------------------------------------------------------------------

const DEFAULT_AUDIO_SETTINGS: AudioSettings = preload("uid://cxuldc155rijc")


var _groups: Dictionary[StringName, AudioGroup] = {}

var _audio_player_a: AUMAPlayer = null
var _audio_player_b: AUMAPlayer = null

var _current_audio_player: AUMAPlayer = null
var _previous_audio_player: AUMAPlayer = null

var _current_loop_group: StringName = &""
var _current_loop_id: StringName = &""

# ------------------------------------------------------------------------------

func _ready() -> void:
	_audio_player_a = AUMAPlayer.new()
	add_child(_audio_player_a)
	_audio_player_b = AUMAPlayer.new()
	add_child(_audio_player_b)

	_current_audio_player = _audio_player_a
	_previous_audio_player = _audio_player_b


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass

# ------------------------------------------------------------------------------

func add_group(id: StringName, group: AudioGroup) -> bool:
	return _add_group(id, group)


func pop_group(id: StringName) -> AudioGroup:
	return _pop_group(id)


func erase_group(id: StringName) -> void:
	_erase_group(id)


func play_one_shot(
		group_name: StringName, id: StringName,
		override_settings: AudioSettings = null) -> void:
	_play_one_shot(group_name, id, override_settings)


func play_loop(
		group_name: StringName, id: StringName,
		override_settings: AudioSettings = null) -> void:
	_play_loop(group_name, id, override_settings)


func stop_loop(duration: float = AUMAPlayer.DEFAULT_FADE_OUT_DURATION) -> void:
	_stop_loop(duration)

# ------------------------------------------------------------------------------

func _add_group(id: StringName, group: AudioGroup) -> bool:
	if not _groups.get(id) == null:
		return false
	_groups[id] = group
	return true


func _pop_group(id: StringName) -> AudioGroup:
	var group: AudioGroup = _groups.get(id)
	_groups.erase(id)
	return group


func _erase_group(id: StringName) -> void:
	_groups.erase(id)


func _play_one_shot(
		group_name: StringName, id: StringName,
		override_settings: AudioSettings = null) -> void:
	if not override_settings:
		override_settings = DEFAULT_AUDIO_SETTINGS

	var group: AudioGroup = _groups.get(group_name)
	if not group:
		FDLog.log_warn(
				"[AudioManager]: OneShot: Attempted to play unexistent group "
				+ ("\"%s\"" % group_name))
		return

	var stream: AudioStream = group.get_content_stream(id)
	if not stream:
		FDLog.log_warn(
				"[AudioManager]: OneShot: Attempted to play unexistent stream "
				+ ("\"%s\" from group \"%s\"." % [id, group_name]))
		return

	var audio_player: AudioStreamPlayer = AudioStreamPlayer.new()
	_apply_settings_to_audio_player(override_settings, audio_player)
	audio_player.set_stream(stream)
	audio_player.set_bus(group.bus_name)
	add_child(audio_player)
	audio_player.finished.connect(audio_player.queue_free)
	audio_player.play()


func _play_loop(
		group_name: StringName, id: StringName,
		override_settings: AudioSettings = null,
		fade_duration: float = AUMAPlayer.DEFAULT_FADE_IN_DURATION) -> void:
	if not _current_audio_player:
		FDLog.log_warn(
				"[AudioManager]: Attempted to play loop, but no audio_manager "
				+ "was defined.")
		return
	elif group_name == _current_loop_group and id == _current_loop_id:
		FDLog.log_warn(
				"[AudioManager]: Attempted to play loop with same stream.")
		return

	if not override_settings:
		override_settings = DEFAULT_AUDIO_SETTINGS

	var group: AudioGroup = _groups.get(group_name)
	if not group:
		FDLog.log_warn(
				"[AudioManager]: Loop: Attempted to play unexistent group "
				+ ("\"%s\"" % group_name))
		return

	var stream: AudioStream = group.get_content_stream(id)
	if not stream:
		FDLog.log_warn(
				"[AudioManager]: Loop: Attempted to play unexistent stream "
				+ ("\"%s\" from group \"%s\"." % [id, group_name]))
		return

	var temp_audio_player: AUMAPlayer = _current_audio_player
	_current_audio_player = _previous_audio_player
	_previous_audio_player = temp_audio_player

	_current_loop_group = group_name
	_current_loop_id = id
	_current_audio_player.set_stream(stream)
	_apply_settings_to_audio_player(override_settings, _current_audio_player)
	_current_audio_player.set_bus(group.bus_name)

	_current_audio_player.fade_in(fade_duration)
	_previous_audio_player.fade_out(fade_duration)


func _stop_loop(duration: float = AUMAPlayer.DEFAULT_FADE_OUT_DURATION) -> void:
	if not _current_audio_player:
		FDLog.log_warn(
				"[AudioManager]: Attempted to stop loop, but no audio_manager "
				+ "was defined.")
		return

	_current_audio_player.fade_out(duration)


func _apply_settings_to_audio_player(
		audio_settings: AudioSettings, audio_player: AudioStreamPlayer) -> void:
	if not audio_settings:
		FDLog.log_warn(
				"[AudioManager]: Attempted to apply null settings to audio "
				+ "player. Ignoring operation.")
		return
	elif not audio_player:
		FDLog.log_warn(
				"[AudioManager]: Attempted to apply settings to null audio "
				+ "player. Ignoring operation.")
		return

	var pitch_scale: float = audio_settings.pitch_scale + randf_range(
			-audio_settings.pitch_randomness,
			audio_settings.pitch_randomness)

	audio_player.set_volume_db(audio_settings.volume_db)
	audio_player.set_pitch_scale(pitch_scale)

