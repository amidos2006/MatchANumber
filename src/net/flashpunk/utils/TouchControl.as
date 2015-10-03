package net.flashpunk.utils
{
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Amidos
	 */
	public class TouchControl 
	{
		public static var MAX_NUMBER_OF_POINTS:int = 1;
		public static var ENABLE_DEBUG:Boolean = true;
		
		public static const UP:int = 0;
		public static const PRESSED:int = 1;
		public static const DOWN:int = 2;
		public static const RELEASED:int = 3;
		
		private static var touchState:Vector.<TouchPoint>;
		
		public static function Intialize():void
		{
			touchState = new Vector.<TouchPoint>();
			
			FP.stage.addEventListener(TouchEvent.TOUCH_BEGIN, touchBegin);
			FP.stage.addEventListener(TouchEvent.TOUCH_MOVE, touchMove);
			FP.stage.addEventListener(TouchEvent.TOUCH_END, touchEnd);
			//For testing
			if (ENABLE_DEBUG)
			{
				FP.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseBegin);
				FP.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				FP.stage.addEventListener(MouseEvent.MOUSE_UP, mouseEnd);
			}
		}
		
		public static function TouchPressed():int
		{
			var result:int = 0;
			for (var i:int = 0; i < touchState.length; i++) 
			{
				if (touchState[i].touchState == PRESSED)
				{
					result += 1;
				}
			}
			
			return result;
		}
		
		public static function TouchReleased():int
		{
			var result:int = 0;
			for (var i:int = 0; i < touchState.length; i++) 
			{
				if (touchState[i].touchState == RELEASED)
				{
					result += 1;
				}
			}
			
			return result;
		}
		
		public static function TouchUp():int
		{
			var result:int = MAX_NUMBER_OF_POINTS - touchState.length;
			
			return result;
		}
		
		public static function TouchDown():int
		{
			var result:int = 0;
			for (var i:int = 0; i < touchState.length; i++) 
			{
				if (touchState[i].touchState == DOWN)
				{
					result += 1;
				}
			}
			
			return result;
		}
		
		public static function GetTouchPoints():Vector.<TouchPoint>
		{
			var points:Vector.<TouchPoint> = new Vector.<TouchPoint>();
			for (var i:int = 0; i < touchState.length; i++) 
			{
				points.push(new TouchPoint(touchState[i].touchID, touchState[i].touchState, touchState[i].x, touchState[i].y));
			}
			
			return points;
		}
		
		public static function UpdateTouchBegin(id:int, touchPoint:Point):void
		{
			if (touchState.length < MAX_NUMBER_OF_POINTS)
			{
				touchState.push(new TouchPoint(id, PRESSED, touchPoint.x, touchPoint.y));
			}
		}
		
		public static function UpdateTouchMove(id:int, touchPoint:Point):void
		{
			for (var i:int = 0; i < touchState.length; i++) 
			{
				if (touchState[i].touchID == id)
				{
					touchState[i].x = touchPoint.x;
					touchState[i].y = touchPoint.y;
				}
			}
		}
		
		public static function UpdateTouchEnd(id:int, touchPoint:Point):void
		{
			for (var i:int = 0; i < touchState.length; i++) 
			{
				if (touchState[i].touchID == id)
				{
					touchState[i].touchState = RELEASED;
				}
			}
		}
		
		public static function Update():void
		{
			var deleteList:Vector.<int> = new Vector.<int>();
			for (var i:int = 0; i < touchState.length; i++) 
			{
				if (touchState[i].touchState == PRESSED)
				{
					touchState[i].touchState = DOWN;
				}
				if (touchState[i].touchState == RELEASED)
				{
					deleteList.push(i);
				}
			}
			
			for (var j:int = 0; j < deleteList.length; j++) 
			{
				touchState.splice(deleteList[j], 1);
			}
		}
		
		private static function ConverPoint(x:Number, y:Number):Point
		{
			return new Point((x - FP.screen.x) / FP.screen.scale, (y - FP.screen.y) / FP.screen.scale);
		}
		
		private static function touchBegin(touchEvent:TouchEvent):void
		{
			TouchControl.UpdateTouchBegin(touchEvent.touchPointID, ConverPoint(touchEvent.stageX, touchEvent.stageY));
		}
		
		private static function touchMove(touchEvent:TouchEvent):void
		{
			TouchControl.UpdateTouchMove(touchEvent.touchPointID, ConverPoint(touchEvent.stageX, touchEvent.stageY));
		}
		
		private static function touchEnd(touchEvent:TouchEvent):void
		{
			TouchControl.UpdateTouchEnd(touchEvent.touchPointID, ConverPoint(touchEvent.stageX, touchEvent.stageY));
		}
		
		private static function mouseBegin(mouseEvent:MouseEvent):void
		{
			TouchControl.UpdateTouchBegin(0, ConverPoint(mouseEvent.stageX, mouseEvent.stageY));
		}
		
		private static function mouseMove(mouseEvent:MouseEvent):void
		{
			TouchControl.UpdateTouchMove(0, ConverPoint(mouseEvent.stageX, mouseEvent.stageY));
		}
		
		private static function mouseEnd(mouseEvent:MouseEvent):void
		{
			TouchControl.UpdateTouchEnd(0, ConverPoint(mouseEvent.stageX, mouseEvent.stageY));
		}
	}

}