package includes;

import bigroom.input.KeyPoll;

class Logic {
	public static function logic(key:KeyPoll):Void {
		var i:Int;
		var j:Int;
		var k:Int;

		if (Control.arrangescrolldelay > 0) {
			Control.arrangescrolldelay--;
		}

		if (Control.messagedelay > 0) {
			Control.messagedelay -= 2;
			if (Control.messagedelay < 0)
				Control.messagedelay = 0;
		}
		if (Control.doubleclickcheck > 0) {
			Control.doubleclickcheck -= 2;
			if (Control.doubleclickcheck < 0)
				Control.doubleclickcheck = 0;
		}
		if (Gfx.buttonpress > 0) {
			Gfx.buttonpress -= 2;
			if (Gfx.buttonpress < 0)
				Gfx.buttonpress = 0;
		}

		if (Control.minresizecountdown > 0) {
			Control.minresizecountdown -= 2;
			if (Control.minresizecountdown <= 0) {
				Control.minresizecountdown = 0;
				Gfx.forceminimumsize();
			}
		}

		if (Control.savescreencountdown > 0) {
			Control.savescreencountdown -= 2;
			if (Control.savescreencountdown <= 0) {
				Control.savescreencountdown = 0;
				Control.savescreensettings();
			}
		}

		if (Control.dragaction == 2) {
			Control.trashbutton += 2;
			if (Control.trashbutton > 10)
				Control.trashbutton = 10;
		} else {
			if (Control.trashbutton > 0)
				Control.trashbutton--;
		}

		if (Control.followmode) {
			if (Control.arrange.currentbar < Control.arrange.viewstart) {
				Control.arrange.viewstart = Control.arrange.currentbar;
			}
			if (Control.arrange.currentbar > Control.arrange.viewstart + 5) {
				Control.arrange.viewstart = Control.arrange.currentbar;
			}
		}
	}
}
