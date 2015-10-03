package MatchANumber.GameEntity 
{
	import adobe.utils.CustomActions;
	import flash.geom.Point;
	import MatchANumber.DifficultyModes;
	import MatchANumber.GameplayModes;
	import MatchANumber.GameSfx;
	import MatchANumber.GameWorld.HelpWorld;
	import MatchANumber.GameWorld.StartWorld;
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
	public class TutorialEntity extends Entity
	{
		public static var X_SIZE:int = 2;
		public static var Y_SIZE:int = 2;
		public static var DisableControl:Boolean;
		
		private const RANDOM_AMOUNT:int = 5;
		private const EMPTY_ID:int = -1;
		
		[Embed(source = "../../../assets/wrong.mp3")]private var wrongClass:Class;
		[Embed(source = "../../../assets/correct.mp3")]private var correctClass:Class;
		[Embed(source = "../../../assets/drag.mp3")]private var dragClass:Class;
		
		private var dataBlockArray:Vector.<Vector.<DataBlock>>
		private var numberBlockArray:Vector.<Vector.<Entity>>;
		private var hudEntity:TutorialHUDEntity;
		private var backBlockImage:Image;
		
		private var touch1ID:int;
		private var touch1Array:Vector.<Point>;
		
		private var expectedResult1:int;
		
		private var startingAlarm:Alarm;
		private var numberOfStartingBlocks:int;
		private var numberGeneratorAlarm:Alarm;
		
		private var wrongSfx:GameSfx;
		private var correctSfx:GameSfx;
		private var dragSfx:GameSfx;
		
		public function TutorialEntity(hud:TutorialHUDEntity) 
		{
			Global.UpdateShift(Y_SIZE, X_SIZE);
			Global.Y_SHIFT += 80;
			
			wrongSfx = new GameSfx(wrongClass);
			correctSfx = new GameSfx(correctClass);
			dragSfx = new GameSfx(dragClass);
			
			touch1Array = new Vector.<Point>();
			touch1ID = EMPTY_ID;
			
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
			DisableControl = true;
			
			numberGeneratorAlarm = new Alarm(RANDOM_AMOUNT, GenerateNewNumberBlock, Tween.PERSIST);
			
			layer = LayerConstant.MAP_LAYER;
		}
		
		override public function added():void 
		{
			super.added();
			
			numberOfStartingBlocks = GetFreeTiles().length;
			startingAlarm = new Alarm(1, GenerateStartingBlocks, Tween.LOOPING);
			addTween(startingAlarm, true);
		}
		
		private function CheckAccessibleTiles(tilePosition:Point):Boolean
		{
			return true;
		}
		
		private function GenerateNewNumberBlock():void
		{
			if (!hudEntity.TutorialEnded())
			{
				var freeTiles:Vector.<Point> = GetFreeTiles();
				var chosenTile:int = FP.rand(freeTiles.length);
				if (freeTiles.length > 0)
				{
					numberBlockArray[freeTiles[chosenTile].y][freeTiles[chosenTile].x] = new NumberBlockEntity(freeTiles[chosenTile].x, 
						freeTiles[chosenTile].y, dataBlockArray[freeTiles[chosenTile].y][freeTiles[chosenTile].x]);
					FP.world.add(numberBlockArray[freeTiles[chosenTile].y][freeTiles[chosenTile].x]);
				}
			}
			
			numberGeneratorAlarm.reset(RANDOM_AMOUNT + FP.rand(RANDOM_AMOUNT));
			numberGeneratorAlarm.start();
		}
		
		private function GenerateTutorialDataBlock(xTile:int, yTile:int, tutorialNumber:int):void
		{
			var number:int = 0;
			var operation:String = "";
			switch (tutorialNumber) 
			{
				case 0:
					operation = MathOperation.ADD;
					if (xTile == 0)
					{
						if (yTile == 0)
						{
							number = 2;
						}
						else
						{
							number = 3;
						}
					}
					else
					{
						if (yTile == 0)
						{
							number = 4;
						}
						else
						{
							number = 1;
						}
					}
					break;
				case 1:
					operation = MathOperation.SUBTRACT;
					if (xTile == 0)
					{
						if (yTile == 0)
						{
							number = 1;
						}
						else
						{
							number = 3;
						}
					}
					else
					{
						if (yTile == 0)
						{
							number = 2;
						}
						else
						{
							number = 5;
						}
					}
					break;
				case 2:
					operation = MathOperation.MULTIPLY;
					if (xTile == 0)
					{
						if (yTile == 0)
						{
							number = 1;
						}
						else
						{
							number = 2;
						}
					}
					else
					{
						if (yTile == 0)
						{
							number = 2;
						}
						else
						{
							number = 2;
						}
					}
					break;
				case 3:
					if (xTile == 0)
					{
						if (yTile == 0)
						{
							number = 2;
							operation = MathOperation.MULTIPLY;
						}
						else
						{
							number = 4;
							operation = MathOperation.ADD;
						}
					}
					else
					{
						if (yTile == 0)
						{
							number = 3;
							operation = MathOperation.SUBTRACT;
						}
						else
						{
							number = 1;
							operation = MathOperation.ADD;
						}
					}
					break;
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
				SetFinalResult(hudEntity.currentTutorialText);
				
				DisableControl = false;
				addTween(numberGeneratorAlarm, true);
				
				return;
			}
			var freeTiles:Vector.<Point> = GetFreeTiles();
			var chosenTile:int = FP.rand(freeTiles.length);
			GenerateTutorialDataBlock(freeTiles[chosenTile].x, freeTiles[chosenTile].y, hudEntity.currentTutorialText);
			numberBlockArray[freeTiles[chosenTile].y][freeTiles[chosenTile].x] = new NumberBlockEntity(freeTiles[chosenTile].x, 
				freeTiles[chosenTile].y, dataBlockArray[freeTiles[chosenTile].y][freeTiles[chosenTile].x]);
			FP.world.add(numberBlockArray[freeTiles[chosenTile].y][freeTiles[chosenTile].x]);
		}
		
		private function SetFinalResult(tutorialNumber:int):void
		{
			switch (tutorialNumber) 
			{
				case 0:
					expectedResult1 = 7;
					break;
				case 1:
					expectedResult1 = -4;
					break;
				case 2:
					expectedResult1 = -8;
					break;
				case 3:
					expectedResult1 = 0;
					break;
			}
			
			hudEntity.ChangeFinalResult1(expectedResult1);
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
			GenerateTutorialDataBlock(xTile, yTile, hudEntity.currentTutorialText);
			dataBlockArray[yTile][xTile].direction = 0;
		}
		
		private function ClearTile(xTile:int, yTile:int):void
		{
			FP.world.remove(numberBlockArray[yTile][xTile]);
			numberBlockArray[yTile][xTile] = null;
			if (hudEntity.TutorialEnded() && GetFreeTiles().length == X_SIZE * Y_SIZE)
			{
				if (Global.firstTime)
				{
					Global.firstTime = false;
					Global.SaveGame();
					FP.world = new StartWorld();
				}
				else
				{
					FP.world = new HelpWorld();
				}
			}
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
					tempResultsArray.push(expectedResult1);
					
					if (CheckExpectedResult(result, tempResultsArray) && touch1Array.length > 1)
					{
						correctSfx.play(0.5);
						hudEntity.GetNextTutorialText();
						for (var k:int = 0; k < touch1Array.length; k++) 
						{
							RemoveTile(touch1Array[k].x, touch1Array[k].y);
						}
						
						SetFinalResult(hudEntity.currentTutorialText);
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
		
		override public function update():void 
		{
			super.update();
			
			if (DisableControl)
			{
				touch1ID = EMPTY_ID;
				touch1Array.length = 0;
				
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
					}
				}
			}
			
			UpdateOneTouch();
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