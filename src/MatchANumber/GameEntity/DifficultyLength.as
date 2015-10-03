package MatchANumber.GameEntity 
{
	import MatchANumber.DifficultyModes;
	/**
	 * ...
	 * @author Amidos
	 */
	public class DifficultyLength 
	{
		private static var values:Array = [2, 3, 4, 5, 6, 7];
		private static var times:Array = [1.25, 1.5, 2, 2.5, 3];
		private static var difficultyTimeFactor:Array = [1, 1, 0.75, 0.75, 0.5, 0.5];
		private static var puzzleEasySetNumbers:Array = [7, 6, 6, 5, 5, 4];
		private static var puzzleMediumSetNumbers:Array = [6, 5, 5, 4, 4, 4];
		private static var puzzleHardSetNumbers:Array = [5, 5, 5, 4, 4, 4];
		private static var scores:Array = [15, 30, 60, 120, 180, 280];
		
		public static function GetLevel(score:int):int
		{
			for (var i:int = 0; i < scores.length; i++) 
			{
				if (score < scores[i])
				{
					return values[i];
				}
			}
			
			return values[values.length - 1];
		}
		
		public static function GetTimeFactor(length:int, score:int):Number
		{
			var timeFactor:Number = times[Math.min(length, 6) - 2];
			var multiplier:Number = difficultyTimeFactor[difficultyTimeFactor.length - 1];
			
			for (var i:int = 0; i < scores.length; i++) 
			{
				if (score < scores[i])
				{
					multiplier = difficultyTimeFactor[i];
					break;
				}
			}
			
			return timeFactor * multiplier;
		}
		
		public static function GetPuzzleSetLength(difficulty:int, score:int):Number
		{
			var arraySet:Array = puzzleEasySetNumbers;
			if (difficulty == DifficultyModes.MEDIUM)
			{
				arraySet = puzzleMediumSetNumbers;
			}
			else
			{
				arraySet = puzzleHardSetNumbers;
			}
			
			for (var i:int = 0; i < scores.length; i++) 
			{
				if (score < scores[i])
				{
					return arraySet[i];
				}
			}
			
			return arraySet[arraySet.length - 1];
		}
	}

}