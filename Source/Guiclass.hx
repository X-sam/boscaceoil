package;

// import openfl.desktop.InteractiveIcon;
import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.utils.*;
import openfl.net.*;
import bigroom.input.KeyPoll;

class Guiclass {
	public function new() {}

	public static function init():Void {
		for (i in 0...250) {
			button.push(new Guibutton());
		}

		numbuttons = 0;
		maxbuttons = 250;

		helpwindow = "nothing";
		helpcondition_check = "nothing";
		helpcondition_set = "nothing";
	}

	public static function changewindow(winname:String, initalise:Bool = true):Void {
		helpwindow = winname;
		if (winname == "nothing")
			return;
		windowxoffset = 0;
		windowyoffset = 0;
		helpcondition_check = "nothing";

		switch (winname) {
			case "firstrun":
				if (initalise) {
					windowwidth = 700;
					windowheight = (Gfx.linesize * 6) + 35;
					windowx = Gfx.screenwidthmid - Std.int(windowwidth / 2);
					windowy = Gfx.screenheightmid - Std.int(windowheight / 2);
					windowtext = "Welcome!";
				}

				addblackout();
				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);

				addcentertextlabel(windowx, windowy + 30, windowwidth, "Looks like this is your first time using Bosca Ceoil!", 0, true);
				addcentertextlabel(windowx, windowy + 30 + Gfx.linesize, windowwidth, "Would you like a quick Introduction?", 0, true);

				addbutton(windowx + Std.int(windowwidth / 3) - 75, windowy + 30 + (Gfx.linesize * 3), 150, "YES", "help1", 0, true);
				addbutton(windowx + Std.int(2 * windowwidth / 3) - 75, windowy + 30 + (Gfx.linesize * 3), 150, "NO", "closewindow", 0, true);

				addcentertextlabel(windowx, windowy + 30 + (Gfx.linesize * 5), windowwidth, "(You can access this tour later by clicking HELP.)", 2, true);
			case "help1":
				if (initalise) {
					windowwidth = 400;
					windowheight = (Gfx.linesize * 5) + (Gfx.linesize * 2) + 35;
					windowx = Gfx.screenwidth - windowwidth - 25;
					windowy = 47;

					windowtext = "HELP - Placing Notes";
				}

				addhighlight(40, Gfx.pianorollposition
					+ Gfx.linesize, Gfx.screenwidth
					- 40,
					Gfx.screenheight
					- Gfx.pianorollposition
					- Gfx.linesize
					- Gfx.linesize, 18, "");

				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);
				windowline = 0;
				addline("Let's start putting down some");
				addline("notes right away!");
				addline("");
				addline("LEFT CLICK anywhere in the pattern", "LEFT CLICK");
				addline("editor below to place a note.");

				addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - Gfx.linesize - 15, 150, "NEXT", "help2", 0, true);
			case "help2":
				if (initalise) {
					windowwidth = 400;
					windowheight = (Gfx.linesize * 2) + (Gfx.linesize * 2) + 35;
					windowx = Gfx.screenwidth - windowwidth - 30;
					windowy = 97;

					windowtext = "HELP - Placing Notes";
				}

				addhighlight(40, Gfx.pianorollposition
					+ Gfx.linesize, Gfx.screenwidth
					- 40,
					Gfx.screenheight
					- Gfx.pianorollposition
					- Gfx.linesize
					- Gfx.linesize, 18, "");
				highlightflash = 0;

				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);
				windowline = 0;
				addline("You can delete notes with");
				addline("RIGHT CLICK, or " + Control.ctrl + " + LEFT CLICK.", "RIGHT CLICK", Control.ctrl + " + LEFT CLICK");

				addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - Gfx.linesize - 15, 150, "NEXT", "help3", 0, true);
				addbutton(windowx + 15, windowy + windowheight - Gfx.linesize - 15, 150, "PREVIOUS", "help1", 0, true);
			case "help3":
				if (initalise) {
					windowwidth = 360;
					windowheight = (Gfx.linesize * 3) + (Gfx.linesize * 2) + 35;
					windowx = Gfx.screenwidth - windowwidth - 52;
					windowy = 72;

					windowtext = "HELP - Placing Notes";
				}

				// Scroll bar
				if (Control.doublesize) {
					addhighlight((42 + (32 * Control.boxsize)), Gfx.pianorollposition
						+ Gfx.linesize, Gfx.screenwidth
						- (42 + (32 * Control.boxsize)),
						Gfx.screenheight
						- Gfx.pianorollposition
						- Gfx.linesize
						- Gfx.linesize, 18, "");
				} else {
					addhighlight((42 + (16 * Control.boxsize)), Gfx.pianorollposition
						+ Gfx.linesize, Gfx.screenwidth
						- (42 + (16 * Control.boxsize)),
						Gfx.screenheight
						- Gfx.pianorollposition
						- Gfx.linesize
						- Gfx.linesize, 18, "");
				}

				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);
				windowline = 0;
				addline("You can reach higher and lower");
				addline("notes with the scrollbar, or by", "scrollbar");
				addline("pressing the UP and DOWN keys.", "UP and DOWN");

				addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - Gfx.linesize - 15, 150, "NEXT", "help4", 0, true);
				addbutton(windowx + 15, windowy + windowheight - Gfx.linesize - 15, 150, "PREVIOUS", "help2", 0, true);
			case "help4":
				if (initalise) {
					windowwidth = 700;
					windowheight = (Gfx.linesize * 5) + (Gfx.linesize * 2) + 35;
					windowx = Gfx.screenwidth - windowwidth - 37;
					windowy = 11;

					windowtext = "HELP - Placing Notes";
				}

				addhighlight(40, Gfx.pianorollposition
					+ Gfx.linesize, Gfx.screenwidth
					- 40,
					Gfx.screenheight
					- Gfx.pianorollposition
					- Gfx.linesize
					- Gfx.linesize, 18, "");
				highlightflash = 0;

				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);

				windowxoffset = Gfx.tutorialimagewidth(0) + 5;
				windowyoffset = 0;
				addtutorialimage(windowx + 5, windowy + 30, 0, true);

				windowline = 0;
				addline("Use the MOUSEWHEEL to change", "MOUSEWHEEL");
				addline("the length of the note.");
				addline("");
				addline("(Or press SHIFT + ARROW keys.)", "SHIFT + ARROW");

				addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - Gfx.linesize - 15, 150, "NEXT", "help5", 0, true);
				addbutton(windowx + 15 + windowxoffset, windowy + windowheight - Gfx.linesize - 15, 150, "PREVIOUS", "help3", 0, true);
			case "help5":
				if (initalise) {
					windowwidth = 450;
					windowheight = (Gfx.linesize * 1) + (Gfx.linesize * 2) + 35;
					windowx = Std.int((Gfx.screenwidth - 40) / 4);
					windowy = Gfx.linesize + 10;

					windowtext = "HELP - Arrangements";
				}

				helpcondition_check = "changetab_arrangement";
				addhighlight((Gfx.screenwidth - 40) / 4, 0, (Gfx.screenwidth - 40) / 4, Gfx.linesize, 18, "");

				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);

				windowline = 0;
				addline("Click on the ARRANGEMENT tab to continue.", "ARRANGEMENT");

				addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - Gfx.linesize - 15, 150, "NEXT", "help6", 0, true);
				addbutton(windowx + 15 + windowxoffset, windowy + windowheight - Gfx.linesize - 15, 150, "PREVIOUS", "help4", 0, true);
			case "help6":
				if (initalise) {
					windowwidth = 450;
					windowheight = (Gfx.linesize * 5) + (Gfx.linesize * 2) + 35;
					windowx = Gfx.screenwidth - windowwidth - 144;
					windowy = 120;

					windowtext = "HELP - Arrangements";
				}

				Control.changetab_ifdifferent(Control.MENUTAB_ARRANGEMENTS);
				Control.arrange.viewstart = 0;
				helpcondition_check = "addnew_pattern";
				addhighlight(Gfx.patternmanagerx
					+ 10
					- 5, Gfx.linespacing
					+ Gfx.pianorollposition
					- 28
					- 5,
					Gfx.screenwidth
					- (Gfx.patternmanagerx)
					- 16
					+ 10, Gfx.linesize
					+ 10, 18, "");
				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);

				windowline = 0;
				addline("This is the ARRANGEMENT tab, where you", "ARRANGEMENT");
				addline("put your song together, building it up");
				addline("one pattern at a time.");
				addline("");
				addline("Let's create a new pattern! Click ADD NEW.", "ADD NEW");

				addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - Gfx.linesize - 15, 150, "NEXT", "help7", 0, true);
				addbutton(windowx + 15 + windowxoffset, windowy + windowheight - Gfx.linesize - 15, 150, "PREVIOUS", "help5", 0, true);
			case "help7":
				if (initalise) {
					windowwidth = 600;
					windowheight = (Gfx.linesize * 6) + (Gfx.linesize * 2) + 35;
					windowx = 23;
					windowy = Gfx.pianorollposition + (Gfx.linesize * 2) - 5;

					windowtext = "HELP - Arrangements";
				}

				Control.changetab_ifdifferent(Control.MENUTAB_ARRANGEMENTS);
				Control.arrange.viewstart = 0;
				addhighlight(0, Gfx.linesize, Gfx.screenwidth, Gfx.pianorollposition, 18, "");
				highlightflash = 0;
				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);

				windowxoffset = Gfx.tutorialimagewidth(1) + 5;
				windowyoffset = 0;
				addtutorialimage(windowx + 5, windowy + 30 + (Gfx.linesize / 2), 1, true);

				windowline = 0;
				addline("DRAG your new pattern from the", "DRAG");
				addline("list on the right to below the");
				addline("original pattern.");
				addline("");
				addline("Now you can edit this pattern");
				addline("and hear both playing together!");

				addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - Gfx.linesize - 15, 150, "NEXT", "help8", 0, true);
				addbutton(windowx + 15 + windowxoffset, windowy + windowheight - Gfx.linesize - 15, 150, "PREVIOUS", "help6", 0, true);
			case "help8":
				if (initalise) {
					windowwidth = 450;
					windowheight = (Gfx.linesize * 7) + (Gfx.linesize * 2) + 35;
					windowx = 20;
					windowy = Gfx.pianorollposition + (Gfx.linesize * 2);

					windowtext = "HELP - Arrangements";
				}

				addhighlight(0, Gfx.linesize, Gfx.screenwidth, Gfx.pianorollposition, 18, "");
				highlightflash = 0;
				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);

				Control.changetab_ifdifferent(Control.MENUTAB_ARRANGEMENTS);
				Control.arrange.viewstart = 0;
				windowxoffset = 0;
				windowyoffset = Gfx.tutorialimageheight(3) + 15;
				addtutorialimage(windowx + 25, windowy + 30 + (Gfx.linesize / 2), 3, true);

				windowline = 0;
				addline("You can copy patterns by DRAGGING them,", "DRAGGING");
				addline("and remove them with RIGHT CLICK.", "RIGHT CLICK");

				addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - Gfx.linesize - 15, 150, "NEXT", "help9", 0, true);
				addbutton(windowx + 15 + windowxoffset, windowy + windowheight - Gfx.linesize - 15, 150, "PREVIOUS", "help7", 0, true);
			case "help9":
				if (initalise) {
					windowwidth = 500;
					windowheight = (Gfx.linesize * 1) + (Gfx.linesize * 2) + 35;
					windowx = 20;
					windowy = 85;

					windowtext = "HELP - Timeline";
				}

				addhighlight(0, Gfx.pianorollposition + 8, Gfx.patternmanagerx, 12, 18, "");
				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);

				Control.changetab_ifdifferent(Control.MENUTAB_ARRANGEMENTS);
				Control.arrange.viewstart = 0;
				windowline = 0;
				addline("This thin line is called the TIMELINE.", "TIMELINE");

				addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - Gfx.linesize - 15, 150, "NEXT", "help10", 0, true);
				addbutton(windowx + 15 + windowxoffset, windowy + windowheight - Gfx.linesize - 15, 150, "PREVIOUS", "help8", 0, true);
			case "help10":
				if (initalise) {
					windowwidth = 460;
					windowheight = (Gfx.linesize * 2) + (Gfx.linesize * 2) + 35;
					windowx = 20;
					windowy = Gfx.pianorollposition + (Gfx.linesize * 2);

					windowtext = "HELP - Timeline";
				}

				addhighlight((2 * Gfx.patternwidth), Gfx.pianorollposition + 8, Gfx.patternwidth, 12, 18, "");
				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);

				Control.changetab_ifdifferent(Control.MENUTAB_ARRANGEMENTS);
				Control.arrange.viewstart = 0;
				windowline = 0;
				addline("If you CLICK on a section of the timeline,", "CLICK");
				addline("the song will loop over that section.");

				addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - Gfx.linesize - 15, 150, "NEXT", "help11", 0, true);
				addbutton(windowx + 15 + windowxoffset, windowy + windowheight - Gfx.linesize - 15, 150, "PREVIOUS", "help9", 0, true);
			case "help11":
				if (initalise) {
					windowwidth = 550;
					windowheight = (Gfx.linesize * 9) + (Gfx.linesize * 2) + 35;
					windowx = 20;
					windowy = Gfx.pianorollposition + (Gfx.linesize * 2);

					windowtext = "HELP - Timeline";
				}

				addhighlight((2 * Gfx.patternwidth), Gfx.pianorollposition + 8, Gfx.patternwidth * 3, 12, 18, "");
				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);

				Control.changetab_ifdifferent(Control.MENUTAB_ARRANGEMENTS);
				Control.arrange.viewstart = 0;
				windowxoffset = 0;
				windowyoffset = Gfx.tutorialimageheight(2) + 15;
				addtutorialimage(windowx + 25, windowy + 30 + (Gfx.linesize / 2), 2, true);

				windowline = 0;
				addline("DRAG over multiple sections to play them all!", "DRAG");

				addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - Gfx.linesize - 15, 150, "NEXT", "help12", 0, true);
				addbutton(windowx + 15 + windowxoffset, windowy + windowheight - Gfx.linesize - 15, 150, "PREVIOUS", "help10", 0, true);
			case "help12":
				if (initalise) {
					windowwidth = 520;
					windowheight = (Gfx.linesize * 2) + (Gfx.linesize * 2) + 35;
					windowx = 20;
					windowy = Gfx.pianorollposition + (Gfx.linesize * 2);

					windowtext = "HELP - Timeline";
				}

				Control.changetab_ifdifferent(Control.MENUTAB_ARRANGEMENTS);
				Control.arrange.viewstart = 0;
				addhighlight(0, Gfx.pianorollposition + 8, Gfx.patternmanagerx, 12, 18, "");
				highlightflash = 0;
				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);

				windowline = 0;
				addline("You can DOUBLE CLICK anywhere on the timeline", "DOUBLE CLICK");
				addline("to play the entire song from that poInt.");

				addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - Gfx.linesize - 15, 150, "NEXT", "help13", 0, true);
				addbutton(windowx + 15 + windowxoffset, windowy + windowheight - Gfx.linesize - 15, 150, "PREVIOUS", "help11", 0, true);
			case "help13":
				if (initalise) {
					windowwidth = 400;
					windowheight = (Gfx.linesize * 1) + (Gfx.linesize * 2) + 35;
					windowx = Std.int(((Gfx.screenwidth - 40) / 4) * 2);
					windowy = Gfx.linesize + 10;

					windowtext = "HELP - Instruments";
				}

				helpcondition_check = "changetab_instrument";
				addhighlight(((Gfx.screenwidth - 40) / 4) * 2, 0, (Gfx.screenwidth - 40) / 4, Gfx.linesize, 18, "");

				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);

				windowline = 0;
				addline("Let's look at INSTRUMENTS next.", "INSTRUMENTS");

				addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - Gfx.linesize - 15, 150, "NEXT", "help14", 0, true);
				addbutton(windowx + 15 + windowxoffset, windowy + windowheight - Gfx.linesize - 15, 150, "PREVIOUS", "help12", 0, true);
			case "help14":
				if (initalise) {
					windowwidth = 450;
					windowheight = (Gfx.linesize * 3) + (Gfx.linesize * 2) + 35;
					windowx = 300;
					windowy = Std.int(Gfx.linespacing + Gfx.pianorollposition - 28 - 5 - (Gfx.linesize * 1.5));

					windowtext = "HELP - Instruments";
				}

				Control.changetab_ifdifferent(Control.MENUTAB_INSTRUMENTS);
				helpcondition_check = "addnew_instrument";
				addhighlight(10 - 5, Gfx.linespacing + Gfx.pianorollposition - 28 - 5, 264 + 10, Gfx.linesize + 10, 18, "");
				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);

				windowline = 0;
				addline("This is the INSTRUMENTS tab. Click on", "INSTRUMENTS");
				addline("ADD NEW INSTRUMENT to be given a new", "ADD NEW INSTRUMENT");
				addline("instrument at random!");

				addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - Gfx.linesize - 15, 150, "NEXT", "help15", 0, true);
				addbutton(windowx + 15 + windowxoffset, windowy + windowheight - Gfx.linesize - 15, 150, "PREVIOUS", "help13", 0, true);
			case "help15":
				if (initalise) {
					windowwidth = 240;
					windowheight = (Gfx.linesize * 3) + (Gfx.linesize * 2) + 35;
					windowx = 23;
					windowy = 86;

					windowtext = "HELP - Instruments";
				}

				Control.changetab_ifdifferent(Control.MENUTAB_INSTRUMENTS);
				addhighlight(286 - 5, ((Gfx.linesize * 2) + 6) - 5, 280 + 180 + 10, Gfx.linesize + 10, 18, "");

				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);
				windowline = 0;
				addline("Or, if you don't like");
				addline("that one, pick a new");
				addline("one from the menu!");

				addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - Gfx.linesize - 15, 150, "NEXT", "help16", 0, true);
				addbutton(windowx + 15 + windowxoffset, windowy + windowheight - Gfx.linesize - 15, 30, "<<", "help14", 0, true);
			case "help16":
				if (initalise) {
					windowwidth = 400;
					windowheight = (Gfx.linesize * 3) + (Gfx.linesize * 2) + 35;
					windowx = 250;
					windowy = Gfx.screenheight - windowheight - (Gfx.linesize * 3);

					windowtext = "HELP - Instruments";
				}

				addhighlight(10, Gfx.screenheight - Gfx.linesize, 280, Gfx.linesize, 18, "");
				highlightflash = 90;

				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);
				windowline = 0;
				addline("You can change what instrument a");
				addline("pattern uses from the menu down");
				addline("here in the bottom left.");

				addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - Gfx.linesize - 15, 150, "NEXT", "help17", 0, true);
				addbutton(windowx + 15, windowy + windowheight - Gfx.linesize - 15, 150, "PREVIOUS", "help15", 0, true);
			case "help17":
				if (initalise) {
					windowwidth = 530;
					windowheight = (Gfx.linesize * 7) + (Gfx.linesize * 2) + 35;
					windowx = 10;
					windowy = Gfx.pianorollposition + (Gfx.linesize * 2) - 5;

					windowtext = "HELP - Arrangements";
				}

				Control.changetab_ifdifferent(Control.MENUTAB_ARRANGEMENTS);
				addhighlight(0, Gfx.linesize, Gfx.screenwidth, Gfx.pianorollposition, 18, "");
				highlightflash = 0;
				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);

				windowline = 0;
				addline("One last thing: when you're arranging your song,");
				addline("something you'll probably want to do a lot is to");
				addline("make slight variations of your patterns. You can");
				addline("do this by making DUPLICATES.", "DUPLICATES");
				addline("");
				addline("To duplicate a pattern, MIDDLE CLICK on it.", "MIDDLE CLICK");
				addline("(You can also use SHIFT + CLICK.)", "SHIFT + CLICK");

				addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - Gfx.linesize - 15, 150, "NEXT", "help18", 0, true);
				addbutton(windowx + 15 + windowxoffset, windowy + windowheight - Gfx.linesize - 15, 150, "PREVIOUS", "help16", 0, true);
			case "help18":
				if (initalise) {
					windowwidth = 430;
					windowheight = (Gfx.linesize * 5) + (Gfx.linesize * 2) + 35;
					windowx = Std.int(Gfx.screenwidthmid - (windowwidth / 2));
					windowy = Gfx.pianorollposition + (Gfx.linesize * 2) - 5;

					windowtext = "HELP - Tutorial Complete";
				}

				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);

				windowline = 0;
				addline("That's everything you need to know!");
				addline("Have fun making music!");
				addline("");
				addline("(For more info and advanced tips,");
				addline("click HELP on the main menu.)", "HELP");

				addbutton(windowx + 15 + windowxoffset, windowy + windowheight - Gfx.linesize - 15, 150, "PREVIOUS", "help17", 0, true);
				addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - Gfx.linesize - 15, 150, "FINISH", "endhelp", 0, true);
			case "advancedhelp1":
				if (initalise) {
					windowwidth = 530;
					windowheight = (Gfx.linesize * 5) + (Gfx.linesize * 2) + 35;
					windowx = Std.int(Gfx.screenwidthmid - (windowwidth / 2));
					windowy = Gfx.pianorollposition + (Gfx.linesize * 2) - 5;

					windowtext = "HELP - Tips and Tricks";
				}

				Control.changetab_ifdifferent(Control.MENUTAB_ARRANGEMENTS);
				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);

				windowline = 0;
				addline("Some useful keys to know:");
				addline("");
				addtextlabel(windowx + 10 + windowxoffset + 140, windowy + 30 + windowyoffset + (Gfx.linesize * windowline),
					"- Pause/Unpause the current song.", 0, true);
				addline("SPACE", "SPACE");
				addtextlabel(windowx + 10 + windowxoffset + 140, windowy + 30 + windowyoffset + (Gfx.linesize * windowline), "- Scroll the pattern editor.",
					0, true);
				addline("UP/DOWN", "UP", "DOWN");
				addtextlabel(windowx + 10 + windowxoffset + 140, windowy + 30 + windowyoffset + (Gfx.linesize * windowline),
					"- Scroll the arrangment editor.", 0, true);
				addline("LEFT/RIGHT", "LEFT", "RIGHT");

				addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - Gfx.linesize - 15, 150, "NEXT", "advancedhelp2", 0, true);
			case "advancedhelp2":
				if (initalise) {
					windowwidth = 385;
					windowheight = (Gfx.linesize * 3) + (Gfx.linesize * 2) + 35;
					windowx = Gfx.screenwidth - 470;
					windowy = Gfx.screenheight - windowheight - (Gfx.linesize * 2) - 10;

					windowtext = "HELP - Tips and Tricks";
				}

				addhighlight(Gfx.screenwidth - 470, Gfx.screenheight - (Gfx.linesize), 80, (Gfx.linesize), 18, "");

				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);

				windowline = 0;
				addline("These little PLUS and MINUS buttons", "PLUS", "MINUS");
				addline("transpose the notes in a pattern,", "transpose");
				addline("moving them higher and lower!");

				addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - Gfx.linesize - 15, 150, "NEXT", "advancedhelp3", 0, true);
				addbutton(windowx + 15 + windowxoffset, windowy + windowheight - Gfx.linesize - 15, 150, "PREVIOUS", "advancedhelp1", 0, true);
			case "advancedhelp3":
				if (initalise) {
					windowwidth = 420;
					windowheight = (Gfx.linesize * 8) + (Gfx.linesize * 2) + 35;
					windowx = Gfx.screenwidth - 460;
					windowy = Gfx.screenheight - windowheight - (Gfx.linesize * 2) - 10;

					windowtext = "HELP - Tips and Tricks";
				}

				addhighlight(Gfx.screenwidth - 380, Gfx.screenheight - (Gfx.linesize), 380, (Gfx.linesize), 18, "");

				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);

				windowline = 0;
				addline("You can change the SCALE and KEY of a", "SCALE", "KEY");
				addline("pattern with this menu in the bottom");
				addline("right. When you're using a SCALE, only", "SCALE");
				addline("the notes in that scale are shown!");
				addline("");
				addline("Limiting yourself to a given scale is a");
				addline("great way to make things sound good");
				addline("when you're learning to write music!");

				addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - Gfx.linesize - 15, 150, "NEXT", "advancedhelp4", 0, true);
				addbutton(windowx + 15 + windowxoffset, windowy + windowheight - Gfx.linesize - 15, 150, "PREVIOUS", "advancedhelp2", 0, true);
			case "advancedhelp4":
				if (initalise) {
					windowwidth = 385;
					windowheight = (Gfx.linesize * 5) + (Gfx.linesize * 2) + 35;
					windowx = 20;
					windowy = Gfx.pianorollposition + (Gfx.linesize * 2) - 5;

					windowtext = "HELP - Tips and Tricks";
				}

				Control.changetab_ifdifferent(Control.MENUTAB_ARRANGEMENTS);
				Control.arrange.viewstart = 0;
				addhighlight(0, Gfx.pianorollposition + 8, Gfx.patternmanagerx, 12, 18, "");

				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);

				windowline = 0;
				addline("You can RIGHT CLICK on a timeline", "RIGHT CLICK");
				addline("section to delete the entire column.");
				addline("");
				addline("You can MIDDLE CLICK on a timeline", "MIDDLE CLICK");
				addline("to insert a blank section.");

				addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - Gfx.linesize - 15, 150, "NEXT", "advancedhelp5", 0, true);
				addbutton(windowx + 15 + windowxoffset, windowy + windowheight - Gfx.linesize - 15, 150, "PREVIOUS", "advancedhelp3", 0, true);
			case "advancedhelp5":
				if (initalise) {
					windowwidth = 465;
					windowheight = (Gfx.linesize * 9) + (Gfx.linesize * 2) + 35;
					windowx = 20;
					windowy = Gfx.pianorollposition + (Gfx.linesize * 2) - 5;

					windowtext = "HELP - Tips and Tricks";
				}

				Control.changetab_ifdifferent(Control.MENUTAB_ARRANGEMENTS);
				Control.arrange.viewstart = 0;
				addhighlight(0, Gfx.pianorollposition + 8, Gfx.patternmanagerx, 12, 18, "");

				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);

				windowline = 0;
				addline("You can COPY and PASTE timeline sections", "COPY", "PASTE");
				addline("with " + Control.ctrl + "+C and " + Control.ctrl + "+V.", Control.ctrl + "+C", Control.ctrl + "+V");
				addline("");
				addline("Just select the sections of the timeline you");
				addline("want, and press " + Control.ctrl + "+C to copy.", Control.ctrl + "+C");
				addline("");
				addline("To paste, hold the mouse over the timeline");
				addline("section you want to insert from, and press");
				addline(Control.ctrl + "+V to insert and paste there.", Control.ctrl + "+V");

				addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - Gfx.linesize - 15, 150, "NEXT", "advancedhelp6", 0, true);
				addbutton(windowx + 15 + windowxoffset, windowy + windowheight - Gfx.linesize - 15, 150, "PREVIOUS", "advancedhelp4", 0, true);
			case "advancedhelp6":
				if (initalise) {
					windowwidth = 450;
					windowheight = (Gfx.linesize * 3) + (Gfx.linesize * 2) + 35;
					windowx = 286;
					windowy = Gfx.pianorollposition + (Gfx.linesize * 2) - 5;

					windowtext = "HELP - Tips and Tricks";
				}

				Control.changetab_ifdifferent(Control.MENUTAB_INSTRUMENTS);
				addhighlight(286, (Gfx.linesize * 4), Gfx.screenwidth - 348, 110, 18, "");

				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);

				windowline = 0;
				addline("Tweak how your instrument sounds with");
				addline("the filter pad! Move the dot around to");
				addline("play with cutoff and resonance values.");

				addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - Gfx.linesize - 15, 150, "NEXT", "advancedhelp7", 0, true);
				addbutton(windowx + 15 + windowxoffset, windowy + windowheight - Gfx.linesize - 15, 150, "PREVIOUS", "advancedhelp5", 0, true);
			case "advancedhelp7":
				if (initalise) {
					windowwidth = 430;
					windowheight = (Gfx.linesize * 3) + (Gfx.linesize * 2) + 35;
					windowx = Gfx.screenwidth - windowwidth - 144;
					windowy = 60;

					windowtext = "HELP - Tips and Tricks";
				}

				Control.changetab_ifdifferent(Control.MENUTAB_ARRANGEMENTS);
				addhighlight(Gfx.patternmanagerx, Gfx.linesize, Gfx.screenwidth - (Gfx.patternmanagerx), Gfx.pianorollposition, 18, "");
				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);

				windowline = 0;
				addline("You can completly DELETE patterns you", "DELETE");
				addline("don't want by dragging them to the");
				addline("bottom right of the screen.");

				addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - Gfx.linesize - 15, 150, "NEXT", "advancedhelp8", 0, true);
				addbutton(windowx + 15 + windowxoffset, windowy + windowheight - Gfx.linesize - 15, 150, "PREVIOUS", "advancedhelp6", 0, true);
			case "advancedhelp8":
				if (initalise) {
					windowwidth = 500;
					windowheight = (Gfx.linesize * 13) + (Gfx.linesize * 2) + 35;
					windowx = Std.int(Gfx.screenwidthmid - (windowwidth / 2));
					windowy = (Gfx.linesize * 3) - 5;

					windowtext = "HELP - Tips and Tricks";
				}

				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);

				windowxoffset = 0;
				windowyoffset = Gfx.tutorialimageheight(4) + 15;
				addtutorialimage(windowx + 35, windowy + 30 + (Gfx.linesize / 2), 4, true);

				windowline = 0;
				addline("Alright, last one, but this one's really fancy!");
				addline("");
				addline("Scroll all the way down to the bottom of a");
				addline("pattern. Hold DOWN. There's a secret button!", "DOWN");
				addline("");
				addline("This enables FILTER RECORDING on this pattern.", "FILTER RECORDING");
				addline("When FILTER RECORDING is on, the filter values", "FILTER RECORDING");
				addline("for this pattern can be changed over time!");

				addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - Gfx.linesize - 15, 150, "NEXT", "advancedhelp9", 0, true);
				addbutton(windowx + 15 + windowxoffset, windowy + windowheight - Gfx.linesize - 15, 150, "PREVIOUS", "advancedhelp7", 0, true);
			case "advancedhelp9":
				if (initalise) {
					windowwidth = 430;
					windowheight = (Gfx.linesize * 2) + (Gfx.linesize * 2) + 35;
					windowx = Std.int(Gfx.screenwidthmid - (windowwidth / 2));
					windowy = Gfx.pianorollposition + (Gfx.linesize * 2) - 5;

					windowtext = "HELP - Tips and Tricks";
				}

				Control.changetab_ifdifferent(Control.MENUTAB_ARRANGEMENTS);
				addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);

				windowline = 0;
				addline("I think that's everything! Thanks for");
				addline("using Bosca Ceoil!");

				addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - Gfx.linesize - 15, 150, "FINISH", "endhelp", 0, true);
			default:
				helpwindow = "nothing";
		}
	}

	public static function addline(line:String, high:String = "", high2:String = ""):Void {
		if (line != "") {
			addtextlabel(windowx + 10 + windowxoffset, windowy + 30 + windowyoffset + (Gfx.linesize * windowline), line, 0, true);
			if (high != "") {
				tx = line.indexOf(high);
				tx = Gfx.len(Help.Left(line, Std.int(tx)));
				addtextlabel(windowx + 10 + tx + windowxoffset, windowy + 30 + windowyoffset + (Gfx.linesize * windowline), high, 18, true);
			}
			if (high2 != "") {
				tx = line.indexOf(high2);
				tx = Gfx.len(Help.Left(line, Std.int(tx)));
				addtextlabel(windowx + 10 + tx + windowxoffset, windowy + 30 + windowyoffset + (Gfx.linesize * windowline), high2, 18, true);
			}
		}
		windowline++;
	}

	public static function addwindow(x:Int, y:Int, w:Int, h:Int, text:String):Void {
		if (helpwindow != "nothing") {
			addguipart(x, y, w, h, windowtext, "window", "window");
		}
	}

	public static function addtutorialimage(x:Float, y:Float, img:Int, towindow:Bool = false):Void {
		addguipart(x, y, 0, 0, "", "", "tutorialimage", img);
		if (towindow)
			button[lastbutton].onwindow = true;
	}

	public static function addbutton(x:Float, y:Float, w:Float, text:String, action:String, textoffset:Int = 0,
			towindow:Bool = false):Void {
		addguipart(x, y, w, Gfx.buttonheight, text, action, "normal", textoffset);
		if (towindow)
			button[lastbutton].onwindow = true;
	}

	public static function addlogo(x:Float, y:Float, towindow:Bool = false):Void {
		addguipart(x, y, 356, 44, "BOSCA CEOIL", "logo", "logo");
		if (towindow)
			button[lastbutton].onwindow = true;
	}

	public static function addtextlabel(x:Float, y:Float, text:String, col:Int = 2, towindow:Bool = false):Void {
		addguipart(x, y, col, 0, text, "", "textlabel");
		if (towindow)
			button[lastbutton].onwindow = true;
	}

	public static function addcentertextlabel(x:Float, y:Float, w:Float, text:String, col:Int = 2,
			towindow:Bool = false):Void {
		addguipart(Std.int(x + ((w / 2) - (Gfx.len(text) / 2))), y, col, 0, text, "", "textlabel");
		if (towindow)
			button[lastbutton].onwindow = true;
	}

	public static function addrighttextlabel(x:Float, y:Float, text:String, col:Int = 2, towindow:Bool = false):Void {
		addguipart(x, y, col, 0, text, "", "righttextlabel");
		if (towindow)
			button[lastbutton].onwindow = true;
	}

	public static function addblackout(towindow:Bool = false):Void {
		addguipart(0, 0, 0, 0, "", "", "blackout", 12);
		if (towindow)
			button[lastbutton].onwindow = true;
	}

	public static function addrect(x:Float, y:Float, w:Float, h:Float, col:Int = 1,
			action:String = "", towindow:Bool = false):Void {
		addguipart(x, y, w, h, "", action, "fillrect", col);
		if (towindow)
			button[lastbutton].onwindow = true;
	}

	public static function addhighlight(x:Float, y:Float, w:Float, h:Float, col:Int = 1,
			action:String = "", towindow:Bool = false):Void {
		highlightflash = 30;
		addguipart(x, y, w, h, "", action, "highlight", col);
		if (towindow)
			button[lastbutton].onwindow = true;
	}

	public static function addleftarrow(x:Float, y:Float, action:String, towindow:Bool = false):Void {
		addguipart(x, y, 16, 16, "", action, "leftarrow");
		if (towindow)
			button[lastbutton].onwindow = true;
	}

	public static function addrightarrow(x:Float, y:Float, action:String, towindow:Bool = false):Void {
		addguipart(x, y, 16, 16, "", action, "rightarrow");
		if (towindow)
			button[lastbutton].onwindow = true;
	}

	public static function addplayarrow(x:Float, y:Float, action:String, towindow:Bool = false):Void {
		addguipart(x, y, 16, 16, "", action, "playarrow");
		if (towindow)
			button[lastbutton].onwindow = true;
	}

	public static function addpausebutton(x:Float, y:Float, action:String, towindow:Bool = false):Void {
		addguipart(x, y, 16, 16, "", action, "pause");
		if (towindow)
			button[lastbutton].onwindow = true;
	}

	public static function addstopbutton(x:Float, y:Float, action:String, towindow:Bool = false):Void {
		addguipart(x, y, 16, 16, "", action, "stop");
		if (towindow)
			button[lastbutton].onwindow = true;
	}

	public static function addplusbutton(x:Float, y:Float, action:String, towindow:Bool = false):Void {
		addguipart(x, y, 16, 16, "", action, "plus");
		if (towindow)
			button[lastbutton].onwindow = true;
	}

	public static function addminusbutton(x:Float, y:Float, action:String, towindow:Bool = false):Void {
		addguipart(x, y, 16, 16, "", action, "minus");
		if (towindow)
			button[lastbutton].onwindow = true;
	}

	public static function adddownarrow(x:Float, y:Float, action:String, towindow:Bool = false):Void {
		addguipart(x, y, 16, 16, "", action, "downarrow");
		if (towindow)
			button[lastbutton].onwindow = true;
	}

	public static function adduparrow(x:Float, y:Float, action:String, towindow:Bool = false):Void {
		addguipart(x, y, 16, 16, "", action, "uparrow");
		if (towindow)
			button[lastbutton].onwindow = true;
	}

	public static function addscrollupbutton(x:Float, y:Float, w:Float, action:String, towindow:Bool = false):Void {
		addguipart(x, y, w, 21, "", action, "scrollup");
		if (towindow)
			button[lastbutton].onwindow = true;
	}

	public static function addscrolldownbutton(x:Float, y:Float, w:Float, action:String, towindow:Bool = false):Void {
		addguipart(x, y, w, 21, "", action, "scrolldown");
		if (towindow)
			button[lastbutton].onwindow = true;
	}

	public static function addvariable(x:Float, y:Float, variable:String, col:Int = 0, towindow:Bool = false):Void {
		addguipart(x, y, col, 0, "", variable, "variable");
		if (towindow)
			button[lastbutton].onwindow = true;
	}

	public static function addhorizontalslider(x:Float, y:Float, w:Float, variable:String, towindow:Bool = false):Void {
		addguipart(x, y, w, 26, "", variable, "horizontalslider");
		if (towindow)
			button[lastbutton].onwindow = true;
	}

	public static function addControl(x:Float, y:Float, type:String):Void {
		// For complex multipart things
		if (type == "changepatternlength") {
			addrect(x, y - 4, 320, 26);
			addrighttextlabel(x + 120, y, "PATTERN", 0);

			addleftarrow(x + 140, y, "barcountdown");
			addvariable(x + 170, y, "barcount");
			addrightarrow(x + 200, y, "barcountup");

			addleftarrow(x + 230, y, "boxcountdown");
			addvariable(x + 250, y, "boxcount");
			addrightarrow(x + 290, y, "boxcountup");
		} else if (type == "changebpm") {
			addrect(x, y - 4, 320, Gfx.buttonheight);
			addrighttextlabel(x + 120, y, "BPM", 0);

			addleftarrow(x + 170, y, "bpmdown");
			addvariable(x + 200, y, "bpm");
			addrightarrow(x + 260, y, "bpmup");
		} else if (type == "changesoundbuffer") {
			addrect(x, y - 4, 320, Gfx.buttonheight);
			addrighttextlabel(x + 160, y, "SOUND BUFFER ", 0);

			adddownarrow(x + 210, y, "bufferlist");
			addvariable(x + 240, y, "buffersize");
			addvariable(x + 8, y + Gfx.buttonheight + 4, "buffersizealert");
		} else if (type == "swingControl") {
			addrect(x, y - 4, 320, Gfx.buttonheight);
			addrighttextlabel(x + 120, y, "SWING", 0);

			addleftarrow(x + 170, y, "swingdown");
			addvariable(x + 200, y, "swing");
			addrightarrow(x + 260, y, "swingup");
		} else if (type == "globaleffects") {
			addrect(x + 40, y - 4, 150, Gfx.buttonheight, 6);
			adddownarrow(x + 10, y, "effectslist");
			addvariable(x, y, "currenteffect");
			addhorizontalslider(x + 40, y - 4, 130, "currenteffect");
		} else if (type == "footer_instrumentlist") {
			addrect(x, y, 280, Gfx.linesize, 1, "footer_instrumentlist");
			adduparrow(x + 10, y + 4, "footer_instrumentlist");
			addvariable(x + 38, y, "currentinstrument");
		} else if (type == "footer_keylist") {
			addrect(x, y, 80, Gfx.linesize, 1, "footer_keylist");
			adduparrow(x + 10, y + 4, "footer_keylist");
			addvariable(x + 38, y, "currentkey");
		} else if (type == "footer_scalelist") {
			addrect(x, y, 300, Gfx.linesize, 1, "footer_scalelist");
			adduparrow(x + 10, y + 4, "footer_scalelist");
			addvariable(x + 38, y, "currentscale");
		}
	}

	public static function addguipart(x:Float, y:Float, w:Float, h:Float, contents:String, act:String = "",
			sty:String = "normal", toffset:Int = 0):Void {
		if (button.length == 0)
			init();

		var i:Int, z:Int;
		if (numbuttons == 0) {
			// If there are no active buttons, Z=0;
			z = 0;
		} else {
			i = 0;
			z = -1;
			while (i < numbuttons) {
				if (!button[i].active) {
					z = i;
					i = numbuttons;
				}
				i++;
			}
			if (z == -1) {
				z = numbuttons;
			}
		}
		button[z].init(x, y, w, h, contents, act, sty);
		button[z].textoffset = toffset;
		if (sty == "horizontalslider" || sty == "scrollup" || sty == "scrolldown" || sty == "window") {
			button[z].moveable = true;
		}
		lastbutton = z;
		numbuttons++;
	}

	public static function clear():Void {
		for (i in 0...numbuttons) {
			button[i].active = false;
		}
		numbuttons = 0;
	}

	public static function buttonexists(t:String):Bool {
		// Return true if there is an active button with action t
		for (i in 0...numbuttons) {
			if (button[i].active) {
				if (button[i].action == t) {
					return true;
				}
			}
		}

		return false;
	}

	public static function checkinput(key:KeyPoll):Void {
		if (highlightflash > 0) {
			highlightflash--;
		}
		// Do window stuff first
		overwindow = false;
		for (i in 0...numbuttons) {
			if (button[i].active && button[i].visable) {
				if (button[i].action == "window") {
					if (Help.inboxw(Control.mx, Control.my, button[i].position.x, button[i].position.y, button[i].position.width, button[i].position.height)) {
						button[i].mouseover = true;
						overwindow = true;
					}

					if (key.press && !Control.clicklist) {
						if (button[i].moveable) {
							if (Help.inboxw(Control.mx, Control.my, button[i].position.x - 20, button[i].position.y - 20, button[i].position.width + 40,
								button[i].position.height + 40)) {
								dobuttonmoveaction(i);
							}
						}
					}
				}
			}
		}

		for (i in 0...numbuttons) {
			if (button[i].active && button[i].visable) {
				if (!overwindow || button[i].onwindow) {
					if (Help.inboxw(Control.mx, Control.my, button[i].position.x, button[i].position.y, button[i].position.width, button[i].position.height)) {
						button[i].mouseover = true;
					} else {
						button[i].mouseover = false;
					}
				}

				if (button[i].action == "window" && windowdrag) {
					if (key.hasreleased) {
						windowdrag = false;
					} else {
						button[i].position.x = Control.mx - windowdx;
						button[i].position.y = Control.my - windowdy;
						if (button[i].position.x < 0)
							button[i].position.x = 0;
						if (button[i].position.y < 0)
							button[i].position.y = 0;

						if (button[i].position.x > Gfx.screenwidth - button[i].position.width)
							button[i].position.x = Gfx.screenwidth - button[i].position.width;
						if (button[i].position.y > Gfx.screenheight - button[i].position.height)
							button[i].position.y = Gfx.screenheight - button[i].position.height;

						windowddx = windowx - Std.int(button[i].position.x);
						windowddy = windowy - Std.int(button[i].position.y);

						windowx = Std.int(button[i].position.x);
						windowy = Std.int(button[i].position.y);

						for (j in 0...numbuttons) {
							if (button[j].active && button[j].visable) {
								if (button[j].onwindow) {
									button[j].position.x -= windowddx;
									button[j].position.y -= windowddy;
								}
							}
						}
					}
				} else if (button[i].action != "" && button[i].action != "window" && !Control.list.active) {
					if (!overwindow || button[i].onwindow) {
						if (key.press && !Control.clicklist) {
							if (button[i].moveable) {
								if (Help.inboxw(Control.mx, Control.my, button[i].position.x - 20, button[i].position.y - 20, button[i].position.width + 40,
									button[i].position.height + 40)) {
									dobuttonmoveaction(i);
								}
							}
						}

						if (key.click) {
							if (button[i].mouseover) {
								dobuttonaction(i);
								key.click = false;
							}
						}
					}
				}
			}
		}

		cleanup();
	}

	public static function cleanup():Void {
		var i:Int = 0;
		i = numbuttons - 1;
		while (i >= 0 && !button[i].active) {
			numbuttons--;
			i--;
		}
	}

	public static function drawbuttons():Void {
		for (i in 0...numbuttons) {
			if (button[i].active && button[i].visable) {
				if (button[i].style == "normal") {
					Gfx.fillrect(button[i].position.x, button[i].position.y, button[i].position.width, button[i].position.height, 12);
					if (button[i].pressed > 0) {
						button[i].pressed--;
						if (button[i].pressed < 2) {
							timage = 1;
						} else {
							timage = 0;
						}
					} else {
						timage = 2;
					}
					if (button[i].mouseover) {
						Gfx.fillrect(button[i].position.x - timage, button[i].position.y - timage, button[i].position.width, button[i].position.height, 20);
					} else {
						Gfx.fillrect(button[i].position.x - timage, button[i].position.y - timage, button[i].position.width, button[i].position.height, 1);
					}

					// tx = button[i].position.x + 7 - timage + button[i].textoffset;
					tx = button[i].position.x + (button[i].position.width / 2) - (Gfx.len(button[i].text) / 2) + button[i].textoffset - timage;
					ty = button[i].position.y + 2 - timage;

					Gfx.print(tx, ty, button[i].text, 0, false, true);
				} else if (button[i].style == "blackout") {
					for (j in 0...Gfx.screenheight) {
						if (j % 4 == 0) {
							Gfx.fillrect(0, j, Gfx.screenwidth, 2, 12);
						}
					}
				} else if (button[i].style == "window") {
					tx = button[i].position.x;
					ty = button[i].position.y;
					tw = button[i].position.width;
					th = button[i].position.height;
					Gfx.fillrect(tx - 5 + 15, ty - 5 + 15, tw + 10, th + 10, 12);
					Gfx.fillrect(tx - 5, ty - 5, tw + 10, th + 10, 12);
					Gfx.fillrect(tx, ty, tw, th, 4);
					Gfx.fillrect(tx, ty, tw, 24, 5);
					Gfx.print(tx + 2, ty + 1, button[i].text, 0, false, true);

					Gfx.drawicon(tx + tw - 20, ty + 4, 14);
				} else if (button[i].style == "scrollup") {
					if (button[i].pressed > 0) {
						button[i].pressed--;
						Gfx.fillrect(button[i].position.x, button[i].position.y, button[i].position.width, 20, 12);
						Gfx.fillrect(button[i].position.x + 2, button[i].position.y + 2, button[i].position.width - 4, 16, 6);
						Gfx.drawicon(button[i].position.x + ((button[i].position.width - 16) / 2), button[i].position.y + 4, 10);
					} else {
						Gfx.fillrect(button[i].position.x, button[i].position.y, button[i].position.width, 20, 12);
						Gfx.fillrect(button[i].position.x + 2, button[i].position.y + 2, button[i].position.width - 4, 16, 5);
						Gfx.drawicon(button[i].position.x + ((button[i].position.width - 16) / 2), button[i].position.y + 4, 10);
					}
				} else if (button[i].style == "scrolldown") {
					if (button[i].pressed > 0) {
						button[i].pressed--;
						Gfx.fillrect(button[i].position.x, button[i].position.y, button[i].position.width, 20, 12);
						Gfx.fillrect(button[i].position.x + 2, button[i].position.y + 2, button[i].position.width - 4, 16, 6);
						Gfx.drawicon(button[i].position.x + ((button[i].position.width - 16) / 2), button[i].position.y + 4, 11);
					} else {
						Gfx.fillrect(button[i].position.x, button[i].position.y, button[i].position.width, 20, 12);
						Gfx.fillrect(button[i].position.x + 2, button[i].position.y + 2, button[i].position.width - 4, 16, 5);
						Gfx.drawicon(button[i].position.x + ((button[i].position.width - 16) / 2), button[i].position.y + 4, 11);
					}
				} else if (button[i].style == "tutorialimage") {
					Gfx.drawimage(button[i].textoffset + 8, button[i].position.x, button[i].position.y);
				} else if (button[i].style == "textlabel") {
					Gfx.print(button[i].position.x, button[i].position.y, button[i].text, Std.int(button[i].position.width), false, true);
				} else if (button[i].style == "righttextlabel") {
					Gfx.rprint(button[i].position.x, button[i].position.y, button[i].text, Std.int(button[i].position.width), true);
				} else if (button[i].style == "fillrect") {
					Gfx.fillrect(button[i].position.x, button[i].position.y, button[i].position.width, button[i].position.height, button[i].textoffset);
				} else if (button[i].style == "highlight") {
					if (highlightflash % 8 < 4) {
						Gfx.drawbox(button[i].position.x, button[i].position.y, button[i].position.width, button[i].position.height, button[i].textoffset);
						Gfx.drawbox(button[i].position.x - 2, button[i].position.y - 2, button[i].position.width + 4, button[i].position.height + 4, 19);
					}
				} else if (button[i].style == "leftarrow") {
					Gfx.drawicon(button[i].position.x, button[i].position.y, 3);
				} else if (button[i].style == "rightarrow") {
					Gfx.drawicon(button[i].position.x, button[i].position.y, 2);
				} else if (button[i].style == "playarrow") {
					if (button[i].pressed > 0) {
						Gfx.drawicon(button[i].position.x, button[i].position.y + 1, 2);
						button[i].pressed--;
					} else {
						Gfx.drawicon(button[i].position.x, button[i].position.y, 2);
					}
				} else if (button[i].style == "stop") {
					if (button[i].pressed > 0) {
						Gfx.drawicon(button[i].position.x, button[i].position.y + 1, 6);
						button[i].pressed--;
					} else {
						Gfx.drawicon(button[i].position.x, button[i].position.y, 6);
					}
				} else if (button[i].style == "pause") {
					if (button[i].pressed > 0) {
						Gfx.drawicon(button[i].position.x, button[i].position.y + 1, 7);
						button[i].pressed--;
					} else {
						Gfx.drawicon(button[i].position.x, button[i].position.y, 7);
					}
				} else if (button[i].style == "plus") {
					if (button[i].pressed > 0) {
						Gfx.drawicon(button[i].position.x, button[i].position.y + 1, 8);
						button[i].pressed--;
					} else {
						Gfx.drawicon(button[i].position.x, button[i].position.y, 8);
					}
				} else if (button[i].style == "minus") {
					if (button[i].pressed > 0) {
						Gfx.drawicon(button[i].position.x, button[i].position.y + 1, 9);
						button[i].pressed--;
					} else {
						Gfx.drawicon(button[i].position.x, button[i].position.y, 9);
					}
				} else if (button[i].style == "uparrow") {
					Gfx.drawicon(button[i].position.x, button[i].position.y, 1);
				} else if (button[i].style == "downarrow") {
					Gfx.drawicon(button[i].position.x, button[i].position.y, 0);
				} else if (button[i].style == "horizontalslider") {
					if (button[i].action == "currenteffect") {
						Gfx.fillrect(button[i].position.x, button[i].position.y, 20, 26, 6);
						Gfx.fillrect(button[i].position.x + 2, button[i].position.y + 2, 16, 22, 5);

						tx = Control.effectvalue;
						Gfx.fillrect(button[i].position.x + tx, button[i].position.y, 20, 26, 4);
						Gfx.fillrect(button[i].position.x + tx + 2, button[i].position.y + 2, 16, 22, 2);

						Gfx.fillrect(button[i].position.x + tx + 4, button[i].position.y + 8, 12, 2, 4);
						Gfx.fillrect(button[i].position.x + tx + 4, button[i].position.y + 12, 12, 2, 4);
						Gfx.fillrect(button[i].position.x + tx + 4, button[i].position.y + 16, 12, 2, 4);
					}
				} else if (button[i].style == "variable") {
					if (button[i].action == "barcount") {
						Gfx.print(button[i].position.x, button[i].position.y, Std.string(Control.barcount), Std.int(button[i].position.width), false, true);
					} else if (button[i].action == "boxcount") {
						Gfx.print(button[i].position.x, button[i].position.y, Std.string(Control.boxcount), Std.int(button[i].position.width), false, true);
					} else if (button[i].action == "bpm") {
						Gfx.print(button[i].position.x, button[i].position.y, Std.string(Control.bpm), Std.int(button[i].position.width), false, true);
					} else if (button[i].action == "buffersize") {
						Gfx.print(button[i].position.x, button[i].position.y, Std.string(Control.buffersize), Std.int(button[i].position.width), false, true);
					} else if (button[i].action == "buffersizealert") {
						if (Control.buffersize != Control.currentbuffersize) {
							if (Help.slowsine >= 32) {
								Gfx.print(button[i].position.x, button[i].position.y, "REQUIRES RESTART", 0);
							} else {
								Gfx.print(button[i].position.x, button[i].position.y, "REQUIRES RESTART", 15);
							}
						}
					} else if (button[i].action == "swing") {
						if (Control.swing == -10) {
							Gfx.print(button[i].position.x, button[i].position.y, Std.string(Control.swing), 0, false, true);
						} else if (Control.swing < 0 || Control.swing == 10) {
							Gfx.print(button[i].position.x + 5, button[i].position.y, Std.string(Control.swing), 0, false, true);
						} else {
							Gfx.print(button[i].position.x + 10, button[i].position.y, Std.string(Control.swing), 0, false, true);
						}
					} else if (button[i].action == "currenteffect") {
						Gfx.rprint(button[i].position.x, button[i].position.y, Control.effectname[Control.effecttype], Std.int(button[i].position.width), true);
					} else if (button[i].action == "currentinstrument") {
						if (Control.currentbox > -1) {
							Gfx.print(button[i].position.x, button[i].position.y,
								Std.string(Control.musicbox[Control.currentbox].instr + 1) + "  " +
								Control.instrument[Control.musicbox[Control.currentbox].instr].name,
								0, false, true);
						}
					} else if (button[i].action == "currentkey") {
						Gfx.print(button[i].position.x, button[i].position.y, Control.notename[Control.key], 0, false, true);
					} else if (button[i].action == "currentscale") {
						Gfx.print(button[i].position.x, button[i].position.y, Control.scalename[Control.currentscale], 0, false, true);
					}
				} else if (button[i].style == "logo") {
					tx = button[i].position.x;
					ty = button[i].position.y;
					if (Control.currentbox != -1) {
						timage = Control.musicbox[Control.currentbox].palette;
						if (timage > 6)
							timage = 6;
					} else {
						timage = 6;
					}

					if (button[i].pressed > 0) {
						Gfx.drawimage(7, tx + 6, ty + 2);
						Gfx.drawimage(timage, tx, ty - 8);
						if (Control.looptime % Control.barcount == 1) {
							button[i].pressed--;
						}
					} else {
						if (Control.looptime % Control.barcount == 1) {
							Gfx.drawimage(7, tx + 6, ty + 10 - 8);
							Gfx.drawimage(timage, tx, ty + 4 - 8);
						} else {
							Gfx.drawimage(7, tx + 6, ty + 10);
							Gfx.drawimage(timage, tx, ty + 4);
						}
					}
				}
			}
		}
	}

	public static function deleteall(t:String = ""):Void {
		if (t == "") {
			for (i in 0...numbuttons)
				button[i].active = false;
			numbuttons = 0;
		} else {
			// Deselect any buttons with style t
			for (i in 0...numbuttons) {
				if (button[i].active) {
					if (button[i].style == t) {
						button[i].active = false;
					}
				}
			}
		}
	}

	public static function selectbutton(t:String):Void {
		// select any buttons with action t
		for (i in 0...numbuttons) {
			if (button[i].active) {
				if (button[i].action == t) {
					dobuttonaction(i);
					button[i].selected = true;
				}
			}
		}
	}

	public static function deselect(t:String):Void {
		// Deselect any buttons with action t
		for (i in 0...numbuttons) {
			if (button[i].active) {
				if (button[i].action == t) {
					button[i].selected = false;
				}
			}
		}
	}

	public static function deselectall(t:String):Void {
		// Deselect any buttons with style t
		for (i in 0...numbuttons) {
			if (button[i].active) {
				if (button[i].style == t) {
					button[i].selected = false;
				}
			}
		}
	}

	public static function findbuttonbyaction(t:String):Int {
		for (i in 0...numbuttons) {
			if (button[i].active) {
				if (button[i].action == t) {
					return i;
				}
			}
		}
		return 0;
	}

	public static function changetab(t:Int):Void {
		// Delete all buttons when tabs change, and create new ones
		deleteall();

		// Some gui stuff is on every tab: add it back here:
		// Footer
		if (Control.currentbox > -1) {
			addrect(0, Gfx.screenheight - (Gfx.linesize), Gfx.screenwidth, Gfx.linesize, 4);
			if (Control.currentbox > -1) {
				addControl(10, Gfx.screenheight - (Gfx.linesize), "footer_instrumentlist");
				if (Control.instrument[Control.musicbox[Control.currentbox].instr].type == 0) {
					addplusbutton(Gfx.screenwidth - 460, Gfx.screenheight - (Gfx.linesize), "transposeup");
					addminusbutton(Gfx.screenwidth - 420, Gfx.screenheight - (Gfx.linesize), "transposedown");
					addControl(Gfx.screenwidth - 380, Gfx.screenheight - (Gfx.linesize), "footer_scalelist");
					addControl(Gfx.screenwidth - 80, Gfx.screenheight - (Gfx.linesize), "footer_keylist");
				}
			}

			if (Control.doublesize) {
				// addrect(42 + (32 * Control.boxsize), Gfx.pianorollposition + Gfx.linesize, Gfx.screenwidth - (42 + (32 * Control.boxsize)), Gfx.screenheight - Gfx.linesize - 20 - Gfx.pianorollposition - Gfx.linesize, 12);
				// addrect(42 + (32 * Control.boxsize)+ 2, Gfx.pianorollposition + Gfx.linesize, Gfx.screenwidth - (42 + (32 * Control.boxsize))- 4, Gfx.screenheight - Gfx.linesize - 20 - Gfx.pianorollposition - Gfx.linesize, 4);
				addscrollupbutton(42 + (32 * Control.boxsize), Gfx.pianorollposition + Gfx.linesize, Gfx.screenwidth - (42 + (32 * Control.boxsize)),
					"notescrollup");
				addscrolldownbutton(42 + (32 * Control.boxsize), Gfx.screenheight - Gfx.linesize - 20, Gfx.screenwidth - (42 + (32 * Control.boxsize)),
					"notescrolldown");
			} else {
				// addrect(42 + (16 * Control.boxsize), Gfx.pianorollposition + Gfx.linesize, Gfx.screenwidth - (42 + (16 * Control.boxsize)), Gfx.screenheight - Gfx.linesize - 20 - Gfx.pianorollposition - Gfx.linesize, 12);
				// addrect(42 + (16 * Control.boxsize)+ 2, Gfx.pianorollposition + Gfx.linesize, Gfx.screenwidth - (42 + (16 * Control.boxsize))- 4, Gfx.screenheight - Gfx.linesize - 20 - Gfx.pianorollposition - Gfx.linesize, 4);
				addscrollupbutton(42 + (16 * Control.boxsize), Gfx.pianorollposition + Gfx.linesize, Gfx.screenwidth - (42 + (16 * Control.boxsize)),
					"notescrollup");
				addscrolldownbutton(42 + (16 * Control.boxsize), Gfx.screenheight - Gfx.linesize - 20, Gfx.screenwidth - (42 + (16 * Control.boxsize)),
					"notescrolldown");
			}
		}

		switch (t) {
			case Control.MENUTAB_FILE:
				tx = (Gfx.screenwidth - 768) / 4;
				addlogo(24 + tx, (Gfx.linespacing * 2));
				addtextlabel(385 + tx - Gfx.len(Control.versionnumber, 1), (Gfx.linespacing * 5), Control.versionnumber);

				addtextlabel(20 + tx, (Gfx.linespacing * 6) + 2, "Created by Terry Cavanagh");
				addtextlabel(20 + tx, (Gfx.linespacing * 7) + 2, "http://www.distractionware.com");

				addbutton(20 + tx, (Gfx.linespacing * 9) - 6, 120, "CREDITS", "creditstab");
				addbutton(154 + tx, (Gfx.linespacing * 9) - 6, 120, "HELP", "helptab");

				#if (CONFIG == "desktop")
				{
					addbutton(Gfx.screenwidth - 340 - tx, Gfx.linespacing * 2, 150, "NEW SONG", "newsong");
					addbutton(Gfx.screenwidth - 170 - tx, Gfx.linespacing * 2, 150, "EXPORT...", "exportlist");
					addbutton(Gfx.screenwidth - 340 - tx, (Gfx.linespacing * 4) + 10, 150, "LOAD .ceol", "loadceol");
					addbutton(Gfx.screenwidth - 170 - tx, (Gfx.linespacing * 4) + 10, 150, "SAVE .ceol", "saveceol");
				}
				#end

				addControl(Gfx.screenwidth - 340 - tx, (Gfx.linespacing * 7) - 2, "changepatternlength");
				addControl(Gfx.screenwidth - 340 - tx, (Gfx.linespacing * 9) - 2, "changebpm");

				addrect(290 + tx, (Gfx.linespacing * 9) - 6, 100, 26);
				addplayarrow(300 + tx, (Gfx.linespacing * 9) - 2, "play");
				addpausebutton(330 + tx, (Gfx.linespacing * 9) - 2, "pause");
				addstopbutton(360 + tx, (Gfx.linespacing * 9) - 2, "stop");
			case Control.MENUTAB_CREDITS:
				tx = (Gfx.screenwidth - 768) / 4;
				addtextlabel(tx + 20, (Gfx.linespacing * 1) + 10, "SiON softsynth library by Kei Mesuda", 0);
				addtextlabel(tx + 20, (Gfx.linespacing * 2) + 10, "sites.google.com/site/sioncenter/");

				addrighttextlabel(Gfx.screenwidth - 20 - tx, (Gfx.linespacing * 1) + 10, "Midias library by Efishocean", 0);
				addrighttextlabel(Gfx.screenwidth - 20 - tx, (Gfx.linespacing * 2) + 10, "code.google.com/p/midas3/");

				addtextlabel(tx + 20, (Gfx.linespacing * 4), "XM, MML Exporters by Rob Hunter", 0);
				addtextlabel(tx + 20, (Gfx.linespacing * 5), "about.me/rjhunter/");

				addrighttextlabel(Gfx.screenwidth - 20 - tx, (Gfx.linespacing * 4), "Linux port by Damien L", 0);
				addrighttextlabel(Gfx.screenwidth - 20 - tx, (Gfx.linespacing * 5), "uncovergame.com/");

				addtextlabel(tx + 20, (Gfx.linespacing * 7) - 10, "Swing function by Stephen Lavelle", 0);
				addtextlabel(tx + 20, (Gfx.linespacing * 8) - 10, "increpare.com/");

				addtextlabel(tx + 20, (Gfx.linespacing * 9) + 8, "Available under FreeBSD Licence", 0);

				addrighttextlabel(Gfx.screenwidth - 20 - tx, (Gfx.linespacing * 7) - 10, "Online version by Chris Kim", 0);
				addrighttextlabel(Gfx.screenwidth - 20 - tx, (Gfx.linespacing * 8) - 10, "dy-dx.com/");

				addbutton(Gfx.screenwidth - 340 - tx, (Gfx.linespacing * 9) + 8, 150, "MORE", "githubtab");
				addbutton(Gfx.screenwidth - 164 - tx, (Gfx.linespacing * 9) + 8, 150, "BACK", "filetab");
			case Control.MENUTAB_GITHUB:
				tx = (Gfx.screenwidth - 768) / 4;
				addtextlabel(tx + 20, (Gfx.linespacing * 1) + 10, "Github pull requsts:", 0);
				addtextlabel(tx + 20, (Gfx.linespacing * 2) + 10, "Filepath memory by Ryusui");
				addtextlabel(tx + 20, (Gfx.linespacing * 3) + 10, "Pattern editor bugs fixed by thomcc");

				addbutton(Gfx.screenwidth - 164 - tx, (Gfx.linespacing * 9) + 8, 150, "BACK", "filetab");
			case Control.MENUTAB_HELP:
				tx = (Gfx.screenwidth - 768) / 2;
				addcentertextlabel(tx, (Gfx.linespacing * 2), 768, "Learn the basics of how to make a song in Bosca Ceoil:", 0);
				addbutton(Gfx.screenwidthmid - 126, (Gfx.linespacing * 3) + 10, 250, "BASIC GUIDE", "help1");

				addcentertextlabel(tx, (Gfx.linespacing * 6), 768, "Learn about some of the more advanced features:", 0);
				addbutton(Gfx.screenwidthmid - 125, (Gfx.linespacing * 7) + 10, 250, "TIPS AND TRICKS", "advancedhelp1");

				addbutton(Gfx.screenwidth - 164 - tx, (Gfx.linespacing * 9) + 8, 150, "BACK", "filetab");
			case Control.MENUTAB_ARRANGEMENTS:
				addbutton(Gfx.patternmanagerx + 10, Gfx.linespacing + Gfx.pianorollposition - 28, Gfx.screenwidth - (Gfx.patternmanagerx) - 16, "ADD NEW",
					"addnewpattern");
			case Control.MENUTAB_INSTRUMENTS:
				addbutton(10, Gfx.linespacing + Gfx.pianorollposition - 28, 264, "ADD NEW INSTRUMENT", "addnewinstrument");
				addminusbutton(706, (Gfx.linespacing * 2) + 6, "previousinstrument");
				addplusbutton(726, (Gfx.linespacing * 2) + 6, "nextinstrument");
			case Control.MENUTAB_ADVANCED:
				tx = (Gfx.screenwidth - 768) / 4;
				addControl(40 + tx, (Gfx.linespacing * 3) + 4, "changesoundbuffer");
				addControl(40 + tx, (Gfx.linespacing * 7) + 4, "swingControl");
				addControl(Gfx.screenwidth - 210 - tx, (Gfx.linespacing * 3) + 4, "globaleffects");

				#if (CONFIG == "desktop")
				{
					if (Gfx.scalemode == 0) {
						addbutton(Gfx.screenwidth - 340 - tx, Gfx.linespacing * 7, 150, "SCALE UP", "changescale");
					} else {
						addbutton(Gfx.screenwidth - 340 - tx, Gfx.linespacing * 7, 150, "SCALE DOWN", "changescale");
					}
					addbutton(Gfx.screenwidth - 170 - tx, Gfx.linespacing * 7, 150, "IMPORT .mid", "loadmidi");
				}
				#end
		}

		if (windowx >= Gfx.screenwidth || windowy >= Gfx.screenheight) {
			changewindow(helpwindow);
		} else {
			changewindow(helpwindow, false);
		}
	}

	public static function dobuttonmoveaction(i:Int):Void {
		currentbutton = button[i].action;

		if (currentbutton == "window") {
			if (Control.mx >= button[i].position.x
				&& Control.mx < button[i].position.x + button[i].position.width
				&& Control.my >= button[i].position.y
				&& Control.my <= button[i].position.y + 22
				&& Control.dragaction == 0) {
				// if we're currently dragging, move the window
				if (windowdrag) {} else {
					// otherwise start dragging from here
					if (Control.mx >= button[i].position.x + button[i].position.width - 20) {
						// close the window
						changewindow("nothing");
						changetab(Control.currenttab);
						Control.clicklist = true;
					} else {
						windowdrag = true;
						windowdx = Control.mx - button[i].position.x;
						windowdy = Control.my - button[i].position.y;
					}
				}
			}
		} else if (currentbutton == "currenteffect") {
			if (Control.mx >= button[i].position.x - 5 - 20
				&& Control.mx < button[i].position.x + button[i].position.width + 20
				&& Control.my >= button[i].position.y - 4 - 20
				&& Control.my <= button[i].position.y
					+ Gfx.buttonheight
					+ 4
					+ 20) {
				var barposition:Int = Std.int(Control.mx - (button[i].position.x + 5));
				if (barposition < 0)
					barposition = 0;
				if (barposition > button[i].position.width)
					barposition = Std.int(button[i].position.width);

				Control.effectvalue = barposition;
				Control.updateeffects();
			}
		} else if (currentbutton == "notescrollup") {
			if (Control.mx >= button[i].position.x
				&& Control.mx < button[i].position.x + button[i].position.width
				&& Control.my >= button[i].position.y
				&& Control.my <= button[i].position.y + button[i].position.width) {
				button[i].pressed = 2;
				if (Control.currentbox > -1) {
					Control.musicbox[Control.currentbox].start++;
					if (Control.musicbox[Control.currentbox].start > Control.pianorollsize - Gfx.notesonscreen) {
						Control.musicbox[Control.currentbox].start = Control.pianorollsize - Gfx.notesonscreen;
					}
				}
			}
		} else if (currentbutton == "notescrolldown") {
			if (Control.mx >= button[i].position.x
				&& Control.mx < button[i].position.x + button[i].position.width
				&& Control.my >= button[i].position.y
				&& Control.my <= button[i].position.y + button[i].position.width) {
				button[i].pressed = 2;
				if (Control.currentbox > -1) {
					Control.musicbox[Control.currentbox].start--;
					if (Control.musicbox[Control.currentbox].start < 0) {
						Control.musicbox[Control.currentbox].start = 0;
					}
				}
			}
		}
	}

	public static function dobuttonaction(i:Int):Void {
		helpcondition_set = "nothing";
		currentbutton = button[i].action;
		button[i].press();

		if (currentbutton == "newsong") {
			Control.newsong();
			button[i].press();
		} else if (currentbutton == "logo") {
			if (!Control.musicplaying) {
				button[i].pressed = 0;
			}
		} else if (currentbutton == "play") {
			if (!Control.musicplaying) {
				Control.startmusic();
			}
		} else if (currentbutton == "pause") {
			if (Control.musicplaying) {
				Control.pausemusic();
			}
		} else if (currentbutton == "stop") {
			if (Control.musicplaying) {
				Control.stopmusic();
			}
		} else if (currentbutton == "exportlist") {
			#if (CONFIG == "desktop")
			{
				tx = (Gfx.screenwidth - 768) / 4;
				Control.filllist(Control.LIST_EXPORTS);
				Control.list.init(Gfx.screenwidth - 170 - tx, (Gfx.linespacing * 4) - 14);
			}
			#end

			#if (CONFIG == "web")
			{
				Control.exportwav();
			}
			#end
		} else if (currentbutton == "loadceol") {
			#if (CONFIG == "desktop")
			{
				Control.loadceol();
			}
			#end
		} else if (currentbutton == "saveceol") {
			#if (CONFIG == "desktop")
			{
				Control.saveceol();
			}
			#end
		} else if (currentbutton == "filetab") {
			Control.changetab(Control.MENUTAB_FILE);
		} else if (currentbutton == "arrangementstab") {
			Control.changetab(Control.MENUTAB_ARRANGEMENTS);
		} else if (currentbutton == "instrumentstab") {
			Control.changetab(Control.MENUTAB_INSTRUMENTS);
		} else if (currentbutton == "advancedtab") {
			Control.changetab(Control.MENUTAB_ADVANCED);
		} else if (currentbutton == "creditstab") {
			Control.changetab(Control.MENUTAB_CREDITS);
		} else if (currentbutton == "githubtab") {
			Control.changetab(Control.MENUTAB_GITHUB);
		} else if (currentbutton == "helptab") {
			/*
				changewindow("firstrun");
			 */
			Control.changetab(Control.MENUTAB_HELP);
		} else if (currentbutton == "barcountdown") {
			Control.barcount--;
			if (Control.barcount < 1)
				Control.barcount = 1;
		} else if (currentbutton == "barcountup") {
			Control.barcount++;
			if (Control.barcount > 32)
				Control.barcount = 32;
		} else if (currentbutton == "boxcountdown") {
			Control.boxcount--;
			if (Control.boxcount < 1)
				Control.boxcount = 1;
			Control.doublesize = Control.boxcount > 16;
			Gfx.updateboxsize();
			changetab(Control.currenttab);
		} else if (currentbutton == "boxcountup") {
			Control.boxcount++;
			if (Control.boxcount > 32)
				Control.boxcount = 32;
			Control.doublesize = Control.boxcount > 16;
			Gfx.updateboxsize();
			changetab(Control.currenttab);
		} else if (currentbutton == "bpmdown") {
			Control.bpm -= 5;
			if (Control.bpm < 10)
				Control.bpm = 10;
			Control._driver.bpm = Control.bpm;
		} else if (currentbutton == "bpmup") {
			Control.bpm += 5;
			if (Control.bpm > 220)
				Control.bpm = 220;
			Control._driver.bpm = Control.bpm;
		} else if (currentbutton == "bufferlist") {
			Control.filllist(Control.LIST_BUFFERSIZE);
			Control.list.init(210, (Gfx.linespacing * 4) + 4);
		} else if (currentbutton == "swingup") {
			Control.swing++;
			if (Control.swing > 10)
				Control.swing = 10;
		} else if (currentbutton == "swingdown") {
			Control.swing--;
			if (Control.swing < -10)
				Control.swing = -10;
		} else if (currentbutton == "effectslist") {
			tx = (Gfx.screenwidth - 768) / 4;
			Control.filllist(Control.LIST_EFFECTS);
			Control.list.init(Gfx.screenwidth - 280 - tx, (Gfx.linespacing * 4) - 3);
		} else if (currentbutton == "addnewinstrument") {
			if (Control.numinstrument < 16) {
				Control.numinstrument++;
				Control.instrumentmanagerview = Control.numinstrument - 6;
				if (Control.instrumentmanagerview < 0)
					Control.instrumentmanagerview = 0;
				Control.currentinstrument = Control.numinstrument - 1;

				helpcondition_set = "addnew_instrument"; // For Interactive tutorial
			}
		} else if (currentbutton == "addnewpattern") {
			Control.addmusicbox();
			Control.patternmanagerview = Control.numboxes - 6;
			if (Control.patternmanagerview < 0)
				Control.patternmanagerview = 0;
			helpcondition_set = "addnew_pattern"; // For Interactive tutorial
		} else if (currentbutton == "footer_instrumentlist") {
			Control.filllist(Control.LIST_SELECTINSTRUMENT);
			Control.list.init(20, (Gfx.screenheight - Gfx.linesize) - (Control.list.numitems * Gfx.linesize));
		} else if (currentbutton == "footer_scalelist") {
			Control.filllist(Control.LIST_SCALE);
			Control.list.init(Gfx.screenwidth - 360, (Gfx.screenheight - Gfx.linesize) - (Control.list.numitems * Gfx.linesize));
		} else if (currentbutton == "footer_keylist") {
			Control.filllist(Control.LIST_KEY);
			Control.list.init(Gfx.screenwidth - 60, (Gfx.screenheight - Gfx.linesize) - (Control.list.numitems * Gfx.linesize));
		} else if (currentbutton == "transposeup") {
			Control.musicbox[Control.currentbox].transpose(1);
		} else if (currentbutton == "transposedown") {
			Control.musicbox[Control.currentbox].transpose(-1);
		} else if (currentbutton == "nextinstrument") {
			Control.nextinstrument();
		} else if (currentbutton == "previousinstrument") {
			Control.previousinstrument();
		} else if (currentbutton == "loadmidi") {
			button[i].press();
			#if (CONFIG == "desktop")
			{
				// midiControl.openfile();TODO:FIXME: add -Sam!
			}
			#end
		} else if (currentbutton == "changescale") {
			button[i].press();
			Gfx.changescalemode(1 - Gfx.scalemode);
			changetab(Control.MENUTAB_ADVANCED);
		} else if (currentbutton == "closewindow") {
			changewindow("nothing");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "help1") {
			if (Control.currentbox == -1) {
				Control.currentbox = 0;
				Control.newsong();
			}

			Control.currenttab = Control.MENUTAB_FILE;
			changewindow("help1");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "help2") {
			changewindow("help2");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "help3") {
			changewindow("help3");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "help4") {
			changewindow("help4");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "help5") {
			changewindow("help5");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "help6") {
			changewindow("help6");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "help7") {
			changewindow("help7");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "help8") {
			changewindow("help8");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "help9") {
			changewindow("help9");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "help10") {
			changewindow("help10");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "help11") {
			changewindow("help11");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "help12") {
			changewindow("help12");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "help13") {
			changewindow("help13");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "help14") {
			changewindow("help14");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "help15") {
			changewindow("help15");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "help16") {
			changewindow("help16");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "help17") {
			changewindow("help17");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "help18") {
			changewindow("help18");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "endhelp") {
			changewindow("nothing");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "advancedhelp1") {
			Control.currenttab = Control.MENUTAB_FILE;

			changewindow("advancedhelp1");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "advancedhelp2") {
			changewindow("advancedhelp2");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "advancedhelp3") {
			changewindow("advancedhelp3");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "advancedhelp4") {
			changewindow("advancedhelp4");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "advancedhelp5") {
			changewindow("advancedhelp5");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "advancedhelp6") {
			changewindow("advancedhelp6");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "advancedhelp7") {
			changewindow("advancedhelp7");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "advancedhelp8") {
			changewindow("advancedhelp8");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		} else if (currentbutton == "advancedhelp9") {
			changewindow("advancedhelp9");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		}
	}

	public static var button:Array<Guibutton> = new Array<Guibutton>();
	public static var numbuttons:Int;
	public static var maxbuttons:Int;

	public static var tx:Float;
	public static var ty:Float;
	public static var timage:Int;
	public static var tw:Float;
	public static var th:Float;
	public static var currentbutton:String;
	public static var lastbutton:Int;
	public static var highlightflash:Int;

	public static var windowcheck:Bool;
	public static var windowdrag:Bool = false;
	public static var overwindow:Bool = false;
	public static var windowddx:Int;
	public static var windowddy:Int;
	public static var windowdx:Float;
	public static var windowdy:Float;
	public static var windowx:Int;
	public static var windowy:Int;
	public static var windowwidth:Int;
	public static var windowheight:Int;
	public static var windowline:Int;
	public static var windowxoffset:Int;
	public static var windowyoffset:Int;
	public static var windowtext:String;

	public static var helpwindow:String;

	public static var helpcondition_check:String;
	public static var helpcondition_set:String;

	public static var firstrun:Bool = false;
}
