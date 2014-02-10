package com.gingee.deepTurtle.gameElements
{
	import com.gingeegames.gamologee.guiModule.gui.animations.GuiAnimationSheet;
	import com.gingeegames.gamologee.guiModule.settings.GuiModuleSettings;
	import com.gingeegames.gamologee.guiModule.utils.ScalingFactors;
	import com.gingeegames.sidescroller.Background;
	import com.gingee.deepTurtle.assets.EmbeddedAssets;
	import com.gingee.deepTurtle.settingsAndEnum.GameSettings;
	
	import flash.display.Sprite;
	
	public class SeaParallaxBackground extends Background
	{
		private var _seaWeedMold:GuiAnimationSheet; // using a single GuiAnimationSheet with clone() function to share BitmapData
		private var _seaweeds:Array = []; // array of pointers to seaweeds currently on stage
		private var _unusedSeaweeds:Array = []; // array of pointers to seaweeds removed from stage
		private var _seaWeedLayer:Sprite = new Sprite(); // containning layer
		
		public function SeaParallaxBackground(parallaxSpeedReduction:Number = 0.5, gameSpeed:Number = 15)
		{
			super(parallaxSpeedReduction, gameSpeed); // pass params
			_seaWeedMold = new GuiAnimationSheet('seaweed', new <String>[EmbeddedAssets.ANIMATIONS_ATLAS]); // create mold
		}
		
		override public function build():void
		{
			super.build();
			addChild(_seaWeedLayer); // add seaweed layer to stage
		}
		
		override public function advance():Boolean
		{
			const speed:Number =  _speed*_parallaxSpeedReduction; // calculate speed in pixel per frame
			
			// iterate through all seaweeds on stage
			for(var i:int = 0 ; i < _seaweeds.length ; i++)
			{
				const sw:GuiAnimationSheet = _seaweeds[i]; // ref current seaweed
				sw.x -= speed; // progress horizontal position
				
				if(sw.x < -sw.width) // if seaweed is out of screen
				{
					_seaWeedLayer.removeChild(sw); // remove from layer
					_seaweeds.splice(i, 1); // splice out of seaweed array
					sw.stop(); // stop animation
					_unusedSeaweeds.push(sw); // push to unused array
				}
			}
			
			if(_seaweeds.length < GameSettings.SEA_WEEDS_AMOUNT) // if current number of seaweeds on screen is less than dictated by settings
				if(Math.random() < GameSettings.PROBEBILITY_FOR_SEAWEED) // if probability allows creation of new seaweed
					createSeaweed();
			
			return super.advance();
		}
		
		private function createSeaweed():void
		{
			var sw:GuiAnimationSheet;
			
			// if the seaweed arrays dont hold the setting amount of total seaweeds pool create a new one
			if(_unusedSeaweeds.length + _seaweeds.length < GameSettings.SEA_WEEDS_AMOUNT) 
			{
				sw = _seaWeedMold.clone(); // clone from mold
				sw.y = GuiModuleSettings.STAGE_REF.stageHeight - sw.height + Math.random()*ScalingFactors.getScaleNum(5); // set vertical position
			}
			else
				sw = _unusedSeaweeds.pop(); // else, get a seaweed from unused array 
			
			sw.x = GuiModuleSettings.STAGE_REF.stageWidth + 10; // set horizontal position to out of stage.
			sw.play(); // start animation
			_seaWeedLayer.addChild(sw); // add to seaweed layer
			_seaweeds.push(sw); // push to used array
		}
	}
}