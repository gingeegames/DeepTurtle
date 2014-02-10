package com.gingee.deepTurtle.obstacles
{
	import com.gingeegames.animator.Animator;
	import com.gingeegames.gamologee.guiModule.settings.GuiModuleSettings;
	import com.gingeegames.interfaces.IAdvanceable;
	
	import flash.display.Sprite;
	import com.gingee.deepTurtle.settingsAndEnum.GameSettings;
	
	public class ObstacleManager extends Sprite implements IAdvanceable
	{
		private var _obstacles:Array = []; // an array of current obstecle pointers
		private var _fullCapacity:Boolean = false; // signals if all the needed obstacles were created
		private var _obstacleSpeed:Number; // speed in pixels per frame
		private var _stageWidth:Number; // pointer to stage width
		private var _strike:Function; // a function to be invoked once hit
		
		private static var DISTANCE_BETWEEN_OBSTACLES:Number; // the distance between obstacles
		
		public function ObstacleManager(strike:Function)
		{
			super();
			_strike = strike;
			_stageWidth = GuiModuleSettings.STAGE_REF.stageWidth; // pointer to stage width
			DISTANCE_BETWEEN_OBSTACLES = _stageWidth *.95/GameSettings.NUM_OBSTACLES; // set to 95% of screen width devided by the number of obstecles
			_obstacleSpeed = GameSettings.GAME_SPEED * GameSettings.OBSTACLES_SPEED_MULTIPLIER; // set speed
		}
		
		private function createObstacle():void
		{
			const o:Obstacle = new Obstacle(); // instanciate
			addChild(o); // add to stage
			o.x = GuiModuleSettings.STAGE_REF.stageWidth; // set position to the right of the screen
			_obstacles.push(o); // push a pointer to obstacles array
		}
		
		public function play():void
		{
			Animator.submitAnimation(this); // add to animator
		}
		
		public function pause():void
		{
			Animator.removeAnimation(this); // remove from animator
		}
		
		public function reset():void
		{
			pause(); // remove from animator
			removeChildren(); // remove all obstacles
			_obstacles = []; // get rid of obstacles pointers
			_fullCapacity = false; // reset full capacity
			createObstacle(); // create first obstacle
		}
		
		public function advance():Boolean
		{
			// itarate over all existing obstacles
			for(var i:int = 0 ; i < _obstacles.length ; i++)
			{
				const o:Obstacle = _obstacles[i];
				o.x -= _obstacleSpeed; // advance x location by _obstacleSpeed
				
				if(o.hitTest())
					_strike();
				
				if(o.x < -o.width) // if obstacle is off screen
				{
					o.recreate(); // re-generate the obstacle - changes the position of the gap
					o.x = _stageWidth; // position it to the right of the screen
				}
			}
			
			// find out if the game has created enough obstacles
			if(!_fullCapacity)
			{
				// check if there is at least one obstacle
				if(_obstacles.length > 0)
				{
					const lastObstacle:Obstacle = _obstacles[_obstacles.length-1];
					// check if the last obstacle's x position is larger than the distance between obstacles
					if(lastObstacle.x < _stageWidth - DISTANCE_BETWEEN_OBSTACLES)
					{
						createObstacle(); // create an obstacle
						
						if(_obstacles.length >= GameSettings.NUM_OBSTACLES)
							_fullCapacity = true; // update full capacity of obstacles
					}
				}
				else // otherwise, create an obstacle
					createObstacle();
			}
			
			return true;
		}
	}
}