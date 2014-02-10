package
{
	import com.gingee.deepTurtle.assets.EmbeddedAssets;
	import com.gingee.deepTurtle.screens.GameScreen;
	import com.gingee.deepTurtle.settingsAndEnum.ElementIDS;
	import com.gingee.deepTurtle.settingsAndEnum.GameSettings;
	import com.gingeegames.gamologee.guiModule.GingeeGuiModule;
	import com.gingeegames.gamologee.guiModule.screens.ScreenManager;
	import com.gingeegames.gamologee.guiModule.screens.transitions.SweepDown;
	import com.gingeegames.gingeeGamesInitiator.Gingee;
	import com.gingeegames.utils.StatsMini;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.Event;

	[SWF(backgroundColor='0x023c52', frameRate="40")]
	public class DeepTurtle extends Sprite
	{
		private var _game:GameScreen;
		
		public function DeepTurtle()
		{
			super();			
			Gingee.init(stage, 'settings.xml', onComplete, 'CUSTOM', '', GingeeGuiModule);
		}
		
		private function onComplete():void
		{
			// .................. Init sprite atlases, settings and assets ..........................
			EmbeddedAssets.init();
			GameSettings.init();
			
			// create and submit screens to screen manager
			_game = new GameScreen(ElementIDS.GAME_SCREEN, new SweepDown());
			ScreenManager.Instance.submitScreen(_game);
			
			addChild(ScreenManager.Instance); // add screen manager to stage
//			addChild(new StatsMini()); // fps meter
			
			// go to first screen
			ScreenManager.Instance.gotoScreen(ElementIDS.GAME_SCREEN);
			EmbeddedAssets.playSong(); // play music
			
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeactivated);
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onActivated);
		}
		
		protected function onActivated(e:Event):void
		{
			EmbeddedAssets.resumeApplication();
		}
		
		protected function onDeactivated(e:Event):void
		{
			EmbeddedAssets.stopApplication();
			_game.pause();
		}
	}
}