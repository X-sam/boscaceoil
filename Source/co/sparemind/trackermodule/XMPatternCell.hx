package co.sparemind.trackermodule;

class XMPatternCell {
	public var note:UInt = 0;
	public var instrument:UInt = 0;
	public var volume:UInt = 0;
	public var effect:UInt = 0;
	public var effectParam:UInt = 0;

	public function new(config:Dynamic = null) {
		if (config == null) {
			return;
		}

		note = config.note;
		instrument = config.instrument;
		volume = config.volume;
		effect = config.effect;
		effectParam = config.effectParam;
	}

	public function isEmpty():Bool {
		return (note == 0 && instrument == 0 && volume == 0 && effect == 0 && effectParam == 0);
	}
}
