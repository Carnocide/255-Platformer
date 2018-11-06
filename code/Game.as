package code {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;


	public class Game extends MovieClip {

		public static var platforms: Array = new Array();

		public function Game() {
			KeyboardInput.setup(stage);
			addEventListener(Event.ENTER_FRAME, gameLoop);
		}
		private function gameLoop(e: Event): void {
			Time.update();
			player.update();

			doCollisionDetection();

			KeyboardInput.update();
		} // ends gameLoop()


		private function doCollisionDetection(): void {
			for (var i: int = 0; i < platforms.length; i++) {

				if (player.collider.checkOverlap(platform.collider)) {
					var fix: Point = player.collider.findOverlapFix(platforms[i].collider);
					player.applyFix(fix);
				}
			}


		}


	} // ends Game class

} // ends package