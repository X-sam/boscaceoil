package co.sparemind.trackermodule;

import haxe.ds.Vector;

class XMPattern {
	public var rows:Vector<XMPatternLine>;

	public function new(numrows:Int) {
		rows = new Vector<XMPatternLine>(numrows);
	}
}
