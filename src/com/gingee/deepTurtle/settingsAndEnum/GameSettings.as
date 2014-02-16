package com.gingee.deepTurtle.settingsAndEnum
{
	import com.gingee.deepTurtle.assets.EmbeddedAssets;
	import com.gingeegames.gamologee.guiModule.utils.ScalingFactors;

	public class GameSettings
	{
		// ................ SCORE ................................................
		
		public static var HIGH_SCORE:Number = 0; // highest score
		private static var SCORE:Number = 0; // current score
		private static var _scoreUpdater:Function; //  a reference to score updating function
		
		// saves if it is curerntly highest score
		public static function storeHighScore():void
		{
			 if (HIGH_SCORE < SCORE) // if current score is bigger, update high score
			 {
				 HIGH_SCORE = SCORE;
				 DataStorage.instance.save(ElementIDS.HIGH_SCORE_STORAGE_ID, HIGH_SCORE);
			 }
		}
		
		// passes a reference to score updating function
		public static function submitScoreUpdater(f:Function):void{_scoreUpdater = f;}
		
		// increments score by 1 and updates text field
		public static function obstaclePassed():void
		{
			EmbeddedAssets.playSuccess();
			_scoreUpdater(++SCORE);
		}
		
		// resets score and updates text field
		public static function resetScore():void
		{
			SCORE = 0;
			_scoreUpdater(SCORE);
		}
		
		// ................ SPEED MANAGER SETTINGS ................................	
		
		public static var GAME_SPEED:Number = 19;
		public static var GRAVITY:Number = 15;
		public static var MAX_FORCE:Number = -110;
		public static var FORCE_DECAY:Number = 15;
		public static const X_SPEED_DECAY:Number = .1;
		public static const MAX_SPEED_DIFF:Number = 2;
		
		// ................. TURTLE SETTINGS  ......................................	
		
		public static var TURTLE_PADDING:Number = 30;
		
		// ................. OBSTACLES SETTINGS ....................................
		
		public static const NUM_OBSTACLES:Number = 3;
		public static var OBSTACLE_GAP:Number = 200;
		public static var OBSTACLE_SIDE_PADDING:Number = 20;
		public static var OBSTACLES_SPEED_MULTIPLIER:Number = .3;
		public static var OBSTACLE_TOP_PADDING:Number = 25;
		
		// ................. BACKGROUND SETTINGS ....................................
		
		public static const SEA_WEEDS_AMOUNT:Number = 2;
		public static var PROBEBILITY_FOR_SEAWEED:Number = .02;
		public static var BOTTOM_LINE:Number;
		
		// ................. TEXT SETTINGS ....................................
		
		public static const FONT:String = '_leviBrush';
		public static var TEXT_SIZE:Number = 60;
		public static var TEXT_COLOR:uint = 0xffffff;
		
		
		public static function init():void
		{
			GameSettings.OBSTACLE_GAP = ScalingFactors.getScaleNum(GameSettings.OBSTACLE_GAP);
			GameSettings.OBSTACLE_SIDE_PADDING = ScalingFactors.getScaleNum(GameSettings.OBSTACLE_SIDE_PADDING);
			GameSettings.OBSTACLE_TOP_PADDING = ScalingFactors.getScaleNum(GameSettings.OBSTACLE_TOP_PADDING);
			GameSettings.TURTLE_PADDING = ScalingFactors.getScaleNum(GameSettings.TURTLE_PADDING);
			
			GameSettings.GAME_SPEED = ScalingFactors.getScaleNum(GameSettings.GAME_SPEED);
			GameSettings.GRAVITY = ScalingFactors.getScaleNum(GameSettings.GRAVITY);
			GameSettings.MAX_FORCE = ScalingFactors.getScaleNum(GameSettings.MAX_FORCE);
			GameSettings.FORCE_DECAY = ScalingFactors.getScaleNum(GameSettings.FORCE_DECAY);
			
			const highscore:Number = Number(DataStorage.instance.load(ElementIDS.HIGH_SCORE_STORAGE_ID));
			HIGH_SCORE = highscore;
			trace('setting high score to ' + highscore);
		}
	}
}