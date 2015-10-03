package MatchANumber.GameEntity 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import MatchANumber.GameSfx;
	import MatchANumber.LayerConstant;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.TouchControl;
	import net.flashpunk.utils.TouchPoint;
	/**
	 * ...
	 * @author Amidos
	 */
	public class ImageButtonEntity extends Entity
	{
		[Embed(source = "../../../assets/click.mp3")]private var clickClass:Class;
		
		private var buttonImage:Image;
		private var pressFunction:Function;
		private var clickSfx:GameSfx;
		
		public function set alpha(value:Number):void
		{
			buttonImage.alpha = value;
		}
		
		public function ImageButtonEntity(bitmapData:BitmapData, endFunction:Function) 
		{
			clickSfx = new GameSfx(clickClass);
			
			buttonImage = new Image(bitmapData);
			buttonImage.centerOO();
			buttonImage.smooth = false;
			
			pressFunction = endFunction;
			
			graphic = buttonImage;
			layer = LayerConstant.BUTTON_LAYER;
			setHitbox(buttonImage.width + 10, buttonImage.height + 10, buttonImage.originX + 5, buttonImage.originY + 5);
		}
		
		override public function update():void 
		{
			super.update();
			
			buttonImage.scale = 1;
			var points:Vector.<TouchPoint> = TouchControl.GetTouchPoints();
			if (points.length > 0 && collidePoint(x, y, points[0].x, points[0].y))
			{
				buttonImage.scale = 1.2;
				if (TouchControl.TouchReleased())
				{
					if (pressFunction != null)
					{
						clickSfx.play();
						pressFunction();
					}
				}
			}
		}
		
		override public function render():void 
		{
			super.render();
		}
	}

}