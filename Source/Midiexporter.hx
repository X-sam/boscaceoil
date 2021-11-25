package;

import flash.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.utils.*;
import openfl.net.*;

#if (CONFIG == "none") // TODO:FIXME: -Port ocean midas3 to haxe? -Sam!
// import ocean.midi.*;
// import ocean.midi.event.*;
// import ocean.midi.model.*;
// Taking Midias library calls away from midicontrol
class Midiexporter {
	// MidiFile
	// MidiTrack
	// MetaItem
	// NoteItem
	// ChannelItem
	public function new() {
		midifile = new MidiFile();
	}

	public function addnewtrack():Void {
		midifile.addTrack(new MidiTrack());
	}

	public function nexttrack():Void {
		addnewtrack();
		currenttrack = midifile.track(midifile._trackArray.length - 1);
	}

	public function writetimesig():Void {
		currenttrack._msgList.push(new MetaItem());
		var t:Int = currenttrack._msgList.length - 1;
		currenttrack._msgList[t].type = 0x58; // Time Signature
		var myba:ByteArray = new ByteArray();
		myba.writeByte(0x04);
		myba.writeByte(0x02);
		myba.writeByte(0x18);
		myba.writeByte(0x08);
		currenttrack._msgList[t].text = myba;
	}

	public function writetempo(tempo:Int):Void {
		currenttrack._msgList.push(new MetaItem());
		var t:Int = currenttrack._msgList.length - 1;
		currenttrack._msgList[t].type = 0x51; // Set Tempo
		var tempoinmidiformat:Int = 60000000 / tempo;

		var byte1:Int = (tempoinmidiformat >> 16) & 0xFF;
		var byte2:Int = (tempoinmidiformat >> 8) & 0xFF;
		var byte3:Int = tempoinmidiformat & 0xFF;

		var myba:ByteArray = new ByteArray();
		myba.writeByte(byte1);
		myba.writeByte(byte2);
		myba.writeByte(byte3);
		currenttrack._msgList[t].text = myba;
	}

	public function writeinstrument(instr:Int, channel:Int):Void {
		currenttrack._msgList.push(new ChannelItem());
		var t:Int = currenttrack._msgList.length - 1;
		currenttrack._msgList[t]._kind = 0xC0; // Program Change
		currenttrack._msgList[t]._command = 192 + channel;
		currenttrack._msgList[t]._data1 = instr;
	}

	public function writenote(channel:Int, pitch:Int, time:Int, length:Int, volume:Int):Void {
		volume = volume / 2;
		if (volume > 127)
			volume = 127;

		currenttrack._msgList.push(new NoteItem(channel, pitch, volume, length, time));
	}

	public var midifile:MidiFile;
	public var currenttrack:MidiTrack;
}
#end
