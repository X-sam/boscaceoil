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

	public function RGB(red:Float, green:Float, blue:Float):Float {
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

	public static function inbox(xc:Int, yc:Int, x1:Int, y1:Int, x2:Int,
			y2:Int):Bool {
		if (xc >= x1 && xc <= x2) {
			if (yc >= y1 && yc <= y2) {
				return true;
			}
		}
		return false;
	}

	public static function inboxw(xc:Float, yc:Float, x1:Float, y1:Float, x2:Float,
			y2:Float):Bool {
		if (xc >= x1 && xc <= x1 + x2) {
			if (yc >= y1 && yc <= y1 + y2) {
				return true;
			}
		}
		return false;
	}

	public static function Instr(s:String, c:String, start:Int = 1):Int {
		return (s.indexOf(c, cast start - 1) + 1);
	}

	public static function Mid(s:String, start:Int = 0, length:Int = 1):String {
		return s.substr(start, length);
	}

	public static function Left(s:String, length:Int = 1):String {
		return s.substr(0, length);
	}

	public static function Right(s:String, length:Int = 1):String {
		return s.substr(cast s.length - length, length);
	}

	public static var glow:Int;
	public static var slowsine:Int;
	public static var glowdir:Int;
}
