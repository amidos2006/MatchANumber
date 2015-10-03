package MatchANumber.GameEntity 
{
	import flash.geom.Point;
	import MatchANumber.GameplayModes;
	import MatchANumber.Global;
	import MatchANumber.LayerConstant;
	import MatchANumber.PlayerHand;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Ease;
	/**
	 * ...
	 * @author Amidos
	 */
	public class HUDEntity extends Entity
	{
		private var MAX_VALUE:Number;
		private const MAX_NORMAL_VALUE:Number = 60;
		private const MAX_MULTIPLAYER_VALUE:Number = 120;
		
		private const DARK_COLOR:uint = 0x666666;
		private const LIGHT_COLOR:uint = 0xFFFFFF;
		
		private var targetResult1Text:Text;
		private var targetResult2Text:Text;
		private var targetResultPuzzleText:Text;
		private var currentResult1Text:Text;
		private var currentResult2Text:Text;
		private var scoreValue1Text:Text;
		private var scoreValue2Text:Text;
		private var puzzleText:Text;
		private var puzzleNumberText:Text;
		private var maxPuzzleNumberText:Text;
		
		private var showCurrentResult1:Boolean;
		private var showCurrentResult2:Boolean;
		private var currentResultPosition1:Point;
		private var currentResultPosition2:Point;
		private var targetPuzzleResults:Array;
		
		private var currentResultImage:Image;
		private var tResultText:Text;
		private var scoreText:Text;
		
		private var timeText:Text;
		private var addedAmountText:Text;
		private var invisibilityTimer:Alarm;
		private var currentValue:Number;
		private var startAlarm:Boolean;
		private var gameOver:Boolean;
		private var undoEntity:UndoEntity;
		private var targetResult1Tweener:VarTween;
		private var targetResult2Tweener:VarTween;
		private var puzzleNumberTweener:VarTween;
		private var score1Tweener:VarTween;
		private var score2Tweener:VarTween;
		
		public function HUDEntity() 
		{
			var options:Object = new Object();
			options["color"] = LIGHT_COLOR;
			options["size"] = 10;
			if (Global.isiPhone())
			{
				options["size"] = 15;
			}
			options["align"] = "center";
			
			showCurrentResult1 = false;
			showCurrentResult2 = false;
			currentResultPosition1 = new Point();
			currentResultPosition2 = new Point();
			targetPuzzleResults = new Array();
			
			currentResultImage = new Image(GraphicLoader.GetGraphics("resultblock"));
			currentResultImage.centerOO();
			
			currentResult1Text = new Text("0", 0, 0, options);
			currentResult1Text.centerOO();
			currentResult2Text = new Text("0", 0, 0, options);
			currentResult2Text.centerOO();
			
			options["color"] = DARK_COLOR;
			options["size"] = 50;
			
			targetResult1Text = new Text("?", 0, 0, options);
			targetResult1Text.centerOO();
			targetResult2Text = new Text("?", 0, 0, options);
			targetResult2Text.centerOO();
			
			if (Global.gameplayMode != GameplayModes.MULTIPLAYER)
			{
				scoreValue1Text = new Text("0", 0, 0, options);
				scoreValue1Text.centerOO();
				scoreValue2Text = new Text("0", 0, 0, options);
				scoreValue2Text.centerOO();
			}
			
			puzzleNumberText = new Text("1", 0, 0, options);
			puzzleNumberText.centerOO();
			puzzleNumberText.originX = puzzleNumberText.width;
			
			options["size"] = 30;
			
			targetResultPuzzleText = new Text("?", 0, 0, options);
			targetResultPuzzleText.centerOO();
			targetResultPuzzleText = new Text("?", 0, 0, options);
			targetResultPuzzleText.centerOO();
			
			maxPuzzleNumberText = new Text("/10", 0, 0, options);
			maxPuzzleNumberText.centerOO();
			maxPuzzleNumberText.originX = 0;
			
			if (Global.gameplayMode == GameplayModes.MULTIPLAYER)
			{
				scoreValue1Text = new Text("0", 0, 0, options);
				scoreValue1Text.centerOO();
				scoreValue2Text = new Text("0", 0, 0, options);
				scoreValue2Text.centerOO();
			}
			
			options["size"] = 20;
			
			tResultText = new Text("target", 0, 0, options);
			tResultText.centerOO();
			
			scoreText = new Text("score", 0, 0, options);
			scoreText.centerOO();
			
			puzzleText = new Text("puzzle", 0, 0, options);
			puzzleText.centerOO();
			
			timeText = new Text("time", 0, 0, options);
			timeText.centerOO();
			
			options["color"] = 0xFFFFFF;
			addedAmountText = new Text("", 0, 0, options);
			addedAmountText.centerOO();
			
			invisibilityTimer = new Alarm(100, DisappearAddedAmount, Tween.PERSIST);
			targetResult1Tweener = new VarTween(null, Tween.PERSIST);
			targetResult2Tweener = new VarTween(null, Tween.PERSIST);
			puzzleNumberTweener = new VarTween(null, Tween.PERSIST);
			score1Tweener = new VarTween(null, Tween.PERSIST);
			score2Tweener = new VarTween(null, Tween.PERSIST);
			
			gameOver = false;
			startAlarm = false;
			if (Global.gameplayMode == GameplayModes.NORMAL)
			{
				MAX_VALUE = MAX_NORMAL_VALUE;
			}
			currentValue = MAX_VALUE;
			
			undoEntity = new UndoEntity();
			
			layer = LayerConstant.HUD_LAYER;
		}
		
		override public function added():void 
		{
			super.added();
			
			addTween(invisibilityTimer);
			addTween(targetResult1Tweener);
			addTween(targetResult2Tweener);
			addTween(puzzleNumberTweener);
			addTween(score1Tweener);
			addTween(score2Tweener);
			
			FP.world.add(undoEntity);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			FP.world.remove(undoEntity);
		}
		
		public function DisappearAddedAmount():void
		{
			addedAmountText.text = "";
			addedAmountText.centerOO();
		}
		
		public function StartAlarm():void
		{
			startAlarm = true;
		}
		
		public function GameOver():void
		{
			if (gameOver)
			{
				return;
			}
			
			gameOver = true;
			MapEntity.DisableControl = true;
			FP.world.add(new GameoverEntity());
		}
		
		public function ShowUndoBar():void
		{
			MapEntity.DisableControl = true;
			undoEntity.ShowBar();
		}
		
		public function HideUndoBar():void
		{
			MapEntity.DisableControl = false;
			undoEntity.HideBar();
		}
		
		public function IncreaseTimer(amount:Number):void
		{
			addedAmountText.text = "+" + amount.toString();
			addedAmountText.centerOO();
			invisibilityTimer.start();
			
			currentValue += amount;
			trace(currentValue);
			if (currentValue > MAX_VALUE)
			{
				currentValue = MAX_VALUE;
			}
		}
		
		public function ChangeCurrentResult1(result:int, position:Point):void
		{
			showCurrentResult1 = true;
			
			currentResultPosition1 = position.add(new Point(0, -Global.TILE_SIZE / 2));
			currentResult1Text.text = result.toString();
			currentResult1Text.centerOO();
		}
		
		public function ChangeCurrentResult2(result:int, position:Point):void
		{
			showCurrentResult2 = true;
			
			currentResultPosition2 = position.add(new Point(0, -Global.TILE_SIZE / 2));
			currentResult2Text.text = result.toString();
			currentResult2Text.centerOO();
		}
		
		public function ClearCurrentResult1():void
		{
			showCurrentResult1 = false;
		}
		
		public function ClearCurrentResult2():void
		{
			showCurrentResult2 = false;
		}
		
		public function ChangeFinalPuzzleResult(targetResults:Array):void
		{
			targetPuzzleResults = targetResults;
		}
		
		public function ChangePuzzleNumber(number:int):void
		{
			puzzleNumberText.text = number.toString();
			puzzleNumberText.centerOO();
			puzzleNumberText.originX = puzzleNumberText.width;
			puzzleNumberText.scale = 2;
			puzzleNumberTweener.tween(puzzleNumberText, "scale", 1, 20, Ease.backOut);
		}
		
		public function ChangeFinalResult1(result:int):void
		{
			targetResult1Text.text = result.toString();
			targetResult1Text.centerOO();
			targetResult1Text.scale = 2;
			targetResult1Tweener.tween(targetResult1Text, "scale", 1, 20, Ease.backOut);
		}
		
		public function ChangeFinalResult2(result:int):void
		{
			targetResult2Text.text = result.toString();
			targetResult2Text.centerOO();
			targetResult2Text.scale = 2;
			targetResult2Tweener.tween(targetResult2Text, "scale", 1, 20, Ease.backOut);
		}
		
		public function ChangeScore1(score:int):void
		{
			scoreValue1Text.text = score.toString();
			if (Global.gameplayMode == GameplayModes.MULTIPLAYER)
			{
				scoreValue1Text.text = score.toString() + "/50";
			}
			scoreValue1Text.centerOO();
			//scoreValue1Text.scale = 2;
			//score1Tweener.tween(scoreValue1Text, "scale", 1, 20, Ease.backOut);
		}
		
		public function ChangeScore2(score:int):void
		{
			scoreValue2Text.text = score.toString();
			if (Global.gameplayMode == GameplayModes.MULTIPLAYER)
			{
				scoreValue2Text.text = score.toString() + "/50";
			}
			scoreValue2Text.centerOO();
			//scoreValue2Text.scale = 2;
			//score2Tweener.tween(scoreValue2Text, "scale", 1, 20, Ease.backOut);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Global.gameplayMode == GameplayModes.NORMAL)
			{
				if (startAlarm)
				{
					currentValue -= FP.elapsed;
					if (currentValue <= 0)
					{
						GameOver();
					}
				}
			}
		}
		
		private function renderTime():void
		{
			var scorePosition:Point = Global.GetPositionFromTile(new Point(MapEntity.X_SIZE - 1, MapEntity.Y_SIZE - 1));
			scorePosition = scorePosition.add(new Point(Global.TILE_SIZE / 2 + 10, Global.TILE_SIZE / 2 + 5));
			if (Global.player1Hand == PlayerHand.LEFT_HANDED)
			{
				scorePosition = Global.GetPositionFromTile(new Point(0, MapEntity.Y_SIZE - 1));
				scorePosition = scorePosition.add(new Point(Global.TILE_SIZE / 2 - 10, Global.TILE_SIZE / 2 + 5));
			}
			
			scoreText.render(renderTarget? renderTarget : FP.buffer, scorePosition.add(new Point(0, -12)), FP.camera);
			scoreValue1Text.render(renderTarget? renderTarget : FP.buffer, scorePosition.add(new Point(0, 12)), FP.camera);
			
			var resultPosition:Point = Global.GetPositionFromTile(new Point(0, MapEntity.Y_SIZE - 1));
			resultPosition = resultPosition.add(new Point(Global.TILE_SIZE / 2 - 10, Global.TILE_SIZE / 2 + 5));
			if (Global.player1Hand == PlayerHand.LEFT_HANDED)
			{
				resultPosition = Global.GetPositionFromTile(new Point(MapEntity.X_SIZE - 1, MapEntity.Y_SIZE - 1));
				resultPosition = resultPosition.add(new Point(Global.TILE_SIZE / 2 + 10, Global.TILE_SIZE / 2 + 5));
			}
			
			tResultText.render(renderTarget? renderTarget : FP.buffer, resultPosition.add(new Point(0, -12)), FP.camera);
			targetResult1Text.render(renderTarget? renderTarget : FP.buffer, resultPosition.add(new Point(0, 12)), FP.camera);
			
			timeText.render(renderTarget? renderTarget : FP.buffer, new Point(FP.halfWidth, 12), FP.camera);
			
			var yConst:int = 8;
			var scale:Number = (MAX_VALUE - currentValue) / MAX_VALUE * 1.0;
			Draw.rectPlus(Global.TILE_SIZE + 8, 18 + yConst, (FP.width - 2 * Global.TILE_SIZE - 16), 19, DARK_COLOR, 1, false, 2);
			Draw.rect(Global.TILE_SIZE + 8 + 2 + scale * (FP.width - 2 * Global.TILE_SIZE - 4 - 16) / 2, 20 + yConst, (1 - scale) * (FP.width - 2 * Global.TILE_SIZE - 4 - 16), 15, DARK_COLOR, 1);
			addedAmountText.render(FP.buffer, new Point(FP.halfWidth, 28 + yConst), FP.camera);
			
			if (showCurrentResult1)
			{
				currentResultImage.render(renderTarget? renderTarget : FP.buffer, currentResultPosition1, FP.camera);
				currentResult1Text.render(renderTarget? renderTarget : FP.buffer, currentResultPosition1, FP.camera);
			}
		}
		
		private function renderPuzzle():void
		{
			var scorePosition:Point = Global.GetPositionFromTile(new Point(MapEntity.X_SIZE - 1, MapEntity.Y_SIZE - 1));
			scorePosition = scorePosition.add(new Point(Global.TILE_SIZE / 2 + 10, Global.TILE_SIZE / 2 + 5));
			if (Global.player1Hand == PlayerHand.LEFT_HANDED)
			{
				scorePosition = Global.GetPositionFromTile(new Point(0, MapEntity.Y_SIZE - 1));
				scorePosition = scorePosition.add(new Point(Global.TILE_SIZE / 2 - 10, Global.TILE_SIZE / 2 + 5));
			}
			
			scoreText.render(renderTarget? renderTarget : FP.buffer, scorePosition.add(new Point(0, -12)), FP.camera);
			scoreValue1Text.render(renderTarget? renderTarget : FP.buffer, scorePosition.add(new Point(0, 12)), FP.camera);
			
			var puzzlePosition:Point = Global.GetPositionFromTile(new Point(0, MapEntity.Y_SIZE - 1));
			var correctingShift:int = -5;
			puzzlePosition = puzzlePosition.add(new Point(Global.TILE_SIZE / 2 - 10, Global.TILE_SIZE / 2 + 5));
			if (Global.player1Hand == PlayerHand.LEFT_HANDED)
			{
				puzzlePosition = Global.GetPositionFromTile(new Point(MapEntity.X_SIZE - 1, MapEntity.Y_SIZE - 1));
				puzzlePosition = puzzlePosition.add(new Point(Global.TILE_SIZE / 2 + 10, Global.TILE_SIZE / 2 + 5));
				correctingShift = 2;
			}
			
			puzzleText.render(renderTarget? renderTarget : FP.buffer, puzzlePosition.add(new Point(0, -12)), FP.camera);
			puzzleNumberText.render(renderTarget? renderTarget : FP.buffer, puzzlePosition.add(new Point(correctingShift, 12)), FP.camera);
			maxPuzzleNumberText.render(renderTarget? renderTarget : FP.buffer, puzzlePosition.add(new Point(correctingShift, 12)), FP.camera);
			
			tResultText.render(renderTarget? renderTarget : FP.buffer, new Point(FP.halfWidth, 12), FP.camera);
			
			var distanceInBetween:Number = Global.TILE_SIZE;
			var startingXPosition:Number = FP.halfWidth - (targetPuzzleResults.length * distanceInBetween) / 2;
			
			if (targetPuzzleResults.length == 0)
			{
				startingXPosition = FP.halfWidth - (MapEntity.NUMBER_OF_PUZZLE_SET * distanceInBetween) / 2;
				for (var i:int = 0; i < MapEntity.NUMBER_OF_PUZZLE_SET; i++) 
				{
					targetResultPuzzleText.text = "?";
					targetResultPuzzleText.centerOO();
					targetResultPuzzleText.render(renderTarget? renderTarget : FP.buffer, new Point(startingXPosition + (i + 0.5) * distanceInBetween, 40), FP.camera);
				}
			}
			
			for (i = 0; i < targetPuzzleResults.length; i++) 
			{
				targetResultPuzzleText.text = targetPuzzleResults[i];
				targetResultPuzzleText.centerOO();
				targetResultPuzzleText.render(renderTarget? renderTarget : FP.buffer, new Point(startingXPosition + (i + 0.5) * distanceInBetween, 40), FP.camera);
			}
			
			if (showCurrentResult1)
			{
				currentResultImage.render(renderTarget? renderTarget : FP.buffer, currentResultPosition1, FP.camera);
				currentResult1Text.render(renderTarget? renderTarget : FP.buffer, currentResultPosition1, FP.camera);
			}
		}
		
		private function renderMultiplayer():void
		{
			var scorePosition:Point = Global.GetPositionFromTile(new Point(MapEntity.X_SIZE - 1, MapEntity.Y_SIZE - 1));
			scorePosition = scorePosition.add(new Point(Global.TILE_SIZE / 2 + 15, Global.TILE_SIZE / 2 + 5));
			if (Global.player1Hand == PlayerHand.LEFT_HANDED)
			{
				scorePosition = Global.GetPositionFromTile(new Point(0, MapEntity.Y_SIZE - 1));
				scorePosition = scorePosition.add(new Point(Global.TILE_SIZE / 2 - 15, Global.TILE_SIZE / 2 + 5));
			}
			
			scoreText.angle = 0;
			scoreText.render(renderTarget? renderTarget : FP.buffer, scorePosition.add(new Point(0, -12)), FP.camera);
			scoreValue1Text.angle = 0;
			scoreValue1Text.render(renderTarget? renderTarget : FP.buffer, scorePosition.add(new Point(0, 12)), FP.camera);
			
			var resultPosition:Point = Global.GetPositionFromTile(new Point(0, MapEntity.Y_SIZE - 1));
			resultPosition = resultPosition.add(new Point(Global.TILE_SIZE / 2 - 10, Global.TILE_SIZE / 2 + 5));
			if (Global.player1Hand == PlayerHand.LEFT_HANDED)
			{
				resultPosition = Global.GetPositionFromTile(new Point(MapEntity.X_SIZE - 1, MapEntity.Y_SIZE - 1));
				resultPosition = resultPosition.add(new Point(Global.TILE_SIZE / 2 + 10, Global.TILE_SIZE / 2 + 5));
			}
			
			tResultText.angle = 0;
			tResultText.render(renderTarget? renderTarget : FP.buffer, resultPosition.add(new Point(0, -12)), FP.camera);
			targetResult1Text.angle = 0;
			targetResult1Text.render(renderTarget? renderTarget : FP.buffer, resultPosition.add(new Point(0, 12)), FP.camera);
			
			scorePosition = Global.GetPositionFromTile(new Point(0, 0));
			scorePosition = scorePosition.add(new Point(Global.TILE_SIZE / 2 - 15, Global.TILE_SIZE / 2 - 5));
			if (Global.player2Hand == PlayerHand.LEFT_HANDED)
			{
				scorePosition = Global.GetPositionFromTile(new Point(MapEntity.X_SIZE - 1, 0));
				scorePosition = scorePosition.add(new Point(Global.TILE_SIZE / 2 + 15, Global.TILE_SIZE / 2 - 5));
			}
			
			scoreText.angle = 180;
			scoreText.render(renderTarget? renderTarget : FP.buffer, scorePosition.add(new Point(0, 12)), FP.camera);
			scoreValue2Text.angle = 180;
			scoreValue2Text.render(renderTarget? renderTarget : FP.buffer, scorePosition.add(new Point(0, -12)), FP.camera);
			
			resultPosition = Global.GetPositionFromTile(new Point(MapEntity.X_SIZE - 1, 0));
			resultPosition = resultPosition.add(new Point(Global.TILE_SIZE / 2 + 10, Global.TILE_SIZE / 2 - 5));
			if (Global.player2Hand == PlayerHand.LEFT_HANDED)
			{
				resultPosition = Global.GetPositionFromTile(new Point(0, 0));
				resultPosition = resultPosition.add(new Point(Global.TILE_SIZE / 2 - 10, Global.TILE_SIZE / 2 - 5));
			}
			
			tResultText.angle = 180;
			tResultText.render(renderTarget? renderTarget : FP.buffer, resultPosition.add(new Point(0, 12)), FP.camera);
			targetResult2Text.angle = 180;
			targetResult2Text.render(renderTarget? renderTarget : FP.buffer, resultPosition.add(new Point(0, -12)), FP.camera);
			
			if (showCurrentResult1)
			{
				currentResultImage.render(renderTarget? renderTarget : FP.buffer, currentResultPosition1, FP.camera);
				currentResult1Text.angle = 0;
				currentResult1Text.render(renderTarget? renderTarget : FP.buffer, currentResultPosition1, FP.camera);
				
				currentResultImage.render(renderTarget? renderTarget : FP.buffer, currentResultPosition1.add(new Point(0, Global.TILE_SIZE)), FP.camera);
				currentResult1Text.angle = 180;
				currentResult1Text.render(renderTarget? renderTarget : FP.buffer, currentResultPosition1.add(new Point(0, Global.TILE_SIZE)), FP.camera);
			}
			
			if (showCurrentResult2)
			{
				currentResultImage.render(renderTarget? renderTarget : FP.buffer, currentResultPosition2, FP.camera);
				currentResult2Text.angle = 0;
				currentResult2Text.render(renderTarget? renderTarget : FP.buffer, currentResultPosition2, FP.camera);
				
				currentResultImage.render(renderTarget? renderTarget : FP.buffer, currentResultPosition2.add(new Point(0, Global.TILE_SIZE)), FP.camera);
				currentResult2Text.angle = 180;
				currentResult2Text.render(renderTarget? renderTarget : FP.buffer, currentResultPosition2.add(new Point(0, Global.TILE_SIZE)), FP.camera);
			}
		}
		
		override public function render():void 
		{
			super.render();
			
			switch (Global.gameplayMode) 
			{
				case GameplayModes.NORMAL:
					renderTime();
					break;
				case GameplayModes.PUZZLE:
					renderPuzzle();
					break;
				case GameplayModes.MULTIPLAYER:
					renderMultiplayer();
					break;
			}
		}
	}

}