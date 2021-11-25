package co.sparemind.trackermodule;

/**
 * A tracker-module song in the "XM" format
 *
 * Largely based on the document entitled "The Unofficial XM File Format
 * Specification: FastTracker II, ADPCM and Stripped Module Subformats"
 * revision 2 by Mr.H et al. Also explored Interactively with XM loading
 * tools like MikMod, XMP, MilkyTracker, SunVox and even TiMidity++.
 *
 * Although this code was originally written for use with Terry Cavanagh's
 * "Bosca Ceoil", it contains no dependencies on Bosca Ceoil and should work
 * anywhere you want to export to XM format.
 *
 * I should also note that this is the first time I've written ActionScript
 * code, so it's very likely this code is unusual. Hopefully it's still
 * useful to you.
 */
import flash.utils.IDataOutput;
import openfl.utils.ByteArray;
import openfl.utils.Endian;

class XMSong {
	/** Theoretically the name of the tool that produced this file.
	 *
	 * In practice some players care about the tracker name so
	 * there are a couple "safe" values.
	 */
	public function new() {}

	public var trackerName:String = 'FastTracker v2.00   ';
	public var songLength:UInt = 0;
	public var restartPos:UInt;
	public var numChannels:UInt = 8;
	public var numPatterns:UInt = 0;
	public var numInstruments:UInt;
	public var instruments:Array<XMInstrument> = new Array<XMInstrument>();

	/**
	 * How many "ticks" per second. Normally about 5 or 6.
	 *
	 * The song itself can change speed through control events.
	 */
	public var defaultTempo:UInt;

	/**
	 * Speed of song in beats per minute (BPM)
	 *
	 * The song itself can change speed through control events.
	 */
	public var defaultBPM:UInt;

	public var patternOrderTable:Array<Dynamic> = [
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	];

	/**
	 * Which frequencies table calculation to use
	 *
	 * 0 = Amiga frequency table
	 * 1 = Linear frequency table
	 */
	public var flags:UInt = 0x0001; // frequency table

	// physical considerations, only relevant for writing
	private var headerSize:UInt = 20 + 256;
	private var idText:String = 'Extended Module: ';
	private var sep:UInt = 26; // DOS EOF
	private var version:UInt = 0x0104;

	public var patterns:Array<XMPattern> = new Array<XMPattern>();

	private var _name:ByteArray = new ByteArray();

	public var songname(get, set):String;

	public function get_songname():String {
		return _name.toString();
	}

	public function set_songname(unpadded:String):String {
		_name.clear();
		_name.writeMultiByte(unpadded.substr(0, 20), 'us-ascii');
		for (i in _name.length...20) {
			_name.writeByte(0x20); // space-padded
		}
		return _name.toString();
	}

	public function writeToStream(stream:IDataOutput):Void {
		var xm:XMSong = this;
		var headbuf:ByteArray = new ByteArray();
		headbuf.endian = Endian.LITTLE_ENDIAN;

		headbuf.writeMultiByte(xm.idText, 'us-ascii'); // physical
		headbuf.writeMultiByte(xm.songname, 'us-ascii');
		headbuf.writeByte(xm.sep); // physical
		headbuf.writeMultiByte(xm.trackerName, 'us-ascii');
		headbuf.writeShort(xm.version); // physical? probably
		headbuf.writeUnsignedInt(xm.headerSize); // physical
		headbuf.writeShort(xm.songLength);
		headbuf.writeShort(xm.restartPos);
		headbuf.writeShort(xm.numChannels);
		headbuf.writeShort(xm.numPatterns);
		headbuf.writeShort(xm.numInstruments);
		headbuf.writeShort(xm.flags); // physical?
		headbuf.writeShort(xm.defaultTempo);
		headbuf.writeShort(xm.defaultBPM);
		for (i in 0...xm.patternOrderTable.length) {
			headbuf.writeByte(xm.patternOrderTable[i]);
		}

		stream.writeBytes(headbuf);

		for (i in 0...xm.patterns.length) {
			var pattern:XMPattern = xm.patterns[i];
			var patbuf:ByteArray = new ByteArray();
			patbuf.endian = Endian.LITTLE_ENDIAN;
			var patternHeaderLength:UInt = 9; // TODO: calculate
			patbuf.writeUnsignedInt(patternHeaderLength);
			patbuf.writeByte(0); // packingType
			patbuf.writeShort(pattern.rows.length);

			var patBodyBuf:ByteArray = new ByteArray();
			patBodyBuf.endian = Endian.LITTLE_ENDIAN;
			for (rownum in 0...pattern.rows.length) {
				var line:XMPatternLine = pattern.rows[rownum];
				for (chan in 0...line.cellOnTrack.length) {
					var cell:XMPatternCell = line.cellOnTrack[chan];
					if (cell.isEmpty()) {
						patBodyBuf.writeByte(0x80);
						continue;
					}
					patBodyBuf.writeByte(cell.note);
					patBodyBuf.writeByte(cell.instrument);
					patBodyBuf.writeByte(cell.volume);
					patBodyBuf.writeByte(cell.effect);
					patBodyBuf.writeByte(cell.effectParam);
				}
			}

			patbuf.writeShort(patBodyBuf.length); // packedDataSize
			stream.writeBytes(patbuf);
			stream.writeBytes(patBodyBuf);
		}

		for (instno in 0...xm.instruments.length) {
			var inst:XMInstrument = xm.instruments[instno];
			var instrheadbuf:ByteArray = new ByteArray();
			instrheadbuf.endian = Endian.LITTLE_ENDIAN;
			var headerSize:UInt = (inst.samples.length < 1) ? 29 : 263;
			instrheadbuf.writeUnsignedInt(headerSize);
			instrheadbuf.writeMultiByte(inst.name, 'us-ascii');
			instrheadbuf.writeByte(0); // type (always 0)
			instrheadbuf.writeShort(inst.samples.length);
			if (inst.samples.length < 1) {
				stream.writeBytes(instrheadbuf);
			}
			instrheadbuf.writeUnsignedInt(40); // sampleHeaderSize
			for (kma in 0...inst.keymapAssignments.length) {
				instrheadbuf.writeByte(inst.keymapAssignments[kma]);
			}
			for (p in 0...12) {
				// var poInt:XMEnvelopePoInt = inst.volumeEnvelope.poInts[p];
				// instrheadbuf.writeShort(poInt.x);
				// instrheadbuf.writeShort(poInt.y);
				instrheadbuf.writeShort(0x1111);
				instrheadbuf.writeShort(0x2222);
			}
			for (p in 0...12) {
				// var poInt:XMEnvelopePoInt = inst.panningEnvelope.poInts[p];
				// instrheadbuf.writeShort(poInt.x);
				// instrheadbuf.writeShort(poInt.y);
				instrheadbuf.writeShort(0x0000);
				instrheadbuf.writeShort(0x0000);
			}
			instrheadbuf.writeByte(0); // numVolumePoInts
			instrheadbuf.writeByte(0); // numVolumePoInts
			instrheadbuf.writeByte(0); // volSustainPoInt
			instrheadbuf.writeByte(0); // volLoopStartPoInt
			instrheadbuf.writeByte(0); // volLoopEndPoInt
			instrheadbuf.writeByte(0); // panSustainPoInt
			instrheadbuf.writeByte(0); // panLoopStartPoInt
			instrheadbuf.writeByte(0); // panLoopEndPoInt
			instrheadbuf.writeByte(0); // volumeType
			instrheadbuf.writeByte(0); // panningType
			instrheadbuf.writeByte(0); // vibratoType
			instrheadbuf.writeByte(0); // vibratoSweep
			instrheadbuf.writeByte(0); // vibratoDepth
			instrheadbuf.writeByte(0); // vibratoRate
			instrheadbuf.writeShort(0); // volumeFadeout);

			// the 22 bytes at offset +241 are reserved
			for (i in 0...22) {
				instrheadbuf.writeByte(0x00);
			}
			stream.writeBytes(instrheadbuf);
			for (s in 0...inst.samples.length) {
				var sample:XMSample = inst.samples[s];
				var sampleHeadBuf:ByteArray = new ByteArray();
				sampleHeadBuf.endian = Endian.LITTLE_ENDIAN;
				sampleHeadBuf.writeUnsignedInt(sample.data.length);
				sampleHeadBuf.writeUnsignedInt(sample.loopStart);
				sampleHeadBuf.writeUnsignedInt(sample.loopLength);
				sampleHeadBuf.writeByte(sample.volume);
				sampleHeadBuf.writeByte(sample.finetune);
				var sampleType:UInt = (sample.loopsForward ? 1 : 0) | (sample.bitsPerSample == 16 ? 16 : 0);
				sampleHeadBuf.writeByte(sampleType);
				sampleHeadBuf.writeByte(sample.panning);
				sampleHeadBuf.writeByte(sample.relativeNoteNumber);
				sampleHeadBuf.writeByte(0); // regular 'delta' sample encoding
				sampleHeadBuf.writeMultiByte(sample.name, 'us-ascii');
				stream.writeBytes(sampleHeadBuf);
			}
			for (s in 0...inst.samples.length) {
				var sample = inst.samples[s];
				stream.writeBytes(sample.data);
			}
		}
	}

	public function addInstrument(instrument:XMInstrument):Void {
		instruments.push(instrument);
	}
}
