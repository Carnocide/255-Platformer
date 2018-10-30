package code {

	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.ui.Keyboard;

	/** 
	 *The player class holds varius pieces of state for the player.
	 * The player class also handles physica for the player
	*/
	public class Player extends MovieClip {
		/** Gravity, the downward force that pushes the player toward the ground */
		private var gravity: Point = new Point(0, 600);
		/** The Maximum speed of the player in the horizontal direction */
		private var maxSpeed: Number = 200;
		private var velocity: Point = new Point(1, 5);

		private const HORIZONTAL_ACCELERATION: Number = 800;
		private const HORIZONTAL_DECELERATION: Number = 800;
		private const VERTICAL_ACCELERATION: Number = 1600;
		private const AIR_JUMPS_MAX: int = 1;

		/** Wheteher or not the player is moving upward in a jump. This affects gravity. */
		private var isJumping = false;
		private var airJumpCounter: int = 1;
		private var jumpAmount: Number = 400;

		private var isGrounded = false;

		public function Player() {
			// constructor code
		} // ends constructor

		public function update(): void {
			handleWalking();
			doPhysics();
			detectGround();
			handleJumping();

		}
		/**
		 * This function looks at the keyboard input in order to accelerate the player
		 * left or right. As a result, this function changes the player's velocity.
		 */
		private function handleWalking(): void {
			if (KeyboardInput.IsKeyDown(Keyboard.LEFT)) velocity.x -= HORIZONTAL_ACCELERATION * Time.dt;
			if (KeyboardInput.IsKeyDown(Keyboard.RIGHT)) velocity.x += HORIZONTAL_ACCELERATION * Time.dt;

			if (!KeyboardInput.IsKeyDown(Keyboard.LEFT) && !KeyboardInput.IsKeyDown(Keyboard.RIGHT)) { // left and right not being pressed...
				if (velocity.x < 0) { // moving left
					velocity.x += HORIZONTAL_DECELERATION * Time.dt; // accelerate right
					if (velocity.x > 0) velocity.x = 0; // clamp at 0
				}
				if (velocity.x > 0) { // moving right
					velocity.x -= HORIZONTAL_DECELERATION * Time.dt; // accelerate left
					if (velocity.x < 0) velocity.x = 0; // clamp at 0
				}
			}

		}


		private function handleJumping(): void {
			if (KeyboardInput.OnKeyDown(Keyboard.SPACE)) {
				//if(jumpCounter > 0) velocity.y = -200;

				/*				jumpCounter--;*/
				if (isGrounded) {
					velocity.y = -400;
					isGrounded = false;
					isJumping = true;
				} else { // in the air, attempting a double jump
					if (airJumpCounter > 0) {
						velocity.y = -400;
						airJumpCounter--;
						isJumping = true;
					}

				}
			}
			if(!KeyboardInput.IsKeyDown(Keyboard.SPACE)) isJumping = false;
			if(velocity.y > 0) isJumping = false
		}

		private function doPhysics(): void {


			var gravityMultiplier: Number = 1;

			if (!isJumping) gravityMultiplier = 2;
			// apply gravity to velocity:
			//velocity.x += gravity.x * Time.dt * gravityMultiplier;
			velocity.y += gravity.y * Time.dt * gravityMultiplier;

			// constrain to maxSpeed:
			if (velocity.x > maxSpeed) velocity.x = maxSpeed; // clamp going right
			if (velocity.x < -maxSpeed) velocity.x = -maxSpeed; // clamp going left

			// apply velocity to position:
			x += velocity.x * Time.dt;
			y += velocity.y * Time.dt;
		}
		private function detectGround(): void {
			// look at y position
			var ground: Number = 350;
			if (y > ground) {
				y = ground; // clamp
				velocity.y = 0;
				airJumpCounter = AIR_JUMPS_MAX;
				isGrounded = true;
			}
		}


	} // ends Player class

} // ends package