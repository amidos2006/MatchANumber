package MatchANumber.GameEntity 
{
	import flash.geom.Point;
	import MatchANumber.GameSfx;
	import MatchANumber.LayerConstant;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.TouchControl;
	import net.flashpunk.utils.TouchPoint;
	/**
	 * ...
	 * @author Amidos
	 */
	public class TextButtonEntity extends Entity
	{
		[Embed(source = "../../../assets/click.mp3")]private var clickClass:Class;
		
		private var buttonText:Text;
		private var pressFunction:Function;
		private var clickSfx:GameSfx;
		
		public function set alpha(value:Number):void
		{
			buttonText.alpha = value;
		}
		
		public function TextButtonEntity(text:String, fontSize:int, fontColor:uint, endFunction:Function) 
		{
			clickSfx = new GameSfx(clickClass);
			
			var options:Object = new Object();
			options["color"] = fontColor;
			options["size"] = fontSize;
			options["align"] = "center";
			
			buttonText = new Text(text, 0, 0, options);
			buttonText.centerOO();
			
			pressFunction = endFunction;
			
			graphic = buttonText;
			layer = LayerConstant.BUTTON_LAYER;
			setHitbox(buttonText.width + 10, buttonText.height + 10, buttonText.originX + 5, buttonText.originY + 5);
		}
		
		override public function update():void 
		{
			super.update();
			
			buttonText.scale = 1;
			var points:Vector.<TouchPoint> = TouchControl.GetTouchPoints();
			if (points.length > 0 && collidePoint(x, y, points[0].x, points[0].y))
			{
				buttonText.scale = 1.1;
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