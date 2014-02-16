package com.gingee.deepTurtle.gameElements
{
	import com.gingee.deepTurtle.assets.EmbeddedAssets;
	import com.gingee.deepTurtle.managers.SpeedManager;
	import com.gingee.deepTurtle.settingsAndEnum.ElementIDS;
	import com.gingee.deepTurtle.settingsAndEnum.GameSettings;
	import com.gingeegames.gamologee.guiModule.gui.GuiElement;
	import com.gingeegames.gamologee.guiModule.gui.animations.GuiAnimationSheet;
	import com.gingeegames.gamologee.guiModule.settings.GuiModuleSettings;
	import com.gingeegames.gamologee.guiModule.utils.ScalingFactors;
	import com.gingeegames.interfaces.IAdvanceable;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class Turtle extends GuiElement implements IAdvanceable
	{
		private var _animation:GuiAnimationSheet; // turtle animation
		private var _animLayer:Sprite; // turtle animation layer
		private var _context:DisplayObject; // container in which this will be added
		private var _disableSwim:Boolean; // a boolean that enables swimming to make sure turtle is within screen
		private var _strike:Function; // a function to be invoked once hit
		
		public function Turtle(context:DisplayObject, strike:Function)
		{
			super(ElementIDS.TURTLE_ID); // set turtle's ID
			
			_strike = strike;
			_animLayer = new Sprite();
			_disableSwim = false; // enable swimming
			
			// pass context and parallax bg to class vars
			_context = context;
			
			// create frame labels
			const labels:Dictionary = new Dictionary();
			labels['swim'] = 1;
			labels['idle'] = 25;
			
			// create turtle animation
			_animation = new GuiAnimationSheet('TurtleSwim', new <String>[EmbeddedAssets.ANIMATIONS_ATLAS], 'turtleAnimation', 1, labels);
			
			// put turtle animation inside a container and set the origin to its center so it can rotate about its center point
			_animLayer.addChild(_animation);
			
			// reallocate the container to make up for internal positionning
			addChild(_animLayer);
			
			_animation.gotoAndPlay('idle'); // play idle animation
		}
		
		public function swim():void
		{
			// if turtle is not at the top of the screen, update speed manager
			if(!_disableSwim)
				SpeedManager.instance.swim();
			
			// show swim animation
			_animation.addEventListener(Event.COMPLETE, onCompleteSwim);
			_animation.gotoAndPlay('swim', false, true);
			EmbeddedAssets.playRandomFlappingSound();
		}
		
		protected function onCompleteSwim(e:Event):void
		{
			// when swim animation is complete, show idle animation
			_animation.removeEventListener(Event.COMPLETE, onCompleteSwim);
			_animation.gotoAndPlay('idle', true);
		}
		
		public function advance():Boolean
		{
			const ySpeed:Number = SpeedManager.instance.ySpeed; // get current vertical speed
			
			if(this.getBounds(_context).y < -ScalingFactors.getScaleNum(50)) // check if turtle is a the top of the screen
			{
				_disableSwim = true; // disable swimming
				
				if(ySpeed > 0)
					this.y += ySpeed; // update vertical position only if it take turtle down
				else
					SpeedManager.instance.disableYSpeed(); // disable vertical speed
			}
			else
			{
				this.y += ySpeed; // update vertical position
				_disableSwim = false; // enable swimming
			}
			
			// check if turtle hit the bottom
			if(this.getBounds(GuiModuleSettings.STAGE_REF).y + _animation.height >= GameSettings.BOTTOM_LINE)
				_strike();
			
			return true;
		}
		
		public function reset():void
		{
			
		}
		
		public function stopAnimation():void
		{
			_animation.gotoAndStop(1);
		}
		
		public function playAnimation():void
		{
			_animation.gotoAndPlay('idle', true);
		}
	}
}