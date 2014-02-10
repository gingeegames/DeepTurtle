package com.gingee.deepTurtle.managers
{
	import com.gingeegames.animator.Animator;
	import com.gingeegames.gamologee.guiModule.settings.GuiModuleSettings;
	import com.gingeegames.interfaces.IAdvanceable;
	import com.gingee.deepTurtle.settingsAndEnum.GameSettings;

	public class SpeedManager implements IAdvanceable
	{
		// ........... class members .................................
		
		private var _xSpeed:Number = GameSettings.GAME_SPEED;
		private var _xSpeedMultiplier:Number;
		
		private var _ySpeed:Number = 0;
		private var _yForce:Number = 0;
		
		public function SpeedManager(l:LKR)
		{
			if(!l)
				throw new Error('illegal instanciation of a singleton object!');
		}

		public function advance():Boolean
		{
			// if there is a vertical force, reduce it. a simplified representation for friction & gravity.
			if(_yForce < 0)
				_yForce += GameSettings.FORCE_DECAY;
			else if(_yForce != 0)
				_yForce = 0; // make sure vertical force = 0 eventually.
			
			// calculate integral vertical force
			const f:Number = GameSettings.GRAVITY + _yForce;
			
			// devides the aggragated force by the FPS factor
			_ySpeed += f/(GuiModuleSettings.STAGE_REF.frameRate);
			
			// if there is a horizontal force, reduce it. a simplified representation for friction.
			if(_xSpeedMultiplier > 1)
			{
				_xSpeedMultiplier -= GameSettings.X_SPEED_DECAY;
				_xSpeed = GameSettings.GAME_SPEED*_xSpeedMultiplier;
			}
			else if(_xSpeedMultiplier != 1)
				_xSpeedMultiplier = 1; // make sure horizontal speed multiplier = 1 eventually.
			
			return true;
		}
		
		// ....... public functions .....................
		
		//submits this from animator
		public function play():void
		{
			Animator.submitAnimation(this);
		}
		
		//removes this from animator
		public function pause():void
		{
			Animator.removeAnimation(this);
		}
		
		// disables swimming force so turtle will not exceed screen limits.
		public function disableForce():void
		{
			_yForce = - GameSettings.GRAVITY;
		}
		
		// disables vertical speed so turtle will not exceed screen limits.
		public function disableYSpeed():void
		{
			_ySpeed = 0;
		}
		
		// creates a force to lift horizontal and vertical speed up
		public function swim():void
		{
			_yForce = GameSettings.MAX_FORCE;
			_xSpeedMultiplier = 1 + GameSettings.MAX_SPEED_DIFF;
		}
		
		// reset all parameters
		public function reset():void
		{
			disableYSpeed();
			_xSpeedMultiplier = 1;
			_yForce = 0;
		}
		
		// ........... ACCESORS ...............................
		
		public function get xSpeed():Number
		{
			return _xSpeed;
		}
		
		public function get ySpeed():Number
		{
			return _ySpeed;
		}
		
		// .................. SINGLETON .......................
		
		private static var _instance:SpeedManager;
		
		public static function get instance():SpeedManager
		{
			if(!_instance)
				_instance = new SpeedManager(new LKR());
			
			return _instance;
		}
	}
}

internal class LKR{}