package;

import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.utils.*;
import openfl.net.*; // import ocean.midi.MidiFile;
import org.si.sion.SiONDriver;
import org.si.sion.SiONData;
import org.si.sion.utils.SiONPresetVoice;
import org.si.sion.SiONVoice;
import org.si.sion.sequencer.SiMMLTrack;
import org.si.sion.effector.*;
import org.si.sion.events.*;
import openfl.filesystem.*;
import openfl.net.FileFilter;
import openfl.system.Capabilities;
#if native
import sys.io.File;
#end
#if web
import js.html.File;
import openfl.external.ExternalInterface;
import haxe.io.Bytes;
import haxe.crypto.Base64;
import lime.media.AudioManager;
#end

class Control extends Sprite {
	public static inline var SCALE_NORMAL:Dynamic /*:Int*/ = 0;
	public static inline var SCALE_MAJOR:Dynamic /*:Int*/ = 1;
	public static inline var SCALE_MINOR:Dynamic /*:Int*/ = 2;
	public static inline var SCALE_BLUES:Dynamic /*:Int*/ = 3;
	public static inline var SCALE_HARMONIC_MINOR:Dynamic /*:Int*/ = 4;
	public static inline var SCALE_PENTATONIC_MAJOR:Dynamic /*:Int*/ = 5;
	public static inline var SCALE_PENTATONIC_MINOR:Dynamic /*:Int*/ = 6;
	public static inline var SCALE_PENTATONIC_BLUES:Dynamic /*:Int*/ = 7;
	public static inline var SCALE_PENTATONIC_NEUTRAL:Dynamic /*:Int*/ = 8;
	public static inline var SCALE_ROMANIAN_FOLK:Dynamic /*:Int*/ = 9;
	public static inline var SCALE_SPANISH_GYPSY:Dynamic /*:Int*/ = 10;
	public static inline var SCALE_ARABIC_MAGAM:Dynamic /*:Int*/ = 11;
	public static inline var SCALE_CHINESE:Dynamic /*:Int*/ = 12;
	public static inline var SCALE_HUNGARIAN:Dynamic /*:Int*/ = 13;
	public static inline var CHORD_MAJOR:Dynamic /*:Int*/ = 14;
	public static inline var CHORD_MINOR:Dynamic /*:Int*/ = 15;
	public static inline var CHORD_5TH:Dynamic /*:Int*/ = 16;
	public static inline var CHORD_DOM_7TH:Dynamic /*:Int*/ = 17;
	public static inline var CHORD_MAJOR_7TH:Dynamic /*:Int*/ = 18;
	public static inline var CHORD_MINOR_7TH:Dynamic /*:Int*/ = 19;
	public static inline var CHORD_MINOR_MAJOR_7TH:Dynamic /*:Int*/ = 20;
	public static inline var CHORD_SUS4:Dynamic /*:Int*/ = 21;
	public static inline var CHORD_SUS2:Dynamic /*:Int*/ = 22;

	public static inline var LIST_KEY:Dynamic /*:Int*/ = 0;
	public static inline var LIST_SCALE:Dynamic /*:Int*/ = 1;
	public static inline var LIST_INSTRUMENT:Dynamic /*:Int*/ = 2;
	public static inline var LIST_CATEGORY:Dynamic /*:Int*/ = 3;
	public static inline var LIST_SELECTINSTRUMENT:Dynamic /*:Int*/ = 4;
	public static inline var LIST_BUFFERSIZE:Dynamic /*:Int*/ = 5;
	public static inline var LIST_MOREEXPORTS:Dynamic /*:Int*/ = 6;
	public static inline var LIST_EFFECTS:Dynamic /*:Int*/ = 7;
	public static inline var LIST_EXPORTS:Dynamic /*:Int*/ = 8;
	public static inline var LIST_MIDIINSTRUMENT:Dynamic /*:Int*/ = 9;
	public static inline var LIST_MIDI_0_PIANO:Dynamic /*:Int*/ = 10;
	public static inline var LIST_MIDI_1_BELLS:Dynamic /*:Int*/ = 11;
	public static inline var LIST_MIDI_2_ORGAN:Dynamic /*:Int*/ = 12;
	public static inline var LIST_MIDI_3_GUITAR:Dynamic /*:Int*/ = 13;
	public static inline var LIST_MIDI_4_BASS:Dynamic /*:Int*/ = 14;
	public static inline var LIST_MIDI_5_STRINGS:Dynamic /*:Int*/ = 15;
	public static inline var LIST_MIDI_6_ENSEMBLE:Dynamic /*:Int*/ = 16;
	public static inline var LIST_MIDI_7_BRASS:Dynamic /*:Int*/ = 17;
	public static inline var LIST_MIDI_8_REED:Dynamic /*:Int*/ = 18;
	public static inline var LIST_MIDI_9_PIPE:Dynamic /*:Int*/ = 19;
	public static inline var LIST_MIDI_10_SYNTHLEAD:Dynamic /*:Int*/ = 20;
	public static inline var LIST_MIDI_11_SYNTHPAD:Dynamic /*:Int*/ = 21;
	public static inline var LIST_MIDI_12_SYNTHEFFECTS:Dynamic /*:Int*/ = 22;
	public static inline var LIST_MIDI_13_WORLD:Dynamic /*:Int*/ = 23;
	public static inline var LIST_MIDI_14_PERCUSSIVE:Dynamic /*:Int*/ = 24;
	public static inline var LIST_MIDI_15_SOUNDEFFECTS:Dynamic /*:Int*/ = 25;

	public static inline var MENUTAB_FILE:Dynamic /*:Int*/ = 0;
	public static inline var MENUTAB_ARRANGEMENTS:Dynamic /*:Int*/ = 1;
	public static inline var MENUTAB_INSTRUMENTS:Dynamic /*:Int*/ = 2;
	public static inline var MENUTAB_ADVANCED:Dynamic /*:Int*/ = 3;
	public static inline var MENUTAB_CREDITS:Dynamic /*:Int*/ = 4;
	public static inline var MENUTAB_HELP:Dynamic /*:Int*/ = 5;
	public static inline var MENUTAB_GITHUB:Dynamic /*:Int*/ = 6;

	public static function init():Void {
		clicklist = false;
		clicksecondlist = false;
		midilistselection = -1;
		savescreencountdown = 0;

		// default filepath
		#if native
		defaultDirectory = Sys.getCwd();
		#end
		#if web
		defaultDirectory = "Downloads/";
		#end

		test = false;
		teststring = "TEST = True";
		patternmanagerview = 0;
		dragaction = 0;
		trashbutton = 0;
		bpm = 120;

		for (i in 0...144)
			notename.push("");
		for (j in 0...12) {
			scale.push(1);
		}

		for (i in 0...256) {
			pianoroll.push(i);
			invertpianoroll.push(i);
		}
		scalesize = 12;

		for (j in 0...11) {
			notename[(j * 12) + 0] = "C";
			notename[(j * 12) + 1] = "C#";
			notename[(j * 12) + 2] = "D";
			notename[(j * 12) + 3] = "D#";
			notename[(j * 12) + 4] = "E";
			notename[(j * 12) + 5] = "F";
			notename[(j * 12) + 6] = "F#";
			notename[(j * 12) + 7] = "G";
			notename[(j * 12) + 8] = "G#";
			notename[(j * 12) + 9] = "A";
			notename[(j * 12) + 10] = "A#";
			notename[(j * 12) + 11] = "B";
		}

		for (i in 0...23) {
			scalename.push("");
		}
		scalename[SCALE_NORMAL] = "Scale: Normal";
		scalename[SCALE_MAJOR] = "Scale: Major";
		scalename[SCALE_MINOR] = "Scale: Minor";
		scalename[SCALE_BLUES] = "Scale: Blues";
		scalename[SCALE_HARMONIC_MINOR] = "Scale: Harmonic Minor";
		scalename[SCALE_PENTATONIC_MAJOR] = "Scale: Pentatonic Major";
		scalename[SCALE_PENTATONIC_MINOR] = "Scale: Pentatonic Minor";
		scalename[SCALE_PENTATONIC_BLUES] = "Scale: Pentatonic Blues";
		scalename[SCALE_PENTATONIC_NEUTRAL] = "Scale: Pentatonic Neutral";
		scalename[SCALE_ROMANIAN_FOLK] = "Scale: Romanian Folk";
		scalename[SCALE_SPANISH_GYPSY] = "Scale: Spanish Gypsy";
		scalename[SCALE_ARABIC_MAGAM] = "Scale: Arabic Magam";
		scalename[SCALE_CHINESE] = "Scale: Chinese";
		scalename[SCALE_HUNGARIAN] = "Scale: Hungarian";
		scalename[CHORD_MAJOR] = "Chord: Major";
		scalename[CHORD_MINOR] = "Chord: Minor";
		scalename[CHORD_5TH] = "Chord: 5th";
		scalename[CHORD_DOM_7TH] = "Chord: Dom 7th";
		scalename[CHORD_MAJOR_7TH] = "Chord: Major 7th";
		scalename[CHORD_MINOR_7TH] = "Chord: Minor 7th";
		scalename[CHORD_MINOR_MAJOR_7TH] = "Chord: Minor Major 7th";
		scalename[CHORD_SUS4] = "Chord: Sus4";
		scalename[CHORD_SUS2] = "Chord: sus2";

		looptime = 0;
		swingoff = 0;
		SetSwing(); // Swing functions submitted on gibhub via @increpare, cheers!

		_presets = new SiONPresetVoice();
		voicelist = new Voicelistclass();

		// Setup drumkits
		drumkit.push(new Drumkitclass());
		drumkit.push(new Drumkitclass());
		drumkit.push(new Drumkitclass()); // Midi Drums
		createdrumkit(0);
		createdrumkit(1);
		createdrumkit(2);

		for (i in 0...16) {
			instrument.push(new Instrumentclass());
			if (i == 0) {
				instrument[i].voice = _presets.voices["midi.piano1"];
			} else {
				voicelist.index = Std.int(Math.random() * voicelist.listsize);
				instrument[i].index = voicelist.index;
				instrument[i].voice = _presets.voices[voicelist.voice[voicelist.index]];
				instrument[i].category = voicelist.category[voicelist.index];
				instrument[i].name = voicelist.name[voicelist.index];
				instrument[i].palette = voicelist.palette[voicelist.index];
			}
			instrument[i].updatefilter();
		}
		numinstrument = 1;
		instrumentmanagerview = 0;

		for (i in 0...4096) {
			musicbox.push(new Musicphraseclass());
		}
		numboxes = 1;

		arrange.loopstart = 0;
		arrange.loopend = 1;
		arrange.bar[0].channel[0] = 0;

		setscale(SCALE_NORMAL);
		key = 0;
		updatepianoroll();
		for (i in 0...numboxes) {
			musicbox[i].start = scalesize * 3;
		}

		currentbox = 0;
		notelength = 1;
		currentinstrument = 0;

		boxcount = 16;
		barcount = 4;

		programsettings = SharedObject.getLocal("boscaceoil_settings");

		if (programsettings.data.buffersize == null) {
			buffersize = 2048;
			programsettings.data.buffersize = buffersize;
			programsettings.flush();
			programsettings.close();
			programsettings.data.fullscreen = 0;
			programsettings.data.windowsize = 2;
		} else {
			buffersize = programsettings.data.buffersize;
			programsettings.flush();
			programsettings.close();
		}

		_driver = new SiONDriver(buffersize);
		currentbuffersize = buffersize;
		_driver.setBeatCallbackInterval(1);
		_driver.setTimerInterruption(1, _onTimerInterruption);

		effecttype = 0;
		effectvalue = 0;
		effectname.push("DELAY");
		effectname.push("CHORUS");
		effectname.push("REVERB");
		effectname.push("DISTORTION");
		effectname.push("LOW BOOST");
		effectname.push("COMPRESSOR");
		effectname.push("HIGH PASS");

		_driver.addEventListener(SiONEvent.STREAM, onStream);

		_driver.bpm = bpm; // Default
		_driver.play(null, false);

		startup = 1;
		#if (CONFIG == "desktop")
		{
			if (invokefile != "null") {
				invokeceol(invokefile);
				invokefile = "null";
			}
		}
		#end
	}

	public static function notecut():Void {
		// This is broken, try to fix later
		// for each (var trk:SiMMLTrack in _driver.sequencer.tracks) trk.keyOff();
	}

	public static function updateeffects():Void {
		// So, I can't see to figure out WHY only one effect at a time seems to work.
		// If anyone else can, please, by all means update this code!

		// start by turning everything off:
		_driver.effector.clear(0);

		if (effectvalue > 5) {
			if (effecttype == 0) {
				_driver.effector.connect(0, new SiEffectStereoDelay((300 * effectvalue) / 100, 0.1, false));
			} else if (effecttype == 1) {
				_driver.effector.connect(0, new SiEffectStereoChorus(20, 0.2, 4, 10 + ((50 * effectvalue) / 100)));
			} else if (effecttype == 2) {
				_driver.effector.connect(0, new SiEffectStereoReverb(0.7, 0.4 + ((0.5 * effectvalue) / 100), 0.8, 0.3));
			} else if (effecttype == 3) {
				_driver.effector.connect(0, new SiEffectDistortion(-20 - ((80 * effectvalue) / 100), 18, 2400, 1));
			} else if (effecttype == 4) {
				_driver.effector.connect(0, new SiFilterLowBoost(3000, 1, 4 + ((6 * effectvalue) / 100)));
			} else if (effecttype == 5) {
				_driver.effector.connect(0, new SiEffectCompressor(0.7, 50, 20, 20, -6, 0.2 + ((0.6 * effectvalue) / 100)));
			} else if (effecttype == 6) {
				_driver.effector.connect(0, new SiCtrlFilterHighPass(((1.0 * effectvalue) / 100), 0.9));
			}
		}
		/*
			effectname.push("DELAY");
			effectname.push("CHORUS");
			effectname.push("REVERB");
			effectname.push("DISTORTION");
			effectname.push("LOW BOOST");
			effectname.push("COMPRESSOR");
			effectname.push("HIGH PASS"); */
	}

	public static function _onTimerInterruption():Void {
		if (musicplaying) {
			if (looptime >= boxcount) {
				looptime -= boxcount;
				// SetSwing();
				arrange.currentbar++;
				if (arrange.currentbar >= arrange.loopend) {
					arrange.currentbar = arrange.loopstart;
					if (nowexporting) {
						musicplaying = false;
						savewav();
					}
				}

				for (i in 0...numboxes) {
					musicbox[i].isplayed = false;
				}
			}
			// Play everything in the current bar
			for (k in 0...8) {
				if (arrange.channelon[k]) {
					i = arrange.bar[arrange.currentbar].channel[k];
					if (i > -1) {
						musicbox[i].isplayed = true;
						if (instrument[musicbox[i].instr].type == 0) {
							for (j in 0...musicbox[i].numnotes) {
								if (musicbox[i].notes[j].width == looptime) {
									if (musicbox[i].notes[j].x > -1) {
										instrument[musicbox[i].instr].updatefilter();
										// If pattern uses recorded values, update them
										if (musicbox[i].recordfilter == 1) {
											instrument[musicbox[i].instr].changefilterto(musicbox[i].cutoffgraph[cast(looptime % boxcount)],
												musicbox[i].resonancegraph[cast(looptime % boxcount)], musicbox[i].volumegraph[cast looptime % boxcount]);
										}
										_driver.noteOn(Std.int(musicbox[i].notes[j].x), instrument[musicbox[i].instr].voice, Std.int(musicbox[i].notes[j].y));
									}
								}
							}
						} else {
							// Drumkits
							for (j in 0...musicbox[i].numnotes) {
								if (musicbox[i].notes[j].width == looptime) {
									if (musicbox[i].notes[j].x > -1) {
										if (musicbox[i].notes[j].x < drumkit[cast(instrument[musicbox[i].instr].type) - 1].size) {
											// Change filter on first note
											if (looptime == 0)
												drumkit[cast instrument[musicbox[i].instr].type - 1].updatefilter(instrument[musicbox[i].instr].cutoff,
													instrument[musicbox[i].instr].resonance);
											if (looptime == 0)
												drumkit[cast instrument[musicbox[i].instr].type - 1].updatevolume(instrument[musicbox[i].instr].volume);
											// If pattern uses recorded values, update them
											if (musicbox[i].recordfilter == 1) {
												drumkit[cast instrument[musicbox[i].instr].type - 1].updatefilter(musicbox[i].cutoffgraph[cast looptime % boxcount],
													musicbox[i].resonancegraph[cast looptime % boxcount]);
												drumkit[cast instrument[musicbox[i].instr].type - 1].updatevolume(musicbox[i].volumegraph[cast looptime % boxcount]);
											}
											_driver.noteOn(drumkit[cast instrument[musicbox[i].instr].type - 1].voicenote[Std.int(musicbox[i].notes[j].x)],
												drumkit[cast instrument[musicbox[i].instr].type - 1].voicelist[Std.int(musicbox[i].notes[j].x)],
												Std.int(musicbox[i].notes[j].y));
										}
									}
								}
							}
						}
					}
				}
			}

			looptime = looptime + 1;
			// SetSwing();
		}
	}

	private static function SetSwing():Void {
		if (_driver == null)
			return;

		// swing goes from -10 to 10
		// fswing goes from 0.2 - 1.8
		var fswing:Float = 0.2 + (swing + 10) * (1.8 - 0.2) / 20.0;

		if (swing == 0) {
			if (swingoff == 1) {
				_driver.setTimerInterruption(1, _onTimerInterruption);
				swingoff = 0;
			}
		} else {
			swingoff = 1;
			if (looptime % 2 == 0) {
				_driver.setTimerInterruption(fswing, _onTimerInterruption);
			} else {
				_driver.setTimerInterruption(2 - fswing, _onTimerInterruption);
			}
		}
	}

	public static function loadscreensettings():Void {
		programsettings = SharedObject.getLocal("boscaceoil_settings");

		if (programsettings.data.firstrun == null) {
			Guiclass.firstrun = true;
			programsettings.data.firstrun = 1;
		} else {
			Guiclass.firstrun = false;
		}

		if (programsettings.data.fullscreen == 0) {
			fullscreen = false;
		} else {
			fullscreen = true;
		}

		if (programsettings.data.scalemode == null) {
			Gfx.changescalemode(0);
		} else {
			Gfx.changescalemode(programsettings.data.scalemode);
		}

		if (programsettings.data.windowwidth == null) {
			Gfx.windowwidth = 768;
			Gfx.windowheight = 560;
		} else {
			Gfx.windowwidth = programsettings.data.windowwidth;
			Gfx.windowheight = programsettings.data.windowheight;
		}

		Gfx.changewindowsize(Gfx.windowwidth, Gfx.windowheight);

		programsettings.flush();
		programsettings.close();
	}

	public static function loadfilesettings():Void {
		programsettings = SharedObject.getLocal("boscaceoil_settings");

		// Add filepath memory
		if (programsettings.data.filepath == "") {
			filepath = defaultDirectory;
		} else {
			filepath = programsettings.data.filepath;
		}

		programsettings.flush();
		programsettings.close();
	}

	public static function savescreensettings():Void {
		programsettings = SharedObject.getLocal("boscaceoil_settings");

		programsettings.data.firstrun = 1;

		if (!fullscreen) {
			programsettings.data.fullscreen = 0;
		} else {
			programsettings.data.fullscreen = 1;
		}

		programsettings.data.scalemode = Gfx.scalemode;
		programsettings.data.windowwidth = Gfx.windowwidth;
		programsettings.data.windowheight = Gfx.windowheight;

		programsettings.flush();
		programsettings.close();
	}

	public static function savefilesettings():Void {
		programsettings = SharedObject.getLocal("boscaceoil_settings");

		// Add filepath memory
		if (filepath != "") {
			programsettings.data.filepath = filepath;
		}

		programsettings.flush();
		programsettings.close();
	}

	public static function setbuffersize(t:Dynamic /*:Int*/):Void {
		if (t == 0)
			buffersize = 2048;
		if (t == 1)
			buffersize = 4096;
		if (t == 2)
			buffersize = 8192;

		programsettings = SharedObject.getLocal("boscaceoil_settings");
		programsettings.data.buffersize = buffersize;
		programsettings.flush();
		programsettings.close();
	}

	public static function adddrumkitnote(t:Dynamic /*:Int*/, name:String, voice:String, note:Dynamic /*:Int*/ = 60):Void {
		if (t == 2 && note == 60)
			note = 16;
		drumkit[t].voicelist.push(_presets.voices[voice]);
		drumkit[t].voicename.push(name);
		drumkit[t].voicenote.push(note);
		if (t == 2) {
			// Midi drumkit
			var voicenum:String = "";
			var afterdot:Bool = false;
			for (i in 0...voice.length) {
				if (afterdot) {
					voicenum = voicenum + voice.charAt(i);
				}
				if (i >= 8)
					afterdot = true;
			}
			drumkit[t].midivoice.push(Std.parseInt(voicenum));
		}
		drumkit[t].size++;
	}

	public static function createdrumkit(t:Dynamic /*:Int*/):Void {
		// Create Drumkit t at index
		switch (t) {
			case 0:
				// Simple
				drumkit[0].kitname = "Simple Drumkit";
				adddrumkitnote(0, "Bass Drum 1", "valsound.percus1", 30);
				adddrumkitnote(0, "Bass Drum 2", "valsound.percus13", 32);
				adddrumkitnote(0, "Bass Drum 3", "valsound.percus3", 30);
				adddrumkitnote(0, "Snare Drum", "valsound.percus30", 20);
				adddrumkitnote(0, "Snare Drum 2", "valsound.percus29", 48);
				adddrumkitnote(0, "Open Hi-Hat", "valsound.percus17", 60);
				adddrumkitnote(0, "Closed Hi-Hat", "valsound.percus23", 72);
				adddrumkitnote(0, "Crash Cymbal", "valsound.percus8", 48);
			case 1:
				// SiON Kit
				drumkit[1].kitname = "SiON Drumkit";
				adddrumkitnote(1, "Bass Drum 2", "valsound.percus1", 30);
				adddrumkitnote(1, "Bass Drum 3 o1f", "valsound.percus2");
				adddrumkitnote(1, "RUFINA BD o2c", "valsound.percus3", 30);
				adddrumkitnote(1, "B.D.(-vBend)", "valsound.percus4");
				adddrumkitnote(1, "BD808_2(-vBend)", "valsound.percus5");
				adddrumkitnote(1, "Cho cho 3 (o2e)", "valsound.percus6");
				adddrumkitnote(1, "Cow-Bell 1", "valsound.percus7");
				adddrumkitnote(1, "Crash Cymbal (noise)", "valsound.percus8", 48);
				adddrumkitnote(1, "Crash Noise", "valsound.percus9");
				adddrumkitnote(1, "Crash Noise Short", "valsound.percus10");
				adddrumkitnote(1, "ETHNIC Percus.0", "valsound.percus11");
				adddrumkitnote(1, "ETHNIC Percus.1", "valsound.percus12");
				adddrumkitnote(1, "Heavy BD.", "valsound.percus13", 32);
				adddrumkitnote(1, "Heavy BD2", "valsound.percus14");
				adddrumkitnote(1, "Heavy SD1", "valsound.percus15");
				adddrumkitnote(1, "Hi-Hat close 5_", "valsound.percus16");
				adddrumkitnote(1, "Hi-Hat close 4", "valsound.percus17");
				adddrumkitnote(1, "Hi-Hat close 5", "valsound.percus18");
				adddrumkitnote(1, "Hi-Hat Close 6 -808-", "valsound.percus19");
				adddrumkitnote(1, "Hi-hat #7 Metal o3-6", "valsound.percus20");
				adddrumkitnote(1, "Hi-Hat Close #8 o4", "valsound.percus21");
				adddrumkitnote(1, "Hi-hat Open o4e-g+", "valsound.percus22");
				adddrumkitnote(1, "Open-hat2 Metal o4c-", "valsound.percus23");
				adddrumkitnote(1, "Open-hat3 Metal", "valsound.percus24");
				adddrumkitnote(1, "Hi-Hat Open #4 o4f", "valsound.percus25");
				adddrumkitnote(1, "Metal ride o4c or o5c", "valsound.percus26");
				adddrumkitnote(1, "Rim Shot #1 o3c", "valsound.percus27");
				adddrumkitnote(1, "Snare Drum Light", "valsound.percus28");
				adddrumkitnote(1, "Snare Drum Lighter", "valsound.percus29");
				adddrumkitnote(1, "Snare Drum 808 o2-o3", "valsound.percus30", 20);
				adddrumkitnote(1, "Snare4 -808type- o2", "valsound.percus31");
				adddrumkitnote(1, "Snare5 o1-2(Franger)", "valsound.percus32");
				adddrumkitnote(1, "Tom (old)", "valsound.percus33");
				adddrumkitnote(1, "Synth tom 2 algo 3", "valsound.percus34");
				adddrumkitnote(1, "Synth (Noisy) Tom #3", "valsound.percus35");
				adddrumkitnote(1, "Synth Tom #3", "valsound.percus36");
				adddrumkitnote(1, "Synth -DX7- Tom #4", "valsound.percus37");
				adddrumkitnote(1, "Triangle 1 o5c", "valsound.percus38");
			case 2:
				// MIDI DRUMS
				drumkit[2].kitname = "Midi Drumkit";
				adddrumkitnote(2, "Seq Click H", "midi.drum24", 24);
				adddrumkitnote(2, "Brush Tap", "midi.drum25", 25);
				adddrumkitnote(2, "Brush Swirl", "midi.drum26", 26);
				adddrumkitnote(2, "Brush Slap", "midi.drum27", 27);
				adddrumkitnote(2, "Brush Tap Swirl", "midi.drum28", 28);
				adddrumkitnote(2, "Snare Roll", "midi.drum29");
				adddrumkitnote(2, "Castanet", "midi.drum32");
				adddrumkitnote(2, "Snare L", "midi.drum31");
				adddrumkitnote(2, "Sticks", "midi.drum32");
				adddrumkitnote(2, "Bass Drum L", "midi.drum33");
				adddrumkitnote(2, "Open Rim Shot", "midi.drum34");
				adddrumkitnote(2, "Bass Drum M", "midi.drum35");
				adddrumkitnote(2, "Bass Drum H", "midi.drum36");
				adddrumkitnote(2, "Closed Rim Shot", "midi.drum37");
				adddrumkitnote(2, "Snare M", "midi.drum38");
				adddrumkitnote(2, "Hand Clap", "midi.drum39");
				adddrumkitnote(2, "Snare H", "midi.drum42");
				adddrumkitnote(2, "Floor Tom L", "midi.drum41");
				adddrumkitnote(2, "Hi-Hat Closed", "midi.drum42");
				adddrumkitnote(2, "Floor Tom H", "midi.drum43");
				adddrumkitnote(2, "Hi-Hat Pedal", "midi.drum44");
				adddrumkitnote(2, "Low Tom", "midi.drum45");
				adddrumkitnote(2, "Hi-Hat Open", "midi.drum46");
				adddrumkitnote(2, "Mid Tom L", "midi.drum47");
				adddrumkitnote(2, "Mid Tom H", "midi.drum48");
				adddrumkitnote(2, "Crash Cymbal 1", "midi.drum49");
				adddrumkitnote(2, "High Tom", "midi.drum52");
				adddrumkitnote(2, "Ride Cymbal 1", "midi.drum51");
				adddrumkitnote(2, "Chinese Cymbal", "midi.drum52");
				adddrumkitnote(2, "Ride Cymbal Cup", "midi.drum53");
				adddrumkitnote(2, "Tambourine", "midi.drum54");
				adddrumkitnote(2, "Splash Cymbal", "midi.drum55");
				adddrumkitnote(2, "Cowbell", "midi.drum56");
				adddrumkitnote(2, "Crash Cymbal 2", "midi.drum57");
				adddrumkitnote(2, "Vibraslap", "midi.drum58");
				adddrumkitnote(2, "Ride Cymbal 2", "midi.drum59");
				adddrumkitnote(2, "Bongo H", "midi.drum62");
				adddrumkitnote(2, "Bongo L", "midi.drum61");
				adddrumkitnote(2, "Conga H Mute", "midi.drum62");
				adddrumkitnote(2, "Conga H Open", "midi.drum63");
				adddrumkitnote(2, "Conga L", "midi.drum64");
				adddrumkitnote(2, "Timbale H", "midi.drum65");
				adddrumkitnote(2, "Timbale L", "midi.drum66");
				adddrumkitnote(2, "Agogo H", "midi.drum67");
				adddrumkitnote(2, "Agogo L", "midi.drum68");
				adddrumkitnote(2, "Cabasa", "midi.drum69");
				adddrumkitnote(2, "Maracas", "midi.drum72");
				adddrumkitnote(2, "Samba Whistle H", "midi.drum71");
				adddrumkitnote(2, "Samba Whistle L", "midi.drum72");
				adddrumkitnote(2, "Guiro Short", "midi.drum73");
				adddrumkitnote(2, "Guiro Long", "midi.drum74");
				adddrumkitnote(2, "Claves", "midi.drum75");
				adddrumkitnote(2, "Wood Block H", "midi.drum76");
				adddrumkitnote(2, "Wood Block L", "midi.drum77");
				adddrumkitnote(2, "Cuica Mute", "midi.drum78");
				adddrumkitnote(2, "Cuica Open", "midi.drum79");
				adddrumkitnote(2, "Triangle Mute", "midi.drum80");
				adddrumkitnote(2, "Triangle Open", "midi.drum81");
				adddrumkitnote(2, "Shaker", "midi.drum82");
				adddrumkitnote(2, "Jingle Bells", "midi.drum83");
				adddrumkitnote(2, "Bell Tree", "midi.drum84");
		}
	}

	public static function changekey(t:Dynamic /*:Int*/):Void {
		var keyshift:Dynamic /*:Int*/ = t - key;
		for (i in 0...musicbox[currentbox].numnotes) {
			musicbox[currentbox].notes[i].x += keyshift;
		}
		musicbox[currentbox].key = t;
		key = t;
		musicbox[currentbox].setnotespan();
		updatepianoroll();
	}

	public static function changescale(t:Dynamic /*:Int*/):Void {
		setscale(t);
		updatepianoroll();

		// Delete notes not in scale
		i = 0;
		while (i < musicbox[currentbox].numnotes) {
			if (invertpianoroll[Std.int(musicbox[currentbox].notes[i].x)] == -1) {
				musicbox[currentbox].deletenote(i);
				i--;
			}
			i++;
		}

		musicbox[currentbox].scale = t;
		if (musicbox[currentbox].bottomnote < 250) {
			musicbox[currentbox].start = invertpianoroll[musicbox[currentbox].bottomnote] - 2;
			if (musicbox[currentbox].start < 0)
				musicbox[currentbox].start = 0;
		} else {
			musicbox[currentbox].start = (scalesize * 4) - 2;
		}
		musicbox[currentbox].setnotespan();
	}

	public static function changemusicbox(t:Dynamic /*:Int*/):Void {
		currentbox = t;
		key = musicbox[t].key;
		setscale(musicbox[t].scale);
		updatepianoroll();

		if (instrument[musicbox[t].instr].type == 0) {
			if (musicbox[t].bottomnote < 250) {
				musicbox[t].start = invertpianoroll[musicbox[t].bottomnote] - 2;
				if (musicbox[t].start < 0)
					musicbox[t].start = 0;
			} else {
				musicbox[t].start = (scalesize * 4) - 2;
			}
		} else {
			musicbox[t].start = 0;
		}

		Guiclass.changetab(currenttab);
	}

	public static function _setscale(t1:Dynamic /*:Int*/ = -1, t2:Dynamic /*:Int*/ = -1, t3:Dynamic /*:Int*/ = -1, t4:Dynamic /*:Int*/ = -1,
			t5:Dynamic /*:Int*/ = -1, t6:Dynamic /*:Int*/ = -1, t7:Dynamic /*:Int*/ = -1, t8:Dynamic /*:Int*/ = -1, t9:Dynamic /*:Int*/ = -1,
			t10:Dynamic /*:Int*/ = -1, t11:Dynamic /*:Int*/ = -1, t12:Dynamic /*:Int*/ = -1):Void {
		if (t1 == -1) {
			scalesize = 0;
		} else if (t2 == -1) {
			scale[0] = t1;
			scalesize = 1;
		} else if (t3 == -1) {
			scale[0] = t1;
			scale[1] = t2;
			scalesize = 2;
		} else if (t4 == -1) {
			scale[0] = t1;
			scale[1] = t2;
			scale[2] = t3;
			scalesize = 3;
		} else if (t5 == -1) {
			scale[0] = t1;
			scale[1] = t2;
			scale[2] = t3;
			scale[3] = t4;
			scalesize = 4;
		} else if (t6 == -1) {
			scale[0] = t1;
			scale[1] = t2;
			scale[2] = t3;
			scale[3] = t4;
			scale[4] = t5;
			scalesize = 5;
		} else if (t7 == -1) {
			scale[0] = t1;
			scale[1] = t2;
			scale[2] = t3;
			scale[3] = t4;
			scale[4] = t5;
			scale[5] = t6;
			scalesize = 6;
		} else if (t8 == -1) {
			scale[0] = t1;
			scale[1] = t2;
			scale[2] = t3;
			scale[3] = t4;
			scale[4] = t5;
			scale[5] = t6;
			scale[6] = t7;
			scalesize = 7;
		} else if (t9 == -1) {
			scale[0] = t1;
			scale[1] = t2;
			scale[2] = t3;
			scale[3] = t4;
			scale[4] = t5;
			scale[5] = t6;
			scale[6] = t7;
			scale[7] = t8;
			scalesize = 8;
		} else if (t10 == -1) {
			scale[0] = t1;
			scale[1] = t2;
			scale[2] = t3;
			scale[3] = t4;
			scale[4] = t5;
			scale[5] = t6;
			scale[6] = t7;
			scale[7] = t8;
			scale[8] = t9;
			scalesize = 9;
		} else if (t11 == -1) {
			scale[0] = t1;
			scale[1] = t2;
			scale[2] = t3;
			scale[3] = t4;
			scale[4] = t5;
			scale[5] = t6;
			scale[6] = t7;
			scale[7] = t8;
			scale[8] = t9;
			scale[9] = t10;
			scalesize = 10;
		} else if (t12 == -1) {
			scale[0] = t1;
			scale[1] = t2;
			scale[2] = t3;
			scale[3] = t4;
			scale[4] = t5;
			scale[5] = t6;
			scale[6] = t7;
			scale[7] = t8;
			scale[8] = t9;
			scale[9] = t10;
			scale[10] = t11;
			scalesize = 11;
		} else {
			scale[0] = t1;
			scale[1] = t2;
			scale[2] = t3;
			scale[3] = t4;
			scale[4] = t5;
			scale[5] = t6;
			scale[6] = t7;
			scale[7] = t8;
			scale[8] = t9;
			scale[9] = t10;
			scale[10] = t11;
			scale[11] = t12;
			scalesize = 12;
		}
	}

	public static function setscale(t:Dynamic /*:Int*/):Void {
		currentscale = t;
		switch (t) {
			case SCALE_MAJOR:
				_setscale(2, 2, 1, 2, 2, 2, 1);
			case SCALE_MINOR:
				_setscale(2, 1, 2, 2, 2, 2, 1);
			case SCALE_BLUES:
				_setscale(3, 2, 1, 1, 3, 2);
			case SCALE_HARMONIC_MINOR:
				_setscale(2, 1, 2, 2, 1, 3, 1);
			case SCALE_PENTATONIC_MAJOR:
				_setscale(2, 3, 2, 2, 3);
			case SCALE_PENTATONIC_MINOR:
				_setscale(3, 2, 2, 3, 2);
			case SCALE_PENTATONIC_BLUES:
				_setscale(3, 2, 1, 1, 3, 2);
			case SCALE_PENTATONIC_NEUTRAL:
				_setscale(2, 3, 2, 3, 2);
			case SCALE_ROMANIAN_FOLK:
				_setscale(2, 1, 3, 1, 2, 1, 2);
			case SCALE_SPANISH_GYPSY:
				_setscale(2, 1, 3, 1, 2, 1, 2);
			case SCALE_ARABIC_MAGAM:
				_setscale(2, 2, 1, 1, 2, 2, 2);
			case SCALE_CHINESE:
				_setscale(4, 2, 1, 4, 1);
			case SCALE_HUNGARIAN:
				_setscale(2, 1, 3, 1, 1, 3, 1);
			case CHORD_MAJOR:
				_setscale(4, 3, 5);
			case CHORD_MINOR:
				_setscale(3, 4, 5);
			case CHORD_5TH:
				_setscale(7, 5);
			case CHORD_DOM_7TH:
				_setscale(4, 3, 3, 2);
			case CHORD_MAJOR_7TH:
				_setscale(4, 3, 4, 1);
			case CHORD_MINOR_7TH:
				_setscale(3, 4, 3, 2);
			case CHORD_MINOR_MAJOR_7TH:
				_setscale(3, 4, 4, 1);
			case CHORD_SUS4:
				_setscale(5, 2, 5);
			case CHORD_SUS2:
				_setscale(2, 5, 5);
			default:
			case SCALE_NORMAL:
				_setscale(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
		}
	}

	public static function updatepianoroll():Void {
		// Set piano roll based on currently loaded scale
		var scaleiter:Dynamic /*:Int*/ = -1,
			pianorolliter:Dynamic /*:Int*/ = 0,
			lastnote:Dynamic /*:Int*/ = 0;

		lastnote = key;
		pianorollsize = 0;

		while (lastnote < 104) {
			pianoroll[pianorolliter] = lastnote;
			pianorollsize++;
			pianorolliter++;
			scaleiter++;
			if (scaleiter >= scalesize)
				scaleiter -= scalesize;

			lastnote = pianoroll[cast pianorolliter - 1] + scale[scaleiter];
		}

		for (i in 0...104) {
			invertpianoroll[i] = -1;
			for (j in 0...pianorollsize) {
				if (pianoroll[j] == i) {
					invertpianoroll[i] = j;
				}
			}
		}
	}

	public static function addmusicbox():Void {
		musicbox[numboxes].clear();
		musicbox[numboxes].instr = currentinstrument;
		musicbox[numboxes].palette = instrument[currentinstrument].palette;
		musicbox[numboxes].hash += currentinstrument;
		numboxes++;
	}

	public static function copymusicbox(a:Dynamic /*:Int*/, b:Dynamic /*:Int*/):Void {
		musicbox[a].numnotes = musicbox[b].numnotes;

		for (j in 0...musicbox[a].numnotes) {
			musicbox[a].notes[j].x = musicbox[b].notes[j].x;
			musicbox[a].notes[j].y = musicbox[b].notes[j].y;
			musicbox[a].notes[j].width = musicbox[b].notes[j].width;
			musicbox[a].notes[j].height = musicbox[b].notes[j].height;
		}

		for (j in 0...16) {
			musicbox[a].cutoffgraph[j] = musicbox[b].cutoffgraph[j];
			musicbox[a].resonancegraph[j] = musicbox[b].resonancegraph[j];
			musicbox[a].volumegraph[j] = musicbox[b].volumegraph[j];
		}

		musicbox[a].recordfilter = musicbox[b].recordfilter;
		musicbox[a].topnote = musicbox[b].topnote;
		musicbox[a].bottomnote = musicbox[b].bottomnote;
		musicbox[a].notespan = musicbox[b].notespan;

		musicbox[a].start = musicbox[b].start;
		musicbox[a].key = musicbox[b].key;
		musicbox[a].instr = musicbox[b].instr;
		musicbox[a].palette = musicbox[b].palette;
		musicbox[a].scale = musicbox[b].scale;
		musicbox[a].isplayed = musicbox[b].isplayed;
	}

	public static function deletemusicbox(t:Dynamic /*:Int*/):Void {
		if (currentbox == t)
			currentbox--;
		for (i in t...numboxes) {
			copymusicbox(i, i + 1);
		}
		numboxes--;

		for (j in 0...8) {
			for (i in 0...arrange.lastbar) {
				if (arrange.bar[i].channel[j] == t) {
					arrange.bar[i].channel[j] = -1;
				} else if (arrange.bar[i].channel[j] > t) {
					arrange.bar[i].channel[j]--;
				}
			}
		}
	}

	public static function seekposition(t:Dynamic /*:Int*/):Void {
		// Make this smoother someday maybe
		barposition = t;
	}

	public static function filllist(t:Dynamic /*:Int*/):Void {
		list.type = t;
		switch (t) {
			case LIST_KEY:
				for (i in 0...12) {
					list.item[i] = notename[i];
				}
				list.numitems = 12;
			case LIST_SCALE:
				for (i in 0...23) {
					list.item[i] = scalename[i];
				}
				list.numitems = 23;
			case LIST_CATEGORY:
				list.item[0] = "MIDI";
				list.item[1] = "DRUMKIT";
				list.item[2] = "CHIPTUNE";
				list.item[3] = "PIANO";
				list.item[4] = "BRASS";
				list.item[5] = "BASS";
				list.item[6] = "STRINGS";
				list.item[7] = "WIND";
				list.item[8] = "BELL";
				list.item[9] = "GUITAR";
				list.item[10] = "LEAD";
				list.item[11] = "SPECIAL";
				list.item[12] = "WORLD";
				list.numitems = 13;
			case LIST_INSTRUMENT:
				if (voicelist.sublistsize > 15) {
					// Need to split Into several pages
					// Fix pagenum if it got broken somewhere
					if ((voicelist.pagenum * 15) > voicelist.sublistsize)
						voicelist.pagenum = 0;
					if (voicelist.sublistsize - (voicelist.pagenum * 15) > 15) {
						for (i in 0...15) {
							list.item[i] = voicelist.subname[cast(voicelist.pagenum * 15) + i];
						}
						list.item[15] = ">> Next Page";
						list.numitems = 16;
					} else {
						for (i in 0...cast(voicelist.sublistsize - (voicelist.pagenum * 15))) {
							list.item[i] = voicelist.subname[cast(voicelist.pagenum * 15) + i];
						}
						list.item[cast voicelist.sublistsize - (voicelist.pagenum * 15)] = "<< First Page";
						list.numitems = voicelist.sublistsize - (voicelist.pagenum * 15) + 1;
					}
				} else {
					// Just a simple single page
					for (i in 0...voicelist.sublistsize) {
						list.item[i] = voicelist.subname[i];
					}
					list.numitems = voicelist.sublistsize;
				}
			case LIST_MIDIINSTRUMENT:
				midilistselection = -1;
				list.item[0] = "> Piano";
				list.item[1] = "> Bells";
				list.item[2] = "> Organ";
				list.item[3] = "> Guitar";
				list.item[4] = "> Bass";
				list.item[5] = "> Strings";
				list.item[6] = "> Ensemble";
				list.item[7] = "> Brass";
				list.item[8] = "> Reed";
				list.item[9] = "> Pipe";
				list.item[10] = "> Lead";
				list.item[11] = "> Pads";
				list.item[12] = "> Synth";
				list.item[13] = "> World";
				list.item[14] = "> Drums";
				list.item[15] = "> Effects";
				list.numitems = 16;
			case LIST_SELECTINSTRUMENT:
				// For choosing from existing instruments
				for (i in 0...numinstrument) {
					list.item[i] = Std.string(i + 1) + " " + instrument[i].name;
				}
				list.numitems = numinstrument;
			case LIST_BUFFERSIZE:
				list.item[0] = "2048 (default, high performance)";
				list.item[1] = "4096 (try if you get cracking on wav exports)";
				list.item[2] = "8192 (slow, not recommended)";
				list.numitems = 3;
			case LIST_EFFECTS:
				for (i in 0...7) {
					list.item[i] = effectname[i];
				}
				list.numitems = 7;
			case LIST_MOREEXPORTS:
				list.item[0] = "EXPORT .xm (wip)";
				list.item[1] = "EXPORT .mml (wip)";
				list.numitems = 2;
			case LIST_EXPORTS:
				list.item[0] = "EXPORT .wav";
				list.item[1] = "EXPORT .mid";
				list.item[2] = "> More";
				list.numitems = 3;
			default:
				// Midi list
				list.type = LIST_MIDIINSTRUMENT;
				secondlist.type = t;
				for (i in 0...8) {
					secondlist.item[i] = voicelist.name[cast i + ((t - 10) * 8)];
				}
				secondlist.numitems = 8;
		}
	}

	public static function setinstrumenttoindex(t:Dynamic /*:Int*/):Void {
		voicelist.index = instrument[t].index;
		if (Help.Left(voicelist.voice[cast(voicelist.index)], 7) == "drumkit") {
			instrument[t].type = Std.parseInt(Help.Right(voicelist.voice[voicelist.index]));
			instrument[t].updatefilter();
			drumkit[cast instrument[t].type - 1].updatefilter(instrument[t].cutoff, instrument[t].resonance);
		} else {
			instrument[t].type = 0;
			instrument[t].voice = _presets.voices[voicelist.voice[voicelist.index]];
			instrument[t].updatefilter();
		}

		instrument[t].name = voicelist.name[voicelist.index];
		instrument[t].category = voicelist.category[voicelist.index];
		instrument[t].palette = voicelist.palette[voicelist.index];
	}

	public static function nextinstrument():Void {
		// Change to the next instrument in a category
		voicelist.index = voicelist.getnext(voicelist.getvoice(instrument[currentinstrument].name));
		changeinstrumentvoice(voicelist.name[voicelist.index]);
	}

	public static function previousinstrument():Void {
		// Change to the previous instrument in a category
		voicelist.index = voicelist.getprevious(voicelist.getvoice(instrument[currentinstrument].name));
		changeinstrumentvoice(voicelist.name[voicelist.index]);
	}

	public static function changeinstrumentvoice(t:String):Void {
		instrument[currentinstrument].name = t;
		voicelist.index = voicelist.getvoice(t);
		instrument[currentinstrument].category = voicelist.category[voicelist.index];
		if (Help.Left(voicelist.voice[voicelist.index], 7) == "drumkit") {
			instrument[currentinstrument].type = Std.parseInt(Help.Right(voicelist.voice[voicelist.index]));
			instrument[currentinstrument].updatefilter();
			drumkit[cast instrument[currentinstrument].type - 1].updatefilter(instrument[currentinstrument].cutoff, instrument[currentinstrument].resonance);

			if (currentbox > -1) {
				if (musicbox[currentbox].start > drumkit[cast instrument[currentinstrument].type - 1].size) {
					musicbox[currentbox].start = 0;
				}
			}
		} else {
			instrument[currentinstrument].type = 0;
			instrument[currentinstrument].voice = _presets.voices[voicelist.voice[voicelist.index]];
			instrument[currentinstrument].updatefilter();
		}

		instrument[currentinstrument].palette = voicelist.palette[voicelist.index];
		instrument[currentinstrument].index = voicelist.index;

		for (i in 0...numboxes) {
			if (musicbox[i].instr == currentinstrument) {
				musicbox[i].palette = instrument[currentinstrument].palette;
			}
		}
	}

	public static function makefilestring():Void {
		filestring = "";
		filestring += Std.string(version) + ",";
		filestring += Std.string(swing) + ",";
		filestring += Std.string(effecttype) + ",";
		filestring += Std.string(effectvalue) + ",";
		filestring += Std.string(bpm) + ",";
		filestring += Std.string(boxcount) + ",";
		filestring += Std.string(barcount) + ",";
		// Instruments first!
		filestring += Std.string(numinstrument) + ",";
		for (i in 0...numinstrument) {
			filestring += Std.string(instrument[i].index) + ",";
			filestring += Std.string(instrument[i].type) + ",";
			filestring += Std.string(instrument[i].palette) + ",";
			filestring += Std.string(instrument[i].cutoff) + ",";
			filestring += Std.string(instrument[i].resonance) + ",";
			filestring += Std.string(instrument[i].volume) + ",";
		}
		// Next, musicboxes
		filestring += Std.string(numboxes) + ",";
		for (i in 0...numboxes) {
			filestring += Std.string(musicbox[i].key) + ",";
			filestring += Std.string(musicbox[i].scale) + ",";
			filestring += Std.string(musicbox[i].instr) + ",";
			filestring += Std.string(musicbox[i].palette) + ",";
			filestring += Std.string(musicbox[i].numnotes) + ",";
			for (j in 0...musicbox[i].numnotes) {
				filestring += Std.string(musicbox[i].notes[j].x) + ",";
				filestring += Std.string(musicbox[i].notes[j].y) + ",";
				filestring += Std.string(musicbox[i].notes[j].width) + ",";
				filestring += Std.string(musicbox[i].notes[j].height) + ",";
			}
			filestring += Std.string(musicbox[i].recordfilter) + ",";
			if (musicbox[i].recordfilter == 1) {
				for (j in 0...16) {
					filestring += Std.string(musicbox[i].volumegraph[j]) + ",";
					filestring += Std.string(musicbox[i].cutoffgraph[j]) + ",";
					filestring += Std.string(musicbox[i].resonancegraph[j]) + ",";
				}
			}
		}
		// Next, arrangements
		filestring += Std.string(arrange.lastbar) + ",";
		filestring += Std.string(arrange.loopstart) + ",";
		filestring += Std.string(arrange.loopend) + ",";
		for (i in 0...arrange.lastbar) {
			for (j in 0...8) {
				filestring += Std.string(arrange.bar[i].channel[j]) + ",";
			}
		}
	}

	public static function newsong():Void {
		changetab(MENUTAB_FILE);
		bpm = 120;
		boxcount = 16;
		barcount = 4;
		doublesize = false;
		effectvalue = 0;
		effecttype = 0;
		updateeffects();
		_driver.bpm = bpm;
		arrange.clear();
		musicbox[0].clear();
		changekey(0);
		changescale(0);
		arrange.bar[0].channel[0] = 0;
		numboxes = 1;
		currentbox = 0;
		numinstrument = 1;
		instrumentmanagerview = 0;
		patternmanagerview = 0;
		// set instrument to grand piano
		instrument[0] = new Instrumentclass();
		instrument[0].voice = _presets.voices["midi.piano1"];
		instrument[0].updatefilter();
		showmessage("NEW SONG CREATED");
	}

	public static function readfilestream():Dynamic /*:Int*/ {
		fi++;
		return filestream[cast fi - 1];
	}

	public static function convertfilestring():Void {
		fi = 0;
		version = readfilestream();
		if (version == 3) {
			swing = readfilestream();
			effecttype = readfilestream();
			effectvalue = readfilestream();
			updateeffects();
			bpm = readfilestream();
			_driver.bpm = bpm;
			boxcount = readfilestream();
			doublesize = boxcount > 16;
			barcount = readfilestream();
			numinstrument = readfilestream();
			for (i in 0...numinstrument) {
				instrument[i].index = readfilestream();
				setinstrumenttoindex(i);
				instrument[i].type = readfilestream();
				instrument[i].palette = readfilestream();
				instrument[i].cutoff = readfilestream();
				instrument[i].resonance = readfilestream();
				instrument[i].volume = readfilestream();
				instrument[i].updatefilter();
				if (instrument[i].type > 0) {
					drumkit[cast instrument[i].type - 1].updatefilter(instrument[i].cutoff, instrument[i].resonance);
					drumkit[cast instrument[i].type - 1].updatevolume(instrument[i].volume);
				}
			}
			// Next, musicboxes
			numboxes = readfilestream();
			for (i in 0...numboxes) {
				musicbox[i].key = readfilestream();
				musicbox[i].scale = readfilestream();
				musicbox[i].instr = readfilestream();
				musicbox[i].palette = readfilestream();
				musicbox[i].numnotes = readfilestream();
				for (j in 0...musicbox[i].numnotes) {
					musicbox[i].notes[j].x = readfilestream();
					musicbox[i].notes[j].y = readfilestream();
					musicbox[i].notes[j].width = readfilestream();
					musicbox[i].notes[j].height = readfilestream();
				}
				musicbox[i].findtopnote();
				musicbox[i].findbottomnote();
				musicbox[i].notespan = musicbox[i].topnote - musicbox[i].bottomnote;
				musicbox[i].recordfilter = readfilestream();
				if (musicbox[i].recordfilter == 1) {
					for (j in 0...16) {
						musicbox[i].volumegraph[j] = readfilestream();
						musicbox[i].cutoffgraph[j] = readfilestream();
						musicbox[i].resonancegraph[j] = readfilestream();
					}
				}
			}
			// Next, arrangements
			arrange.lastbar = readfilestream();
			arrange.loopstart = readfilestream();
			arrange.loopend = readfilestream();
			for (i in 0...arrange.lastbar) {
				for (j in 0...8) {
					arrange.bar[i].channel[j] = readfilestream();
				}
			}
		} else {
			// opps, the file we're loading is out of date. Let's try to convert it
			legacy_convertfilestring(version);
			version = 3;
		}
	}

	public static function legacy_convertfilestring(t:Dynamic /*:Int*/):Void {
		switch (t) {
			case 2: // Before effects and 32 note patterns
				swing = readfilestream();
				effecttype = 0;
				effectvalue = 0;
				bpm = readfilestream();
				_driver.bpm = bpm;
				boxcount = readfilestream();
				doublesize = boxcount > 16;
				barcount = readfilestream();
				numinstrument = readfilestream();
				for (i in 0...numinstrument) {
					instrument[i].index = readfilestream();
					setinstrumenttoindex(i);
					instrument[i].type = readfilestream();
					instrument[i].palette = readfilestream();
					instrument[i].cutoff = readfilestream();
					instrument[i].resonance = readfilestream();
					instrument[i].volume = readfilestream();
					instrument[i].updatefilter();
					if (instrument[i].type > 0) {
						drumkit[cast instrument[i].type - 1].updatefilter(instrument[i].cutoff, instrument[i].resonance);
						drumkit[cast instrument[i].type - 1].updatevolume(instrument[i].volume);
					}
				}
				// Next, musicboxes
				numboxes = readfilestream();
				for (i in 0...numboxes) {
					musicbox[i].key = readfilestream();
					musicbox[i].scale = readfilestream();
					musicbox[i].instr = readfilestream();
					musicbox[i].palette = readfilestream();
					musicbox[i].numnotes = readfilestream();
					for (j in 0...musicbox[i].numnotes) {
						musicbox[i].notes[j].x = readfilestream();
						musicbox[i].notes[j].y = readfilestream();
						musicbox[i].notes[j].width = readfilestream();
						musicbox[i].notes[j].height = readfilestream();
					}
					musicbox[i].findtopnote();
					musicbox[i].findbottomnote();
					musicbox[i].notespan = musicbox[i].topnote - musicbox[i].bottomnote;
					musicbox[i].recordfilter = readfilestream();
					if (musicbox[i].recordfilter == 1) {
						for (j in 0...16) {
							musicbox[i].volumegraph[j] = readfilestream();
							musicbox[i].cutoffgraph[j] = readfilestream();
							musicbox[i].resonancegraph[j] = readfilestream();
						}
					}
				}
				// Next, arrangements
				arrange.lastbar = readfilestream();
				arrange.loopstart = readfilestream();
				arrange.loopend = readfilestream();
				for (i in 0...arrange.lastbar) {
					for (j in 0...8) {
						arrange.bar[i].channel[j] = readfilestream();
					}
				}
			case 1: // Original release, had a bug where volume info wasn't saved
				bpm = readfilestream();
				_driver.bpm = bpm;
				swing = 0;
				effecttype = 0;
				effectvalue = 0;
				boxcount = readfilestream();
				doublesize = boxcount > 16;
				barcount = readfilestream();
				numinstrument = readfilestream();
				for (i in 0...numinstrument) {
					instrument[i].index = readfilestream();
					setinstrumenttoindex(i);
					instrument[i].type = readfilestream();
					instrument[i].palette = readfilestream();
					instrument[i].cutoff = readfilestream();
					instrument[i].resonance = readfilestream();
					instrument[i].updatefilter();
					if (instrument[i].type > 0) {
						drumkit[cast instrument[i].type - 1].updatefilter(instrument[i].cutoff, instrument[i].resonance);
					}
				}
				// Next, musicboxes
				numboxes = readfilestream();
				for (i in 0...numboxes) {
					musicbox[i].key = readfilestream();
					musicbox[i].scale = readfilestream();
					musicbox[i].instr = readfilestream();
					musicbox[i].palette = readfilestream();
					musicbox[i].numnotes = readfilestream();
					for (j in 0...musicbox[i].numnotes) {
						musicbox[i].notes[j].x = readfilestream();
						musicbox[i].notes[j].y = readfilestream();
						musicbox[i].notes[j].width = readfilestream();
						musicbox[i].notes[j].height = readfilestream();
					}
					musicbox[i].findtopnote();
					musicbox[i].findbottomnote();
					musicbox[i].notespan = musicbox[i].topnote - musicbox[i].bottomnote;
					musicbox[i].recordfilter = readfilestream();
					if (musicbox[i].recordfilter == 1) {
						for (j in 0...16) {
							musicbox[i].volumegraph[j] = readfilestream();
							musicbox[i].cutoffgraph[j] = readfilestream();
							musicbox[i].resonancegraph[j] = readfilestream();
						}
					}
				}
				// Next, arrangements
				arrange.lastbar = readfilestream();
				arrange.loopstart = readfilestream();
				arrange.loopend = readfilestream();
				for (i in 0...arrange.lastbar) {
					for (j in 0...8) {
						arrange.bar[i].channel[j] = readfilestream();
					}
				}
		}
	} // File stuff

	#if (CONFIG == "desktop")
	public static function fileHasExtension(file:String, extension:String):Bool {
		if (file.split('.')[1] == null || file.split('.')[1].toLowerCase() != extension) {
			return false;
		}
		return true;
	}

	public static function addExtensionToFile(file:String, extension:String):Void {
		file += "." + extension;
	}

	public static function saveceol():Void {
		/*TODO:FIXME: add -Sam!
			if (filepath == "") {
				filepath = defaultDirectory;
			}
			file = filepath.resolvePath("*.ceol");
			file.addEventListener(Event.SELECT, onsaveceol);
			file.browseForSave("Save .ceol File");

			fixmouseclicks = true;
		 */
	}

	private static function onsaveceol(e:Event):Void {
		/*TODO:FIXME: add -Sam!
			file = cast e.currentTarget;

			if (!fileHasExtension(file, "ceol")) {
				addExtensionToFile(file, "ceol");
			}

			makefilestring();

			stream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(filestring);
			stream.close();

			fixmouseclicks = true;
			showmessage("SONG SAVED");
			savefilesettings();
		 */
	}

	public static function loadceol():Void {
		/*TODO:FIXME: add -Sam!
			if (filepath == "") {
				filepath = defaultDirectory;
			}
			file = filepath.resolvePath("");
			file.addEventListener(Event.SELECT, onloadceol);
			file.browseForOpen("Load .ceol File", [ceolFilter]);

			fixmouseclicks = true;
		 */
	}

	public static function invokeceol(t:String):Void {
		/*TODO:FIXME: add -Sam!
			file = new File();
			file.nativePath = t;

			stream = new FileStream();
			stream.open(file, FileMode.READ);
			filestring = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();

			loadfilestring(filestring);
			_driver.play(null, false);

			fixmouseclicks = true;
			showmessage("SONG LOADED");
		 */
	}

	private static function onloadceol(e:Event):Void {
		/*TODO:FIXME: add -Sam!
			file = cast e.currentTarget;
			filepath = file.resolvePath("");

			stream = new FileStream();
			stream.open(file, FileMode.READ);
			filestring = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();

			loadfilestring(filestring);
			_driver.play(null, false);

			fixmouseclicks = true;
			showmessage("SONG LOADED");
			savefilesettings();
		 */
	}

	public static function exportxm():Void {
		/*TODO:FIXME: add -Sam!
			stopmusic();

			if (!filepath) {
				filepath = defaultDirectory;
			}
			file = filepath.resolvePath("*.xm");
			file.addEventListener(Event.SELECT, onexportxm);
			file.browseForSave("Export .XM module file");

			fixmouseclicks = true;
		 */
	}

	private static function onexportxm(e:Event):Void {
		file = cast e.currentTarget;

		if (!fileHasExtension(file, "xm")) {
			addExtensionToFile(file, "xm");
		}

		var xm:TrackerModuleXM = new TrackerModuleXM();
		xm.loadFromLiveBoscaCeoilModel(file);

		// stream = new FileStream();// TODO:FIXME: add -Sam!
		// stream.open(file, FileMode.WRITE);
		// xm.writeToStream(stream);
		// stream.close();

		fixmouseclicks = true;
		showmessage("SONG EXPORTED AS XM");
		savefilesettings();
	}

	public static function exportmml():Void {
		/*TODO:FIXME: add -Sam!
			stopmusic();

			if (filepath == "") {
				filepath = defaultDirectory;
			}
			file = filepath.resolvePath("*.mml");
			file.addEventListener(Event.SELECT, onexportmml);
			file.browseForSave("Export MML music text file");

			fixmouseclicks = true;
		 */
	}

	private static function onexportmml(e:Event):Void {
		/*TODO:FIXME: add -Sam!
			file = cast e.currentTarget;

			if (!fileHasExtension(file, "mml")) {
				addExtensionToFile(file, "mml");
			}

			var song:MMLSong = new MMLSong();
			song.loadFromLiveBoscaCeoilModel();

			stream = new FileStream();
			stream.open(file, FileMode.WRITE);
			song.writeToStream(stream);
			stream.close();

			fixmouseclicks = true;
			showmessage("SONG EXPORTED AS MML");
			savefilesettings();
		 */
	}

	private static function onsavewav(e:Event):Void {
		/*TODO:FIXME: add -Sam!
			file = cast e.currentTarget;

			if (!fileHasExtension(file, "wav")) {
				addExtensionToFile(file, "wav");
			}

			stream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(_wav, 0, _wav.length);
			stream.close();

			fixmouseclicks = true;
			showmessage("SONG EXPORTED AS WAV");
			savefilesettings();
		 */
	}
	#end

	#if (CONFIG == "web")
	{
		public static function invokeCeolWeb(ceolStr:String):Void {
			changetab(MENUTAB_FILE);
			if (ceolStr != "") {
				filestring = ceolStr;
				loadfilestring(filestring);
				showmessage("SONG LOADED");
			} else {
				newsong();
			}

			_driver.play(null, false);
		}

		public static function getCeolString():String {
			makefilestring();
			return filestring;
		}
	}
	#end
	private static function loadfilestring(s:String):Void {
		filestream = new Array();
		filestream = s.split(",");

		numinstrument = 1;
		numboxes = 0;
		arrange.clear();
		arrange.currentbar = 0;
		arrange.viewstart = 0;

		convertfilestring();

		changemusicbox(0);
		looptime = 0;
	}

	public static function showmessage(t:String):Void {
		message = t;
		messagedelay = 90;
	}

	public static function onStream(e:SiONEvent):Void {
		e.streamBuffer.position = 0;
		while (e.streamBuffer.bytesAvailable > 0) {
			var d:Float = e.streamBuffer.readFloat() * 32767;
			if (nowexporting)
				_data.writeShort(Std.int(d));
		}
	}

	public static function pausemusic():Void {
		if (musicplaying) {
			musicplaying = !musicplaying;
			if (!musicplaying)
				notecut();
		}
	}

	public static function stopmusic():Void {
		if (musicplaying) {
			musicplaying = !musicplaying;
			looptime = 0;
			arrange.currentbar = arrange.loopstart;
			if (!musicplaying)
				notecut();
		}
	}

	public static function startmusic():Void {
		if (!musicplaying) {
			#if web
			var v:js.lib.Promise<Dynamic> = AudioManager.context.web.resume();
			v.then(function(res:Dynamic) {
				_driver.resume();
				musicplaying = !musicplaying;
			});
			#else
			musicplaying = !musicplaying;
			#end
		}
	}

	public static function exportwav():Void {
		changetab(MENUTAB_ARRANGEMENTS);
		clicklist = true;
		arrange.loopstart = 0;
		arrange.loopend = arrange.lastbar;
		musicplaying = true;
		looptime = 0;
		arrange.currentbar = arrange.loopstart;
		SetSwing();

		// Clear the wav buffer
		_data = new ByteArray();
		_data.endian = Endian.LITTLE_ENDIAN;

		followmode = true;
		nowexporting = true;
	}

	public static function savewav():Void {
		nowexporting = false;
		followmode = false;

		_wav = new ByteArray();
		_wav.endian = Endian.LITTLE_ENDIAN;
		_wav.writeUTFBytes("RIFF");
		var len:Dynamic /*:Int*/ = _data.length;
		_wav.writeInt(len + 36);
		_wav.writeUTFBytes("WAVE");
		_wav.writeUTFBytes("fmt ");
		_wav.writeInt(16);
		_wav.writeShort(1);
		_wav.writeShort(2);
		_wav.writeInt(44100);
		_wav.writeInt(176400);
		_wav.writeShort(4);
		_wav.writeShort(16);
		_wav.writeUTFBytes("data");
		_wav.writeInt(len);
		_data.position = 0;
		_wav.writeBytes(_data);

		#if (CONFIG == "desktop")
		{
			/*TODO:FIXME: add -Sam!
				if (filepath == "") {
					filepath = defaultDirectory;
				}
				file = filepath.resolvePath("*.wav");
				file.addEventListener(Event.SELECT, onsavewav);
				file.browseForSave("Export .wav File");
			 */
		}
		#end

		#if web
		{
			_wav.position = 0;
			var bytes:Bytes = Bytes.ofString(_wav.readUTFBytes(_wav.length));
			ExternalInterface.call('Bosca._wavRecorded', Base64.encode(bytes));
		}
		#end

		fixmouseclicks = true;
	}

	public static function changetab(newtab:Dynamic /*:Int*/):Void {
		currenttab = newtab;
		Guiclass.changetab(newtab);
	}

	public static function changetab_ifdifferent(newtab:Dynamic /*:Int*/):Void {
		if (currenttab != newtab) {
			currenttab = newtab;
			Guiclass.changetab(newtab);
		}
	}

	#if (CONFIG == "desktop")
	public static var file:String;
	// public static var stream:FileStream;
	#end
	public static var filestring:String;
	public static var fi:Dynamic /*:Int*/;
	public static var filestream:Array<Dynamic>;
	public static var ceolFilter:FileFilter = new FileFilter("Ceol", "*.ceol");
	public static var i:Dynamic /*:Int*/;
	public static var j:Dynamic /*:Int*/;
	public static var k:Dynamic /*:Int*/;
	public static var fullscreen:Bool;
	public static var fullscreentoggleheld:Bool = false;

	public static var press_up:Bool;
	public static var press_down:Bool;
	public static var press_left:Bool;
	public static var press_right:Bool;
	public static var press_space:Bool;
	public static var press_enter:Bool;

	public static var keypriority:Dynamic /*:Int*/ = 0;

	public static var keyheld:Bool = false;

	public static var clicklist:Bool;
	public static var clicksecondlist:Bool;
	public static var copykeyheld:Bool = false;
	public static var keydelay:Dynamic /*:Int*/;
	public static var keyboardpressed:Dynamic /*:Int*/ = 0;
	public static var fixmouseclicks:Bool = false;
	public static var mx:Float;
	public static var my:Float;
	public static var test:Bool;
	public static var teststring:String;
	public static var _driver:SiONDriver;
	public static var _presets:SiONPresetVoice;
	public static var voicelist:Voicelistclass;
	public static var instrument:Array<Instrumentclass> = new Array<Instrumentclass>();
	public static var numinstrument:Dynamic /*:Int*/;
	public static var instrumentmanagerview:Dynamic /*:Int*/;
	public static var musicbox:Array<Musicphraseclass> = new Array<Musicphraseclass>();
	public static var numboxes:Dynamic /*:Int*/;
	public static var looptime:Dynamic /*:Int*/;
	public static var currentbox:Dynamic /*:Int*/;
	public static var currentnote:Dynamic /*:Int*/;
	public static var currentinstrument:Dynamic /*:Int*/;
	public static var boxsize:Dynamic /*:Int*/;
	public static var boxcount:Dynamic /*:Int*/;
	public static var barsize:Dynamic /*:Int*/;
	public static var barcount:Dynamic /*:Int*/;
	public static var notelength:Dynamic /*:Int*/;
	public static var doublesize:Bool;
	public static var arrangescrolldelay:Dynamic /*:Int*/ = 0;
	public static var barposition:Float = 0;
	public static var drawnoteposition:Dynamic /*:Int*/;
	public static var drawnotelength:Dynamic /*:Int*/;
	public static var cursorx:Dynamic /*:Int*/;
	public static var cursory:Dynamic /*:Int*/;
	public static var arrangecurx:Dynamic /*:Int*/;
	public static var arrangecury:Dynamic /*:Int*/;
	public static var patterncury:Dynamic /*:Int*/;
	public static var timelinecurx:Dynamic /*:Int*/;
	public static var instrumentcury:Dynamic /*:Int*/;
	public static var notey:Dynamic /*:Int*/;
	public static var notename:Array<String> = new Array<String>();
	public static var scalename:Array<String> = new Array<String>();
	public static var currentscale:Dynamic /*:Int*/ = 0;
	public static var scale:Array<Int> = new Array<Int>();
	public static var key:Dynamic /*:Int*/;
	public static var scalesize:Dynamic /*:Int*/;
	public static var pianoroll:Array<Int> = new Array<Int>();
	public static var invertpianoroll:Array<Int> = new Array<Int>();
	public static var pianorollsize:Dynamic /*:Int*/;
	public static var arrange:Arrangementclass = new Arrangementclass();
	public static var drumkit:Array<Drumkitclass> = new Array<Drumkitclass>();
	public static var currenttab:Dynamic /*:Int*/;
	public static var dragaction:Dynamic /*:Int*/;
	public static var dragx:Dynamic /*:Int*/;
	public static var dragy:Dynamic /*:Int*/;
	public static var dragpattern:Dynamic /*:Int*/;
	public static var patternmanagerview:Dynamic /*:Int*/;
	public static var trashbutton:Dynamic /*:Int*/;
	public static var list:Listclass = new Listclass();
	public static var secondlist:Listclass = new Listclass();
	public static var midilistselection:Dynamic /*:Int*/;
	public static var musicplaying:Bool = false;
	public static var nowexporting:Bool = false;
	public static var followmode:Bool = false;
	public static var bpm:Dynamic /*:Int*/;
	public static var version:Dynamic /*:Int*/;
	public static var swing:Dynamic /*:Int*/;
	public static var swingoff:Dynamic /*:Int*/;
	public static var doubleclickcheck:Dynamic /*:Int*/;
	public static var programsettings:SharedObject;
	public static var buffersize:Dynamic /*:Int*/;
	public static var currentbuffersize:Dynamic /*:Int*/;
	private static var _data:ByteArray;
	private static var _wav:ByteArray;
	public static var message:String;
	public static var messagedelay:Dynamic /*:Int*/ = 0;
	public static var startup:Dynamic /*:Int*/ = 0;
	public static var invokefile:String = "null";
	public static var ctrl:String;

	// Add filepath memory
	public static var filepath:String = "";
	public static var defaultDirectory:String = "";
	// Global effects
	public static var effecttype:Dynamic /*:Int*/;
	public static var effectvalue:Dynamic /*:Int*/;
	public static var effectname:Array<String> = new Array<String>();
	public static var versionnumber:String;
	public static var savescreencountdown:Dynamic /*:Int*/;
	public static var minresizecountdown:Dynamic /*:Int*/;
	public static var forceresize:Bool = false;
}
