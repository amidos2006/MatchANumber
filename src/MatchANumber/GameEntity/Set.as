package MatchANumber.GameEntity 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Amidos
	 */
	public class Set 
	{
		public var tilesArray:Vector.<Point>;
		
		public function Set(tile:Point) 
		{
			tilesArray = new Vector.<Point>();
			tilesArray.push(tile);
		}
		
		private function IsPossibleToMerge(otherSet:Set):Boolean
		{
			if (this == otherSet)
			{
				return false;
			}
			
			return CheckOneTileAway(tilesArray[0], otherSet.tilesArray[0]) ||
				CheckOneTileAway(tilesArray[0], otherSet.tilesArray[otherSet.tilesArray.length - 1]) ||
				CheckOneTileAway(tilesArray[tilesArray.length - 1], otherSet.tilesArray[0]) ||
				CheckOneTileAway(tilesArray[tilesArray.length - 1], otherSet.tilesArray[otherSet.tilesArray.length - 1]);
		}
		
		private function CheckOneTileAway(point1:Point, point2:Point):Boolean
		{
			if ((Math.abs(point1.x - point2.x) == 1 && Math.abs(point1.y - point2.y) == 0) || 
				(Math.abs(point1.x - point2.x) == 0 && Math.abs(point1.y - point2.y) == 1))
			{
				return true;
			}
			
			return false;
		}
		
		public function MergeIfPossible(otherSet:Set):Boolean
		{
			var newArray:Vector.<Point> = new Vector.<Point>();
			var i:int = 0;
			if (CheckOneTileAway(tilesArray[0], otherSet.tilesArray[0]))
			{
				for (i = otherSet.tilesArray.length - 1; i >= 0; i--) 
				{
					newArray.push(otherSet.tilesArray[i]);
				}
				
				for (i = 0; i < tilesArray.length; i++) 
				{
					newArray.push(tilesArray[i]);
				}
				
				tilesArray = newArray;
				return true;
			}
			
			if (CheckOneTileAway(tilesArray[0], otherSet.tilesArray[otherSet.tilesArray.length - 1]))
			{
				for (i = 0; i < otherSet.tilesArray.length; i++) 
				{
					newArray.push(otherSet.tilesArray[i]);
				}
				
				for (i = 0; i < tilesArray.length; i++) 
				{
					newArray.push(tilesArray[i]);
				}
				
				tilesArray = newArray;
				return true;
			}
			
			if (CheckOneTileAway(tilesArray[tilesArray.length - 1], otherSet.tilesArray[0]))
			{
				for (i = 0; i < tilesArray.length; i++) 
				{
					newArray.push(tilesArray[i]);
				}
				
				for (i = 0; i < otherSet.tilesArray.length; i++) 
				{
					newArray.push(otherSet.tilesArray[i]);
				}
				
				tilesArray = newArray;
				return true;
			}
			
			if (CheckOneTileAway(tilesArray[tilesArray.length - 1], otherSet.tilesArray[otherSet.tilesArray.length - 1]))
			{
				for (i = 0; i < tilesArray.length; i++) 
				{
					newArray.push(tilesArray[i]);
				}
				
				for (i = otherSet.tilesArray.length - 1; i >= 0; i--) 
				{
					newArray.push(otherSet.tilesArray[i]);
				}
				
				tilesArray = newArray;
				return true;
			}
			
			return false;
		}
		
		public function GetPossible(setArray:Array):Array
		{
			var result:Array = new Array();
			for (var i:int = 0; i < setArray.length; i++) 
			{
				if (IsPossibleToMerge(setArray[i]))
				{
					result.push(i);
				}
			}
			
			return result;
		}
	}

}