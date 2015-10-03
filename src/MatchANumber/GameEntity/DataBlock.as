package MatchANumber.GameEntity 
{
	/**
	 * ...
	 * @author Amidos
	 */
	public class DataBlock 
	{
		public var number:Number;
		public var operation:String;
		public var direction:int;
		
		public function DataBlock(number:Number, operation:String)
		{
			this.number = number;
			this.operation = operation;
			this.direction = 0;
		}
		
	}

}