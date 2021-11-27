package includes;

import bigroom.input.KeyPoll;

class Render {
	public static function render(key:KeyPoll):Void {
		var i:Dynamic /*:Int*/;
		var j:Dynamic /*:Int*/;
		var k:Dynamic /*:Int*/;

		if (cast Gfx.updatebackground > 0) {
			Gfx.changeframerate(30);
			// Background
			Gfx.fillrect(0, 0, Gfx.screenwidth, Gfx.screenheight, 1);

			// Tabs
			#if (CONFIG == "desktop")
			{
				j = Std.int((Gfx.screenwidth - 40) / 4);
			}
			#end
			#if (CONFIG == "web")
			{
				j = (Gfx.screenwidth) / 4;
			}
			#end
			if (Control.currenttab == Control.MENUTAB_HELP) {
				Gfx.fillrect(0, 0, j, Gfx.linesize, 5);
				Gfx.print(14, 0, "HELP", Control.currenttab == Control.MENUTAB_HELP ? 0 : 2, false, true);
			} else if (Control.currenttab == Control.MENUTAB_CREDITS || Control.currenttab == Control.MENUTAB_GITHUB) {
				Gfx.fillrect(0, 0, j, Gfx.linesize, 5);
				Gfx.print(14, 0, "CREDITS", (Control.currenttab == Control.MENUTAB_CREDITS
					|| Control.currenttab == Control.MENUTAB_GITHUB) ? 0 : 2, false,
					true);
			} else {
				Gfx.fillrect(Control.currenttab * j, 0, j, Gfx.linesize, 5);
				Gfx.print(14, 0, "FILE", Control.currenttab == Control.MENUTAB_FILE ? 0 : 2, false, true);
			}
			Gfx.print(j + 14, 0, "ARRANGEMENT", Control.currenttab == Control.MENUTAB_ARRANGEMENTS ? 0 : 2, false, true);
			Gfx.print((j * 2) + 14, 0, "INSTRUMENT", Control.currenttab == Control.MENUTAB_INSTRUMENTS ? 0 : 2, false, true);
			Gfx.print((j * 3) + 14, 0, "ADVANCED", Control.currenttab == Control.MENUTAB_ADVANCED ? 0 : 2, false, true);
			#if (CONFIG == "desktop")
			{
				Gfx.fillrect((j * 4), 0, 42, 20, 3);
				Gfx.drawicon((j * 4) + 12, 1, Control.fullscreen ? 5 : 4);
			}
			#end

			if (Control.nowexporting) {
				Gfx.updatebackground = 5;
				Gfx.fillrect(0, Gfx.pianorollposition + Gfx.linesize, Gfx.screenwidth, Gfx.screenheight - (Gfx.pianorollposition + Gfx.linesize), 14);
				if (Control.arrange.currentbar % 2 == 0) {
					Guiclass.tx = Std.int(Gfx.screenwidth / 64) + 1;
					for (i in -1...Guiclass.tx) {
						Gfx.fillrect((i * 64)
							+ Help.slowsine, Gfx.pianorollposition
							+ Gfx.linesize, 32,
							Gfx.screenheight
							- (Gfx.pianorollposition + Gfx.linesize), 1);
					}
				} else {
					Guiclass.tx = Std.int(Gfx.screenheight - (Gfx.pianorollposition + Gfx.linesize) / 64) + 1;
					for (i in 0...Guiclass.tx) {
						Gfx.fillrect(0, Gfx.pianorollposition + Gfx.linesize + (i * 64) + Help.slowsine, Gfx.screenwidth, 32, 1);
					}
					if (Help.slowsine >= 32) {
						Gfx.fillrect(0, Gfx.pianorollposition + Gfx.linesize, Gfx.screenwidth, Help.slowsine - 32, 1);
					}
				}
				if (Help.slowsine < 32) {
					Gfx.print(Gfx.screenwidthmid - Std.int(Gfx.len("NOW EXPORTING AS WAV, PLEASE WAIT") / 2),
						Std.int((Gfx.pianorollposition + Gfx.linesize) + (Gfx.screenheight - Gfx.hig("WAV") - (Gfx.pianorollposition + Gfx.linesize)) / 2),
						"NOW EXPORTING AS WAV, PLEASE WAIT", 0, false, true);
				}
			} else if (Control.currentbox > -1) {
				Gfx.drawpatterneditor();
			} else {
				Gfx.fillrect(0, Gfx.pianorollposition + Gfx.linesize, Gfx.screenwidth, Gfx.screenheight - Gfx.pianorollposition, 14);
			}

			// Draw menu area
			Gfx.fillrect(0, Gfx.linesize, Gfx.screenwidth, Gfx.linesize * 10, 5);
			for (j in 0...cast(Gfx.linesize * 10)) {
				if (j % 4 == 0) {
					Gfx.fillrect(0, Gfx.linesize + j, Gfx.screenwidth, 2, 1);
				}
			}

			switch (Control.currenttab) {
				case Control.MENUTAB_FILE:
					Guiclass.tx = Std.int((Gfx.screenwidth - 768) / 4);
					Gfx.fillrect(Guiclass.tx, Gfx.linesize, 408, Gfx.linesize * 10, 5);
					Gfx.fillrect(Gfx.screenwidth - Guiclass.tx - 408 + 24, Gfx.linesize, 408, Gfx.linesize * 10, 5);
				case Control.MENUTAB_CREDITS:
					Guiclass.tx = Std.int((Gfx.screenwidth - 768) / 4);
					Gfx.fillrect(Guiclass.tx, Gfx.linesize, 408, Gfx.linesize * 10, 5);
					Gfx.fillrect(Gfx.screenwidth - Guiclass.tx - 408 + 24, Gfx.linesize, 408, Gfx.linesize * 10, 5);
				case Control.MENUTAB_GITHUB:
					Guiclass.tx = Std.int((Gfx.screenwidth - 768) / 4);
					Gfx.fillrect(Guiclass.tx, Gfx.linesize, 408, Gfx.linesize * 10, 5);
					Gfx.fillrect(Gfx.screenwidth - Guiclass.tx - 408 + 24, Gfx.linesize, 408, Gfx.linesize * 10, 5);
				case Control.MENUTAB_HELP:
					Guiclass.tx = Std.int((Gfx.screenwidth - 768) / 2);
					Gfx.fillrect(Guiclass.tx, Gfx.linesize, 768, Gfx.linesize * 10, 5);
				case Control.MENUTAB_ARRANGEMENTS:
					Gfx.drawarrangementeditor();
					Gfx.drawtimeline();
					Gfx.drawpatternmanager();
				case Control.MENUTAB_INSTRUMENTS:
					Gfx.drawinstrumentlist();
					Gfx.drawinstrument();
				case Control.MENUTAB_ADVANCED:
					Guiclass.tx = Std.int((Gfx.screenwidth - 768) / 4);
					Gfx.fillrect(Guiclass.tx, Gfx.linesize, 408, Gfx.linesize * 10, 5);
					Gfx.fillrect(Gfx.screenwidth - Guiclass.tx - 408 + 24, Gfx.linesize, 408, Gfx.linesize * 10, 5);
			}

			// Cache bitmap at this point
			Gfx.updatebackground--;
			if (Gfx.updatebackground == 0) {
				Gfx.settrect(Std.int(Gfx.backbuffer.rect.x), Std.int(Gfx.backbuffer.rect.y), Std.int(Gfx.backbuffer.rect.width),
					Std.int(Gfx.backbuffer.rect.height));
				Gfx.backbuffercache.copyPixels(Gfx.backbuffer, Gfx.trect, Gfx.tl);
			}
		} else {
			if (!Control.musicplaying)
				Gfx.changeframerate(15); // If there's no music playing, drop the framerate!
			// Draw from cache
			Gfx.settrect(Std.int(Gfx.backbuffercache.rect.x), Std.int(Gfx.backbuffercache.rect.y), Std.int(Gfx.backbuffercache.rect.width),
				Std.int(Gfx.backbuffercache.rect.height));
			Gfx.backbuffer.copyPixels(Gfx.backbuffercache, Gfx.trect, Gfx.tl);
		}

		if (Control.currenttab == Control.MENUTAB_ARRANGEMENTS) {
			Gfx.drawarrangementcursor();
			if (Control.mx > Gfx.patternmanagerx - 108) {
				Gfx.drawpatternmanager();
			}
			Gfx.drawtimeline_cursor();
			Gfx.drawpatternmanager_cursor();
		}

		if (!Control.nowexporting) {
			if (Control.currentbox > -1) {
				Gfx.drawpatterneditor_cursor();
			}
		}

		Guiclass.drawbuttons();

		if (Control.messagedelay > 0) {
			i = Control.messagedelay > 10 ? 10 : Control.messagedelay;
			Gfx.fillrect(0, Gfx.screenheight - (i * 2), Gfx.screenwidth, 20, 16);
			Gfx.print(Std.int(Gfx.screenwidthmid - (Gfx.len(Control.message) / 2)), Gfx.screenheight - (i * 2), Control.message, 0, false, true);
		}

		// Draw pop up lists over all that
		Gfx.drawlist();

		// Draw mouse dragging stuff over everything
		if (Control.dragaction == 1 || Control.dragaction == 2) {
			if (Math.abs(Control.mx - Control.dragx) > 4 || Math.abs(Control.my - Control.dragy) > 4) {
				Gfx.drawmusicbox(Std.int(Control.mx), Std.int(Control.my), Control.dragpattern);
			}
		}

		Gfx.render();
	}
}
