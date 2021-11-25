package;

import openfl.utils.IDataOutput;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
import openfl.geom.Rectangle;
import org.si.sion.SiONDriver;
import org.si.sion.SiONVoice;
import co.sparemind.trackermodule.XMSong;
import co.sparemind.trackermodule.XMInstrument;
import co.sparemind.trackermodule.XMSample;
import co.sparemind.trackermodule.XMPattern;
import co.sparemind.trackermodule.XMPatternLine;
import co.sparemind.trackermodule.XMPatternCell;

class TrackerModuleXM {
	public function new() {}

	public var xm:XMSong;

	public function loadFromLiveBoscaCeoilModel(desiredSongName:String):Void {
		var boscaInstrument:Instrumentclass;

		xm = new XMSong();

		xm.songname = desiredSongName;
		xm.defaultBPM = Control.bpm;
		xm.defaultTempo = Std.int(Control.bpm / 20);
		xm.numChannels = 8; // bosca has a hard-coded limit
		xm.numInstruments = Control.numinstrument;

		var notesByEachInstrumentNumber:Array<Array<Int>> = _notesUsedByEachInstrumentAcrossEntireSong();

		// map notes to other notes (mostly for drums)
		var perInstrumentBoscaNoteToXMNoteMap:Array<Array<UInt>> = new Array<Array<UInt>>();
		for (i in 0...Control.numinstrument) {
			boscaInstrument = Control.instrument[i];
			var boscaNoteToXMNoteMapForThisInstrument:Array<UInt> = _boscaNoteToXMNoteMapForInstrument(boscaInstrument, notesByEachInstrumentNumber[i]);
			perInstrumentBoscaNoteToXMNoteMap[i] = boscaNoteToXMNoteMapForThisInstrument;
		}

		// pattern arrangement
		for (i in 0...Control.arrange.lastbar) {
			var xmpat:XMPattern = xmPatternFromBoscaBar(i, perInstrumentBoscaNoteToXMNoteMap);
			xm.patterns.push(xmpat);
			xm.patternOrderTable[i] = i;
			xm.numPatterns++;
			xm.songLength++;
		}

		for (i in 0...Control.numinstrument) {
			boscaInstrument = Control.instrument[i];
			var xmInstrument:XMInstrument = new XMInstrument();
			var notesUsed:Array<Int> = notesByEachInstrumentNumber[i];
			xmInstrument.name = boscaInstrument.name;
			xmInstrument.volume = Std.int(boscaInstrument.volume / 4);
			switch (boscaInstrument.type) {
				case 0:
					xmInstrument.addSample(_boscaInstrumentToXMSample(boscaInstrument, Control._driver));
					break;
				default:
					// XXX: bosca ceoil drumkits are converted lossily to a single XM
					// instrument, but they could be converted to several instruments.
					var drumkitNumber:UInt = Std.int(boscaInstrument.type - 1);
					xmInstrument.addSamples(_boscaDrumkitToXMSamples(Control.drumkit[drumkitNumber], notesUsed, perInstrumentBoscaNoteToXMNoteMap[i],
						Control._driver));
					for (s in 0...notesUsed.length) {
						var sionNote:Int = notesUsed[s];
						var key:UInt = perInstrumentBoscaNoteToXMNoteMap[i][sionNote] - 1; // 0th key is note 1
						xmInstrument.keymapAssignments[key] = s;
					}

					for (sample in xmInstrument.samples) {
						sample.volume = xmInstrument.volume;
					}
			}

			xm.addInstrument(xmInstrument);
		}
	}

	public function writeToStream(stream:IDataOutput):Void {
		xm.writeToStream(stream);
	}

	public function _notesUsedByEachInstrumentAcrossEntireSong():Array<Array<Int>> {
		var seenNotePerInstrument:Array<Dynamic> = [];
		var i:UInt;
		var n:Int;

		// start with a clear 2d array
		for (i in 0...Control.numinstrument) {
			seenNotePerInstrument[i] = [];
		}

		// build a 2d sparse boolean array of notes used
		for (i in 0...Control.numboxes) {
			var box:Musicphraseclass = Control.musicbox[i];
			var instrumentNum:Int = box.instr;

			for (n in 0...box.numnotes) {
				var noteNum:Int = Std.int(box.notes[n].x);
				seenNotePerInstrument[instrumentNum][noteNum] = true;
			}
		}

		// map the sparse boolean array Into a list of list of Ints
		var notesUsedByEachInstrument:Array<Array<Int>> = new Array<Array<Int>>();
		for (i in 0...seenNotePerInstrument.length) {
			var notesUsedByThisInstrument:Array<Int> = new Array<Int>();
			for (n in 0...seenNotePerInstrument[i].length) {
				if (seenNotePerInstrument[i][n]) {
					notesUsedByThisInstrument.push(n);
				}
			}
			notesUsedByEachInstrument.push(notesUsedByThisInstrument);
		}

		return notesUsedByEachInstrument;
	}

	private function xmPatternFromBoscaBar(barNum:UInt, instrumentNoteMap:Array<Array<UInt>>):XMPattern {
		var numtracks:UInt = 8;
		var numrows:UInt = Control.boxcount;
		var pattern:XMPattern = new XMPattern(numrows);
		var rows:haxe.ds.Vector<XMPatternLine> = pattern.rows;
		// 	var lineAllNotesOff = [];
		// 	for (var i:UInt = 0; i < numtracks; i++) {
		// 		lineAllNotesOff.push({
		// 			note: 97,
		// 			instrument: 0,
		// 			volume: 0,
		// 			effect: 0,
		// 			effectParam: 0
		// 		});
		// 	}
		// 	rows.push(lineAllNotesOff.slice(0));
		for (rowToBlank in 0...numrows) {
			rows[rowToBlank] = new XMPatternLine(numtracks);
		}
		// ----------
		for (i in 0...numtracks) {
			var whichbox:Int = Control.arrange.bar[barNum].channel[i];
			if (whichbox < 0) {
				continue;
			}
			var box:Musicphraseclass = Control.musicbox[whichbox];

			var notes:Array<Rectangle> = box.notes;
			for (j in 0...box.numnotes) {
				var boscaNote:Rectangle = notes[j];
				var timerelativetostartofbar:UInt = Std.int(boscaNote.width); // yes, it's called width. whatever.
				var notelength:UInt = Std.int(boscaNote.y);
				var xmnote:XMPatternCell = boscaBoxNoteToXMNote(box, j, instrumentNoteMap);

				// find a clear place to write
				var targetTrack:UInt = i;
				while (rows[timerelativetostartofbar].cellOnTrack[targetTrack].note > 0) {
					// track is busy (eg drum hits at once, chords)
					targetTrack++;
					if (!(targetTrack < numtracks)) {
						// too much going on, just ignore this note
						continue;
					}
				}

				rows[timerelativetostartofbar].cellOnTrack[targetTrack] = xmnote;
				var endrow:UInt = timerelativetostartofbar + notelength;
				if (endrow >= numrows) {
					continue;
				}
				if (rows[endrow].cellOnTrack[targetTrack].note > 0) {
					continue;
				} // someone else is already starting to play
				rows[endrow].cellOnTrack[targetTrack] = new XMPatternCell({
					note: 97, // "note off"
					instrument: 0,
					volume: 0,
					effect: 0,
					effectParam: 0
				});
			}
		}
		return pattern;
	}

	private function boscaBoxNoteToXMNote(box:Musicphraseclass, notenum:UInt, noteMapping:Array<Array<UInt>>):XMPatternCell {
		var sionNoteNum:Int = Std.int(box.notes[notenum].x);
		var xmNoteNum:UInt = noteMapping[box.instr][sionNoteNum];
		return new XMPatternCell({
			note: xmNoteNum,
			instrument: box.instr + 1,
			volume: 0,
			effect: 0,
			effectParam: 0
		});
	}

	private function _boscaNoteToXMNoteMapForInstrument(boscaInstrument:Instrumentclass, usefulNotes:Array<Int>):Array<UInt> {
		if (boscaInstrument.type > 0) {
			return _boscaDrumkitToXMNoteMap(usefulNotes);
		}

		return _boscaNoteToXMNoteMapLinear();
	}

	private function _boscaNoteToXMNoteMapLinear():Array<UInt> {
		var map:Array<UInt> = new Array<UInt>();
		for (scionNote in 0...127) {
			var maybeXMNote:Int = scionNote + 13;
			var xmNote:UInt;
			if (maybeXMNote < 1) { // too low for XM
				map[scionNote] = 0;
				continue;
			}
			if (maybeXMNote > 96) { // too high for XM
				map[scionNote] = 0;
				continue;
			}
			map[scionNote] = maybeXMNote;
		}
		return map;
	}

	private function _boscaDrumkitToXMNoteMap(necessaryNotes:Array<Int>):Array<UInt> {
		var map:Array<UInt> = new Array<UInt>();
		var startAt:Int = 49; // 1 = low C, 49 = middle C, 96 = highest B
		var scionNote:Int;
		var offset:UInt;

		// start with a clear map for the unused notes
		for (scionNote in 0...128) {
			map[scionNote] = 0; // not used anyway
		}

		// fill up the used notes in the middle where sampling doesn't change
		// much
		for (offset in 0...necessaryNotes.length) {
			var necessaryNote:Int = necessaryNotes[offset];
			var xmNote:UInt = startAt + offset;
			map[necessaryNote] = xmNote;
		}

		return map;
	}

	// bosca drumkits can be much larger than a single XM instrument
	// and an XM instrument can only have one "relative note" setting all
	// samples.
	//

	private function _boscaDrumkitToXMSamples(drumkit:Drumkitclass, whichDrumNumbers:Array<Int>, noteMapping:Array<UInt>, driver:SiONDriver):Array<XMSample> {
		var samples:Array<XMSample> = new Array<XMSample>();
		for (di in 0...whichDrumNumbers.length) {
			var d:UInt = whichDrumNumbers[di];
			var voice:SiONVoice = drumkit.voicelist[d];
			var samplename:String = drumkit.voicename[d];
			var sionNoteNum:Int = drumkit.voicenote[d];
			var xmNoteNum:UInt = noteMapping[sionNoteNum];

			var compensationNeeded:Int = 0; // 49 - xmNoteNum;

			var xmsample:XMSample = new XMSample();
			xmsample.relativeNoteNumber = 0;
			xmsample.name = voice.name;
			xmsample.volume = 0x40;
			xmsample.bitsPerSample = 16;
			xmsample.data = _playSiONNoteTo16BitDeltaSamples(sionNoteNum + compensationNeeded, voice, 32, driver);

			samples.push(xmsample);
		}
		return samples;
	}

	private function _boscaInstrumentToXMSample(instrument:Instrumentclass, driver:SiONDriver):XMSample {
		var voice:SiONVoice = instrument.voice;
		var xmsample:XMSample = new XMSample();
		xmsample.relativeNoteNumber = 3;
		xmsample.name = voice.name;
		xmsample.volume = 0x40;
		xmsample.bitsPerSample = 16;

		// consider voice.preferableNote
		var c5:Int = 60;

		xmsample.data = _playSiONNoteTo16BitDeltaSamples(c5, voice, 16, driver);
		trace(xmsample);
		return xmsample;
	}

	private function _playSiONNoteTo16BitDeltaSamples(note:Int, voice:SiONVoice, length:Float, driver:SiONDriver):ByteArray {
		var deltasamples:ByteArray = new ByteArray();
		deltasamples.endian = Endian.LITTLE_ENDIAN;

		// XXX: Interferes with regular playback. Find a more reliable way.
		// driver.renderQueue() might work
		driver.stop();

		var renderBuffer:Array<Float> = new Array<Float>();
		// XXX: only works for %6 (FM synth) voices.
		// theoretically voice.moduleType is 6 for FM and switchable
		var mml:String = voice.getMML(voice.channelNum) + ' %6,' + voice.channelNum + '@' + voice.toneNum + ' ' +
			_mmlNoteFromSiONNoteNumber(note); // theoretically, command 'n60' plays note 60
		trace(mml);
		driver.render(mml, renderBuffer, 1);

		// delta encoding algorithm that module formats like XM use
		var previousSample:Int = 0;
		for (i in 0...renderBuffer.length) {
			var thisSample:Int = Std.int(renderBuffer[i] * 32767); // signed float to 16-bit signed Int
			var sampleDelta:Int = thisSample - previousSample;
			deltasamples.writeShort(sampleDelta);
			previousSample = thisSample;
		}
		driver.play();

		return deltasamples;
	}

	/**
	 *
	 * I'm sure there's a better way to do this (eg maybe there's an MML
	 * command for "play note number").
	 */
	private function _mmlNoteFromSiONNoteNumber(noteNum:Int):String {
		var noteNames:Array<String> = ['c', 'c+', 'd', 'd+', 'e', 'f', 'f+', 'g', 'g+', 'a', 'a+', 'b'];

		var octave:Int = Std.int(noteNum / 12);
		var noteName:String = noteNames[noteNum % 12];
		return 'o' + octave + noteName;
	}
}
