package MatchANumber.GameEntity 
{
	import flash.geom.Point;
	import flash.display.BitmapData;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Amidos
	 */
	public class BlockGridRender extends Graphic
	{
		private const SPACING:int = 64;
		
		private var smallBlock:Image;
		private var registeredPoints:Vector.<Point>;
		
		public function BlockGridRender() 
		{
			smallBlock = new Image(GraphicLoader.GetGraphics("backblock"));
			smallBlock.centerOO();
			
			registeredPoints = new Vector.<Point>();
		}
		
		public function RegisterColoumn(colNumber:int):void
		{
			for (var i:int = 0; i < FP.height / SPACING; i++) 
			{
				registeredPoints.push(new Point(colNumber, i));
			}
		}
		
		public function RegisterPoint(point:Point):void
		{
			registeredPoints.push(point);
		}
		
		public function RemovePoint(point:Point):void
		{
			for (var i:int = 0; i < registeredPoints.length; i++) 
			{
				if (point.equals(registeredPoints[i]))
				{
					registeredPoints.splice(i, 1);
					return;
				}
			}
		}
		
		override public function render(target:BitmapData, point:Point, camera:Point):void 
		{
			for (var i:int = 0; i < registeredPoints.length; i++) 
			{
				var currentPosition:Point = registeredPoints[i].clone();
				currentPosition.x = currentPosition.x * SPACING + point.x + SPACING / 2;
				currentPosition.y = currentPosition.y * SPACING + point.y + SPACING / 2;
				
				smallBlock.render(target, currentPosition, camera);
			}
		}
	}

}