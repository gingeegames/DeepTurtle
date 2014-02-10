package com.gingee.deepTurtle.obstacles
{
	import com.gingeegames.gamologee.guiModule.assetManagment.AssetsManager;
	import com.gingeegames.gamologee.guiModule.settings.GuiModuleSettings;
	import com.gingee.deepTurtle.assets.EmbeddedAssets;
	import com.gingee.deepTurtle.gameElements.Turtle;
	import com.gingee.deepTurtle.settingsAndEnum.GameSettings;
	import com.gingeegames.utils.NumbersTools;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class Obstacle extends Sprite
	{
		private var _topGap:Number; // top's calculated position. used for hitTest
		private var _bottomGap:Number; // bottom's calculated position. used for hitTest
		private var _passed:Boolean = false;
		
		public function Obstacle()
		{
			super();
			recreate(); // create anemonies
		}
		
		public function recreate():void
		{
			_passed = false;
			removeChildren(); // remove previously added anemonies if exsits
			const halfGap:Number = ((GameSettings.OBSTACLE_GAP)>>1); // half of the gap between top and bottom anemone 
			const min:Number = TOP.height + FILLER.height + halfGap; // minimum is the height of top anemone (the height of top asset + height of the filling asset + half the gap)
			const max:Number = GuiModuleSettings.STAGE_REF.stageHeight - min - halfGap; // max is the height of buttom anemone (the height of top asset + height of the filling asset + half the gap)
			const middle:Number = NumbersTools.randomRange(min, max); // get a random number between min and max
			
			_topGap = middle - halfGap; // save top's position
			_bottomGap = GuiModuleSettings.STAGE_REF.stageHeight - _topGap + GameSettings.OBSTACLE_GAP; // save bottom's position
			
			const t:Anemone = new Anemone(_topGap, TOP, FILLER, true); // top anemone
			const b:Anemone = new Anemone(_bottomGap, TOP, FILLER, false); // bottom anemone
			
			// add to obstacle's stage
			addChild(t);
			addChild(b);
			
			// set bottom's position
			b.y = _topGap + GameSettings.OBSTACLE_GAP;
			
			_topGap = t.getBounds(GuiModuleSettings.STAGE_REF).bottom;
			_bottomGap = b.getBounds(GuiModuleSettings.STAGE_REF).y;
		}
		
		public function hitTest():Boolean
		{
			if(_passed)
				return false;
			
			const b:Rectangle = this.getBounds(GuiModuleSettings.STAGE_REF); // get this bounds in stage coordinates
			
			if(turtleStageX >= b.x + GameSettings.OBSTACLE_SIDE_PADDING) // if turtle's head is after this obstecle's left edge
			{
				if(turtleStageBack < b.right - GameSettings.OBSTACLE_SIDE_PADDING) // and if turtle's tail is before this obstecle's right edge
				{
					const tBounds:Rectangle = TURTLE_REF.getBounds(GuiModuleSettings.STAGE_REF); // get turtle's vertical position in stage coordinates
					
					if(tBounds.y + GameSettings.TURTLE_PADDING < _topGap - GameSettings.OBSTACLE_TOP_PADDING || tBounds.bottom > _bottomGap + GameSettings.OBSTACLE_TOP_PADDING) // check if turtle is currently inside the gap
						return true;
				}
				else
				{
					_passed = true;
					GameSettings.obstaclePassed();
				}
			}
			
			return false;
		}
		
		// ........................ STATIC .......................................
		
		private static var TOP:Bitmap; // a static reference to TOP asset
		private static var FILLER:Bitmap; // a static reference to FILLER asset
		private static var turtleStageX:Number; // a static reference to turtle's horizontal position in stage coordinates
		private static var turtleStageBack:Number; // a static reference to turtle's horizontal tail position in stage coordinates
		private static var turtleHeight:Number; // a static reference to turtle's height
		private static var TURTLE_REF:Turtle; // a static reference to turtle object
		
		public static function init(turtle:Turtle):void
		{
			// update static references
			turtleHeight = turtle.height;
			turtleStageBack = turtle.getBounds(GuiModuleSettings.STAGE_REF).x;
			turtleStageX = turtleStageBack + turtle.width;
			TURTLE_REF = turtle;
			
			// create assets and scale parameters to device's resolution if did not already do so
			if(!TOP)
			{
				TOP = AssetsManager.getImg('top', EmbeddedAssets.ANIMATIONS_ATLAS);
				FILLER = AssetsManager.getImg('mediator', EmbeddedAssets.ANIMATIONS_ATLAS);
			}
		}
	}
}