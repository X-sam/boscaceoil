package;

import openfl.geom.*;

class Guibutton {
	public function new() {
		position = new Rectangle(0, 0, 0, 0);
		selected = false;
		active = false;
		visable = false;
		mouseover = false;
	}

	public function init(x:Float, y:Float, w:Float, h:Float, contents:String, act:String = "",
			sty:String = "normal"):Void {
		position.setTo(x, y, w, h);
		text = contents;
		action = act;
		style = sty;

		selected = false;
		moveable = false;
		visable = true;
		active = true;
		onwindow = false;
		textoffset = 0;
		pressed = 0;
	}

	public function press():Void {
		pressed = 6;
	}

	public var position:Rectangle;
	public var text:String;
	public var action:String;
	public var style:String;

	public var visable:Bool;
	public var mouseover:Bool;
	public var selected:Bool;
	public var active:Bool;
	public var moveable:Bool;
	public var onwindow:Bool;

	public var pressed:Int;
	public var textoffset:Int;
}
