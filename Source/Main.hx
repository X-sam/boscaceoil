package;

import haxe.Log;
import openfl.display.Sprite;
import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;
import openfl.media.*;
// import openfl.ui.ContextMenu;
// import openfl.ui.ContextMenuItem;
import openfl.ui.Keyboard;
import bigroom.input.KeyPoll;
import openfl.ui.Mouse;
import openfl.Assets;
import openfl.Lib.getTimer;
import openfl.utils.Timer;
#if (CONFIG == "desktop")
// import openfl.desktop.NativeApplication;
#end
#if (CONFIG == "web")
import openfl.external.ExternalInterface;
#end
import includes.Input.input;
import includes.Logic.logic;
import includes.Render.render;
// import Control;
import Gfx;

class Main extends Sprite {
	public function new():Void {
		super();
		_rate = 1000 / TARGET_FPS; // how long (in seconds) each frame is
		_skip = _rate * 10; // this tells us to allow a maximum of 10 frame skips
		Control.versionnumber = "v2.1 unstable"; // Version number displayed beside logo
		Control.version = 3; // Version number used by file
		Control.ctrl = "Ctrl"; // Set this to Cmd on Mac so that the tutorial is correct

		#if (CONFIG == "NONE") // "desktop") //todo:addme -Sam!
		{
			NativeApplication.nativeApplication.setAsDefaultApplication("ceol");
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvokeEvent);
		}
		#end

		key = new KeyPoll(stage);
		Control.init();

		// Working towards resolution independence!
		Gfx.init(stage);

		#if (CONFIG == "desktop")
		{
			stage.addEventListener(Event.RESIZE, handleResize);
		}
		#end

		var im_icons = Assets.getBitmapData('images/icons.png');
		var im_logo0 = Assets.getBitmapData('images/logo_blue.png');
		var im_logo1 = Assets.getBitmapData('images/logo_purple.png');
		var im_logo2 = Assets.getBitmapData('images/logo_red.png');
		var im_logo3 = Assets.getBitmapData('images/logo_orange.png');
		var im_logo4 = Assets.getBitmapData('images/logo_green.png');
		var im_logo5 = Assets.getBitmapData('images/logo_cyan.png');
		var im_logo6 = Assets.getBitmapData('images/logo_gray.png');
		var im_logo7 = Assets.getBitmapData('images/logo_shadow.png');

		var tempbmp:BitmapData;
		Gfx.buffer = im_icons;
		Gfx.makeiconarray();
		tempbmp = im_logo0;
		Gfx.buffer = tempbmp;
		Gfx.addimage();
		tempbmp = im_logo1;
		Gfx.buffer = tempbmp;
		Gfx.addimage();
		tempbmp = im_logo2;
		Gfx.buffer = tempbmp;
		Gfx.addimage();
		tempbmp = im_logo3;
		Gfx.buffer = tempbmp;
		Gfx.addimage();
		tempbmp = im_logo4;
		Gfx.buffer = tempbmp;
		Gfx.addimage();
		tempbmp = im_logo5;
		Gfx.buffer = tempbmp;
		Gfx.addimage();
		tempbmp = im_logo6;
		Gfx.buffer = tempbmp;
		Gfx.addimage();
		tempbmp = im_logo7;
		Gfx.buffer = tempbmp;
		Gfx.addimage();

		// Embedded resources:
		var im_tutorialimage0 = Assets.getBitmapData('images/tutorial_longnote.png');
		var im_tutorialimage1 = Assets.getBitmapData('images/tutorial_drag.png');
		var im_tutorialimage2 = Assets.getBitmapData('images/tutorial_timelinedrag.png');
		var im_tutorialimage3 = Assets.getBitmapData('images/tutorial_patterndrag.png');
		var im_tutorialimage4 = Assets.getBitmapData('images/tutorial_secret.png');
		tempbmp = im_tutorialimage0;
		Gfx.buffer = tempbmp;
		Gfx.addimage();
		tempbmp = im_tutorialimage1;
		Gfx.buffer = tempbmp;
		Gfx.addimage();
		tempbmp = im_tutorialimage2;
		Gfx.buffer = tempbmp;
		Gfx.addimage();
		tempbmp = im_tutorialimage3;
		Gfx.buffer = tempbmp;
		Gfx.addimage();
		tempbmp = im_tutorialimage4;
		Gfx.buffer = tempbmp;
		Gfx.addimage();
		Gfx.buffer = new BitmapData(1, 1, false, 0x000000);

		Control.changetab(Control.MENUTAB_FILE);

		Control.voicelist.fixlengths();
		stage.fullScreenSourceRect = null;
		addChild(Gfx.screen);

		Control.loadscreensettings();
		Control.loadfilesettings();
		updategraphicsmode();

		Gfx.changescalemode(Gfx.scalemode);

		if (Guiclass.firstrun) {
			Guiclass.changewindow("firstrun");
			Control.changetab(Control.currenttab);
			Control.clicklist = true;
		}

		#if (CONFIG == "desktop")
		{
			_startMainLoop();
		}
		#end

		#if (CONFIG == "web")
		{
			if (ExternalInterface.available) {
				if (ExternalInterface.call("Bosca._isReady")) {
					_startMainLoopWeb();
				} else {
					// If the container is not ready, set up a Timer to call the
					// container at 100ms intervals. Once the container responds that
					// it's ready, the timer will be stopped.
					var containerIsReadyTimer:Timer = new Timer(100);
					containerIsReadyTimer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):Void {
						if (ExternalInterface.call("Bosca._isReady")) {
							Timer(e.target).stop();
							_startMainLoopWeb();
						}
					});
					containerIsReadyTimer.start();
				}
			}
		}
		#end
	}

	private function handleResize(e:Dynamic):Void {
		// adjust the gui to fit the new device resolution
		var tempwidth:Dynamic /*:Int*/;
		var tempheight:Dynamic /*:Int*/;
		if (e != null) {
			e.preventDefault();
			tempwidth = e.target.stageWidth;
			tempheight = e.target.stageHeight;
		} else {
			tempwidth = Gfx.windowwidth;
			tempheight = Gfx.windowheight;
		}

		Control.savescreencountdown = 30; // Half a second after a resize, save the settings
		Control.minresizecountdown = 5; // Force a minimum screensize
		Gfx.changewindowsize(tempwidth, tempheight);

		Gfx.patternmanagerx = Gfx.screenwidth - 116;
		Gfx.patterneditorheight = Std.int((Gfx.windowheight - (Gfx.pianorollposition - (Gfx.linesize + 2))) / 12);
		Gfx.notesonscreen = Std.int(((Gfx.screenheight - Gfx.pianorollposition - Gfx.linesize) / Gfx.linesize)) + 1;
		Gfx.tf_1.width = Gfx.windowwidth;
		Gfx.updateboxsize();

		Guiclass.changetab(Control.currenttab);

		var temp:BitmapData = new BitmapData(Gfx.windowwidth, Gfx.windowheight, false, 0x000000);
		Gfx.updatebackground = 5;
		Gfx.backbuffercache = new BitmapData(Gfx.windowwidth, Gfx.windowheight, false, 0x000000);
		temp.copyPixels(Gfx.backbuffer, Gfx.backbuffer.rect, Gfx.tl);
		Gfx.backbuffer = temp;
		// Gfx.screen.bitmapData.dispose();
		Gfx.screen.bitmapData = Gfx.backbuffer;
		if (Gfx.scalemode == 1) {
			Gfx.screen.scaleX = 1.5;
			Gfx.screen.scaleY = 1.5;
		} else {
			Gfx.screen.scaleX = 1;
			Gfx.screen.scaleY = 1;
		}
	}

	private function _startMainLoop():Void {
		#if (CONFIG == "desktop")
		{
			addEventListener(Event.DEACTIVATE, __deactivate__);
			addEventListener(Event.ACTIVATE, __activate__);
			// NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, __activate__); TODO:FIXME: add -Sam!
			// NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, __deactivate__);
		}
		#end
		#if (CONFIG == "web")
		{
			addEventListener(Event.DEACTIVATE, __activate__);
			addEventListener(Event.ACTIVATE, __deactivate__);
		}
		#end

		_timer.addEventListener(TimerEvent.TIMER, mainloop);
		_timer.start();
	}

	private function __activate__(event:Event):Void {
		Gfx.changeframerate(30);
	}

	private function __deactivate__(event:Event):Void {
		Gfx.changeframerate(1);
	}

	#if (CONFIG == "web")
	{
		private function _startMainLoopWeb():Void {
			// Expose some functions to external JS
			ExternalInterface.addCallback("getCeolString", Control.getCeolString);
			ExternalInterface.addCallback("invokeCeolWeb", Control.invokeCeolWeb);
			ExternalInterface.addCallback("newSong", Control.newsong);
			ExternalInterface.addCallback("exportWav", Control.exportwav);

			Control.invokeCeolWeb(ExternalInterface.call("Bosca._getStartupCeol"));

			_startMainLoop();
		}
	}
	#end
	public function _input():Void {
		if (Gfx.scalemode == 1) {
			Control.mx = mouseX / 1.5;
			Control.my = mouseY / 1.5;
		} else {
			Control.mx = mouseX;
			Control.my = mouseY;
		}

		input(key, this);
	}

	public function _logic():Void {
		logic(key);
		Help.updateglow();
		if (Control.forceresize) {
			Control.forceresize = false;
			handleResize(null);
		}
	}

	public function _render():Void {
		Gfx.backbuffer.lock();
		render(key);
	}

	public function mainloop(e:TimerEvent):Void {
		_current = getTimer();
		if (_last < 0)
			_last = _current;
		_delta += _current - _last;
		_last = _current;
		if (_delta >= _rate) {
			_delta %= _skip;
			while (_delta >= _rate) {
				_delta -= _rate;
				_input();
				_logic();
				if (key.hasclicked)
					key.click = false;
				if (key.hasrightclicked)
					key.rightclick = false;
				if (key.hasmiddleclicked)
					key.middleclick = false;
			}
			_render();

			e.updateAfterEvent();
		}
	}

	public function updategraphicsmode():Void {
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;

		if (Control.fullscreen) {
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		} else {
			stage.displayState = StageDisplayState.NORMAL;
		}

		Control.savescreensettings();
	}

	#if (CONFIG == "NONE") // "desktop") TODO:FIXME: add -Sam!
	public function onInvokeEvent(event:InvokeEvent):Void {
		if (event.arguments.length > 0) {
			if (event.currentDirectory != null) {
				// set file directory to current directory
				Control.filepath = event.currentDirectory;
			}
			if (Control.startup == 0) {
				// Loading a song at startup, wait until the sound is initilised
				Control.invokefile = event.arguments[0];
			} else {
				// Program is up and running, just load now
				Control.invokeceol(event.arguments[0]);
			}
		}
	}
	#end

	public var key:KeyPoll;

	// Timer information (a shout out to ChevyRay for the implementation)
	public static inline var TARGET_FPS:Dynamic /*:Float*/ = 30; // the fixed-FPS we want the Control to run at

	private var _rate:Dynamic /*:Float*/; // how long (in seconds) each frame is
	private var _skip:Dynamic /*:Float*/; // this tells us to allow a maximum of 10 frame skips
	private var _last:Dynamic /*:Float*/ = -1;
	private var _current:Dynamic /*:Float*/ = 0;
	private var _delta:Dynamic /*:Float*/ = 0;
	private var _timer:Timer = new Timer(4);
}
