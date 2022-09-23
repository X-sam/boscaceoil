package;

import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;
import org.si.sion.SiONVoice;

class Drumkitclass {
	public function new():Void {
		size = 0;
	}

	public function updatefilter(cutoff:Int, resonance:Int):Void {
		for (i in 0...size) {
			if (voicelist[i].channelParam.cutoff != cutoff || voicelist[i].channelParam.resonance != resonance) {
				voicelist[i].setFilterEnvelop(0, cutoff, resonance);
			}
		}
	}

	public function updatevolume(volume:Int):Void {
		for (i in 0...size) {
			if (voicelist[i].velocity != volume) {
				voicelist[i].updateVolumes = true;
				voicelist[i].velocity = volume;
			}
		}
	}

	public var voicelist:Array<SiONVoice> = new Array<SiONVoice>();
	public var voicename:Array<String> = new Array<String>();
	public var voicenote:Array<Int> = new Array<Int>();
	public var midivoice:Array<Int> = new Array<Int>();
	public var kitname:String;
	public var size:Int;
}
