package includes;

import bigroom.input.KeyPoll;
import includes.Keypoll.generickeypoll;
import openfl.ui.Keyboard;

class Input {
	public static function input(key:KeyPoll, main:Main):Void {
		var i:Int;
		var j:Int;
		var k:Int;

		generickeypoll(key, main);
		if (key.click || key.press || key.rightpress || key.rightclick || key.middlepress || key.middleclick || key.mousewheel != 0) {
			// Update screen when you click the mouse
			Gfx.updatebackground = 5;
		}

		if (Control.fixmouseclicks) {
			Control.fixmouseclicks = false;
			key.releaseall();
		}

		Control.cursorx = -1;
		Control.cursory = -1;
		Control.notey = -1;
		Control.instrumentcury = -1;
		Control.arrangecurx = -1;
		Control.arrangecury = -1;
		Control.patterncury = -1;
		Control.timelinecurx = -1;
		Control.list.selection = -1;
		Control.secondlist.selection = -1;

		if (Control.clicklist) {
			if (!key.press) {
				Control.clicklist = false;
			}
		}

		if (Control.clicksecondlist) {
			if (!key.press) {
				Control.clicksecondlist = false;
			}
		}

		Guiclass.checkinput(key);

		if (Guiclass.windowdrag) {
			key.click = false;
			key.press = false;
		}

		if (Control.list.active || Control.secondlist.active) {
			if (Control.secondlist.active) {
				if (Control.mx > Control.secondlist.x
					&& Control.mx < Control.secondlist.x + Control.secondlist.w
					&& Control.my > Control.secondlist.y
					&& Control.my < Control.secondlist.y + Control.secondlist.h) {
					Control.secondlist.selection = Std.int(Control.my - Control.secondlist.y);
					Control.secondlist.selection = Std.int((Control.secondlist.selection - (Control.secondlist.selection % Gfx.linesize)) / Gfx.linesize);
				}
			}
			if (Control.list.active) {
				if (Control.mx > Control.list.x
					&& Control.mx < Control.list.x + Control.list.w
					&& Control.my > Control.list.y
					&& Control.my < Control.list.y + Control.list.h) {
					Control.list.selection = Std.int(Control.my - Control.list.y);
					Control.list.selection = Std.int((Control.list.selection - (Control.list.selection % Gfx.linesize)) / Gfx.linesize);
				}
			}
		} else {
			if (!Guiclass.overwindow) {
				if (Control.mx > 40 && Control.mx < Gfx.screenwidth - 24) {
					if (Control.my > Gfx.pianorollposition + Gfx.linesize
						&& Control.my < Gfx.pianorollposition + (Gfx.linesize * (Gfx.patterneditorheight + 1))) {
						Control.cursorx = Std.int(Control.mx - 40);
						Control.cursorx = Std.int((Control.cursorx - (Control.cursorx % Control.boxsize)) / Control.boxsize);

						Control.cursory = Std.int((Gfx.screenheight - Gfx.linesize) - Control.my);
						Control.cursory = 1 + Std.int((Control.cursory - (Control.cursory % Gfx.linesize)) / Gfx.linesize);
						if (Control.cursorx >= Control.boxcount)
							Control.cursorx = Control.boxcount - 1;
						if (Control.my >= Gfx.screenheight - (Gfx.linesize))
							Control.cursory = -1;
					}
				} else if (Control.mx <= 40) {
					if (Control.my > Gfx.pianorollposition + Gfx.linesize
						&& Control.my < Gfx.pianorollposition + (Gfx.linesize * (Gfx.patterneditorheight + 1))) {
						Control.notey = Std.int((Gfx.screenheight - Gfx.linesize) - Control.my);
						Control.notey = 1 + Std.int((Control.notey - (Control.notey % Gfx.linesize)) / Gfx.linesize);
						if (Control.my >= Gfx.screenheight - (Gfx.linesize))
							Control.notey = -1;
					}
				}

				if (Control.my > Gfx.linesize && Control.my < Gfx.pianorollposition + 20) {
					if (Control.currenttab == Control.MENUTAB_ARRANGEMENTS) {
						// Priority: Timeline, Pattern manager, arrangements
						if (Control.mx > Gfx.patternmanagerx) {
							// Pattern Manager
							Control.patterncury = Std.int(Control.my) - Gfx.linesize - 4;
							Control.patterncury = Std.int((Control.patterncury - (Control.patterncury % Gfx.patternheight)) / Gfx.patternheight);
							if (Control.patterncury > 6)
								Control.patterncury = -1;
						} else if (Control.my >= Gfx.pianorollposition + 8 || Control.dragaction == 3) {
							// Timeline
							Control.timelinecurx = Std.int(Control.mx);
							Control.timelinecurx = Std.int((Control.timelinecurx - (Control.timelinecurx % Gfx.patternwidth)) / Gfx.patternwidth);
						} else {
							// Arrangements
							Control.arrangecurx = Std.int(Control.mx);
							Control.arrangecurx = Std.int((Control.arrangecurx - (Control.arrangecurx % Gfx.patternwidth)) / Gfx.patternwidth);
							Control.arrangecury = Std.int((Control.my - Gfx.linesize));
							Control.arrangecury = Std.int((Control.arrangecury - (Control.arrangecury % Gfx.patternheight)) / Gfx.patternheight);
							if (Control.arrangecury > 7)
								Control.arrangecury = 7;
						}
					} else if (Control.currenttab == Control.MENUTAB_INSTRUMENTS) {
						if (Control.mx < 280) {
							Control.instrumentcury = Std.int(Control.my - Gfx.linesize);
							Control.instrumentcury = Std.int((Control.instrumentcury - (Control.instrumentcury % Gfx.patternheight)) / Gfx.patternheight);
							if (Control.instrumentcury > 6)
								Control.instrumentcury = -1;
						}
					}
				}
			}
		}

		if (Control.copykeyheld) {
			if (!key.isDown(Keyboard.C) && !key.isDown(Keyboard.V)) {
				Control.copykeyheld = false;
			}
		}

		if (Control.timelinecurx > -1) {
			if (key.ctrlheld && !Control.copykeyheld) {
				if (key.isDown(Keyboard.V)) {
					Gfx.updatebackground = 5;
					Control.copykeyheld = true;
					Control.arrange.paste(Control.arrange.viewstart + Control.timelinecurx);
				}
			}
		}

		if (key.ctrlheld && !Control.copykeyheld) {
			if (key.isDown(Keyboard.C)) {
				Control.copykeyheld = true;
				Control.arrange.copy();
				Control.showmessage("PATTERNS COPIED");
			}
		}

		if (Control.cursorx > -1 && Control.cursory > -1 && Control.currentbox > -1 && !Control.clicklist) {
			if (key.press && Control.dragaction == 0) {
				// Add note
				if (Control.musicbox[Control.currentbox].start + Control.cursory - 1 == -1) {
					if (key.click) {
						// Enable/Disable recording filter for this musicbox
						Control.musicbox[Control.currentbox].recordfilter = 1 - Control.musicbox[Control.currentbox].recordfilter;
					}
				} else {
					if (Control.musicbox[Control.currentbox].start + Control.cursory - 1 > -1
						&& Control.musicbox[Control.currentbox].start + Control.cursory - 1 < Control.pianorollsize) {
						Control.currentnote = Control.pianoroll[Control.musicbox[Control.currentbox].start + Control.cursory - 1];
						if (Control.musicbox[Control.currentbox].noteat(Control.cursorx, Control.currentnote)) {
							Control.musicbox[Control.currentbox].removenote(Control.cursorx, Control.currentnote);
							Control.musicbox[Control.currentbox].addnote(Control.cursorx, Control.currentnote, Control.notelength);
						} else {
							Control.musicbox[Control.currentbox].addnote(Control.cursorx, Control.currentnote, Control.notelength);
						}
					}
				}
			}

			if (key.rightpress) {
				// Remove any note in this position
				if (Control.musicbox[Control.currentbox].start + ((Gfx.patterneditorheight - 1) - Control.cursory) > -1) {
					// OLD
					// Control.currentnote = Control.pianoroll[Control.musicbox[Control.currentbox].start + ((Gfx.patterneditorheight - 1) - Control.cursory)];
					if (Control.musicbox[Control.currentbox].start + Control.cursory - 1 > -1) {
						Control.currentnote = Control.pianoroll[Control.musicbox[Control.currentbox].start + Control.cursory - 1];
					}

					Control.musicbox[Control.currentbox].removenote(Control.cursorx, Control.currentnote);
				}
			}
		} else {
			if (key.click) {
				if (Control.secondlist.active) {
					if (Control.secondlist.selection > -1) {
						// List selection stuff here
						if (Control.secondlist.type >= Control.LIST_MIDI_0_PIANO
							&& Control.secondlist.type <= Control.LIST_MIDI_15_SOUNDEFFECTS) {
							Control.changeinstrumentvoice(Control.secondlist.item[Control.secondlist.selection]);
							Control.secondlist.close();
							Control.list.close();
						}
					} else {
						Control.secondlist.close();
						if (Control.list.selection == -1) {
							Control.list.close();
						}
					}

					Control.clicksecondlist = true;
				}

				if (Control.list.active) {
					if (Control.list.selection > -1) {
						// List selection stuff here
						if (Control.list.type == Control.LIST_CATEGORY) {
							Control.list.close();
							Control.instrument[Control.currentinstrument].category = Control.list.item[Control.list.selection];
							Control.voicelist.index = Control.voicelist.getfirst(Control.instrument[Control.currentinstrument].category);
							Control.changeinstrumentvoice(Control.voicelist.name[Control.voicelist.index]);
						}
						if (Control.list.type == Control.LIST_MIDIINSTRUMENT) {
							Control.list.close();
							Control.filllist(Control.LIST_MIDIINSTRUMENT);
							Control.list.init(470, (Gfx.linesize * 3) + 6);
							Control.midilistselection = Control.list.selection;

							Control.secondlist.close();
							Control.filllist(Control.LIST_MIDI_0_PIANO + Control.list.selection);
							if (Gfx.screenwidth < 800) {
								Control.secondlist.init(580, (Gfx.linesize * 3) + 6 + (Control.list.selection * Gfx.linesize));
							} else {
								Control.secondlist.init(595, (Gfx.linesize * 3) + 6 + (Control.list.selection * Gfx.linesize));
							}
						}
						if (Control.list.type == Control.LIST_INSTRUMENT) {
							if (Help.Left(Control.list.item[Control.list.selection], 2) == "<<") {
								Control.voicelist.pagenum = 0;
								Control.list.close();
								Control.filllist(Control.LIST_INSTRUMENT);
								Control.list.init(470, (Gfx.linesize * 3) + 6);
							} else if (Help.Left(Control.list.item[Control.list.selection], 2) == ">>") {
								Control.voicelist.pagenum++;
								if (Control.voicelist.pagenum == 15)
									Control.voicelist.pagenum = 0;
								Control.list.close();
								Control.filllist(Control.LIST_INSTRUMENT);
								Control.list.init(470, (Gfx.linesize * 3) + 6);
							} else {
								Control.changeinstrumentvoice(Control.list.item[Control.list.selection]);
								Control.list.close();
							}
						}
						if (Control.list.type == Control.LIST_SELECTINSTRUMENT) {
							Control.musicbox[Control.currentbox].instr = Control.list.selection;
							Control.musicbox[Control.currentbox].palette = Control.instrument[Control.musicbox[Control.currentbox].instr].palette;
							Control.list.close();
							Guiclass.changetab(Control.currenttab);
						}
						if (Control.list.type == Control.LIST_KEY) {
							Control.changekey(Control.list.selection);
							Control.list.close();
						}
						if (Control.list.type == Control.LIST_SCALE) {
							Control.changescale(Control.list.selection);
							Control.list.close();
						}

						if (Control.list.type == Control.LIST_BUFFERSIZE) {
							Control.setbuffersize(Control.list.selection);
							Control.list.close();
						}

						if (Control.list.type == Control.LIST_EFFECTS) {
							Control.effecttype = Control.list.selection;
							Control.updateeffects();
							Control.list.close();
						}

						if (Control.list.type == Control.LIST_MOREEXPORTS) {
							if (Control.list.selection == 0) {
								#if (CONFIG == "desktop")
								{
									Control.exportxm();
								}
								#end
							} else if (Control.list.selection == 1) {
								// TODO: enable for web usage too (it's just text!)
								#if (CONFIG == "desktop")
								{
									Control.exportmml();
								}
								#end
							}
							Control.list.close();
						}

						if (Control.list.type == Control.LIST_EXPORTS) {
							Control.list.close();
							if (Control.list.selection == 0) {
								Control.exportwav();
							} else if (Control.list.selection == 1) {
								#if (CONFIG == "desktop")
								{
									// midiControl.savemidi();TODO:FIXME: add -Sam!
								}
								#end
							} else if (Control.list.selection == 2) {
								Control.filllist(Control.LIST_MOREEXPORTS);
								Control.list.init(Gfx.screenwidth - 170 - ((Gfx.screenwidth - 768) / 4), (Gfx.linespacing * 4) - 14);
							}
						}
					} else {
						Control.list.close();
					}
					Control.clicklist = true;
				} else if (Control.clicksecondlist) {
					// Clumsy workaround :3
					Control.clicklist = true;
				} else if (Control.my <= Gfx.linesize) {
					// Change tabs
					#if (CONFIG == "desktop")
					{
						if (Control.mx < (Gfx.screenwidth - 40) / 4) {
							Control.changetab(Control.MENUTAB_FILE);
						} else if (Control.mx < (2 * (Gfx.screenwidth - 40)) / 4) {
							Control.changetab(Control.MENUTAB_ARRANGEMENTS);
							Guiclass.helpcondition_set = "changetab_arrangement"; // For interactive tutorial
						} else if (Control.mx < (3 * (Gfx.screenwidth - 40)) / 4) {
							Control.changetab(Control.MENUTAB_INSTRUMENTS);
							Guiclass.helpcondition_set = "changetab_instrument"; // For interactive tutorial
						} else if (Control.mx >= Gfx.screenwidth - 40) {
							if (Control.fullscreen) {
								Control.fullscreen = false;
							} else {
								Control.fullscreen = true;
							}
							main.updategraphicsmode();
						} else {
							Control.changetab(Control.MENUTAB_ADVANCED);
						}
					}
					#end

					#if (CONFIG == "web")
					{
						if (Control.mx < (Gfx.screenwidth) / 4) {
							Control.changetab(Control.MENUTAB_FILE);
						} else if (Control.mx < (2 * (Gfx.screenwidth)) / 4) {
							Control.changetab(Control.MENUTAB_ARRANGEMENTS);
						} else if (Control.mx < (3 * (Gfx.screenwidth)) / 4) {
							Control.changetab(Control.MENUTAB_INSTRUMENTS);
						} else {
							Control.changetab(Control.MENUTAB_ADVANCED);
						}
					}
					#end
				} else if (Control.my > Gfx.linesize && Control.my < Gfx.pianorollposition + 20) {
					if (Control.currenttab == Control.MENUTAB_ARRANGEMENTS) {
						// Arrangements
						// Timeline
						if (Control.timelinecurx > -1) {
							j = Control.arrange.viewstart + Control.timelinecurx;
							if (cast j > -1) {
								if (Control.doubleclickcheck > 0) {
									// Set loop song from this bar
									Control.arrange.loopstart = j;
									Control.arrange.loopend = Control.arrange.lastbar;
									if (Control.arrange.loopend <= Control.arrange.loopstart) {
										Control.arrange.loopend = Control.arrange.loopstart + 1;
									}
									Control.doubleclickcheck = 0;
								} else {
									Control.dragx = j;
									Control.dragaction = 3;
									Control.doubleclickcheck = 25;
								}
							}
						}
						// Pattern Manager
						if (Control.patterncury > -1) {
							if (Control.patterncury == 0 && Control.patternmanagerview > 0 && Control.numboxes > 0) {
								Control.patternmanagerview--;
							} else if (Control.patterncury == 6 && Control.patterncury + Control.patternmanagerview < Control.numboxes) {
								Control.patternmanagerview++;
							} else {
								j = Control.patternmanagerview + Control.patterncury;
								if (j > -1 && j < Control.numboxes) {
									Control.changemusicbox(j);
									Control.dragaction = 2;
									Control.dragpattern = j;
									Control.dragx = Std.int(Control.mx);
									Control.dragy = Std.int(Control.my);
								}
							}
						}
						// Arrangements
						if (Control.arrangecurx > -1 && Control.arrangecury > -1) {
							if (Gfx.arrangementscrollleft == 0 && Gfx.arrangementscrollright == 0) {
								// Change, start drag
								if (Control.dragaction == 0) {
									if (Control.arrangecurx + Control.arrange.viewstart > -1) {
										j = Control.arrange.bar[Control.arrangecurx + Control.arrange.viewstart].channel[Control.arrangecury];
										if (j > -1) {
											Control.changemusicbox(j);
											Control.dragaction = 1;
											Control.dragpattern = j;
											Control.dragx = Std.int(Control.mx);
											Control.dragy = Std.int(Control.my);
										}
									} else {
										// Clicked the Control panel
										if (Control.arrange.viewstart == -1 && Control.arrangecurx == 0) {
											/* Not doing this stuff anymore
												if (Control.mx < Gfx.patternwidth / 2) {
													Control.arrange.channelon[Control.arrangecury] = true;
												}else {
													Control.arrange.channelon[Control.arrangecury] = false;
											}*/
											// Set loop to entire song!
											Control.arrange.loopstart = 0;
											Control.arrange.loopend = Control.arrange.lastbar;
										}
									}
								}
							}

							// Control.arrange.bar[Control.arrangecurx + Control.arrange.viewstart].channel[Control.arrangecury] = Control.currentbox;
						}
					} else if (Control.currenttab == Control.MENUTAB_INSTRUMENTS) {
						// Instrument Manager
						if (Control.instrumentcury > -1) {
							if (Control.instrumentcury == 0 && Control.instrumentmanagerview > 0 && Control.numinstrument > 0) {
								Control.instrumentmanagerview--;
							} else if (Control.instrumentcury == 6
								&& Control.instrumentcury + Control.instrumentmanagerview < Control.numinstrument) {
								Control.instrumentmanagerview++;
							} else if (Control.instrumentcury == 7) {
								// Add a new one!
							} else {
								j = Control.instrumentcury + Control.instrumentmanagerview;
								if (j < Control.numinstrument) {
									Control.currentinstrument = j;
								}
							}
						} else {
							if (Control.my > (Gfx.linesize * 2) + 6 && Control.my < (Gfx.linesize * 3) + 6) {
								if (Control.mx > 280 && Control.mx < 460) {
									Control.filllist(Control.LIST_CATEGORY);
									Control.list.init(290, (Gfx.linesize * 3) + 6);
								} else if (Control.mx >= 460 && Control.mx <= 740) {
									if (Control.instrument[Control.currentinstrument].category == "MIDI") {
										Control.voicelist.makesublist(Control.instrument[Control.currentinstrument].category);
										Control.voicelist.pagenum = 0;
										Control.filllist(Control.LIST_MIDIINSTRUMENT);
										Control.list.init(470, (Gfx.linesize * 3) + 6);
									} else {
										Control.voicelist.makesublist(Control.instrument[Control.currentinstrument].category);
										Control.filllist(Control.LIST_INSTRUMENT);
										Control.list.init(470, (Gfx.linesize * 3) + 6);
									}
								}
							}
						}
					}
				} else if (Control.notey > -1) {
					// Play a single note
					if (Control.currentbox > -1) {
						if (Control.instrument[Control.musicbox[Control.currentbox].instr].type == 0) {
							// Normal instrument
							j = Control.musicbox[Control.currentbox].start + Control.notey - 1;
							if (j >= 0 && j < 128)
								Control._driver.noteOn(Control.pianoroll[j], Control.instrument[Control.musicbox[Control.currentbox].instr].voice,
									Control.notelength);
						} else {
							// Drumkit
							j = Control.musicbox[Control.currentbox].start + Control.notey - 1;
							if (j >= 0 && j < 128)
								Control._driver.noteOn(Control.drumkit[(cast Control.instrument[Control.musicbox[Control.currentbox].instr].type)
									- 1].voicenote[j],
									Control.drumkit[(cast Control.instrument[Control.musicbox[Control.currentbox].instr].type) - 1].voicelist[j],
									Control.notelength);
						}
					}
				}
			}

			if (key.press && (!Control.clicklist && !Control.clicksecondlist)) {
				if (Control.currenttab == Control.MENUTAB_ARRANGEMENTS) {
					if (Control.dragaction == 0 || Control.dragaction == 3) {
						if (Control.arrangescrolldelay == 0) {
							if (Gfx.arrangementscrollleft > 0) {
								Control.arrange.viewstart--;
								if (Control.arrange.viewstart < 0)
									Control.arrange.viewstart = 0;
								Control.arrangescrolldelay = 4;
							} else if (Gfx.arrangementscrollright > 0) {
								Control.arrange.viewstart++;
								if (Control.arrange.viewstart > 1000)
									Control.arrange.viewstart = 1000;
								Control.arrangescrolldelay = 4;
							}
						}
					}
				} else if (Control.currenttab == Control.MENUTAB_INSTRUMENTS) {
					if (Control.my > Gfx.linesize && Control.my < Gfx.pianorollposition + 20) {
						if (Control.mx >= 280 && Control.my > 70 && Control.mx < Gfx.screenwidth - 50) {
							i = Std.int(Control.mx) - 280;
							j = Std.int(Control.my) - 80;
							if (i < 0)
								i = 0;
							if (i > Gfx.screenwidth - 368)
								i = Gfx.screenwidth - 368;
							if (j < 0)
								j = 0;
							if (j > 90)
								j = 90;
							k = 0;
							if (Control.currentbox > -1) {
								if (Control.musicbox[Control.currentbox].recordfilter == 1)
									k = 1;
							}
							if (k == 1) {
								Control.musicbox[Control.currentbox].cutoffgraph[cast(Control.looptime % Control.boxcount)] = cast((i * 128) / (Gfx.screenwidth
									- 368));
								Control.musicbox[Control.currentbox].resonancegraph[cast(Control.looptime % Control.boxcount)] = cast((j * 9) / 90);
								Control.instrument[Control.currentinstrument].changefilterto(Control.musicbox[Control.currentbox].cutoffgraph[cast(Control.looptime % Control.boxcount)],
									Control.musicbox[Control.currentbox].resonancegraph[cast(Control.looptime % Control.boxcount)],
									Control.musicbox[Control.currentbox].volumegraph[cast(Control.looptime % Control.boxcount)]);
								if (cast(Control.instrument[cast(Control.currentinstrument)].type, Int) > 0) {
									Control.drumkit[cast(Control.instrument[Control.currentinstrument].type, Int)
										- 1].updatefilter(Control.instrument[Control.currentinstrument].cutoff,
										Control.instrument[Control.currentinstrument].resonance);
								}
							} else {
								Control.instrument[Control.currentinstrument].setfilter(Std.int((i * 128) / (Gfx.screenwidth - 368)),Std.int((j * 9) / 90));
								Control.instrument[Control.currentinstrument].updatefilter();
								if (cast(Control.instrument[Control.currentinstrument].type, Int) > 0) {
									Control.drumkit[cast(Control.instrument[Control.currentinstrument].type, Int)
										- 1].updatefilter(Control.instrument[Control.currentinstrument].cutoff,
										Control.instrument[Control.currentinstrument].resonance);
								}
							}
						} else if (Control.my > 70 && Control.mx >= Gfx.screenwidth - 50) {
							j = Std.int(Control.my) - 90;
							if (j < 0)
								j = 0;
							if (j > 90)
								j = 90;
							j = 90 - j;
							k = 0;
							if (Control.currentbox > -1) {
								if (Control.musicbox[Control.currentbox].recordfilter == 1) {
									if (Control.musicbox[Control.currentbox].instr == Control.currentinstrument) {
										k = 1;
									}
								}
							}
							if (k == 1) {
								Control.musicbox[Control.currentbox].volumegraph[cast(Control.looptime % Control.boxcount)] = cast((j * 256) / 90);
								Control.instrument[Control.currentinstrument].changevolumeto(Std.int((j * 256) / 90));
								if (cast(Control.instrument[Control.currentinstrument].type, Int) > 0) {
									Control.drumkit[cast(Control.instrument[Control.currentinstrument].type, Int) - 1].updatevolume(Std.int((j * 256) / 90));
								}
							} else {
								Control.instrument[Control.currentinstrument].setvolume(Std.int((j * 256) / 90));
								Control.instrument[Control.currentinstrument].updatefilter();
								if (cast(Control.instrument[Control.currentinstrument].type, Int) > 0) {
									Control.drumkit[cast(Control.instrument[Control.currentinstrument].type, Int) - 1].updatevolume(Std.int((j * 256) / 90));
								}
							}
						}
					}
				}
			}

			if (key.rightpress) {
				if (Control.my > Gfx.linesize && Control.my < Gfx.pianorollposition + Gfx.linesize) {
					if (Control.currenttab == Control.MENUTAB_FILE) {
						// Files
					} else if (Control.currenttab == Control.MENUTAB_ARRANGEMENTS) {
						// Arrangements
						// Timeline
						if (key.rightclick) {
							if (Control.timelinecurx > -1) {
								j = Control.arrange.viewstart + Control.timelinecurx;
								if (j > -1) {
									// Insert blank pattern
									Control.arrange.deletebar(j);
								}
							}
						}
						// Pattern Manager
						// Arrangements
						if (Control.arrangecurx > -1 && Control.arrangecury > -1) {
							// Delete pattern from position
							Control.dragaction = 0;
							if (Control.arrange.bar[Control.arrangecurx + Control.arrange.viewstart].channel[Control.arrangecury] > -1) {
								Control.arrange.removepattern(Control.arrangecurx + Control.arrange.viewstart, Control.arrangecury);
							}
						}
					} else if (Control.currenttab == Control.MENUTAB_INSTRUMENTS) {
						// Instruments
					}
				}
			}

			if (key.middleclick) {
				if (Control.my > Gfx.linesize && Control.my < Gfx.pianorollposition + Gfx.linesize) {
					if (Control.currenttab == Control.MENUTAB_FILE) {
						// Files
					} else if (Control.currenttab == Control.MENUTAB_ARRANGEMENTS) {
						// Arrangements
						// Timeline
						if (Control.timelinecurx > -1) {
							j = Control.arrange.viewstart + Control.timelinecurx;
							if (j > -1) {
								// Insert blank pattern
								Control.arrange.insertbar(j);
							}
						}
						// Pattern Manager
						// Arrangements
						if (Control.arrangecurx > -1 && Control.arrangecury > -1) {
							// Make variation pattern!
							j = Control.arrange.bar[Control.arrangecurx + Control.arrange.viewstart].channel[Control.arrangecury];
							if (j > -1) {
								Control.addmusicbox();
								Control.copymusicbox(Control.numboxes - 1, j);
								Control.musicbox[cast(Control.numboxes) - 1].setnotespan();
								Control.patternmanagerview = Control.numboxes - 6;
								Control.changemusicbox(Control.numboxes - 1);

								if (Control.patternmanagerview < 0)
									Control.patternmanagerview = 0;
								Control.dragaction = 1;
								Control.dragpattern = Control.numboxes - 1;
								Control.dragx = Std.int(Control.mx);
								Control.dragy = Std.int(Control.my);
							}
						}
					} else if (Control.currenttab == Control.MENUTAB_INSTRUMENTS) {
						// Instruments
					}
				}
			}
		}

		if (key.hasreleased || key.hasmiddlereleased) {
			// Check for click releases: deal with immediately
			key.hasreleased = false;
			key.hasmiddlereleased = false;
			Gfx.updatebackground = 5; // Update the background on input

			if (Control.dragaction == 1 || Control.dragaction == 2) {
				Control.dragaction = 0;
				if (Control.arrangecurx > -1 && Control.arrangecury > -1) {
					Control.arrange.addpattern(Control.arrangecurx + Control.arrange.viewstart, Control.arrangecury, Control.dragpattern);
				} else {
					if (Control.mx > Gfx.screenwidth - 120 && Control.my > Gfx.screenheight - 40) {
						Control.deletemusicbox(Control.dragpattern);
						Guiclass.changetab(Control.currenttab);
					}
				}
			} else if (Control.dragaction == 3) {
				Control.dragaction = 0;

				Control.arrange.loopstart = Control.dragx;
				Control.arrange.loopend = Control.arrange.viewstart + Control.timelinecurx + 1;
				if (Control.arrange.loopend <= Control.arrange.loopstart) {
					i = Control.arrange.loopend;
					Control.arrange.loopend = Control.arrange.loopstart + 1;
					Control.arrange.loopstart = i - 1;
				}
				if (Control.arrange.currentbar < Control.arrange.loopstart)
					Control.arrange.currentbar = Control.arrange.loopstart;
				if (Control.arrange.currentbar >= Control.arrange.loopend)
					Control.arrange.currentbar = Control.arrange.loopend - 1;
				if (Control.arrange.loopstart < 0)
					Control.arrange.loopstart = 0;
			}
		}

		if (Control.my > Gfx.pianorollposition) {
			if (key.mousewheel < 0) {
				Control.notelength--;
				if (Control.notelength < 1)
					Control.notelength = 1;
				key.mousewheel = 0;
			} else if (key.mousewheel > 0) {
				Control.notelength++;
				key.mousewheel = 0;
			}
		} else {
			if (key.mousewheel < 0 || (key.shiftheld && (Control.press_down || Control.press_left))) {
				Gfx.zoom--;
				if (Gfx.zoom < 1)
					Gfx.zoom = 1;
				Gfx.setzoomlevel(Gfx.zoom);
				key.mousewheel = 0;
			} else if (key.mousewheel > 0 || (key.shiftheld && (Control.press_up || Control.press_right))) {
				Gfx.zoom++;
				if (Gfx.zoom > 4)
					Gfx.zoom = 4;
				Gfx.setzoomlevel(Gfx.zoom);
				key.mousewheel = 0;
			}
		}

		if (Control.keydelay <= 0) {
			if (Control.currentbox > -1) {
				if (!key.shiftheld) {
					if (Control.press_down) {
						Control.musicbox[Control.currentbox].start--;
						if (Control.musicbox[Control.currentbox].start < -1)
							Control.musicbox[Control.currentbox].start = -1;
						Control.keydelay = 2;
					} else if (Control.press_up) {
						Control.musicbox[Control.currentbox].start++;
						if (Control.musicbox[Control.currentbox].start > Control.pianorollsize - Gfx.notesonscreen) {
							Control.musicbox[Control.currentbox].start = Control.pianorollsize - Gfx.notesonscreen;
						}
						if (cast(Control.instrument[Control.musicbox[Control.currentbox].instr].type, Int) > 0) {
							// Also check for drumkit ranges
							if (Control.musicbox[Control.currentbox].start > Control.drumkit[
								cast(Control.instrument[Control.musicbox[Control.currentbox].instr].type, Int) - 1
							].size - 12) {
								Control.musicbox[Control.currentbox].start = Control.drumkit[
									cast(Control.instrument[Control.musicbox[Control.currentbox].instr].type, Int) - 1
								].size - 12;
							}
							if (Control.musicbox[Control.currentbox].start < 0) {
								Control.musicbox[Control.currentbox].start = 0;
							}
						}
						Control.keydelay = 2;
					}
				} else {
					if (Control.press_down || Control.press_left) {
						Control.notelength--;
						if (Control.notelength < 1)
							Control.notelength = 1;
						Control.keydelay = 2;
					} else if (Control.press_up || Control.press_right) {
						Control.notelength++;
						Control.keydelay = 2;
					}
				}
			}

			if (!key.shiftheld) {
				if (Control.press_left) {
					Control.arrange.viewstart--;
					if (Control.arrange.viewstart < 0)
						Control.arrange.viewstart = 0;
					Control.keydelay = 2;
				} else if (Control.press_right) {
					Control.arrange.viewstart++;
					if (Control.arrange.viewstart > 1000)
						Control.arrange.viewstart = 1000;
					Control.keydelay = 2;
				}
			}
		} else {
			Control.keydelay--;
		}

		if (Control.currentbox > -1) {
			if (!Control.press_down && Control.musicbox[Control.currentbox].start == -1) {
				Control.musicbox[Control.currentbox].start = 0;
			}
		}

		if (!Control.keyheld) {
			if (Control.press_space || Control.press_enter) {
				if (!Control.musicplaying) {
					Control.startmusic();
				} else {
					Control.stopmusic();
				}
				Control.keyheld = true;
			}
		}

		// Hardcoding some interactive tutorial stuff here
		if (Guiclass.helpcondition_check != "nothing") {
			if (Guiclass.helpcondition_check == Guiclass.helpcondition_set) {
				if (Guiclass.helpcondition_check == "changetab_arrangement") {
					Guiclass.changewindow("help6");
					Control.changetab(Control.currenttab);
					Control.clicklist = true;
				} else if (Guiclass.helpcondition_check == "addnew_pattern") {
					Guiclass.changewindow("help7");
					Control.changetab(Control.currenttab);
					Control.clicklist = true;
				} else if (Guiclass.helpcondition_check == "addnew_instrument") {
					Guiclass.changewindow("help15");
					Control.changetab(Control.currenttab);
					Control.clicklist = true;
				} else if (Guiclass.helpcondition_check == "changetab_instrument") {
					Guiclass.changewindow("help14");
					Control.changetab(Control.currenttab);
					Control.clicklist = true;
				}
			}
			Guiclass.helpcondition_set = "nothing";
		}

		#if (CONFIG == "desktop")
		{
			if (key.isDown(Keyboard.ESCAPE)) {
				// NativeApplication.nativeApplication.exit(0);TODO:FIXME: add -Sam!
			}
		}
		#end
	}
}
