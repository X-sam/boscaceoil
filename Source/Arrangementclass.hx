package;

import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;

class Arrangementclass {
	public function new():Void {
		for (i in 0...1000) {
			bar.push(new Barclass());
		}
		for (i in 0...100) {
			copybuffer.push(new Barclass());
		}
		copybuffersize = 0;

		for (i in 0...8) {
			channelon.push(true);
		}
		clear();
	}

	public function copy():Void {
		for (i in loopstart...loopend) {
			for (j in 0...8) {
				copybuffer[cast i - loopstart].channel[j] = bar[i].channel[j];
			}
		}
		copybuffersize = loopend - loopstart;
	}

	public function paste(t:Int):Void {
		for (i in 0...copybuffersize) {
			insertbar(t);
		}

		for (i in t...(t + copybuffersize)) {
			for (j in 0...8) {
				bar[i].channel[j] = copybuffer[cast i - t].channel[j];
			}
		}
	}

	public function clear():Void {
		loopstart = 0;
		loopend = 1;
		currentbar = 0;

		for (i in 0...lastbar) {
			for (j in 0...8) {
				bar[i].channel[j] = -1;
			}
		}

		lastbar = 1;
	}

	public function addpattern(a:Int, b:Int, t:Int):Void {
		bar[a].channel[b] = t;
		if (a + 1 > lastbar)
			lastbar = a + 1;
	}

	public function removepattern(a:Int, b:Int):Void {
		bar[a].channel[b] = -1;
		var lbcheck:Int = 0;
		for (i in 0...lastbar) {
			for (j in 0...8) {
				if (bar[i].channel[j] > -1) {
					lbcheck = i;
				}
			}
		}
		lastbar = lbcheck + 1;
	}

	public function insertbar(t:Int):Void {
		var i:Int = lastbar + 1;
		while (i > t) {
			for (j in 0...8) {
				bar[i].channel[j] = bar[i - 1].channel[j];
			}
			i--;
		}
		for (j in 0...8) {
			bar[t].channel[j] = -1;
		}
		lastbar++;
	}

	public function deletebar(t:Int):Void {
		for (i in t...(lastbar + 1)) {
			for (j in 0...8) {
				bar[i].channel[j] = bar[i + 1].channel[j];
			}
		}
		lastbar--;
	}

	public var copybuffer:Array<Barclass> = new Array<Barclass>();
	public var copybuffersize:Int;

	public var bar:Array<Barclass> = new Array<Barclass>();
	public var channelon:Array<Bool> = new Array<Bool>();
	public var loopstart:Int;
	public var loopend:Int;
	public var currentbar:Int;

	public var lastbar:Int;

	public var viewstart:Int;
}
