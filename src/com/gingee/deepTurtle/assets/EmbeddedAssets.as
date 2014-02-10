package com.gingee.deepTurtle.assets
{
	import com.gingee.deepTurtle.settingsAndEnum.DataStorage;
	import com.gingee.deepTurtle.settingsAndEnum.ElementIDS;
	import com.gingeegames.gamologee.guiModule.GingeeGuiModule;
	import com.gingeegames.soundEngine.GamologeeSoundsEngine;
	import com.gingeegames.utils.NumbersTools;
	
	import flash.display.Bitmap;
	
	public class EmbeddedAssets
	{
		// fonts
		[Embed(source="/com/gingee/deepTurtle/assets/LEVIBRUSH.TTF", fontName="_leviBrush", embedAsCFF="false")] 
		public static const _leviBrush:Class;
		
		// Backgrounds and Assets
		[Embed(source="/com/gingee/deepTurtle/assets/animations.png")]
		private static const _anim:Class;
		private static const Animations:Bitmap = new _anim() as Bitmap;
		
		[Embed(source="/com/gingee/deepTurtle/assets/animations.xml", mimeType="application/octet-stream")]
		private static const _animXML:Class;
		private static const AnimationsXML:Object = new _animXML();
		
		// Backgrounds and Assets
		[Embed(source="/com/gingee/deepTurtle/assets/assets.png")]
		private static const _assets:Class;
		private static const Assets:Bitmap = new _assets() as Bitmap;
		
		[Embed(source="/com/gingee/deepTurtle/assets/assets.xml", mimeType="application/octet-stream")]
		private static const _assetsXML:Class;
		private static const AssetsXML:Object = new _assetsXML();
		
		public static const ASSETS_ATLAS:String = 'assets';
		public static const ANIMATIONS_ATLAS:String = 'animations';
		
		private static const FLAP1:String = 'FLAP1';
		private static const FLAP2:String = 'FLAP2';
		private static const FLAP3:String = 'FLAP3';
		private static const SUCCESS:String = 'SUCCESS';
		private static const FAIL:String = 'FAIL';
		private static var FLAPPING_ARRAY:Array;
		
		public static const SONG:String = 'SONG';
		public static var MUTED:Boolean = false;
		
		public static function playRandomFlappingSound():void
		{
			if(MUTED) // check if muted
				return;
			
			// plays a random plapping sound from the sounds array
			const pos:Number = Math.round(NumbersTools.randomRange(0, FLAPPING_ARRAY.length-1));
			const soundId:String = FLAPPING_ARRAY[pos];
			GamologeeSoundsEngine.play(soundId, .5); // play sound in half the volume
		}
		
		public static function unmute():void
		{
			MUTED = false; // set mute flag
			playSong(); // play song
		}
		
		public static function playSong():void
		{
			if(MUTED) // check if muted
				return;
			
			DataStorage.instance.save(ElementIDS.MUTE_MUSIC, MUTED);
			GamologeeSoundsEngine.play(SONG, 1, 0, -1);
		}
		
		public static function playSuccess():void
		{
			if(MUTED) // check if muted
				return;
			
			GamologeeSoundsEngine.play(SUCCESS, .7);
		}
		
		public static function playFail():void
		{
			if(MUTED) // check if muted
				return;
			
			GamologeeSoundsEngine.play(FAIL, .7);
		}
		
		public static function mute():void
		{
			MUTED = true; // set mute flag
			DataStorage.instance.save(ElementIDS.MUTE_MUSIC, MUTED); // save to local storage
			GamologeeSoundsEngine.stopAll(); // stop every sound that is currently playing
		}
		
		public static function stopApplication():void
		{
			GamologeeSoundsEngine.pause(SONG);
		}
		
		public static function resumeApplication():void
		{
			GamologeeSoundsEngine.getSound(SONG).resume();
		}
		
		public static function init():void
		{
			// load sprite atlases
			GingeeGuiModule.createSpriteAtlas(ANIMATIONS_ATLAS, Animations, XML(AnimationsXML));
			GingeeGuiModule.createSpriteAtlas(ASSETS_ATLAS, Assets, XML(AssetsXML));
			
			// load sounds
			GamologeeSoundsEngine.init(.95, false);
			GamologeeSoundsEngine.loadSound('/com/gingee/deepTurtle/assets/flap1.mp3', FLAP1);
			GamologeeSoundsEngine.loadSound('/com/gingee/deepTurtle/assets/flap2.mp3', FLAP2);
			GamologeeSoundsEngine.loadSound('/com/gingee/deepTurtle/assets/flap3.mp3', FLAP3);
			GamologeeSoundsEngine.loadSound('/com/gingee/deepTurtle/assets/DeepTurtle.mp3', SONG);
			
			GamologeeSoundsEngine.loadSound('/com/gingee/deepTurtle/assets/success.mp3', SUCCESS);
			GamologeeSoundsEngine.loadSound('/com/gingee/deepTurtle/assets/fail.mp3', FAIL);
			
			FLAPPING_ARRAY = [FLAP1, FLAP2, FLAP3]; // create flapping sound array
			MUTED = DataStorage.instance.load(ElementIDS.MUTE_MUSIC); // load previous mute state from local storage
		}
	}
}