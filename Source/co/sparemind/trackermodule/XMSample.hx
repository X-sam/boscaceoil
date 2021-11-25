package co.sparemind.trackermodule;

import openfl.utils.ByteArray;
import openfl.utils.Endian;

class XMSample {
	public var volume:UInt;
	public var finuetune:UInt = 0;
	// type bitfield: looping, 8-bit/16-bit
	public var panning:UInt = 0x80;
	public var relativeNoteNumber:Int = 0;

	private var _name:ByteArray;

	public var data:ByteArray;
	public var bitsPerSample:UInt = 8;
	public var finetune:UInt = 0;
	public var loopStart:UInt = 0;
	public var loopLength:UInt = 0;
	public var loopsForward:Bool = false;

	public function new() {
		_name = new ByteArray();
		_name.endian = Endian.LITTLE_ENDIAN;
		this.name = '                      ';
	}

	public var name(get, set):String;

	public function get_name():String {
		return _name.toString();
	}

	public function set_name(unpadded:String):String {
		_name.clear();
		_name.writeMultiByte(unpadded.substr(0, 22), 'us-ascii');
		for (i in _name.length...22) {
			_name.writeByte(0x20); // space-padded
		}
		return _name.toString();
	}
}
