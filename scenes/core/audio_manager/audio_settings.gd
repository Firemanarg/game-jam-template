class_name AudioSettings
extends Resource

# ------------------------------------------------------------------------------

const DEFAULT_VOLUME_DB: float = 0.0
const DEFAULT_PITCH_SCALE: float = 1.0
const DEFAULT_PITCH_RANDOMNESS: float = 0.0


@export var volume_db: float = 0.0
@export var pitch_scale: float = 1.0
@export var pitch_randomness: float = 0.0

# ------------------------------------------------------------------------------

func _init(
		_volume_db: float = 0.0,
		_pitch_scale: float = 1.0,
		_pitch_randomness: float = 0.0) -> void:
	volume_db = _volume_db
	pitch_scale = _pitch_scale
	pitch_randomness = _pitch_randomness
