package;

import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;

class Help {
	public static function init():Void {
		glow = 0;
		glowdir = 0;
		slowsine = 0;
	}

	public function RGB(red:Dynamic /*:Float*/, green:Dynamic /*:Float*/, blue:Dynamic /*:Float*/):Dynamic /*:Float*/ {
		return (Std.int(blue) | (Std.int(green) << 8) | (Std.int(red) << 16));
	}

	public static function removeObject(obj:Dynamic, arr:Array<Dynamic>):Void {
		var i:String;
		for (i in arr) {
			if (arr[i] == obj) {
				arr.splice(i, 1);
				break;
			}
		}
	}

	public static function updateglow():Void {
		slowsine += 2;
		if (slowsine >= 64)
			slowsine = 0;

		if (glowdir == 0) {
			glow += 2;
			if (glow >= 63)
				glowdir = 1;
		} else {
			glow -= 2;
			if (glow < 1)
				glowdir = 0;
		}
	}

	public static function inbox(xc:Dynamic /*:Int*/, yc:Dynamic /*:Int*/, x1:Dynamic /*:Int*/, y1:Dynamic /*:Int*/, x2:Dynamic /*:Int*/,
			y2:Dynamic /*:Int*/):Bool {
		if (xc >= x1 && xc <= x2) {
			if (yc >= y1 && yc <= y2) {
				return true;
			}
		}
		return false;
	}

	public static function inboxw(xc:Dynamic /*:Int*/, yc:Dynamic /*:Int*/, x1:Dynamic /*:Int*/, y1:Dynamic /*:Int*/, x2:Dynamic /*:Int*/,
			y2:Dynamic /*:Int*/):Bool {
		if (xc >= x1 && xc <= x1 + x2) {
			if (yc >= y1 && yc <= y1 + y2) {
				return true;
			}
		}
		return false;
	}

	public static function Instr(s:String, c:String, start:Dynamic /*:Int*/ = 1):Dynamic /*:Int*/ {
		return (s.indexOf(c, cast start - 1) + 1);
	}

	public static function Mid(s:String, start:Dynamic /*:Int*/ = 0, length:Dynamic /*:Int*/ = 1):String {
		return s.substr(start, length);
	}

	public static function Left(s:String, length:Dynamic /*:Int*/ = 1):String {
		return s.substr(0, length);
	}

	public static function Right(s:String, length:Dynamic /*:Int*/ = 1):String {
		return s.substr(cast s.length - length, length);
	}

	public static var glow:Dynamic /*:Int*/;
	public static var slowsine:Dynamic /*:Int*/;
	public static var glowdir:Dynamic /*:Int*/;
}
