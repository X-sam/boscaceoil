package;

import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;

class Musicphraseclass {
	public function new():Void {
		for (i in 0...129) {
			notes.push(new Rectangle(-1, 0, 0, 0));
		}
		for (i in 0...16) {
			cutoffgraph.push(128);
			resonancegraph.push(0);
			volumegraph.push(256);
		}
		clear();
	}

	public function clear():Void {
		for (i in 0...128) {
			notes[i].setTo(-1, 0, 0, 0);
		}

		for (i in 0...16) {
			cutoffgraph[i] = 128;
			resonancegraph[i] = 0;
			volumegraph[i] = 256;
		}
		start = 48; // start at c4
		numnotes = 0;
		instr = 0;
		scale = 0;
		key = 0;

		palette = 0;
		isplayed = false;

		recordfilter = 0;
		topnote = -1;
		bottomnote = 250;

		hash = 0;
	}

	public function findtopnote():Void {
		topnote = -1;
		for (i in 0...numnotes) {
			if (notes[i].x > topnote) {
				topnote = notes[i].x;
			}
		}
	}

	public function findbottomnote():Void {
		bottomnote = 250;
		for (i in 0...numnotes) {
			if (notes[i].x < bottomnote) {
				bottomnote = notes[i].x;
			}
		}
	}

	public function transpose(amount:Dynamic /*:Int*/):Void {
		for (i in 0...numnotes) {
			if (notes[i].x != -1) {
				if (Control.invertpianoroll[cast notes[i].x] + amount != -1) {
					notes[i].x = Control.pianoroll[Control.invertpianoroll[cast notes[i].x] + amount];
				}
			}
			if (notes[i].x < 0)
				notes[i].x = 0;
			if (notes[i].x > 104)
				notes[i].x = 104;
		}
	}

	public function addnote(noteindex:Dynamic /*:Int*/, note:Dynamic /*:Int*/, time:Dynamic /*:Int*/):Void {
		if (numnotes < 128) {
			notes[numnotes].setTo(note, time, noteindex, 0);
			numnotes++;
		}

		if (note > topnote)
			topnote = note;
		if (note < bottomnote)
			bottomnote = note;
		notespan = topnote - bottomnote;

		hash = (hash + (note * time)) % 2147483647;
	}

	public function noteat(noteindex:Dynamic /*:Int*/, note:Dynamic /*:Int*/):Bool {
		// Returns true if there is a note that Intersects the cursor position
		for (i in 0...numnotes) {
			if (notes[i].x == note) {
				if (noteindex >= notes[i].width && noteindex < notes[i].width + notes[i].y) {
					return true;
				}
			}
		}
		return false;
	}

	public function removenote(noteindex:Dynamic /*:Int*/, note:Dynamic /*:Int*/):Void {
		// Remove any note that Intersects that cursor position!
		var i = 0;
		while (i < numnotes) {
			if (notes[i].x == note) {
				if (noteindex >= notes[i].width && noteindex < notes[i].width + notes[i].y) {
					deletenote(i);
					i--;
				}
			}
			i++;
		}

		findtopnote();
		findbottomnote();
		notespan = topnote - bottomnote;
	}

	public function setnotespan():Void {
		findtopnote();
		findbottomnote();
		notespan = topnote - bottomnote;
	}

	public function deletenote(t:Dynamic /*:Int*/):Void {
		// Remove note t, rearrange note vector
		for (i in t...numnotes) {
			notes[i].x = notes[i + 1].x;
			notes[i].y = notes[i + 1].y;
			notes[i].width = notes[i + 1].width;
			notes[i].height = notes[i + 1].height;
		}
		numnotes--;
	}

	public var notes:Array<Rectangle> = new Array<Rectangle>();
	public var start:Dynamic /*:Int*/;
	public var numnotes:Dynamic /*:Int*/;

	public var cutoffgraph:Array<Int> = new Array<Int>();
	public var resonancegraph:Array<Int> = new Array<Int>();
	public var volumegraph:Array<Int> = new Array<Int>();
	public var recordfilter:Dynamic /*:Int*/;

	public var topnote:Dynamic /*:Int*/;
	public var bottomnote:Dynamic /*:Int*/;
	public var notespan:Dynamic /*:Float*/;

	public var key:Dynamic /*:Int*/;
	public var scale:Dynamic /*:Int*/;

	public var instr:Dynamic /*:Int*/;

	public var palette:Dynamic /*:Int*/;

	public var isplayed:Bool;

	public var hash:Dynamic /*:Int*/; // massively simplified thing
}
