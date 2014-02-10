package com.gingee.deepTurtle.screens
{
	import com.gingee.deepTurtle.assets.EmbeddedAssets;
	import com.gingee.deepTurtle.gameElements.HighscorePanel;
	import com.gingee.deepTurtle.gameElements.SeaParallaxBackground;
	import com.gingee.deepTurtle.gameElements.Turtle;
	import com.gingee.deepTurtle.managers.SpeedManager;
	import com.gingee.deepTurtle.obstacles.Obstacle;
	import com.gingee.deepTurtle.obstacles.ObstacleManager;
	import com.gingee.deepTurtle.settingsAndEnum.ElementIDS;
	import com.gingee.deepTurtle.settingsAndEnum.GameSettings;
	import com.gingeegames.animationUtils.TweenFactory;
	import com.gingeegames.animator.Animator;
	import com.gingeegames.gamologee.guiModule.GingeeGuiModule;
	import com.gingeegames.gamologee.guiModule.assetManagment.AssetsManager;
	import com.gingeegames.gamologee.guiModule.gui.alignment.enum.GuiElementAlignmentMethods;
	import com.gingeegames.gamologee.guiModule.gui.buttons.GuiImageButton;
	import com.gingeegames.gamologee.guiModule.gui.buttons.GuiOnOffButton;
	import com.gingeegames.gamologee.guiModule.gui.stageEvents.StageEventsManager;
	import com.gingeegames.gamologee.guiModule.gui.text.GuiTextQuick;
	import com.gingeegames.gamologee.guiModule.screens.GuiBasicScreen;
	import com.gingeegames.gamologee.guiModule.screens.interfaces.ITransition;
	import com.gingeegames.gamologee.guiModule.settings.GuiModuleSettings;
	import com.gingeegames.gamologee.guiModule.utils.ScalingFactors;
	import com.gingeegames.sidescroller.Background;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class GameScreen extends GuiBasicScreen
	{
		private var _turtle:Turtle; // turtle
		private var _parallax:SeaParallaxBackground; // parallax background
		private var _backgroundImage:Bitmap; // background image pointer
		private var _play:GuiImageButton; // play button
		private var _pause:GuiImageButton; // pause button
		private var _buttonsLayer:Sprite; // a layer for buttons
		private var _gameLayer:Sprite; // a layer for game objects
		private var _highscoreLayer:Sprite; // a layer for highscore panel
		private var _obstacles:ObstacleManager; // obstacle manager
		private var _score:GuiTextQuick; // displays the score on screen
		private var _stopped:Boolean = false; // flag indicating game was hulted. for resuming purposes.
		private var _highscore:HighscorePanel; // displays high score
		private var _sound:GuiOnOffButton; // sound enabling button
		
		public function GameScreen(id:String, transition:ITransition)
		{
			super(id, "SCREEN", transition);
		}
		
		override public function init():void
		{
			super.init();

			// .................. Get background ..........................
			_backgroundImage = AssetsManager.getImg('bg', EmbeddedAssets.ASSETS_ATLAS);
			
			// create screen's layer
			_gameLayer = new Sprite();
			_buttonsLayer = new Sprite();
			_highscoreLayer = new Sprite();
			
			// create buttons
			_play = new GuiImageButton('play', onPlay, uint.MAX_VALUE, EmbeddedAssets.ANIMATIONS_ATLAS);
			_pause = new GuiImageButton('pause', pause, uint.MAX_VALUE, EmbeddedAssets.ANIMATIONS_ATLAS);
			_sound = new GuiOnOffButton(AssetsManager.getImg('sound0001', EmbeddedAssets.ANIMATIONS_ATLAS), AssetsManager.getImg('sound0002', EmbeddedAssets.ANIMATIONS_ATLAS), EmbeddedAssets.unmute, EmbeddedAssets.mute, ElementIDS.MUTE_BTN, !EmbeddedAssets.MUTED);
			
			// .................. Setup parralax background layers ..........................
			_parallax = new SeaParallaxBackground(.5, GameSettings.GAME_SPEED);
			
			// submit layers
			const top:Bitmap = AssetsManager.getImg('top', EmbeddedAssets.ASSETS_ATLAS);
			_parallax.submitBackgroundLayer(AssetsManager.getImg('mid', EmbeddedAssets.ASSETS_ATLAS), Background.BOTTOM);
			_parallax.submitBackgroundLayer(AssetsManager.getImg('bottom', EmbeddedAssets.ASSETS_ATLAS), Background.TOP, false);
			_parallax.submitBackgroundLayer(top, Background.BOTTOM);
			
			GameSettings.BOTTOM_LINE = GuiModuleSettings.STAGE_HEIGHT - top.height*.9; // set bottom line for hit
			
			// build parallax bg
			_parallax.build();
			
			// ...................... Create turtle ..........................................................
			_turtle = new Turtle(this, _parallax, strike);
			
			// ...................... Create obstacle manager ................................................
			_obstacles = new ObstacleManager(strike);
			
			// highscore
			_highscore = new HighscorePanel();
			
			// ...................... points ................................................
			_score = new GuiTextQuick('0', GameSettings.TEXT_SIZE, GameSettings.TEXT_COLOR, GameSettings.FONT);
			GameSettings.submitScoreUpdater(updateScore);
			
			//................ Add to stage .................................
			_gameLayer.addChild(_parallax);
			_gameLayer.addChild(_turtle);
			_gameLayer.addChild(_obstacles);
			_gameLayer.addChild(_score);
			_gameLayer.addChild(_sound);
			
			_highscoreLayer.addChild(_highscore);
			
			addChild(_gameLayer);
			addChild(_highscoreLayer);
			addChild(_buttonsLayer);
			
			// show play button
			_buttonsLayer.removeChildren();
			_buttonsLayer.addChild(_play);
			
			_play.align = GuiElementAlignmentMethods.STAGE_X_CENTER; // position the button
			_highscore.align = GuiElementAlignmentMethods.STAGE_X_CENTER; // set highscore horizontal position. Align can only be invoked if a GuiElement is added to stage! thats why we add it to stage and then align and remove it.
			_highscoreLayer.removeChildren(); // remove highscore panel
			_highScoreFinalLocation = ((GuiModuleSettings.STAGE_HEIGHT - _highscore.height)>>1);// 
			updateScore(0); // set score to 0
			
			_play.y = ScalingFactors.getScaleNum(150); // set play's location
			_sound.align = GuiElementAlignmentMethods.STAGE_TOP_RIGHT;
			const padding:Number = ScalingFactors.getScaleNum(20);
			_sound.x -= padding;
			_sound.y += padding;
		}
		
		private var _highScoreFinalLocation:Number;
		
		override public function clear():void
		{
			super.clear();
			stop();
		}
		
		override public function reset():void
		{
			super.reset();
			
			// .................. Set background ..........................
			GingeeGuiModule.setBackgroundImage(_backgroundImage);
			
			resetItems();
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
		
		private function updateScore(score:Number):void
		{
			_score.text = score.toString(); // set text
			_score.align = GuiElementAlignmentMethods.STAGE_X_RIGHT; // position the button
			
			const padding:Number = ScalingFactors.getScaleNum(20);
			// set padding from borders
			_score.x -= 2*padding;
			_score.y = _sound.getBounds(this).bottom + padding;
		}
		
		public function strike():void
		{
			// once strike out - stop game
			stop();
			
			// store highscore if needed
			GameSettings.storeHighScore();
			
			// setup high score panel
			_highscore.y = - _highscore.height; // allocate highscore panel outside the screen
			_highscore.score = GameSettings.HIGH_SCORE; // update highest score to panel
			
			_buttonsLayer.removeChildren();
			TweenFactory.tweenTo(_highscore, 1, {onComplete:showPlay, y:_highScoreFinalLocation}); // start a tween-in for the panel
			_highscoreLayer.addChild(_highscore); // add panel to layer
			EmbeddedAssets.playFail();
		}
		
		private function showPlay():void
		{
			// show play button
			_buttonsLayer.removeChildren();
			_buttonsLayer.addChild(_play);
		}
		
		public function pause():void
		{
			pauseElements(); // pause game
			
			// show play button
			showPlay();
		}
		
		private function onPlay():void
		{
			if(_stopped)
				reset();
			
			_highscoreLayer.removeChildren();
			
			play(); // play game
			
			// show pause button
			_buttonsLayer.removeChildren();
			_buttonsLayer.addChild(_pause);
			
			_pause.align = GuiElementAlignmentMethods.STAGE_BOTTOM_RIGHT; // position the button
		}
		
		private function stop():void
		{
			pauseElements();
			_stopped = true;
			_turtle.stopAnimation();
			_turtle.reset();
			Animator.removeAnimation(_parallax);
		}
		
		private function resetItems():void
		{
			// set positions on screen
			_turtle.align = GuiElementAlignmentMethods.STAGE_Y_MIDDLE;
			_turtle.x = ScalingFactors.getScaleNum(300);
			Obstacle.init(_turtle);
			
			// reset speed manager
			SpeedManager.instance.reset();
			_turtle.reset();
			
			// reset obstacle manager
			_obstacles.reset();
			
			// reset points
			GameSettings.resetScore();
		}
		
		private function play():void
		{
			// ignite Turtle and Background
			Animator.submitAnimation(_turtle);
			_turtle.playAnimation();
			
			// ignite speed manager
			SpeedManager.instance.play();
			
			// ignite obstacles
			_obstacles.play();
			
			// ignite parallax bg
			Animator.submitAnimation(_parallax);
			
			// Listen to stage clicks
			StageEventsManager.registerStageClick(makeSwim);
		}
		
		private function pauseElements():void
		{
			_stopped = false;
			
			// pause Turtle and Background
			Animator.removeAnimation(_turtle);
			
			// pause speed manager
			SpeedManager.instance.pause();
			
			// pause obstacles
			_obstacles.pause();
			
			// Listen to stage clicks
			StageEventsManager.unregisterStageClick(makeSwim);
		}
		
		// on stage click, make turtle swim!
		private function makeSwim(e:*):void
		{
			_turtle.swim();
		}
	}
}