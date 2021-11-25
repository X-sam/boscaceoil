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

	public function init(xp:Dynamic /*:Int*/, yp:Dynamic /*:Int*/):Void {
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
		var temp:Dynamic /*:Int*/;
		for (i in 0...numitems) {
			temp = Gfx.len(item[i]);
			if (w < temp)
				w = temp;
		}
		w += 10;
	}

	public var item:Array<String> = new Array<String>();
	public var numitems:Dynamic /*:Int*/;
	public var active:Bool;
	public var x:Dynamic /*:Int*/;
	public var y:Dynamic /*:Int*/;
	public var w:Dynamic /*:Int*/;
	public var h:Dynamic /*:Int*/;
	public var type:Dynamic /*:Int*/;
	public var selection:Dynamic /*:Int*/;
}
