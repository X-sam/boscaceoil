package;

import openfl.Assets;
import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;
import openfl.text.*;
import openfl.utils.Dictionary;
#if (CONFIG == "desktop")
// import openfl.display.NativeWindow;
import Control;
#end

class Gfx extends Sprite {
	public static function init(_stage:Stage):Void {
		min_windowwidth = 768;
		min_windowheight = 540;
		updatebackground = 5;
		#if air
		var ttffont = Assets.getFont("MyFlashFont");
		#elseif native
		var ttffont = Assets.getFont("MyFont");
		#end
		#if web
		var ttffont = Assets.getFont("MyWebFont");
		#end

		initGfx();
		initfont(ttffont);
		initpal();

		mStage = _stage;
	}

	public static function changeframerate(t:Dynamic /*:Int*/):Void {
		if (t != boscaframerate) {
			mStage.frameRate = t;
			boscaframerate = t;
		}
	}

	public static function changescalemode(t:Dynamic /*:Int*/):Void {
		// Set new minimum screensize
		if (t == 0) {
			min_windowwidth = 768;
			min_windowheight = 540;
			#if (CONFIG == "desktop")
			{
				// mStage.nativeWindow.minSize = new Point(768 + windowboundsx, 540 + windowboundsy); TODO:FIXME: add -Sam!
			}
			#end
		} else {
			min_windowwidth = 1152;
			min_windowheight = 690;
			#if (CONFIG == "desktop")
			{
				// mStage.nativeWindow.minSize = new Point(1152 + windowboundsx, 690 + windowboundsy); TODO:FIXME: add -Sam!
			}
			#end
		}

		scalemode = t;
		// Control.forceresize = true;
		// Control.clicklist = true; // Stops from placing a note on resize
	}

	public static function tutorialimagewidth(t:Dynamic /*:Int*/):Dynamic /*:Int*/ {
		return images[t + 8].width;
	}

	public static function tutorialimageheight(t:Dynamic /*:Int*/):Dynamic /*:Int*/ {
		return images[t + 8].height;
	}

	public static function forceminimumsize():Void {
		if (windowwidth < min_windowwidth && windowheight < min_windowheight) {
			changewindowsize(min_windowwidth, min_windowheight);
		} else if (windowwidth < min_windowwidth) {
			changewindowsize(min_windowwidth, windowheight);
		} else if (windowheight < min_windowheight) {
			changewindowsize(windowwidth, min_windowheight);
		}
	}

	public static function initpal():Void {
		// Initalise all the program's palettes here
		pal[0].setto(255, 255, 255); // Pure White
		pal[1].setto(52, 66, 70); // Background
		pal[2].setto(188, 200, 204); // Menu bar
		pal[3].setto(146, 163, 170); // Bar, Bright
		pal[4].setto(109, 133, 141); // Bar, Dark
		pal[5].setto(80, 101, 106); // Guideline
		pal[6].setto(52, 66, 70); // Dark guideline
		pal[7].setto(146, 185, 196); // Note names
		pal[8].setto(104, 0, 0); // Note, dark part
		pal[9].setto(160, 0, 0); // Note, bright part

		pal[10].setto(255, 255, 255); // Arrangement Bar (bright)
		pal[11].setto(109, 133, 141); // Arrangement Bar (dark)
		pal[12].setto(0, 0, 0); // Black
		pal[13].setto(72, 0, 0); // Dark Red
		pal[14].setto(26, 33, 35); // Very dark grey
		pal[15].setto(255, 0, 0); // Red
		pal[16].setto(0, 132, 255); // Cyan
		pal[17].setto(0, 0, 140); // Dark Blue
		pal[18].setto(255, 255, 0); // Yellow
		pal[19].setto(222, 222, 0); // Darker Yellow

		pal[20].setto(65, 82, 87); // Background mouseover

		// Blue
		pal[100].setto(59, 39, 238); // Bar, Bright
		pal[101].setto(43, 33, 151); // Bar, Dark
		pal[102].setto(10, 14, 62); // Guideline
		pal[103].setto(5, 7, 31); // Dark guideline
		pal[104].setto(255, 185, 95); // Note, dark part
		pal[105].setto(255, 255, 192); // Note, bright part
		pal[106].setto(188, 207, 255); // Octave change

		// Purple
		pal[110].setto(156, 11, 240); // Bar, Bright
		pal[111].setto(91, 5, 143); // Bar, Dark
		pal[112].setto(10, 14, 62); // Guideline
		pal[113].setto(5, 7, 31); // Dark guideline
		pal[114].setto(255, 185, 95); // Note, dark part
		pal[115].setto(255, 255, 192); // Note, bright part
		pal[116].setto(224, 185, 255); // Octave change

		// Red
		pal[120].setto(210, 41, 58); // Bar, Bright
		pal[121].setto(124, 23, 35); // Bar, Dark
		pal[122].setto(62, 15, 10); // Guideline
		pal[123].setto(31, 8, 5); // Dark guideline
		pal[124].setto(255, 185, 95); // Note, dark part
		pal[125].setto(255, 255, 192); // Note, bright part
		pal[126].setto(244, 193, 201); // Octave change

		// Orange
		pal[130].setto(210, 153, 41); // Bar, Bright
		pal[131].setto(124, 90, 23); // Bar, Dark
		pal[132].setto(62, 55, 10); // Guideline
		pal[133].setto(30, 27, 5); // Dark guideline
		pal[134].setto(255, 185, 95); // Note, dark part
		pal[135].setto(255, 255, 192); // Note, bright part
		pal[136].setto(244, 224, 193); // Octave change

		// Green
		pal[140].setto(54, 215, 36); // Bar, Bright
		pal[141].setto(32, 127, 20); // Bar, Dark
		pal[142].setto(10, 62, 23); // Guideline
		pal[143].setto(5, 30, 12); // Dark guideline
		pal[144].setto(255, 185, 95); // Note, dark part
		pal[145].setto(255, 255, 192); // Note, bright part
		pal[146].setto(200, 246, 191); // Octave change

		// Cyan
		pal[150].setto(19, 144, 232); // Bar, Bright
		pal[151].setto(10, 86, 138); // Bar, Dark
		pal[152].setto(10, 31, 62); // Guideline
		pal[153].setto(5, 14, 30); // Dark guideline
		pal[154].setto(255, 185, 95); // Note, dark part
		pal[155].setto(255, 255, 192); // Note, bright part
		pal[156].setto(186, 227, 250); // Octave change

		// Grayscale
		pal[300].setto(140, 140, 140); // Bar, Bright
		pal[301].setto(96, 96, 96); // Bar, Dark
		pal[302].setto(31, 31, 31); // Guideline
		pal[303].setto(14, 14, 14); // Dark guideline
		pal[304].setto(255, 185, 95); // Note, dark part
		pal[305].setto(255, 255, 192); // Note, bright part
		pal[306].setto(227, 227, 227); // Octave change
	}

	public static function updateboxsize():Void {
		if (Control.doublesize) {
			Control.boxsize = cast((screenwidth - 60) / 32);
			Control.barsize = Control.boxsize * Control.barcount;
		} else {
			Control.boxsize = cast((screenwidth - 60) / 16);
			Control.barsize = Control.boxsize * Control.barcount;
		}
	}

	public static function lastchar(s:String):String {
		return (s.length > 0) ? s.charAt(s.length - 1) : "";
	}

	public static function drawpatterneditor():Void {
		// Pattern editor
		updateboxsize();

		// Draw background colour for each row
		var isdrumkit:Bool = Control.instrument[Control.musicbox[Control.currentbox].instr].type >= 1;
		for (i in 0...notesonscreen) {
			var instsize:Dynamic /*:Int*/ = Control.pianorollsize;
			if (Control.instrument[Control.musicbox[Control.currentbox].instr].type >= 1) {
				instsize = Control.drumkit[cast Control.instrument[Control.musicbox[Control.currentbox].instr].type - 1].size;
			}
			if (Control.musicbox[Control.currentbox].start + i - 1 < instsize) {
				var n:Dynamic /*:Int*/ = Control.musicbox[Control.currentbox].start + i - 1;
				var notename:String = (n > -1) ? Control.notename[Control.pianoroll[n]] : "";
				var sharp:Bool = isdrumkit ? (n % 2 == 0) : (lastchar(notename) == '#');
				if (!sharp) {
					fillrect(0, screenheight
						- linesize
						- (i * linesize), screenwidth, linesize, 100
						+ (Control.musicbox[Control.currentbox].palette * 10));
					fillrect(0, screenheight - linesize - (i * linesize), screenwidth, 2, 103 + (Control.musicbox[Control.currentbox].palette * 10));
				} else {
					fillrect(0, screenheight
						- linesize
						- (i * linesize), screenwidth, linesize, 101
						+ (Control.musicbox[Control.currentbox].palette * 10));
					fillrect(0, screenheight - linesize - (i * linesize), screenwidth, 2, 103 + (Control.musicbox[Control.currentbox].palette * 10));
				}
			}
		}

		// Draw bars
		for (i in 0...Control.boxcount) {
			fillrect(40
				+ (i * Control.boxsize), pianorollposition
				+ linesize, 2, (linesize * patterneditorheight),
				102
				+ (Control.musicbox[Control.currentbox].palette * 10));
		}
		for (i in 0...Std.int(((Control.boxcount / Control.barcount) + 1))) {
			fillrect(40
				+ (i * Control.barsize)
				+ 2, pianorollposition
				+ linesize, 2, (linesize * patterneditorheight),
				103
				+ (Control.musicbox[Control.currentbox].palette * 10));
		}

		// Reduced patternsize? Just draw over it!
		if (Control.doublesize) {
			if (Control.boxcount < 32) {
				fillrect(42
					+ (Control.boxcount * Control.boxsize), pianorollposition
					+ linesize, screenwidth, linesize * patterneditorheight,
					103
					+ (Control.musicbox[Control.currentbox].palette * 10));
			}
		} else {
			if (Control.boxcount < 16) {
				fillrect(42
					+ (Control.boxcount * Control.boxsize), pianorollposition
					+ linesize, screenwidth, linesize * patterneditorheight,
					103
					+ (Control.musicbox[Control.currentbox].palette * 10));
			}
		}

		// Note names
		fillrect(0, pianorollposition + linesize, 40, linesize * patterneditorheight, 4);
		if (Control.notey > -1) {
			fillrect(0, screenheight - linesize - (Control.notey * linesize), 40, linesize, 6);
		}

		// PrInt note names
		j = Control.instrument[Control.musicbox[Control.currentbox].instr].type;
		if (j >= 1) {
			// Drumkit!
			j--;
			for (i in 0...notesonscreen) {
				if (Control.musicbox[Control.currentbox].start + i - 1 < Control.drumkit[j].size) {
					if (Control.musicbox[Control.currentbox].start + i - 1 > -1) {
						print(3, screenheight - linesize - (i * linesize), Control.drumkit[j].voicename[Control.musicbox[Control.currentbox].start + i - 1],
							0, false, true);
					} else {
						if (Control.musicbox[Control.currentbox].recordfilter == 1) {
							fillrect(0, screenheight - linesize - (i * linesize), screenwidth, linesize, 13);
							print(Gfx.screenwidthmid
								- Std.int((Gfx.len("! ADVANCED FILTER EDITING ON !") / 2)), screenheight
								- linesize
								- (i * linesize)
								+ 1,
								"! ADVANCED FILTER EDITING ON !", 15, false);
						} else {
							fillrect(0, screenheight - linesize - (i * linesize), screenwidth, linesize, 12);
							print(Gfx.screenwidthmid - Std.int((Gfx.len("ADVANCED FILTER EDITING OFF") / 2)), screenheight - linesize - (i * linesize) + 1,
								"ADVANCED FILTER EDITING OFF", 0);
						}
					}
				}
			}
		} else {
			for (i in 0...notesonscreen) {
				if (Control.musicbox[Control.currentbox].start + i - 1 > -1) {
					print(3, screenheight - linesize - (i * linesize),
						Control.notename[Control.pianoroll[Control.musicbox[Control.currentbox].start + i - 1]], 0);
				} else {
					if (Control.musicbox[Control.currentbox].recordfilter == 1) {
						fillrect(0, screenheight - linesize - (i * linesize), screenwidth, linesize, 13);
						print(Gfx.screenwidthmid - (Gfx.len("! ADVANCED FILTER EDITING ON !") / 2), screenheight - linesize - (i * linesize) + 1,
							"! ADVANCED FILTER EDITING ON !", 15);
					} else {
						fillrect(0, screenheight - linesize - (i * linesize), screenwidth, linesize, 12);
						print(Gfx.screenwidthmid - (Gfx.len("ADVANCED FILTER EDITING OFF") / 2), screenheight - linesize - (i * linesize) + 1,
							"ADVANCED FILTER EDITING OFF", 0, true);
					}
				}
			}
		}

		// Scroll bar
		if (Control.doublesize) {
			if (Control.musicbox[Control.currentbox].recordfilter == 1) {
				fillrect((42 + (32 * Control.boxsize)), pianorollposition + linesize, 40, linesize * patterneditorheight, 9);
			} else {
				fillrect((42 + (32 * Control.boxsize)), pianorollposition + linesize, 40, linesize * patterneditorheight, 4);
			}
		} else {
			if (Control.musicbox[Control.currentbox].recordfilter == 1) {
				fillrect((42 + (16 * Control.boxsize)), pianorollposition + linesize, 40, linesize * patterneditorheight, 9);
			} else {
				fillrect((42 + (16 * Control.boxsize)), pianorollposition + linesize, 40, linesize * patterneditorheight, 4);
			}
		}

		// Octave bars
		j = Control.instrument[Control.musicbox[Control.currentbox].instr].type;
		if (j == 0) {
			j = Control.musicbox[Control.currentbox].start;
			for (i in 0...notesonscreen) {
				if ((j + i) % Control.scalesize == 0) {
					fillrect(30, screenheight - linesize - (i * linesize), screenwidth, 3, 106 + (Control.musicbox[Control.currentbox].palette * 10));
					fillrect(30, screenheight
						- linesize
						- (i * linesize)
						+ 3, screenwidth, 1, 107
						+ (Control.musicbox[Control.currentbox].palette * 10));
					tempstring = Std.string(Std.int(j + i) / Control.scalesize);
					print(screenwidth - 20, screenheight - linesize - (i * linesize) + 4, tempstring, 0, false, true);
				}
			}
		}

		// DRAW THE NOTES HERE
		for (j in 0...Control.musicbox[Control.currentbox].numnotes) {
			i = Control.musicbox[Control.currentbox].notes[j].width;
			if (i < Control.boxcount) {
				Control.drawnoteposition = Control.invertpianoroll[cast Control.musicbox[Control.currentbox].notes[j].x] + 1;
				Control.drawnotelength = Control.musicbox[Control.currentbox].notes[j].y * Control.boxsize;
				if (Control.drawnoteposition > -1) {
					Control.drawnoteposition -= Control.musicbox[Control.currentbox].start;
					if (Control.drawnoteposition <= 0) {
						fillrect(42
							+ (i * Control.boxsize), screenheight
							- linesize
							- 4, Control.drawnotelength, 4,
							104
							+ (Control.musicbox[Control.currentbox].palette * 10));
						fillrect(42
							+ (i * Control.boxsize), screenheight
							- linesize
							- 2, Control.drawnotelength, 2,
							105
							+ (Control.musicbox[Control.currentbox].palette * 10));
						fillrect(42 + (i * Control.boxsize), screenheight - linesize - 8, 2, 8, 105 + (Control.musicbox[Control.currentbox].palette * 10));
						fillrect(42
							+ (i * Control.boxsize)
							+ Control.drawnotelength
							- 2, screenheight
							- linesize
							- 8, 2, 8,
							105
							+ (Control.musicbox[Control.currentbox].palette * 10));
					} else if (Control.drawnoteposition >= notesonscreen) {
						fillrect(42
							+ (i * Control.boxsize), pianorollposition
							+ linesize, Control.drawnotelength, 4,
							104
							+ (Control.musicbox[Control.currentbox].palette * 10));
						fillrect(42
							+ (i * Control.boxsize), pianorollposition
							+ linesize, Control.drawnotelength, 2,
							105
							+ (Control.musicbox[Control.currentbox].palette * 10));
						fillrect(42
							+ (i * Control.boxsize), pianorollposition
							+ linesize, 2, 8, 105
							+ (Control.musicbox[Control.currentbox].palette * 10));
						fillrect(42
							+ (i * Control.boxsize)
							+ Control.drawnotelength
							- 2, pianorollposition
							+ linesize, 2, 8,
							105
							+ (Control.musicbox[Control.currentbox].palette * 10));
					} else {
						fillrect(42
							+ (i * Control.boxsize), screenheight
							- linesize
							- (Control.drawnoteposition * linesize), Control.drawnotelength,
							linesize, 105
							+ (Control.musicbox[Control.currentbox].palette * 10));
						fillrect(42
							+ (i * Control.boxsize), screenheight
							- linesize
							- (Control.drawnoteposition * linesize)
							+ 16, Control.drawnotelength, 4,
							104
							+ (Control.musicbox[Control.currentbox].palette * 10));
						fillrect(42
							+ (i * Control.boxsize)
							+ Control.drawnotelength
							- 4, screenheight
							- linesize
							- (Control.drawnoteposition * linesize), 4,
							linesize, 104
							+ (Control.musicbox[Control.currentbox].palette * 10));

						tempstring = Std.string(Std.int(Control.musicbox[Control.currentbox].notes[j].y));
						if (Control.doublesize) {
							if (Control.musicbox[Control.currentbox].notes[j].y + Control.musicbox[Control.currentbox].notes[j].width > 32) {
								print(42 + (i * Control.boxsize), screenheight - linesize - (Control.drawnoteposition * linesize), tempstring, 12);
							}
						} else {
							if (Control.musicbox[Control.currentbox].notes[j].y + Control.musicbox[Control.currentbox].notes[j].width > 16) {
								print(42 + (i * Control.boxsize), screenheight - linesize - (Control.drawnoteposition * linesize), tempstring, 12);
							}
						}
					}
				}
			}
		}
	}

	public static function drawpatterneditor_cursor():Void {
		// Bar position
		Control.seekposition(Control.boxsize * Control.looptime);
		if (Control.musicbox[Control.currentbox].isplayed) {
			// Only draw if this musicbox is actually being played
			fillrect(40 + Control.barposition, pianorollposition + linesize, 4, linesize * patterneditorheight, 10);
			fillrect(40 + Control.barposition + 4, pianorollposition + linesize, 4, linesize * patterneditorheight, 11);
		}

		// Draw the cursor
		if (Control.cursorx > -1 && Control.cursory > -1) {
			if (Control.musicbox[Control.currentbox].start + Control.cursory - 1 == -1) {
				if (Control.doublesize) {
					drawbox(40 + (4 * Control.boxsize), Gfx.screenheight - linesize - (Control.cursory * linesize), Control.boxsize * 24, linesize, 0);
				} else {
					drawbox(40 + (2 * Control.boxsize), Gfx.screenheight - linesize - (Control.cursory * linesize), Control.boxsize * 12, linesize, 0);
				}
			} else {
				if (Control.cursory == notesonscreen - 1) {
					// draw partial cursor
					drawpartialbox(40
						+ (Control.cursorx * Control.boxsize), Gfx.screenheight
						- linesize
						- (Control.cursory * linesize),
						Control.boxsize * Control.notelength, linesize, 0, pianorollposition
						+ linesize);
				} else {
					drawbox(40 + (Control.cursorx * Control.boxsize), Gfx.screenheight - linesize - (Control.cursory * linesize),
						Control.boxsize * Control.notelength, linesize, 0);
					if (Control.notelength > Control.boxcount) {
						tempstring = Std.string(Control.notelength);
						print(40 + (Control.cursorx * Control.boxsize), Gfx.screenheight - linesize - (Control.cursory * linesize), tempstring, 0);
					}
				}
			}
		}
	}

	public static function drawlist():Void {
		if (Control.list.active) {
			// Draw list
			fillrect(Control.list.x - 2, Control.list.y - 2, Control.list.w + 4, Control.list.h + 4, 12);
			fillrect(Control.list.x, Control.list.y, Control.list.w, Control.list.h, 11);
			if (Control.list.type == Control.LIST_SELECTINSTRUMENT) {
				for (i in 0...Control.list.numitems) {
					fillrect(Control.list.x, Control.list.y + (i * linesize), Control.list.w, linesize, 101 + (Control.instrument[i].palette * 10));
				}
				if (Control.list.selection > -1) {
					fillrect(Control.list.x, Control.list.y + (Control.list.selection * linesize), Control.list.w, linesize,
						100 + (Control.instrument[Control.list.selection].palette * 10));
				}
			} else {
				for (i in 0...Control.list.numitems) {
					if (Help.Left(Control.list.item[i], 1) == ">" || Help.Left(Control.list.item[i], 1) == "<") {
						fillrect(Control.list.x, Control.list.y + (i * linesize), Control.list.w, linesize, 0);
					}
				}

				if (Control.list.type == Control.LIST_MIDIINSTRUMENT) {
					if (Control.midilistselection > -1) {
						fillrect(Control.list.x, Control.list.y + (Control.midilistselection * linesize), Control.list.w, linesize, 3);
					}
				}

				if (Control.list.selection > -1) {
					fillrect(Control.list.x, Control.list.y + (Control.list.selection * linesize), Control.list.w, linesize, 2);
				}
			}

			for (i in 0...Control.list.numitems) {
				if (Help.Left(Control.list.item[i], 1) == ">" || Help.Left(Control.list.item[i], 1) == "<") {
					print(Control.list.x + 2, Control.list.y + (i * linesize), Control.list.item[i], 14);
				} else {
					print(Control.list.x + 2, Control.list.y + (i * linesize), Control.list.item[i], 0);
				}
			}
		}

		if (Control.secondlist.active) {
			// Draw list
			fillrect(Control.secondlist.x - 2, Control.secondlist.y - 2, Control.secondlist.w + 4, Control.secondlist.h + 4, 12);
			fillrect(Control.secondlist.x, Control.secondlist.y, Control.secondlist.w, Control.secondlist.h, 11);
			for (i in 0...Control.secondlist.numitems) {
				if (Help.Left(Control.secondlist.item[i], 1) == ">" || Help.Left(Control.secondlist.item[i], 1) == "<") {
					fillrect(Control.secondlist.x, Control.secondlist.y + (i * linesize), Control.secondlist.w, linesize, 0);
				}
			}
			if (Control.secondlist.selection > -1) {
				fillrect(Control.secondlist.x, Control.secondlist.y + (Control.secondlist.selection * linesize), Control.secondlist.w, linesize, 2);
			}

			for (i in 0...Control.secondlist.numitems) {
				if (Help.Left(Control.secondlist.item[i], 1) == ">" || Help.Left(Control.secondlist.item[i], 1) == "<") {
					print(Control.secondlist.x + 2, Control.secondlist.y + (i * linesize), Control.secondlist.item[i], 14);
				} else {
					print(Control.secondlist.x + 2, Control.secondlist.y + (i * linesize), Control.secondlist.item[i], 0);
				}
			}
		}

		// Special trash button!
		if (Control.trashbutton > 0) {
			fillrect(screenwidth - 100 - 4, screenheight - (Control.trashbutton * 2) - 4, 108, (Control.trashbutton * 2) + 8, 12);
			fillrect(screenwidth - 100, screenheight - (Control.trashbutton * 2), 100, (Control.trashbutton * 2), 13);
			print(screenwidth - 100 + 4, screenheight - (Control.trashbutton * 2), "DELETE?", 0, false, true);
		}
	}

	public static function drawmusicbox(xp:Dynamic /*:Int*/, yp:Dynamic /*:Int*/, t:Dynamic /*:Int*/, enabled:Bool = true,
			forcezoom:Dynamic /*:Int*/ = -1):Void {
		// Draw a little music box containing our notes!
		if (xp < screenwidth) {
			temppal = Control.musicbox[t].palette;
			if (!enabled)
				temppal = 21;

			if (forcezoom == -1) {
				temppatternwidth = patternwidth;
				zoomoffset = zoom / 2;
			} else {
				temppatternwidth = 44 + (forcezoom * 16);
				zoomoffset = forcezoom / 2;
			}

			if (Control.doublesize)
				zoomoffset = zoomoffset / 2;

			fillrect(xp, yp, temppatternwidth, 24, 100 + (temppal * 10));
			fillrect(xp + 44, yp + 2, temppatternwidth - 46, 20, 101 + (temppal * 10));
			for (mbj in 0...Control.musicbox[t].numnotes) {
				mbi = Control.musicbox[t].notes[mbj].width;
				Control.drawnoteposition = Control.musicbox[t].notes[mbj].x;
				Control.drawnotelength = Math.ceil(Control.musicbox[t].notes[mbj].y * zoomoffset);
				if (mbi + Control.musicbox[t].notes[mbj].y > Control.boxcount) {
					// temppatternwidth for each bar
					Control.drawnotelength = (temppatternwidth / 2) - (21 + Std.int(mbi * zoomoffset));
					Control.drawnotelength += ((temppatternwidth / 2) * (Control.musicbox[t].notes[mbj].y - (Control.boxcount - mbi)) / Control.boxcount);
				}
				if (Control.drawnoteposition > -1) {
					Control.drawnoteposition -= Control.musicbox[t].bottomnote;
					if (Control.musicbox[t].notespan > 10) {
						Control.drawnoteposition = ((Control.drawnoteposition * 8) / Control.musicbox[t].notespan) + 2;
					} else {
						Control.drawnoteposition++;
						if (Control.musicbox[t].notespan < 6) {
							Control.drawnoteposition += 6 - Control.musicbox[t].notespan;
						}
					}
					if (Control.drawnoteposition >= 1 && Control.drawnoteposition < 11) {
						fillrect(xp
							+ 42
							+ Std.int((mbi * 2) * zoomoffset), yp
							+ 22
							- (Control.drawnoteposition * 2), Control.drawnotelength * 2, 2,
							105
							+ (temppal * 10));
					}
				}
			}

			fillrect(xp, yp, 40, 24, 101 + (temppal * 10));
			fillrect(xp, yp, 40, 16, 100 + (temppal * 10));

			fillrect(xp + 42, yp, 2, 24, 100 + (temppal * 10));
			fillrect(xp + temppatternwidth - 2, yp, 2, 24, 100 + (temppal * 10));

			if (Control.currentbox == t) {
				drawbox(xp, yp, temppatternwidth, patternheight, 9);
				drawbox(xp + 2, yp + 2, temppatternwidth - 4, patternheight - 4, 12);
			}

			if (t + 1 < 10) {
				print(xp + 10, yp + 2, Std.string(t + 1), 2, false, true);
			} else {
				print(xp + 4, yp + 2, Std.string(t + 1), 2, false, true);
			}
		}
	}

	public static function drawarrangementeditor():Void {
		for (i in 0...8) {
			if (Control.arrange.channelon[i]) {
				if (i % 2 == 0) {
					fillrect(0, linesize + (i * patternheight), screenwidth, patternheight, 4);
				} else {
					fillrect(0, linesize + (i * patternheight), screenwidth, patternheight, 5);
				}
			} else {
				fillrect(0, linesize + (i * patternheight), screenwidth, patternheight, 14);
			}
		}

		// Draw bars
		temp = Std.int(screenwidth / patternwidth);
		for (i in 0...temp) {
			fillrect((i * patternwidth), linesize, 2, pianorollposition + 10 - linesize, 6);
		}

		// Draw patterns
		var k:Int = temp;
		while (k >= 0) {
			for (j in 0...8) {
				if (k + Control.arrange.viewstart > -1) {
					if (Control.arrange.bar[k + Control.arrange.viewstart].channel[j] > -1) {
						drawmusicbox(k * patternwidth, linesize + (j * patternheight), Control.arrange.bar[k + Control.arrange.viewstart].channel[j],
							Control.arrange.channelon[j]);
					}
				}
			}
			k--;
		}
	}

	public static function drawarrangementcursor():Void {
		// Position bar
		i = ((Control.looptime * patternwidth) / Control.boxcount) + ((Control.arrange.currentbar - Control.arrange.viewstart) * patternwidth);
		if (i < patternmanagerx) {
			fillrect(i, linesize, 4, pianorollposition, 10);
			fillrect(i + 4, linesize, 4, pianorollposition, 11);
		}

		if (Control.mx < 20 && Control.my > linesize && Control.my < linesize + pianorollposition && Control.arrange.viewstart > 0) {
			if (arrangementscrollleft < 20) {
				arrangementscrollleft += 4;
				if (arrangementscrollleft >= 20)
					arrangementscrollleft = 20;
			}

			fillrect(-20 + arrangementscrollleft, linesize, 20, pianorollposition, 12);
			fillrect(-20 + 2 + arrangementscrollleft, linesize + 2, 16, pianorollposition - 4, 5);
			drawicon(-20 + 4 + arrangementscrollleft, linesize + (pianorollposition / 2) - 12, 12);
		} else if (Control.mx > patternmanagerx - 20
			&& Control.mx < patternmanagerx
			&& Control.my > linesize
			&& Control.my < linesize + pianorollposition) {
			if (arrangementscrollright < 20) {
				arrangementscrollright += 4;
				if (arrangementscrollright >= 20)
					arrangementscrollright = 20;
			}

			fillrect(patternmanagerx - arrangementscrollright, linesize, 20, pianorollposition, 12);
			fillrect(patternmanagerx - arrangementscrollright + 2, linesize + 2, 16, pianorollposition - 4, 5);
			drawicon(patternmanagerx - arrangementscrollright + 5, linesize + (pianorollposition / 2) - 12, 13);
		} else {
			// Draw the cursor
			if (Control.arrangecurx > -1 && Control.arrangecury > -1) {
				if (Control.arrangecurx == 0 && Control.arrange.viewstart == -1) {
					drawbox(0, linesize, patternwidth, pianorollposition - 12, 0);
				} else {
					drawbox(Control.arrangecurx * patternwidth, linesize + (Control.arrangecury * patternheight), patternwidth, patternheight, 0);
				}
			}

			if (arrangementscrollleft > 0) {
				arrangementscrollleft -= 4;
				if (arrangementscrollleft <= 0)
					arrangementscrollleft = 0;

				fillrect(-20 + arrangementscrollleft, linesize, 20, pianorollposition, 12);
				fillrect(-20 + 2 + arrangementscrollleft, linesize + 2, 16, pianorollposition - 4, 5);
				drawicon(-20 + 4 + arrangementscrollleft, linesize + (pianorollposition / 2) - 12, 12);
			}
			if (arrangementscrollright > 0) {
				arrangementscrollright -= 4;
				if (arrangementscrollright <= 0)
					arrangementscrollright = 0;

				fillrect(patternmanagerx - arrangementscrollright, linesize, 20, pianorollposition, 12);
				fillrect(patternmanagerx - arrangementscrollright + 2, linesize + 2, 16, pianorollposition - 4, 5);
				drawicon(patternmanagerx - arrangementscrollright + 5, linesize + (pianorollposition / 2) - 12, 13);
				drawpatternmanager();
			}
		}
	}

	public static function drawtimeline():Void {
		// From here: TIMELINE
		fillrect(0, pianorollposition + 8, screenwidth, 12, 6);

		temp = Std.int(screenwidth / patternwidth);
		for (i in 0...temp) {
			fillrect((i * patternwidth), pianorollposition + 8, 2, 12, 14);
		}

		if (Control.dragaction == 3) {
			for (i in 0...temp) {
				if (i + Control.arrange.viewstart == Control.dragx
					|| (i + Control.arrange.viewstart >= Control.dragx
						&& i + Control.arrange.viewstart < Control.timelinecurx + Control.arrange.viewstart + 1)
					|| (i + Control.arrange.viewstart < Control.dragx
						&& i + Control.arrange.viewstart >= Control.timelinecurx + Control.arrange.viewstart + 1)) {
					fillrect((i * patternwidth), pianorollposition + 8, patternwidth, 12, 0);
				}
			}
		}

		for (i in 0...temp) {
			if (i + Control.arrange.viewstart >= Control.arrange.loopstart && i + Control.arrange.viewstart < Control.arrange.loopend) {
				if (i + Control.arrange.viewstart == Control.arrange.loopstart) {
					fillrect((i * patternwidth), pianorollposition + 10, 4, 8, 2);
				}
				if (i + Control.arrange.viewstart == Control.arrange.loopend - 1) {
					fillrect(((i + 1) * patternwidth) - 4, pianorollposition + 10, 4, 8, 2);
				}
				fillrect((i * patternwidth), pianorollposition + 12, patternwidth, 4, 2);
			}
			//	if (Control.arrange.bar[i+Control.arrange.viewstart].channel[j] > -1) {
			//	drawmusicbox(Control, i * patternwidth, linesize + (j * patternheight), Control.arrange.bar[i+Control.arrange.viewstart].channel[j]);
			//	}
		}

		if (Control.arrange.viewstart == -1) {
			fillrect(0, pianorollposition + 8, patternwidth, 12, 16);
		}
	}

	public static function drawtimeline_cursor():Void {
		// Draw the cursor
		if (Control.timelinecurx > -1) {
			if (Control.arrange.viewstart == -1 && Control.timelinecurx == 0) {
				drawbox(0, linesize, patternwidth, pianorollposition - 12, 0);
			} else {
				drawbox(Control.timelinecurx * patternwidth, pianorollposition + 8, patternwidth, 12, 0);
				print(Control.timelinecurx * patternwidth, pianorollposition + 8 - linesize, Std.string(Control.arrange.viewstart + Control.timelinecurx + 1),
					0, false, true);
			}
		}
	}

	public static function drawpatternmanager():Void {
		// From here, PATTERN Manager
		fillrect(patternmanagerx, linesize, screenwidth - patternmanagerx, pianorollposition, 2);

		// List
		for (k in 0...7) {
			if (k == 0 && Control.patternmanagerview > 0 && Control.numboxes > 0) {
				// Draw scrollup
				drawicon(patternmanagerx + 50, linesize + 4 + (k * patternheight), 1);
			} else if (k == 6 && k + Control.patternmanagerview < Control.numboxes) {
				// Draw scrolldown
				drawicon(patternmanagerx + 50, linesize + 2 + (k * patternheight), 0);
			} else {
				// Normal
				if (Control.patternmanagerview + k < Control.numboxes) {
					drawmusicbox(patternmanagerx + 3, linesize + 2 + (k * patternheight), Control.patternmanagerview + k, true, 4);
				}
			}
		}
	}

	public static function drawpatternmanager_cursor():Void {
		// Draw the cursor
		if (Control.patterncury > -1) {
			drawbox(patternmanagerx + 3, linesize + 2 + (Control.patterncury * patternheight), 108, patternheight, 0);
		}
	}

	public static function drawinstrumentlist():Void {
		fillrect(0, linesize, 280, pianorollposition, 2);

		// List
		for (k in 0...7) {
			if (k == 0 && Control.instrumentmanagerview > 0 && Control.numinstrument > 0) {
				// Draw scrollup
				drawicon(132, linesize + 8 + (k * patternheight), 1);
			} else if (k == 6 && k + Control.instrumentmanagerview < Control.numinstrument) {
				// Draw scrolldown
				drawicon(132, linesize + 4 + (k * patternheight), 0);
			} else {
				// Normal
				if (Control.instrumentmanagerview + k < Control.numinstrument) {
					fillrect(4, linesize
						+ 4
						+ (k * patternheight), 272, 24, 100
						+ (Control.instrument[Control.instrumentmanagerview + k].palette * 10));
					fillrect(4
						+ 50, linesize
						+ 4
						+ (k * patternheight), 272
						- 50, 24,
						101
						+ (Control.instrument[Control.instrumentmanagerview + k].palette * 10));
					print(12, linesize + 6 + (k * patternheight), Std.string(Control.instrumentmanagerview + k + 1), 0, false, true);
					print(56, linesize + 6 + (k * patternheight), Control.instrument[Control.instrumentmanagerview + k].name, 0, false, true);
				}
			}
		}
		// Draw the cursor
		if (Control.instrumentcury > -1) {
			drawbox(4, linesize + 4 + (Control.instrumentcury * patternheight), 272, patternheight, 0);
		}
	}

	public static function drawinstrument():Void {
		fillrect(280, linesize, screenwidth - 280, pianorollposition, 101 + (Control.instrument[Control.currentinstrument].palette * 10));
		print(290, linesize + 6, "INSTRUMENT " + Std.string(Control.currentinstrument + 1), 0, false, true);

		fillrect(286, (linesize * 2) + 6, 160, linesize, 100 + (Control.instrument[Control.currentinstrument].palette * 10));
		drawicon(290, (linesize * 2) + 4, 0);
		print(320, (linesize * 2) + 6, Control.instrument[Control.currentinstrument].category, 0, false, true);

		fillrect(286 + 180, (linesize * 2) + 6, 280, linesize, 100 + (Control.instrument[Control.currentinstrument].palette * 10));
		drawicon(290 + 180, (linesize * 2) + 4, 0);
		print(320 + 180, (linesize * 2) + 6, Control.instrument[Control.currentinstrument].name, 0, false, true);

		// Filter pad and volume bar
		i = 0;
		if (Control.currentbox > -1) {
			if (Control.musicbox[Control.currentbox].recordfilter == 1) {
				if (Control.musicbox[Control.currentbox].instr == Control.currentinstrument) {
					i = 1;
				}
			}
		}
		if (i == 1) {
			fillrect(286, (linesize * 4), screenwidth - 348, 110, 8);
			fillrect(screenwidth - 42, (linesize * 4), 20, 110, 8);

			for (i in 0...110) {
				if (i % 4 == 0) {
					fillrect(286, (linesize * 4) + i, screenwidth - 348, 2, 12);
					fillrect(screenwidth - 42, (linesize * 4) + i, 20, 2, 12);
				}
			}

			print(286
				+ ((screenwidth - 348) / 2)
				- (len("! RECORDING FOR PATTERN " + Std.string(Control.currentbox + 1) + "!") / 2), (linesize * 4)
				+ 114,
				"! RECORDING FOR PATTERN "
				+ Std.string(Control.currentbox + 1)
				+ "!", 15, false, true);

			// Move over recording
			j = Std.int(((256 - Control.musicbox[Control.currentbox].volumegraph[cast Control.looptime % Control.boxcount]) * 90) / 256);
			fillrect(screenwidth - 42, (linesize * 4) + j, 20, 20, 101 + (Control.instrument[Control.currentinstrument].palette * 10));
			fillrect(screenwidth - 42 + 2, (linesize * 4) + j + 2, 16, 16, 100 + (Control.instrument[Control.currentinstrument].palette * 10));

			i = Std.int((Control.musicbox[Control.currentbox].cutoffgraph[cast Control.looptime % Control.boxcount] * (screenwidth - 368)) / 128);
			j = Std.int((Control.musicbox[Control.currentbox].resonancegraph[cast Control.looptime % Control.boxcount] * 90) / 9);
			fillrect(286 + i, (linesize * 4) + j, 20, 20, 101 + (Control.instrument[Control.currentinstrument].palette * 10));
			fillrect(286 + i + 2, (linesize * 4) + j + 2, 16, 16, 100 + (Control.instrument[Control.currentinstrument].palette * 10));
		} else {
			fillrect(286, (linesize * 4), screenwidth - 348, 110, 102 + (Control.instrument[Control.currentinstrument].palette * 10));
			fillrect(screenwidth - 42, (linesize * 4), 20, 110, 102 + (Control.instrument[Control.currentinstrument].palette * 10));

			for (i in 0...110) {
				if (i % 4 == 0) {
					fillrect(286, (linesize * 4) + i, screenwidth - 348, 2, 103 + (Control.instrument[Control.currentinstrument].palette * 10));
					fillrect(screenwidth - 42, (linesize * 4) + i, 20, 2, 103 + (Control.instrument[Control.currentinstrument].palette * 10));
				}
			}

			print(286
				+ ((screenwidth - 348) / 2)
				- (len("LOW PASS FILTER PAD") / 2), (linesize * 4)
				+ 114, "LOW PASS FILTER PAD",
				103
				+ (Control.instrument[Control.currentinstrument].palette * 10));
			print(screenwidth - 52, (linesize * 4) + 114, "VOL", 103 + (Control.instrument[Control.currentinstrument].palette * 10));

			// Default values
			j = 0;
			fillrect(screenwidth - 42, (linesize * 4) + j, 20, 20, 6);
			fillrect(screenwidth - 42 + 2, (linesize * 4) + j + 2, 16, 16, 5);

			i = screenwidth - 368;
			j = 0;
			fillrect(286 + i, (linesize * 4) + j, 20, 20, 6);
			fillrect(286 + i + 2, (linesize * 4) + j + 2, 16, 16, 5);

			// Switches for volume/filter
			j = Std.int((256 - Control.instrument[Control.currentinstrument].volume) * 90 / 256);
			fillrect(screenwidth - 42, (linesize * 4) + j, 20, 20, 101 + (Control.instrument[Control.currentinstrument].palette * 10));
			fillrect(screenwidth - 42 + 2, (linesize * 4) + j + 2, 16, 16, 100 + (Control.instrument[Control.currentinstrument].palette * 10));

			i = Std.int(Control.instrument[Control.currentinstrument].cutoff * (screenwidth - 368) / 128);
			j = Std.int(Control.instrument[Control.currentinstrument].resonance * 90 / 9);
			fillrect(286 + i, (linesize * 4) + j, 20, 20, 101 + (Control.instrument[Control.currentinstrument].palette * 10));
			fillrect(286 + i + 2, (linesize * 4) + j + 2, 16, 16, 100 + (Control.instrument[Control.currentinstrument].palette * 10));
		}
	}

	public static function initGfx():Void {
		// We initialise a few things
		linesize = 20;
		linespacing = 20;
		buttonheight = 26;
		patternheight = 24;
		setzoomlevel(4);
		pianorollposition = linesize * 10;

		fontsize.push(0);
		fontsize.push(0);
		fontsize.push(0);
		fontsize.push(0);
		fontsize.push(0);
		fontsize.push(0);
		fontsize.push(0);
		fontsize.push(0);

		fontsize[0] = 16;
		fontsize[1] = 32;
		fontsize[2] = 48;
		fontsize[3] = 64;
		fontsize[4] = 96;

		icons_rect = new Rectangle(0, 0, 32, 32);
		trect = new Rectangle();
		tpoInt = new Point();
		tbuffer = new BitmapData(1, 1, true);
		ct = new ColorTransform(0, 0, 0, 1, 255, 255, 255, 1); // Set to white
		tempicon = new BitmapData(32, 32, false, 0x000000);

		backbuffer = new BitmapData(1, 1, false, 0x000000);
		backbuffercache = new BitmapData(1, 1, false, 0x000000);

		for (i in 0...400) {
			pal.push(new Paletteclass());
		}

		buttonpress = 0;

		screen = new Bitmap(backbuffer);
		screen.x = 0;
		screen.y = 0;
	}

	public static function setzoomlevel(t:Dynamic /*:Int*/):Void {
		zoom = t;
		patternwidth = 44 + (zoom * 16);
	}

	#if (CONFIG == "desktop")
	public static function changewindowsize(w:Dynamic /*:Int*/, h:Dynamic /*:Int*/):Void {
		// if (w < 768) w = 768;
		// if (h < 480) h = 480;
		/*windowboundsx = mStage.nativeWindow.bounds.width - mStage.stageWidth; TODO:FIXME: add -Sam!
			windowboundsy = mStage.nativeWindow.bounds.height - mStage.stageHeight; */
		windowwidth = w;
		windowheight = h;
		if (Control.fullscreen) {} else {
			/*if (mStage && mStage.nativeWindow) { TODO:FIXME: add -Sam!
				mStage.nativeWindow.width = w + windowboundsx;
				mStage.nativeWindow.height = h + windowboundsy;
			}*/
		}

		if (Gfx.scalemode == 1) {
			screenwidth = w / 1.5;
			screenheight = h / 1.5;
		} else {
			screenwidth = w;
			screenheight = h;
		}

		screenwidthmid = screenwidth / 2;
		screenheightmid = screenheight / 2;
		screenviewwidth = screenwidth;
		screenviewheight = screenheight;
	}
	#end

	#if (CONFIG == "web")
	{
		public static function changewindowsize(w:Dynamic /*:Int*/, h:Dynamic /*:Int*/):Void {
			windowwidth = w;
			windowheight = h;

			if (Gfx.scalemode == 1) {
				screenwidth = w / 1.5;
				screenheight = h / 1.5;
			} else {
				screenwidth = w;
				screenheight = h;
			}

			screenwidthmid = screenwidth / 2;
			screenheightmid = screenheight / 2;
			screenviewwidth = screenwidth;
			screenviewheight = screenheight;
		}
	}
	#end
	public static function settrect(x:Dynamic /*:Int*/, y:Dynamic /*:Int*/, w:Dynamic /*:Int*/, h:Dynamic /*:Int*/):Void {
		trect.x = x;
		trect.y = y;
		trect.width = w;
		trect.height = h;
	}

	public static function settpoint(x:Dynamic /*:Int*/, y:Dynamic /*:Int*/):Void {
		tpoInt.x = x;
		tpoInt.y = y;
	}

	public static function addimage():Void {
		var t:BitmapData = new BitmapData(buffer.width, buffer.height, true, 0x000000);
		t.copyPixels(buffer, new Rectangle(0, 0, buffer.width, buffer.height), tl);
		images.push(t);
	}

	public static function drawimage(t:Dynamic /*:Int*/, xp:Dynamic /*:Int*/, yp:Dynamic /*:Int*/):Void {
		settpoint(xp, yp);
		settrect(0, 0, images[t].width, images[t].height);
		backbuffer.copyPixels(images[t], trect, tpoInt);
	}

	public static function makeiconarray():Void {
		for (i in 0...20) {
			var t:BitmapData = new BitmapData(32, 32, true, 0x000000);
			var temprect:Rectangle = new Rectangle(i * 32, 0, 32, 32);
			t.copyPixels(buffer, temprect, tl);
			icons.push(t);
		}
	}

	// Draw Primatives
	public static function drawline(x1:Dynamic /*:Int*/, y1:Dynamic /*:Int*/, x2:Dynamic /*:Int*/, y2:Dynamic /*:Int*/, col:Dynamic /*:Int*/):Void {
		if (x1 > x2) {
			drawline(x2, y1, x1, y2, col);
		} else if (y1 > y2) {
			drawline(x1, y2, x2, y1, col);
		} else {
			tempshape.graphics.clear();
			tempshape.graphics.lineStyle(1, RGB(pal[col].r, pal[col].g, pal[col].b));
			tempshape.graphics.lineTo(x2 - x1, y2 - y1);

			shapematrix.translate(x1, y1);
			backbuffer.draw(tempshape, shapematrix);
			shapematrix.translate(-x1, -y1);
		}
	}

	public static function drawpartialbox(x1:Dynamic /*:Int*/, y1:Dynamic /*:Int*/, w1:Dynamic /*:Int*/, h1:Dynamic /*:Int*/, col:Dynamic /*:Int*/,
			cutoff:Dynamic /*:Int*/):Void {
		if (y1 > cutoff) {
			settrect(x1, y1, w1, 2);
			backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
		}
		if (y1 + h1 - 2 > cutoff) {
			settrect(x1, y1 + h1 - 2, w1, 2);
			backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
		}
		if (y1 > cutoff) {
			settrect(x1, y1, 2, h1);
			backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
		} else {
			settrect(x1, cutoff, 2, h1 - (cutoff - y1));
			backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
		}
		if (y1 > cutoff) {
			settrect(x1 + w1 - 2, y1, 2, h1);
			backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
		} else {
			settrect(x1 + w1 - 2, cutoff, 2, h1 - (cutoff - y1));
			backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
		}
	}

	public static function drawbox(x1:Dynamic /*:Int*/, y1:Dynamic /*:Int*/, w1:Dynamic /*:Int*/, h1:Dynamic /*:Int*/, col:Dynamic /*:Int*/):Void {
		settrect(x1, y1, w1, 2);
		backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
		settrect(x1, y1 + h1 - 2, w1, 2);
		backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
		settrect(x1, y1, 2, h1);
		backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
		settrect(x1 + w1 - 2, y1, 2, h1);
		backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
	}

	public static function cls():Void {
		fillrect(0, 0, 384, 240, 1);
	}

	public static function fillrect(x1:Dynamic /*:Int*/, y1:Dynamic /*:Int*/, w1:Dynamic /*:Int*/, h1:Dynamic /*:Int*/, t:Dynamic /*:Int*/):Void {
		settrect(x1, y1, w1, h1);
		backbuffer.fillRect(trect, RGB(pal[t].r, pal[t].g, pal[t].b));
	}

	public static function drawbuffericon(x:Dynamic /*:Int*/, y:Dynamic /*:Int*/, t:Dynamic /*:Int*/):Void {
		settpoint(x, y);
		buffer.copyPixels(icons[t], icons_rect, tpoInt);
	}

	public static function drawicon(x:Dynamic /*:Int*/, y:Dynamic /*:Int*/, t:Dynamic /*:Int*/):Void {
		settpoint(x, y);
		backbuffer.copyPixels(icons[t], icons_rect, tpoInt);
	}

	// Text Functions
	public static function initfont(font:Font):Void {
		tf_1.embedFonts = true;
		tf_1.defaultTextFormat = new TextFormat(font.fontName, fontsize[0], 0, true);
		tf_1.width = screenwidth;
		tf_1.height = 200;
		tf_1.antiAliasType = AntiAliasType.NORMAL;

		tf_2.embedFonts = true;
		tf_2.defaultTextFormat = new TextFormat(font.fontName, fontsize[1], 0, true);
		tf_2.width = screenwidth;
		tf_2.height = 100;
		tf_2.antiAliasType = AntiAliasType.NORMAL;

		tf_3.embedFonts = true;
		tf_3.defaultTextFormat = new TextFormat(font.fontName, fontsize[2], 0, true);
		tf_3.width = screenwidth;
		tf_3.height = 100;
		tf_3.antiAliasType = AntiAliasType.NORMAL;

		tf_4.embedFonts = true;
		tf_4.defaultTextFormat = new TextFormat(font.fontName, fontsize[3], 0, true);
		tf_4.width = screenwidth;
		tf_4.height = 100;
		tf_4.antiAliasType = AntiAliasType.NORMAL;

		tf_5.embedFonts = true;
		tf_5.defaultTextFormat = new TextFormat(font.fontName, fontsize[4], 0, true);
		tf_5.width = screenwidth;
		tf_5.height = 100;
		tf_5.antiAliasType = AntiAliasType.NORMAL;
	}

	public static function rprint(x:Dynamic /*:Int*/, y:Dynamic /*:Int*/, t:String, col:Dynamic /*:Int*/, shadow:Bool = false):Void {
		x = x - len(t);
		print(x, y, t, col, false, shadow);
	}

	public static var cachedtextindex:Dictionary<String, Null<Int>> = new Dictionary();
	public static var cachedtext:Array<BitmapData> = new Array<BitmapData>();
	public static var cachedrect:Array<Rectangle> = new Array<Rectangle>();
	public static var cacheindex:Dynamic /*:Int*/;
	public static var cachelabel:String;

	public static function print(x:Dynamic /*:Int*/, y:Dynamic /*:Int*/, t:String, col:Dynamic /*:Int*/, cen:Bool = false, shadow:Bool = false):Void {
		if (shadow) {
			cachelabel = t + "_" + Std.string(col) + "_shadow";
		} else {
			cachelabel = t + "_" + Std.string(col) + "_noshadow";
		}
		if (cachedtextindex[cachelabel] == null) {
			// Cache the text
			cacheindex = cachedtext.length;
			cachedtextindex[cachelabel] = cacheindex;
			cachedtext.push(new BitmapData(len(t), 22, true, 0));
			cachedrect.push(new Rectangle(0, 0, len(t), 22));

			printoncache(0, 0, t, col, false, shadow);
		}

		cacheindex = cachedtextindex[cachelabel];
		settpoint(x, y);
		backbuffer.copyPixels(cachedtext[cacheindex], cachedrect[cacheindex], tpoInt);
	}

	public static function printoncache(x:Dynamic /*:Int*/, y:Dynamic /*:Int*/, t:String, col:Dynamic /*:Int*/, cen:Bool = false, shadow:Bool = false):Void {
		y -= 3;

		tf_1.textColor = RGB(pal[col].r, pal[col].g, pal[col].b);
		tf_1.text = t;
		if (cen)
			x = screenwidthmid - (tf_1.textWidth / 2) + x;

		if (shadow) {
			shapematrix.translate(x + 1, y + 1);
			tf_1.textColor = RGB(0, 0, 0);
			cachedtext[cacheindex].draw(tf_1, shapematrix);

			shapematrix.translate(-x - 1, -y - 1);
		}

		shapematrix.translate(x, y);
		tf_1.textColor = RGB(pal[col].r, pal[col].g, pal[col].b);
		cachedtext[cacheindex].draw(tf_1, shapematrix);

		shapematrix.translate(-x, -y);
	}

	public static function normalprint(x:Dynamic /*:Int*/, y:Dynamic /*:Int*/, t:String, col:Dynamic /*:Int*/, cen:Bool = false, shadow:Bool = false):Void {
		y -= 3;

		tf_1.textColor = RGB(pal[col].r, pal[col].g, pal[col].b);
		tf_1.text = t;
		if (cen)
			x = screenwidthmid - (tf_1.textWidth / 2) + x;

		if (shadow) {
			shapematrix.translate(x + 1, y + 1);
			tf_1.textColor = RGB(0, 0, 0);
			backbuffer.draw(tf_1, shapematrix);

			shapematrix.translate(-x - 1, -y - 1);
		}

		shapematrix.translate(x, y);
		tf_1.textColor = RGB(pal[col].r, pal[col].g, pal[col].b);
		backbuffer.draw(tf_1, shapematrix);

		shapematrix.translate(-x, -y);
	}

	public static function len(t:String, sz:Dynamic /*:Int*/ = 1):Dynamic /*:Int*/ {
		if (sz == 1) {
			tf_1.text = t;
			return tf_1.textWidth;
		} else if (sz == 2) {
			tf_2.text = t;
			return tf_2.textWidth;
		} else if (sz == 3) {
			tf_3.text = t;
			return tf_3.textWidth;
		} else if (sz == 4) {
			tf_4.text = t;
			return tf_4.textWidth;
		} else if (sz == 5) {
			tf_5.text = t;
			return tf_5.textWidth;
		}

		tf_1.text = t;
		return tf_1.textWidth;
	}

	public static function hig(t:String, sz:Dynamic /*:Int*/ = 1):Dynamic /*:Int*/ {
		if (sz == 1) {
			tf_1.text = t;
			return tf_1.textHeight;
		} else if (sz == 2) {
			tf_2.text = t;
			return tf_2.textHeight;
		} else if (sz == 3) {
			tf_3.text = t;
			return tf_3.textHeight;
		} else if (sz == 4) {
			tf_4.text = t;
			return tf_4.textHeight;
		} else if (sz == 5) {
			tf_5.text = t;
			return tf_5.textHeight;
		}

		tf_1.text = t;
		return tf_1.textHeight;
	}

	public static function rbigprint(x:Dynamic /*:Int*/, y:Dynamic /*:Int*/, t:String, r:Dynamic /*:Int*/, g:Dynamic /*:Int*/, b:Dynamic /*:Int*/,
			cen:Bool = false, sc:Dynamic /*:Float*/ = 2):Void {
		x = x - len(t, sc);
		bigprint(x, y, t, r, g, b, cen, sc);
	}

	public static function bigprint(x:Dynamic /*:Int*/, y:Dynamic /*:Int*/, t:String, r:Dynamic /*:Int*/, g:Dynamic /*:Int*/, b:Dynamic /*:Int*/,
			cen:Bool = false, sc:Dynamic /*:Float*/ = 2):Void {
		if (r < 0)
			r = 0;
		if (g < 0)
			g = 0;
		if (b < 0)
			b = 0;
		if (r > 255)
			r = 255;
		if (g > 255)
			g = 255;
		if (b > 255)
			b = 255;

		y -= 3;

		if (sc == 2) {
			tf_2.text = t;
			if (cen)
				x = screenwidthmid - (tf_2.textWidth / 2);

			shapematrix.translate(x, y);
			tf_2.textColor = RGB(r, g, b);
			backbuffer.draw(tf_2, shapematrix);

			shapematrix.translate(-x, -y);
		} else if (sc == 3) {
			tf_3.text = t;
			if (cen)
				x = screenwidthmid - (tf_3.textWidth / 2);

			shapematrix.translate(x, y);
			tf_3.textColor = RGB(r, g, b);
			backbuffer.draw(tf_3, shapematrix);

			shapematrix.translate(-x, -y);
		} else if (sc == 4) {
			tf_4.text = t;
			if (cen)
				x = screenwidthmid - (tf_4.textWidth / 2);

			shapematrix.translate(x, y);
			tf_4.textColor = RGB(r, g, b);
			backbuffer.draw(tf_4, shapematrix);

			shapematrix.translate(-x, -y);
		} else if (sc == 5) {
			tf_5.textColor = RGB(r, g, b);
			tf_5.text = t;
			if (cen)
				x = screenwidthmid - (tf_5.textWidth / 2);

			shapematrix.translate(x, y);
			backbuffer.draw(tf_5, shapematrix);
			shapematrix.translate(-x, -y);
		}
	}

	public static function RGB(red:Dynamic /*:Float*/, green:Dynamic /*:Float*/, blue:Dynamic /*:Float*/):Dynamic /*:Float*/ {
		return (blue | (green << 8) | (red << 16));
	}

	// Render functions
	public static function normalrender():Void {
		backbuffer.unlock();
		backbuffer.lock();
	}

	public static function render():Void {
		// if (Control.test) {
		settrect(0, 0, screenwidth, 10);
		backbuffer.fillRect(trect, 0x000000);
		print(5, 0, "TEST = True", 2, false);
		// print(5, 0, Control.teststring, 2, false);
		// }

		normalrender();
	}

	public static var icons:Array<BitmapData> = new Array<BitmapData>();
	public static var ct:ColorTransform;
	public static var icons_rect:Rectangle;
	public static var tl:Point = new Point(0, 0);
	public static var images:Array<BitmapData> = new Array<BitmapData>();
	public static var trect:Rectangle;
	public static var tpoInt:Point;
	public static var tbuffer:BitmapData;
	public static var i:Dynamic /*:Int*/;
	public static var j:Dynamic /*:Int*/;
	public static var k:Dynamic /*:Int*/;
	public static var l:Dynamic /*:Int*/;
	public static var mbi:Dynamic /*:Int*/;
	public static var mbj:Dynamic /*:Int*/;
	public static var tempstring:String;

	public static var screenwidth:Dynamic /*:Int*/;
	public static var screenheight:Dynamic /*:Int*/;
	public static var screenwidthmid:Dynamic /*:Int*/;
	public static var screenheightmid:Dynamic /*:Int*/;
	public static var screenviewwidth:Dynamic /*:Int*/;
	public static var screenviewheight:Dynamic /*:Int*/;
	public static var linesize:Dynamic /*:Int*/;
	public static var patternheight:Dynamic /*:Int*/;
	public static var patternwidth:Dynamic /*:Int*/;
	public static var temppatternwidth:Dynamic /*:Int*/;
	public static var patternmanagerx:Dynamic /*:Int*/;
	public static var linespacing:Dynamic /*:Int*/;
	public static var patterneditorheight:Dynamic /*:Int*/;
	public static var buttonheight:Dynamic /*:Int*/;
	public static var pianorollposition:Dynamic /*:Int*/;
	public static var notesonscreen:Dynamic /*:Int*/;

	public static var temp:Dynamic /*:Int*/;
	public static var temp2:Dynamic /*:Int*/;
	public static var temp3:Dynamic /*:Int*/;
	public static var alphamult:UInt;
	public static var stemp:String;
	public static var buffer:BitmapData;
	public static var temppal:Dynamic /*:Int*/;

	public static var zoom:Dynamic /*:Int*/;
	public static var zoomoffset:Dynamic /*:Float*/;

	public static var tempicon:BitmapData;
	// Actual backgrounds
	public static var drawto:BitmapData;
	public static var backbuffer:BitmapData;
	public static var backbuffercache:BitmapData;
	public static var updatebackground:Dynamic /*:Int*/;
	public static var screenbuffer:BitmapData;
	public static var screen:Bitmap;
	// Tempshape
	public static var tempshape:Shape = new Shape();
	public static var shapematrix:Matrix = new Matrix();

	public static var tf_1:TextField = new TextField();
	public static var tf_2:TextField = new TextField();
	public static var tf_3:TextField = new TextField();
	public static var tf_4:TextField = new TextField();
	public static var tf_5:TextField = new TextField();
	public static var fontsize:Array<Int> = new Array<Int>();
	public static var pal:Array<Paletteclass> = new Array<Paletteclass>();
	public static var buttonpress:Dynamic /*:Int*/;

	public static var mStage:Stage;

	public static var windowwidth:Dynamic /*:Int*/;
	public static var windowheight:Dynamic /*:Int*/;
	public static var min_windowwidth:Dynamic /*:Int*/;
	public static var min_windowheight:Dynamic /*:Int*/;
	public static var windowboundsx:Dynamic /*:Int*/;
	public static var windowboundsy:Dynamic /*:Int*/;
	public static var scalemode:Dynamic /*:Int*/;

	public static var boscaframerate:Dynamic /*:Int*/ = -1;

	public static var arrangementscrollleft:Dynamic /*:Int*/ = 0;
	public static var arrangementscrollright:Dynamic /*:Int*/ = 0;
}
