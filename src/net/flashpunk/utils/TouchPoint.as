package net.flashpunk.utils
{
	/**
	 * ...
	 * @author Amidos
	 */
	public class TouchPoint 
	{
		public var touchID:int;
		public var touchState:int;
		
		public var x:int;
		public var y:int;
		
		public function TouchPoint(id:int, state:int, xIn:int, yIn:int) 
		{
			touchID = id;
			touchState = state;
			
			x = xIn;
			y = yIn;
		}
	}

}