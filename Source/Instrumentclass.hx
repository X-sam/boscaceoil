package;

import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;
import org.si.sion.SiONVoice;

class Instrumentclass {
	public function new():Void {
		clear();
	}

	public function clear():Void {
		category = "MIDI";
		name = "Grand Piano";
		type = 0;
		index = 0;
		cutoff = 128;
		resonance = 0;
		palette = 0;
		volume = 256;
	}

	public function setfilter(c:Int, r:Int):Void {
		cutoff = c;
		resonance = r;
	}

	public function setvolume(v:Int):Void {
		volume = v;
	}

	public function updatefilter():Void {
		if (voice != null) {
			if (voice.velocity != volume) {
				voice.updateVolumes = true;
				voice.velocity = volume;
			}
			if (voice.channelParam.cutoff != cutoff || voice.channelParam.resonance != resonance) {
				voice.setFilterEnvelop(0, cutoff, resonance);
			}
		}
	}

	public function changefilterto(c:Int, r:Int, v:Int):Void {
		if (voice != null) {
			voice.updateVolumes = true;
			voice.velocity = v;
			voice.setFilterEnvelop(0, c, r);
		}
	}

	public function changevolumeto(v:Int):Void {
		if (voice != null) {
			voice.updateVolumes = true;
			voice.velocity = v;
		}
	}

	public var cutoff:Int;
	public var resonance:Int;

	public var voice:SiONVoice = new SiONVoice();
	public var category:String;
	public var name:String;
	public var palette:Int;
	public var type:Int;
	public var index:Int;
	public var volume:Int;
}
