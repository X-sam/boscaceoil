package includes;

import bigroom.input.KeyPoll;
import openfl.ui.Keyboard;
import Main;

class Keypoll {
	public static function generickeypoll(key:KeyPoll, main:Main):Void {
		Control.press_up = false;

		Control.press_down = false;
		Control.press_left = false;
		Control.press_right = false;
		Control.press_space = false;
		Control.press_enter = false;
		if (key.isDown(Keyboard.LEFT) || key.isDown(Keyboard.A))
			Control.press_left = true;
		if (key.isDown(Keyboard.RIGHT) || key.isDown(Keyboard.D))
			Control.press_right = true;
		if (key.isDown(Keyboard.UP) || key.isDown(Keyboard.W))
			Control.press_up = true;
		if (key.isDown(Keyboard.DOWN) || key.isDown(Keyboard.S))
			Control.press_down = true;
		if (key.isDown(Keyboard.SPACE))
			Control.press_space = true;
		if (key.isDown(Keyboard.ENTER))
			Control.press_enter = true;
		Control.keypriority = 0;
		if (Control.keypriority == 3) {
			Control.press_up = false;
			Control.press_down = false;
		} else if (Control.keypriority == 4) {
			Control.press_left = false;
			Control.press_right = false;
		}
		if ((key.isDown(15) || key.isDown(17)) && key.isDown(70) && !Control.fullscreentoggleheld) {
			// Toggle fullscreen
			Control.fullscreentoggleheld = true;
			if (Control.fullscreen) {
				Control.fullscreen = false;
			} else {
				Control.fullscreen = true;
			}
			main.updategraphicsmode();
		}
		if (Control.fullscreentoggleheld) {
			if (!key.isDown(15) && !key.isDown(17) && !key.isDown(70)) {
				Control.fullscreentoggleheld = false;
			}
		}
		if (Control.keyheld) {
			if (Control.press_space || Control.press_right || Control.press_left || Control.press_enter || Control.press_down || Control.press_up) {
				Control.press_space = false;
				Control.press_enter = false;
				Control.press_up = false;
				Control.press_down = false;
				Control.press_left = false;
				Control.press_right = false;
			} else {
				Control.keyheld = false;
			}
		}
		if (Control.press_space || Control.press_right || Control.press_left || Control.press_enter || Control.press_down || Control.press_up) {
			// Update screen when there is input.
			Gfx.updatebackground = 5;
		}
	}
}
