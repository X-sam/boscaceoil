package co.sparemind.trackermodule;

import haxe.ds.Vector;

class XMPatternLine {
	public var cellOnTrack:Vector<XMPatternCell>;

	public function new(numtracks:Int) {
		cellOnTrack = new Vector<XMPatternCell>(numtracks);
		for (i in 0...numtracks) {
			cellOnTrack[i] = new XMPatternCell();
		}
	}
}
