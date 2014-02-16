package com.gingee.deepTurtle.gameElements
{
	import com.gingee.deepTurtle.assets.EmbeddedAssets;
	import com.gingee.deepTurtle.settingsAndEnum.ElementIDS;
	import com.gingee.deepTurtle.settingsAndEnum.GameSettings;
	import com.gingeegames.gamologee.guiModule.assetManagment.AssetsManager;
	import com.gingeegames.gamologee.guiModule.gui.GuiElement;
	import com.gingeegames.gamologee.guiModule.gui.text.GuiTextQuick;
	import com.gingeegames.gamologee.guiModule.utils.ScalingFactors;
	
	import flash.display.Bitmap;
	
	public class HighscorePanel extends GuiElement
	{
		private var _title:Bitmap; // title bitmap
		private var _score:GuiTextQuick; // score text
		private var _bg:Bitmap; // background bitmap
		
		public function HighscorePanel()
		{
			super(ElementIDS.HIGHSCORE_PANEL);
			
			// create title
			_title = AssetsManager.getImg('highscoretitle', EmbeddedAssets.ANIMATIONS_ATLAS); // get title
			
			_score = new GuiTextQuick('0', GameSettings.TEXT_SIZE - 15, GameSettings.TEXT_COLOR, GameSettings.FONT); // create score text
			_bg = AssetsManager.getImg('highscore', EmbeddedAssets.ANIMATIONS_ATLAS); // get background
			
			// add to stage
			addChild(_bg);
			addChild(_title);
			addChild(_score);
			
			// set locations
			_title.y = ScalingFactors.getScaleNum(60);
			_score.y = _title.getBounds(this).bottom + ScalingFactors.getScaleNum(10);
			_score.x = ((_bg.width - _score.width)>>1);
			_title.x = ((_bg.width - _title.width)>>1);
		}
		
		public function set score(val:Number):void
		{
			// chnage highscore value and reposition horizontally
			_score.text = val.toString();
			_score.x = ((_bg.width - _score.width)>>1);
		}
	}
}