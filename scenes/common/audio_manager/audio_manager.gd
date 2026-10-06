extends Node

# ------------------------------------------------------------------------------

const DEFAULT_AUDIO_SETTINGS: AudioSettings = preload("uid://cxuldc155rijc")


var _groups: Dictionary[StringName, AudioGroup] = {}

# ------------------------------------------------------------------------------

func _ready() -> void:
	pass


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
				"[AudioManager]: Attempted to play unexistent group "
				+ ("\"%s\"" % group_name))
		return

	var stream: AudioStream = group.get_content_stream(id)
	if not stream:
		FDLog.log_warn(
				"[AudioManager]: Attempted to play unexistent stream "
				+ ("\"%s\" from group \"%s\"." % [id, group_name]))
		return

	var audio_player: AudioStreamPlayer = AudioStreamPlayer.new()
	_apply_settings_to_audio_player(override_settings, audio_player)
	audio_player.set_stream(stream)
	audio_player.set_bus(group.bus_name)
	add_child(audio_player)
	audio_player.finished.connect(audio_player.queue_free)
	audio_player.play()


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

