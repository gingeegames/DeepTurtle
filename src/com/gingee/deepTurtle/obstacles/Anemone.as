package com.gingee.deepTurtle.obstacles
{
	import com.gingeegames.gamologee.guiModule.gui.tiling.GuiVerticalTiler;
	import com.gingeegames.utils.BitmapTools;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class Anemone extends Bitmap
	{
		public function Anemone(h:Number, top:Bitmap, mediator:Bitmap, upsideDown:Boolean = false)
		{
			// create tiler at the height left
			const tiler:GuiVerticalTiler = new GuiVerticalTiler(mediator, h - top.height);
			
			const container:Sprite = new Sprite(); // create a container
			const t:Bitmap = new Bitmap(top.bitmapData); // new top peace
			const tl:Bitmap = BitmapTools.createBitmap(tiler); // create a bitmap of the tiler
			
			tl.y = top.height-1; // set tile's location to the bottom of the top peace
			container.addChild(tl); // add tile
			container.addChild(t); // add top
			
			var bmd:BitmapData;
			
			if(upsideDown) // if needs to be flipped vertically
			{
				const anemone:Bitmap = BitmapTools.createBitmap(container); // create a bitmap out of the container
				anemone.scaleY = -1; // flip vertically
				
				const newContainer:Sprite = new Sprite(); // create a new container
				newContainer.addChild(anemone); // add anemone to new container

				// get bitmap data. this patches the fact that AIR's bitmap data ignores the scaleY parameter
				bmd = BitmapTools.createBitmap(newContainer).bitmapData; 
			}
			else
				bmd = BitmapTools.createBitmapData(container); // get bitmap data
				
			super(bmd);
		}
	}
}