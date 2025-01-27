﻿/**
 * Key polling class
 * 
 * To create:
 * var key:KeyPoll = new KeyPoll( displayObject );
 * 
 * the display object will usually be the stage.
 *
 * Full example:
 * package
 *  {
 *  	import flash.display.Sprite;
 *  	import flash.events.Event;
 *  	import flash.ui.Keyboard;
 *  	import fgc.input.KeyPoll;
 *  	
 *  	public class Test 
 *  	{
 *  		var key:KeyPoll;
 *  		
 *  		public function Test()
 *  		{
 *  			key = new KeyPoll( this.stage );
 *  			addEventListener( Event.ENTER_FRAME, enterFrame );
 *  		}
 *  		
 *  		public function enterFrame( ev:Event ):void
 *  		{
 *  			if( key.isDown( Keyboard.LEFT ) )
 *  			{
 *  				trace( "left key is down" );
 *  			}
 *  			if( key.isDown( Keyboard.RIGHT ) )
 *  			{
 *  				trace( "right key is down" );
 *  			}
 *  		}
 *  	}
 *  }
 * 
 * Author: Richard Lord
 * Copyright (c) FlashcontrolCode.net 2007
 * Version 1.0.2
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package bigroom.input;

import flash.events.KeyboardEvent;
import flash.events.Event;
import flash.display.DisplayObject;
import flash.utils.ByteArray;
import flash.events.MouseEvent;

class KeyPoll {
	private var states:ByteArray;
	private var dispObj:DisplayObject;

	public var click:Bool = false;
	public var hasclicked:Bool = false;
	public var hasreleased:Bool = false;
	public var press:Bool = false;
	public var rightclick:Bool = false;
	public var hasrightclicked:Bool = false;
	public var rightpress:Bool = false;
	public var middleclick:Bool = false;
	public var hasmiddleclicked:Bool = false;
	public var hasmiddlereleased:Bool = false;
	public var middlepress:Bool = false;
	public var onscreen:Bool = true;
	public var mousewheel:Int = 0;

	public var shiftheld:Bool = false;
	public var ctrlheld:Bool = false;

	public function new(obj:DisplayObject) {
		states = new ByteArray();
		states.writeUnsignedInt(0);
		states.writeUnsignedInt(0);
		states.writeUnsignedInt(0);
		states.writeUnsignedInt(0);
		states.writeUnsignedInt(0);
		states.writeUnsignedInt(0);
		states.writeUnsignedInt(0);
		states.writeUnsignedInt(0);
		dispObj = obj;
		dispObj.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener, false, 0, true);
		dispObj.addEventListener(KeyboardEvent.KEY_UP, keyUpListener, false, 0, true);
		dispObj.addEventListener(Event.ACTIVATE, activateListener, false, 0, true);
		dispObj.addEventListener(Event.DEACTIVATE, deactivateListener, false, 0, true);
		dispObj.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
		dispObj.addEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
		dispObj.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, mouserightDownListener);
		dispObj.addEventListener(MouseEvent.RIGHT_MOUSE_UP, mouserightUpListener);
		dispObj.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, mousemiddleDownListener);
		dispObj.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, mousemiddleUpListener);
		dispObj.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		dispObj.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
		dispObj.addEventListener(MouseEvent.MOUSE_WHEEL, mousewheelHandler);
	}

	public function mousewheelHandler(e:MouseEvent):Void {
		mousewheel = e.delta;
	}

	public function mouseOverHandler(e:MouseEvent):Void {
		onscreen = true;
	}

	public function mouseOutHandler(e:MouseEvent):Void {
		onscreen = false;
	}

	public function releaseall():Void {
		press = false;
		click = false;
		hasclicked = false;
		hasreleased = true;
		middlepress = false;
		middleclick = false;
		hasmiddleclicked = false;
		hasmiddlereleased = true;
		rightpress = false;
		rightclick = false;
		hasrightclicked = false;
	}

	public function mouseUpListener(e:MouseEvent):Void {
		press = false;

		click = false;
		hasclicked = false;
		hasreleased = true;

		if (shiftheld || middlepress) {
			// Middle click
			middlepress = false;

			middleclick = false;
			hasmiddleclicked = false;
			hasmiddlereleased = true;
		}

		if (ctrlheld || rightpress) {
			// Right click
			rightpress = false;

			rightclick = false;
			hasrightclicked = false;
		}
	}

	public function mouseDownListener(e:MouseEvent):Void {
		press = true;

		click = true;
		hasclicked = true;
		hasreleased = false;

		if (shiftheld) {
			// Middle click
			middlepress = true;

			middleclick = true;
			hasmiddleclicked = true;
			hasmiddlereleased = false;
		}

		if (ctrlheld) {
			// Right click
			rightpress = true;

			rightclick = true;
			hasrightclicked = true;
		}
	}

	public function mouserightUpListener(e:MouseEvent):Void {
		rightpress = false;

		rightclick = false;
		hasrightclicked = false;
	}

	public function mouserightDownListener(e:MouseEvent):Void {
		rightpress = true;

		rightclick = true;
		hasrightclicked = true;
	}

	public function mousemiddleUpListener(e:MouseEvent):Void {
		middlepress = false;

		middleclick = false;
		hasmiddleclicked = false;
		hasmiddlereleased = true;
	}

	public function mousemiddleDownListener(e:MouseEvent):Void {
		middlepress = true;

		middleclick = true;
		hasmiddleclicked = true;
		hasmiddlereleased = false;
	}

	private function keyDownListener(ev:KeyboardEvent):Void {
		states[ev.keyCode >>> 3] |= 1 << (ev.keyCode & 7);

		if (ev.keyCode == 16)
			shiftheld = true;
		if (ev.keyCode == 17)
			ctrlheld = true;
		if (ev.keyCode == 27) {
			ev.preventDefault();
		}
	}

	private function keyUpListener(ev:KeyboardEvent):Void {
		states[ev.keyCode >>> 3] &= ~(1 << (ev.keyCode & 7));

		if (ev.keyCode == 16)
			shiftheld = false;
		if (ev.keyCode == 17)
			ctrlheld = false;
	}

	private function activateListener(ev:Event):Void {
		for (i in 0...8) {
			states[i] = 0;
		}
	}

	private function deactivateListener(ev:Event):Void {
		for (i in 0...8) {
			states[i] = 0;
		}
	}

	public function isDown(keyCode:UInt):Bool {
		return (states[keyCode >>> 3] & (1 << (keyCode & 7))) != 0;
	}

	public function isUp(keyCode:UInt):Bool {
		return (states[keyCode >>> 3] & (1 << (keyCode & 7))) == 0;
	}
}
