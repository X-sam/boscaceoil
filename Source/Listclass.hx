package;

import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;

class Listclass {
	public function new():Void {
		for (i in 0...30) {
			item.push("");
		}
		clear();
	}

	public function clear():Void {
		numitems = 0;
		active = false;
		x = 0;
		y = 0;
		selection = -1;
	}

	public function init(xp:Float, yp:Float):Void {
		x = xp;
		y = yp;
		active = true;
		getwidth();
		h = numitems * Gfx.linesize;
	}

	public function close():Void {
		active = false;
	}

	public function getwidth():Void {
		w = 0;
		var temp:Int;
		for (i in 0...numitems) {
			temp = Gfx.len(item[i]);
			if (w < temp)
				w = temp;
		}
		w += 10;
	}

	public var item:Array<String> = new Array<String>();
	public var numitems:Int;
	public var active:Bool;
	public var x:Float;
	public var y:Float;
	public var w:Float;
	public var h:Float;
	public var type:Int;
	public var selection:Int;
}
