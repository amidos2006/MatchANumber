package MatchANumber.GameEntity 
{
	import adobe.utils.CustomActions;
	import flash.geom.Point;
	import MatchANumber.DifficultyModes;
	import MatchANumber.GameplayModes;
	import MatchANumber.GameSfx;
	import MatchANumber.GameWorld.GameplayWorld;
	import MatchANumber.Global;
	import MatchANumber.LayerConstant;
	import MatchANumber.PlayerHand;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.TouchControl;
	import net.flashpunk.utils.TouchPoint;
	/**
	 * ...
	 * @author Amidos
	 */
	public class MapEntity extends Entity
	{
		public static var X_SIZE:int = 4;
		public static var Y_SIZE:int = 6;
		public static var NUMBER_OF_SETS:int = 6;
		public static var NUMBER_OF_PUZZLE_SET:int = 4;
		public static var DisableControl:Boolean;
		
		private const RANDOM_AMOUNT:int = 5;
		private const EMPTY_ID:int = -1;
		
		[Embed(source = "../../../assets/wrong.mp3")]private var wrongClass:Class;
		[Embed(source = "../../../assets/correct.mp3")]private var correctClass:Class;
		[Embed(source = "../../../assets/drag.mp3")]private var dragClass:Class;
		
		private var dataBlockArray:Vector.<Vector.<DataBlock>>;
		private var numberBlockArray:Vector.<Vector.<Entity>>;
		private var hudEntity:HUDEntity;
		private var backBlockImage:Image;
		
		private var touch1ID:int;
		private var touch2ID:int;
		private var touch1Array:Vector.<Point>;
		private var touch2Array:Vector.<Point>;
		
		private var expectedResult1:int;
		private var expectedResult2:int;
		private var expectedResults:Array;
		private var length:int;
		
		private var topUndoArray:int;
		private var undoArray:Array;
		
		private var startingAlarm:Alarm;
		private var regeneratePuzzleAlarm:Alarm;
		private var numberOfStartingBlocks:int;
		private var numberGeneratorAlarm:Alarm;
		
		private var wrongSfx:GameSfx;
		private var correctSfx:GameSfx;
		private var dragSfx:GameSfx;
		
		public function MapEntity(hud:HUDEntity) 
		{
			Global.UpdateShift(Y_SIZE, X_SIZE);
			
			wrongSfx = new GameSfx(wrongClass);
			correctSfx = new GameSfx(correctClass);
			dragSfx = new GameSfx(dragClass);
			
			touch1Array = new Vector.<Point>();
			touch2Array = new Vector.<Point>();
			touch1ID = EMPTY_ID;
			touch2ID = EMPTY_ID;
			
			dataBlockArray = new Vector.<Vector.<DataBlock>>();
			numberBlockArray = new Vector.<Vector.<Entity>>();
			for (var i:int = 0; i < Y_SIZE; i++) 
			{
				dataBlockArray.push(new Vector.<DataBlock>());
				numberBlockArray.push(new Vector.<Entity>());
				for (var j:int = 0; j < X_SIZE; j++) 
				{
					dataBlockArray[i].push(null);
					numberBlockArray[i].push(null);
				}
			}
			
			hudEntity = hud;
			
			backBlockImage = new Image(GraphicLoader.GetGraphics("backblock"));
			backBlockImage.centerOO();
			
			expectedResult1 = 0;
			expectedResult2 = 0;
			expectedResults = new Array();
			topUndoArray = 0;
			undoArray = new Array();
			length = 2;
			DisableControl = true;
			
			numberGeneratorAlarm = new Alarm(RANDOM_AMOUNT, GenerateNewNumberBlock, Tween.PERSIST);
			regeneratePuzzleAlarm = new Alarm(30, GenerateNewPuzzleBlocks, Tween.PERSIST);
			
			layer = LayerConstant.MAP_LAYER;
		}
		
		override public function added():void 
		{
			super.added();
			
			numberOfStartingBlocks = GetFreeTiles().length;
			startingAlarm = new Alarm(1, GenerateStartingBlocks, Tween.LOOPING);
			addTween(startingAlarm, true);
			addTween(regeneratePuzzleAlarm);
			
			if (Global.numberOfResets != Global.ALLOWED_NUMBER_RESET && Global.gameplayMode == GameplayModes.PUZZLE)
			{
				Global.score1 = Global.score2;
			}
			else
			{
				Global.score1 = 0;
				Global.score2 = 0;
				Global.puzzleNumber = 1;
			}
			
			hudEntity.ChangeScore1(Global.score1);
			hudEntity.ChangeScore2(Global.score2);
			hudEntity.ChangePuzzleNumber(Global.puzzleNumber);
			
			switch (Global.difficultyMode) 
			{
				case DifficultyModes.EASY:
					NUMBER_OF_PUZZLE_SET = 4;
					break;
				case DifficultyModes.MEDIUM:
					NUMBER_OF_PUZZLE_SET = 4;
					break;
				case DifficultyModes.HARD:
					NUMBER_OF_PUZZLE_SET = 4;
					break;
			}
		}
		
		private function CheckAccessibleTiles(tilePosition:Point):Boolean
		{
			if (Global.gameplayMode == GameplayModes.MULTIPLAYER)
			{
				return !(tilePosition.x == 0 && tilePosition.y == Y_SIZE - 1) && 
					!(tilePosition.x == X_SIZE - 1 && tilePosition.y == Y_SIZE - 1) &&
					!(tilePosition.x == 0 && tilePosition.y == 0) &&
					!(tilePosition.x == X_SIZE - 1 && tilePosition.y == 0);
			}
			if (Global.gameplayMode == GameplayModes.PUZZLE)
			{
				//if (Global.player1Hand == PlayerHand.RIGHT_HANDED)
				//{
					//return !(tilePosition.x == X_SIZE - 1 && tilePosition.y == Y_SIZE - 1);
				//}
				//
				//return !(tilePosition.x == 0 && tilePosition.y == Y_SIZE - 1)
				
				return !(tilePosition.x == 0 && tilePosition.y == Y_SIZE - 1) && !(tilePosition.x == X_SIZE - 1 && tilePosition.y == Y_SIZE - 1);
			}
			
			return !(tilePosition.x == 0 && tilePosition.y == Y_SIZE - 1) && !(tilePosition.x == X_SIZE - 1 && tilePosition.y == Y_SIZE - 1);
		}
		
		private function GenerateNewPuzzleBlocks(incrementPuzzle:Boolean = true):void
		{
			if (Global.puzzleNumber < 10)
			{
				if (incrementPuzzle)
				{
					Global.puzzleNumber += 1;
					Global.score2 = Global.score1;
				}
				hudEntity.ChangePuzzleNumber(Global.puzzleNumber);
				
				numberOfStartingBlocks = GetFreeTiles().length;
				startingAlarm = new Alarm(1, GenerateStartingBlocks, Tween.LOOPING);
				
				addTween(startingAlarm, true);
				undoArray = new Array();
				topUndoArray = 0;
			}
			else
			{
				hudEntity.GameOver();
			}
		}
		
		private function GenerateNewNumberBlock():void
		{
			var freeTiles:Vector.<Point> = GetFreeTiles();
			var chosenTile:int = FP.rand(freeTiles.length);
			if (freeTiles.length > 0)
			{
				numberBlockArray[freeTiles[chosenTile].y][freeTiles[chosenTile].x] = new NumberBlockEntity(freeTiles[chosenTile].x, 
					freeTiles[chosenTile].y, dataBlockArray[freeTiles[chosenTile].y][freeTiles[chosenTile].x]);
				FP.world.add(numberBlockArray[freeTiles[chosenTile].y][freeTiles[chosenTile].x]);
			}
			numberGeneratorAlarm.reset(RANDOM_AMOUNT + FP.rand(RANDOM_AMOUNT));
			numberGeneratorAlarm.start();
		}
		
		private function GenerateRandomDataBlock(xTile:int, yTile:int):void
		{
			var multiplyPercentage:Number = 0.15;
			switch (Global.difficultyMode) 
			{
				case DifficultyModes.MEDIUM:
					multiplyPercentage = 0.175;
					break;
				case DifficultyModes.HARD:
					multiplyPercentage = 0.2;
					break;
			}
			
			var operation:String = MathOperation.ADD;
			if (FP.random < multiplyPercentage)
			{
				operation = MathOperation.MULTIPLY;
			}
			else
			{
				if (FP.random < 0.5)
				{
					operation = MathOperation.SUBTRACT;
				}
				else
				{
					operation = MathOperation.ADD;
				}
			}
			
			var normalNumber:int = 4;
			var multiplyNumber:int = 1;
			switch (Global.difficultyMode) 
			{
				case DifficultyModes.MEDIUM:
					normalNumber = 6;
					multiplyNumber = 1;
					break;
				case DifficultyModes.HARD:
					normalNumber = 7;
					multiplyNumber = 2;
					break;
			}
			
			var number:int = FP.rand(normalNumber) + 1;
			if (operation == MathOperation.MULTIPLY)
			{
				number = FP.rand(multiplyNumber) + 2;
			}
			
			dataBlockArray[yTile][xTile] = new DataBlock(number, operation);
		}
		
		private function GenerateStartingBlocks():void
		{
			numberOfStartingBlocks -= 1;
			if (numberOfStartingBlocks < 0)
			{
				removeTween(startingAlarm);
				var resultAway:Vector.<int> = new Vector.<int>();
				resultAway.push(expectedResult1);
				if (Global.gameplayMode == GameplayModes.NORMAL)
				{
					SetFinalResult(length, resultAway, 1);
					if (!Global.firstTimeGoal[Global.gameplayMode])
					{
						hudEntity.StartAlarm();
					}
				}
				else if (Global.gameplayMode == GameplayModes.MULTIPLAYER)
				{
					SetMultiplayerFinalResult(length, resultAway, 1);
					resultAway.push(expectedResult1, expectedResult2);
					SetMultiplayerFinalResult(length, resultAway, 2);
					hudEntity.StartAlarm();
				}
				else
				{
					NUMBER_OF_SETS = DifficultyLength.GetPuzzleSetLength(Global.difficultyMode, Global.score1);
					SetFinalResults();
					hudEntity.ChangeFinalPuzzleResult(expectedResults);
				}
				if (!Global.firstTimeGoal[Global.gameplayMode])
				{
					DisableControl = false;
				}
				if (Global.gameplayMode != GameplayModes.PUZZLE)
				{
					addTween(numberGeneratorAlarm, true);
				}
				return;
			}
			var freeTiles:Vector.<Point> = GetFreeTiles();
			var chosenTile:int = FP.rand(freeTiles.length);
			GenerateRandomDataBlock(freeTiles[chosenTile].x, freeTiles[chosenTile].y);
			if (Global.gameplayMode == GameplayModes.MULTIPLAYER)
			{
				dataBlockArray[freeTiles[chosenTile].y][freeTiles[chosenTile].x].direction = 0;
				if (freeTiles[chosenTile].y < Y_SIZE / 2)
				{
					dataBlockArray[freeTiles[chosenTile].y][freeTiles[chosenTile].x].direction = 180;
				}
			}
			numberBlockArray[freeTiles[chosenTile].y][freeTiles[chosenTile].x] = new NumberBlockEntity(freeTiles[chosenTile].x, 
				freeTiles[chosenTile].y, dataBlockArray[freeTiles[chosenTile].y][freeTiles[chosenTile].x]);
			FP.world.add(numberBlockArray[freeTiles[chosenTile].y][freeTiles[chosenTile].x]);
		}
		
		private function CheckResultAway(currentResult:int, resultAway:Vector.<int>):Boolean
		{
			for (var i:int = 0; i < resultAway.length; i++) 
			{
				if (currentResult == resultAway[i])
				{
					return false;
				}
			}
			
			return true;
		}
		
		private function GetRandomMinIndex(setArray:Array):int
		{
			var minimumIndex:int = 0;
			for (var i:int = 1; i < setArray.length; i++) 
			{
				if (setArray[i].tilesArray.length < setArray[minimumIndex].tilesArray.length)
				{
					minimumIndex = i;
				}
			}
			
			var randomIndex:int = FP.rand(setArray.length);
			
			if (FP.random < 0.75)
			{
				return minimumIndex;
			}
			
			return randomIndex;
		}
		
		private function SetFinalResults():void
		{
			var setArray:Array = new Array();
			for (var i:int = 0; i < Y_SIZE; i++) 
			{
				for (var j:int = 0; j < X_SIZE; j++) 
				{
					if (CheckAccessibleTiles(new Point(j, i)))
					{
						setArray.push(new Set(new Point(j, i)));
					}
				}
			}
			
			Global.ShuffleArray(setArray);
			for (i = 0; i < setArray.length; i++) 
			{
				var firstSet:Set = setArray[i];
				if (firstSet.tilesArray.length <= 1)
				{
					var possibleIndeces:Array = firstSet.GetPossible(setArray);
					if (possibleIndeces.length > 0)
					{
						Global.ShuffleArray(possibleIndeces);
						for (j = 0; j < possibleIndeces.length; j++) 
						{
							var secondIndex:int = possibleIndeces[j];
							var secondSet:Set = setArray[secondIndex];
							if (firstSet.MergeIfPossible(secondSet))
							{
								setArray.splice(secondIndex, 1);
								i -= 1;
								break;
							}
						}
					}
				}
				
				if (firstSet.tilesArray.length <= 1)
				{
					SetFinalResults();
					return;
				}
			}
			
			do
			{
				firstSet = setArray[GetRandomMinIndex(setArray)];
				possibleIndeces = firstSet.GetPossible(setArray);
				if (possibleIndeces.length > 0)
				{
					secondIndex = possibleIndeces[FP.rand(possibleIndeces.length)];
					secondSet = setArray[secondIndex];
					if (firstSet.MergeIfPossible(secondSet))
					{
						setArray.splice(secondIndex, 1);
					}
				}
			}while (setArray.length > NUMBER_OF_SETS);
			
			expectedResults = new Array();
			for (i = 0; i < Math.min(NUMBER_OF_PUZZLE_SET, setArray.length); i++) 
			{
				expectedResults.push(GetEquationResult(setArray[i].tilesArray));
			}
			
			if (expectedResults.length != NUMBER_OF_PUZZLE_SET)
			{
				SetFinalResults();
			}
		}
		
		private function SetFinalResult(length:int, resultAway:Vector.<int>, playerID:int):void
		{
			var randomStartingPoint:Point = new Point();
			do 
			{
				randomStartingPoint.x = FP.rand(X_SIZE);
				randomStartingPoint.y = FP.rand(Y_SIZE);
			}while (dataBlockArray[randomStartingPoint.y][randomStartingPoint.x] == null || !CheckAccessibleTiles(randomStartingPoint));
			
			var directionArray:Array = [new Point( -1, 0), new Point(1, 0), new Point(0, -1), new Point(0, 1)];
			Global.ShuffleArray(directionArray);
			var mathArray:Vector.<Point> = new Vector.<Point>();
			mathArray.push(randomStartingPoint);
			for (var i:int = 0; i < length - 1; i++) 
			{
				var newDirection:Boolean = false;
				for (var j:int = 0; j < directionArray.length; j++) 
				{
					var direction:int = FP.rand(directionArray.length);
					var newPoint:Point = randomStartingPoint.add(directionArray[direction]);
					if (newPoint.x >= 0 && newPoint.y >= 0 && newPoint.x < X_SIZE && newPoint.y < Y_SIZE && NotInTheList(newPoint, mathArray) &&
						CheckAccessibleTiles(newPoint))
					{
						newDirection = true;
						break;
					}
				}
				
				if(newDirection && dataBlockArray[newPoint.y][newPoint.x] != null)
				{
					mathArray.push(newPoint);
					randomStartingPoint = newPoint;
				}
			}
			
			if (mathArray.length == length && CheckResultAway(GetEquationResult(mathArray), resultAway))
			{
				if (playerID == 1)
				{
					expectedResult1 = GetEquationResult(mathArray);
					hudEntity.ChangeFinalResult1(expectedResult1);
				}
				else if (playerID == 2)
				{
					expectedResult2 = GetEquationResult(mathArray);
					hudEntity.ChangeFinalResult2(expectedResult2);
				}
			}
			else
			{
				SetFinalResult(length, resultAway, playerID);
			}
		}
		
		private function SetMultiplayerFinalResult(length:int, resultAway:Vector.<int>, playerID:int):void
		{
			var randomStartingPoint:Point = new Point();
			do 
			{
				randomStartingPoint.x = FP.rand(X_SIZE);
				randomStartingPoint.y = FP.rand(Y_SIZE / 2);
				if (playerID == 1)
				{
					randomStartingPoint.y += Math.floor(Y_SIZE / 2);
				}
			}while (dataBlockArray[randomStartingPoint.y][randomStartingPoint.x] == null || !CheckAccessibleTiles(randomStartingPoint));
			
			var directionArray:Array = [new Point( -1, 0), new Point(1, 0), new Point(0, -1), new Point(0, 1)];
			Global.ShuffleArray(directionArray);
			var mathArray:Vector.<Point> = new Vector.<Point>();
			mathArray.push(randomStartingPoint);
			for (var i:int = 0; i < length - 1; i++) 
			{
				var newDirection:Boolean = false;
				for (var j:int = 0; j < directionArray.length; j++) 
				{
					var direction:int = FP.rand(directionArray.length);
					var newPoint:Point = randomStartingPoint.add(directionArray[direction]);
					if (newPoint.x >= 0 && newPoint.y >= 0 && newPoint.x < X_SIZE && newPoint.y < Y_SIZE && NotInTheList(newPoint, mathArray) &&
						CheckAccessibleTiles(newPoint))
					{
						newDirection = true;
						break;
					}
				}
				
				if(newDirection && dataBlockArray[newPoint.y][newPoint.x] != null)
				{
					mathArray.push(newPoint);
					randomStartingPoint = newPoint;
				}
			}
			
			if (mathArray.length == length && CheckResultAway(GetEquationResult(mathArray), resultAway))
			{
				if (playerID == 1)
				{
					expectedResult1 = GetEquationResult(mathArray);
					hudEntity.ChangeFinalResult1(expectedResult1);
				}
				else if (playerID == 2)
				{
					expectedResult2 = GetEquationResult(mathArray);
					hudEntity.ChangeFinalResult2(expectedResult2);
				}
			}
			else
			{
				SetMultiplayerFinalResult(length, resultAway, playerID);
			}
		}
		
		private function GetFreeTiles():Vector.<Point>
		{
			var tileArray:Vector.<Point> = new Vector.<Point>();
			
			for (var i:int = 0; i < Y_SIZE; i++) 
			{
				for (var j:int = 0; j < X_SIZE; j++) 
				{
					if (numberBlockArray[i][j] == null && CheckAccessibleTiles(new Point(j, i)))
					{
						tileArray.push(new Point(j, i));
					}
				}
			}
			
			return tileArray;
		}
		
		private function IsPuzzleSolved():Boolean
		{
			for (var i:int = 0; i < Y_SIZE; i++) 
			{
				for (var j:int = 0; j < X_SIZE; j++) 
				{
					if (CheckAccessibleTiles(new Point(j, i)) && numberBlockArray[i][j] is NumberBlockEntity)
					{
						return false;
					}
				}
			}
			
			return true;
		}
		
		private function AddTile(xTile:int, yTile:int):void
		{
			if (numberBlockArray[yTile][xTile] != null)
			{
				FP.world.remove(numberBlockArray[yTile][xTile]);
			}
			
			numberBlockArray[yTile][xTile] = new NumberBlockEntity(xTile, yTile, dataBlockArray[yTile][xTile]);
			FP.world.add(numberBlockArray[yTile][xTile]);
		}
		
		private function RemoveTile(xTile:int, yTile:int, playerNumber:int = 0):void
		{
			var tempTile:NumberBlockEntity = numberBlockArray[yTile][xTile] as NumberBlockEntity;
			FP.world.remove(tempTile);
			numberBlockArray[yTile][xTile] = new DeathNumberBlockEntity(xTile, yTile, tempTile.dataBlock, ClearTile);
			FP.world.add(numberBlockArray[yTile][xTile]);
			if (Global.gameplayMode != GameplayModes.PUZZLE)
			{
				GenerateRandomDataBlock(xTile, yTile);
				if (playerNumber == 1)
				{
					dataBlockArray[yTile][xTile].direction = 0;
				}
				else if (playerNumber == 2)
				{
					dataBlockArray[yTile][xTile].direction = 180;
				}
			}
		}
		
		private function RemoveExpectedResult(result:int):void
		{
			for (var j:int = 0; j < expectedResults.length; j++) 
			{
				if (result == expectedResults[j])
				{
					expectedResults.splice(j, 1);
					return;
				}
			}
		}
		
		public function UndoAllowed():Boolean
		{
			return topUndoArray > 0 && !DisableControl;
		}
		
		public function Undo():void
		{	
			hudEntity.HideUndoBar();
			
			topUndoArray -= 1;
			var tilesArray:Vector.<Point> = undoArray[topUndoArray];
			for (var i:int = 0; i < tilesArray.length; i++) 
			{
				AddTile(tilesArray[i].x, tilesArray[i].y);
			}
			
			Global.score1 -= tilesArray.length;
			hudEntity.ChangeScore1(Global.score1);
			expectedResults.push(GetEquationResult(tilesArray));
			hudEntity.ChangeFinalPuzzleResult(expectedResults);
		}
		
		public function RedoAllowed():Boolean
		{
			return undoArray.length > topUndoArray && !DisableControl;
		}
		
		public function Redo():void
		{
			var tilesArray:Vector.<Point> = undoArray[topUndoArray];
			for (var i:int = 0; i < tilesArray.length; i++) 
			{
				RemoveTile(tilesArray[i].x, tilesArray[i].y);
			}
			
			Global.score1 += tilesArray.length;
			hudEntity.ChangeScore1(Global.score1);
			RemoveExpectedResult(GetEquationResult(tilesArray));
			topUndoArray += 1;
			hudEntity.ChangeFinalPuzzleResult(expectedResults);
		}
		
		private function ClearTile(xTile:int, yTile:int):void
		{
			FP.world.remove(numberBlockArray[yTile][xTile]);
			numberBlockArray[yTile][xTile] = null;
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
		
		private function NotInTheList(point:Point, list:Vector.<Point>):Boolean
		{
			for (var i:int = 0; i < list.length; i++) 
			{
				if (point.x == list[i].x && point.y == list[i].y)
				{
					return false;
				}
			}
			return true;
		}
		
		private function GetEquationResult(list:Vector.<Point>):int
		{
			var result:int = 0;
			var specialCase:Boolean = false;
			
			for (var i:int = 0; i < list.length; i++) 
			{
				var currentDataBlock:DataBlock = dataBlockArray[list[i].y][list[i].x];
				
				if (specialCase)
				{
					switch (currentDataBlock.operation) 
					{
						case MathOperation.ADD:
							result *= currentDataBlock.number;
							break;
						case MathOperation.SUBTRACT:
							result *= -currentDataBlock.number;
							break;
						case MathOperation.MULTIPLY:
							result *= currentDataBlock.number;
							break;
					}
					specialCase = false;
					continue;
				}
				
				switch (currentDataBlock.operation) 
				{
					case MathOperation.ADD:
						result += currentDataBlock.number;
						break;
					case MathOperation.SUBTRACT:
						result -= currentDataBlock.number;
						break;
					case MathOperation.MULTIPLY:
						if (i == 0)
						{
							result = currentDataBlock.number;
							specialCase = true;
						}
						else
						{
							result *= currentDataBlock.number;
						}
						break;
				}
			}
			
			return result;
		}
		
		private function CheckExpectedResult(value:int, array:Array):Boolean
		{
			for (var i:int = 0; i < array.length; i++) 
			{
				if (value == array[i])
				{
					array.splice(i, 1);
					return true;
				}
			}
			
			return false;
		}
		
		private function UpdateOneTouch():void
		{
			var points:Vector.<TouchPoint> = TouchControl.GetTouchPoints();
			var touchTile:Point;
			if (points.length > 0)
			{
				touchTile = Global.GetTileFromPosition(new Point(points[0].x, points[0].y));
			}
			
			if (touch1Array.length == 0)
			{
				if (TouchControl.TouchDown() || TouchControl.TouchPressed())
				{
					if (touchTile.x >= 0 && touchTile.x < X_SIZE && touchTile.y >= 0 && touchTile.y < Y_SIZE)
					{
						if (numberBlockArray[touchTile.y][touchTile.x] != null && numberBlockArray[touchTile.y][touchTile.x] is NumberBlockEntity)
						{
							touch1Array.push(new Point(touchTile.x, touchTile.y));
							hudEntity.ChangeCurrentResult1(GetEquationResult(touch1Array), Global.GetPositionFromTile(touchTile).add(new Point(Global.TILE_SIZE / 2, Global.TILE_SIZE / 2)));
							dragSfx.play(0.5);
						}
					}
				}
			}
			else
			{
				if (TouchControl.TouchDown())
				{
					if (touchTile.x >= 0 && touchTile.x < X_SIZE && touchTile.y >= 0 && touchTile.y < Y_SIZE)
					{
						if (numberBlockArray[touchTile.y][touchTile.x] != null && numberBlockArray[touchTile.y][touchTile.x] is NumberBlockEntity)
						{
							if (CheckOneTileAway(touchTile, touch1Array[touch1Array.length - 1]) && NotInTheList(touchTile, touch1Array))
							{
								touch1Array.push(new Point(touchTile.x, touchTile.y));
								hudEntity.ChangeCurrentResult1(GetEquationResult(touch1Array), Global.GetPositionFromTile(touchTile).add(new Point(Global.TILE_SIZE / 2, Global.TILE_SIZE / 2)));
								dragSfx.play(0.5);
							}
							if (touch1Array.length > 1 && touchTile.x == touch1Array[touch1Array.length - 2].x && 
								touchTile.y == touch1Array[touch1Array.length - 2].y)
							{
								touch1Array.pop();
								hudEntity.ChangeCurrentResult1(GetEquationResult(touch1Array), Global.GetPositionFromTile(touchTile).add(new Point(Global.TILE_SIZE / 2, Global.TILE_SIZE / 2)));
								dragSfx.play(0.5);
							}
						}
					}
				}
				
				if (TouchControl.TouchReleased())
				{
					var result:int = GetEquationResult(touch1Array);
					var tempResultsArray:Array = new Array();
					if (Global.gameplayMode == GameplayModes.NORMAL)
					{
						tempResultsArray.push(expectedResult1);
					}
					else if (Global.gameplayMode == GameplayModes.PUZZLE)
					{
						for (var i:int = 0; i < expectedResults.length; i++) 
						{
							tempResultsArray.push(expectedResults[i]);
						}
					}
					
					if (CheckExpectedResult(result, tempResultsArray) && touch1Array.length > 1)
					{
						correctSfx.play(0.5);
						for (var k:int = 0; k < touch1Array.length; k++) 
						{
							RemoveTile(touch1Array[k].x, touch1Array[k].y);
						}
						
						if (Global.gameplayMode == GameplayModes.NORMAL)
						{
							Global.score1 += touch1Array.length;
							hudEntity.ChangeScore1(Global.score1);
							hudEntity.IncreaseTimer(touch1Array.length * DifficultyLength.GetTimeFactor(touch1Array.length, Global.score1));
							length = DifficultyLength.GetLevel(Global.score1);
							
							var resultAway:Vector.<int> = new Vector.<int>();
							resultAway.push(expectedResult1);
							SetFinalResult(length, resultAway, 1);
						}
						else if (Global.gameplayMode == GameplayModes.PUZZLE)
						{
							Global.score1 += touch1Array.length;
							hudEntity.ChangeScore1(Global.score1);
							RemoveExpectedResult(result);
							hudEntity.ChangeFinalPuzzleResult(expectedResults);
							
							var removalCount:int = undoArray.length - topUndoArray;
							if (removalCount > 0)
							{
								undoArray.splice(undoArray.length - removalCount, removalCount);
							}
							var undoResultArray:Vector.<Point> = new Vector.<Point>();
							for (var j:int = 0; j < touch1Array.length; j++) 
							{
								undoResultArray.push(touch1Array[j]);
							}
							undoArray.push(undoResultArray);
							topUndoArray += 1;
							
							if (expectedResults.length == 0 && !startingAlarm.active)
							{
								DisableControl = true;
								regeneratePuzzleAlarm.start();
							}
						}
					}
					else
					{
						wrongSfx.play(0.2);
					}
					touch1Array.length = 0;
					hudEntity.ClearCurrentResult1();
				}
			}
		}
		
		private function UpdateTwoTouch():void
		{
			var points:Vector.<TouchPoint> = TouchControl.GetTouchPoints();
			var touchTile:Point;
			for (var i:int = 0; i < points.length; i++) 
			{
				touchTile = Global.GetTileFromPosition(new Point(points[i].x, points[i].y));
				if (points[i].touchState == TouchControl.PRESSED)
				{
					if (touchTile.x >= 0 && touchTile.x < X_SIZE && touchTile.y >= 0 && touchTile.y < Y_SIZE)
					{
						if (numberBlockArray[touchTile.y][touchTile.x] != null && numberBlockArray[touchTile.y][touchTile.x] is NumberBlockEntity &&
							NotInTheList(touchTile, touch1Array) && NotInTheList(touchTile, touch2Array))
						{
							if (touch1ID == EMPTY_ID)
							{
								touch1ID = points[i].touchID;
								touch1Array.push(new Point(touchTile.x, touchTile.y));
								hudEntity.ChangeCurrentResult1(GetEquationResult(touch1Array), Global.GetPositionFromTile(touchTile).add(new Point(Global.TILE_SIZE / 2, Global.TILE_SIZE / 2)));
								dragSfx.play(0.5);
							}
							else if (touch2ID == EMPTY_ID)
							{
								touch2ID = points[i].touchID;
								touch2Array.push(new Point(touchTile.x, touchTile.y));
								hudEntity.ChangeCurrentResult2(GetEquationResult(touch1Array), Global.GetPositionFromTile(touchTile).add(new Point(Global.TILE_SIZE / 2, Global.TILE_SIZE / 2)));
								dragSfx.play(0.5);
							}
						}
					}
				}
				else if (points[i].touchState == TouchControl.DOWN)
				{
					if (touchTile.x >= 0 && touchTile.x < X_SIZE && touchTile.y >= 0 && touchTile.y < Y_SIZE)
					{
						if (numberBlockArray[touchTile.y][touchTile.x] != null && numberBlockArray[touchTile.y][touchTile.x] is NumberBlockEntity)
						{
							if (touch1ID == points[i].touchID)
							{
								if (CheckOneTileAway(touchTile, touch1Array[touch1Array.length - 1]) && NotInTheList(touchTile, touch1Array) &&
									NotInTheList(touchTile, touch2Array))
								{
									touch1Array.push(new Point(touchTile.x, touchTile.y));
									hudEntity.ChangeCurrentResult1(GetEquationResult(touch1Array), Global.GetPositionFromTile(touchTile).add(new Point(Global.TILE_SIZE / 2, Global.TILE_SIZE / 2)));
									dragSfx.play(0.5);
								}
								if (touch1Array.length > 1 && touchTile.x == touch1Array[touch1Array.length - 2].x && 
									touchTile.y == touch1Array[touch1Array.length - 2].y)
								{
									touch1Array.pop();
									hudEntity.ChangeCurrentResult1(GetEquationResult(touch1Array), Global.GetPositionFromTile(touchTile).add(new Point(Global.TILE_SIZE / 2, Global.TILE_SIZE / 2)));
									dragSfx.play(0.5);
								}
							}
							else if (touch2ID == points[i].touchID)
							{
								if (CheckOneTileAway(touchTile, touch2Array[touch2Array.length - 1]) && NotInTheList(touchTile, touch1Array) &&
									NotInTheList(touchTile, touch2Array))
								{
									touch2Array.push(new Point(touchTile.x, touchTile.y));
									hudEntity.ChangeCurrentResult2(GetEquationResult(touch2Array), Global.GetPositionFromTile(touchTile).add(new Point(Global.TILE_SIZE / 2, Global.TILE_SIZE / 2)));
									dragSfx.play(0.5);
								}
								if (touch2Array.length > 1 && touchTile.x == touch2Array[touch2Array.length - 2].x && 
									touchTile.y == touch2Array[touch2Array.length - 2].y)
								{
									touch2Array.pop();
									hudEntity.ChangeCurrentResult2(GetEquationResult(touch2Array), Global.GetPositionFromTile(touchTile).add(new Point(Global.TILE_SIZE / 2, Global.TILE_SIZE / 2)));
									dragSfx.play(0.5);
								}
							}
						}
					}
				}
				else if (points[i].touchState == TouchControl.RELEASED)
				{
					var result:int;
					var k:int;
					if (touch1ID == points[i].touchID)
					{
						result = GetEquationResult(touch1Array);
						if ((result == expectedResult1 || result == expectedResult2) && touch1Array.length > 1)
						{
							correctSfx.play(0.5);
							var playerNumber:int = 0;
							if (result == expectedResult1)
							{
								Global.score1 += touch1Array.length;
								hudEntity.ChangeScore1(Global.score1);
								playerNumber = 1;
							}
							else if (result == expectedResult2)
							{
								Global.score2 += touch1Array.length;
								hudEntity.ChangeScore2(Global.score2);
								playerNumber = 2;
							}
							
							if (Global.score1 >= 50 || Global.score2 >= 50)
							{
								hudEntity.GameOver();
							}
							
							for (k = 0; k < touch1Array.length; k++) 
							{
								RemoveTile(touch1Array[k].x, touch1Array[k].y, playerNumber);
							}
							var resultAway:Vector.<int> = new Vector.<int>();
							resultAway.push(expectedResult1, expectedResult2);
							length = DifficultyLength.GetLevel(Global.score1);
							SetMultiplayerFinalResult(length, resultAway, 1);
							resultAway.push(expectedResult1);
							length = DifficultyLength.GetLevel(Global.score2);
							SetMultiplayerFinalResult(length, resultAway, 2);
						}
						else
						{
							wrongSfx.play(0.2);
						}
						touch1Array.length = 0;
						touch1ID = EMPTY_ID;
						hudEntity.ClearCurrentResult1();
					}
					else if (touch2ID == points[i].touchID)
					{
						result = GetEquationResult(touch2Array);
						if ((result == expectedResult1 || result == expectedResult2) && touch2Array.length > 1)
						{
							correctSfx.play(0.5);
							playerNumber = 0;
							if (result == expectedResult1)
							{
								Global.score1 += touch2Array.length;
								hudEntity.ChangeScore1(Global.score1);
								playerNumber = 1;
							}
							else if (result == expectedResult2)
							{
								Global.score2 += touch2Array.length;
								hudEntity.ChangeScore2(Global.score2);
								playerNumber = 2;
							}
							for (k = 0; k < touch2Array.length; k++) 
							{
								RemoveTile(touch2Array[k].x, touch2Array[k].y, playerNumber);
							}
							resultAway = new Vector.<int>();
							resultAway.push(expectedResult1, expectedResult2);
							length = DifficultyLength.GetLevel(Global.score1);
							SetMultiplayerFinalResult(length, resultAway, 1);
							resultAway.push(expectedResult1);
							length = DifficultyLength.GetLevel(Global.score2);
							SetMultiplayerFinalResult(length, resultAway, 2);
						}
						else
						{
							wrongSfx.play(0.2);
						}
						touch2Array.length = 0;
						touch2ID = EMPTY_ID;
						hudEntity.ClearCurrentResult2();
					}
				}
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			if (DisableControl)
			{
				touch1ID = EMPTY_ID;
				touch2ID = EMPTY_ID;
				touch1Array.length = 0;
				touch2Array.length = 0;
				
				return;
			}
			
			for (var i:int = 0; i < Y_SIZE; i++)
			{
				for (var j:int = 0; j < X_SIZE; j++) 
				{
					if (numberBlockArray[i][j] != null && numberBlockArray[i][j] is NumberBlockEntity)
					{
						(numberBlockArray[i][j] as NumberBlockEntity).GoLow();
					}
					if (numberBlockArray[i][j] != null && numberBlockArray[i][j] is NumberBlockEntity)
					{
						if (!NotInTheList(new Point(j, i), touch1Array))
						{
							(numberBlockArray[i][j] as NumberBlockEntity).GoHigh1();
						}
						if (!NotInTheList(new Point(j, i), touch2Array))
						{
							(numberBlockArray[i][j] as NumberBlockEntity).GoHigh2();
						}
					}
				}
			}
			
			switch (Global.gameplayMode) 
			{
				case GameplayModes.NORMAL:
					UpdateOneTouch();
					break;
				case GameplayModes.PUZZLE:
					UpdateOneTouch();
					break;
				case GameplayModes.MULTIPLAYER:
					UpdateTwoTouch();
					break;
			}
		}
		
		override public function render():void 
		{
			super.render();
			
			for (var i:int = 0; i < Y_SIZE; i++) 
			{
				for (var j:int = 0; j < X_SIZE; j++) 
				{
					if (CheckAccessibleTiles(new Point(j, i)))
					{
						var position:Point = Global.GetPositionFromTile(new Point(j, i));
						backBlockImage.render(FP.buffer, position.add(new Point(Global.TILE_SIZE / 2, Global.TILE_SIZE / 2)), FP.camera);
					}
				}
			}
		}
	}

}