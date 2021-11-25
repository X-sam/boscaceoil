package;

import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;

class Paletteclass {
	public function new():Void {
		r = 0;
		g = 0;
		b = 0;
	}

	public function setto(r1:Dynamic /*:Int*/, g1:Dynamic /*:Int*/, b1:Dynamic /*:Int*/):Void {
		r = r1;
		g = g1;
		b = b1;
		fixbounds();
	}

	public function transition(r1:Dynamic /*:Int*/, g1:Dynamic /*:Int*/, b1:Dynamic /*:Int*/, ?speed:Dynamic /*:Int*/):Void {
		if (speed == null)
			speed = 5;
		if (r < r1) {
			r += speed;
			if (r > r1)
				r = r1;
		}
		if (g < g1) {
			g += speed;
			if (g > g1)
				g = g1;
		}
		if (b < b1) {
			b += speed;
			if (b > b1)
				b = b1;
		}

		if (r > r1) {
			r -= speed;
			if (r < r1)
				r = r1;
		}
		if (g > g1) {
			g -= speed;
			if (g < g1)
				g = g1;
		}
		if (b > b1) {
			b -= speed;
			if (b < b1)
				b = b1;
		}

		fixbounds();
	}

	public function fixbounds():Void {
		if (r <= 0)
			r = 0;
		if (g <= 0)
			g = 0;
		if (b <= 0)
			b = 0;
		if (r > 255)
			r = 255;
		if (g > 255)
			g = 255;
		if (b > 255)
			b = 255;
	}

	public var r:Dynamic /*:Int*/;
	public var g:Dynamic /*:Int*/;
	public var b:Dynamic /*:Int*/;
}
