package MatchANumber.GameEntity 
{
	import flash.geom.Point;
	import MatchANumber.ColorScheme;
	import MatchANumber.GameplayModes;
	import MatchANumber.GameWorld.HelpWorld;
	import MatchANumber.GameWorld.StartWorld;
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
	public class TutorialHUDEntity extends Entity
	{
		private const DARK_COLOR:uint = 0x666666;
		private const LIGHT_COLOR:uint = 0xFFFFFF;
		
		private var tutorialArray:Array;
		public var currentTutorialText:int;
		private var tutorialText:Text;
		private var targetResult1Text:Text;
		private var currentResult1Text:Text;
		
		private var showCurrentResult1:Boolean;
		private var currentResultPosition1:Point;
		
		private var currentResultImage:Image;
		private var tResultText:Text;
		
		private var targetResult1Tweener:VarTween;
		
		private var smallBlocks:BlockGridRender;
		private var gameLogo:Image;
		private var creditsText:Text;
		
		public function TutorialHUDEntity() 
		{
			smallBlocks = new BlockGridRender();
			smallBlocks.RegisterColoumn(0);
			smallBlocks.RegisterColoumn(5);
			smallBlocks.RemovePoint(new Point());
			
			gameLogo = new Image(GraphicLoader.GetGraphics("gamelogo"));
			gameLogo.originX = gameLogo.width / 2;
			gameLogo.originY = 0;
			
			var options:Object = new Object();
			options["color"] = DARK_COLOR;
			options["size"] = 15;
			options["align"] = "center";
			
			creditsText = new Text("game by amidos\nmusic by agent whiskers", 0, 0, options);
			creditsText.centerOO();
			creditsText.originY = creditsText.height;
			
			tutorialArray = new Array();
			currentTutorialText = 0;
			
			var posNum:String = "";
			var negNum:String = "";
			var multNum:String = "";
			if (Global.colorScheme == ColorScheme.BLUE_POS_RED_NEG_YELL_MUL)
			{
				posNum = "blue";
				negNum = "red";
				multNum = "yellow";
			}
			else if(Global.colorScheme == ColorScheme.RED_POS_BLUE_NEG_YELL_MUL)
			{
				posNum = "red";
				negNum = "blue";
				multNum = "yellow";
			}
			
			tutorialArray.push(posNum + " tiles represent\naddition (+)\n\nmove your fingers\nover numbers to get\nthe target");
			tutorialArray.push(negNum + " tiles represent\nsubtraction (-)\n\nmove your fingers\nover numbers to get\nthe target");
			tutorialArray.push(multNum + " tiles represent\nmultiplication (x)\n\nmove your finger\nover numbers to get\nthe target");
			tutorialArray.push("let's see what you\nhave learned so far\n\ntry to get\nthe current target");
			
			options["size"] = 25;
			
			tutorialText = new Text(tutorialArray[currentTutorialText], 0, 0, options);
			tutorialText.height += 25;
			tutorialText.centerOO();
			tutorialText.originY = tutorialText.height;
			
			options["color"] = LIGHT_COLOR;
			options["size"] = 10;
			if (Global.isiPhone())
			{
				options["size"] = 15;
			}
			options["align"] = "center";
			
			showCurrentResult1 = false;
			currentResultPosition1 = new Point();
			
			currentResultImage = new Image(GraphicLoader.GetGraphics("resultblock"));
			currentResultImage.centerOO();
			
			currentResult1Text = new Text("0", 0, 0, options);
			currentResult1Text.centerOO();
			
			options["color"] = DARK_COLOR;
			options["size"] = 50;
			
			targetResult1Text = new Text("?", 0, 0, options);
			targetResult1Text.centerOO();
			
			options["size"] = 20;
			
			tResultText = new Text("target", 0, 0, options);
			tResultText.centerOO();
			
			targetResult1Tweener = new VarTween(null, Tween.PERSIST);
			
			layer = LayerConstant.BUTTON_LAYER;
		}
		
		override public function added():void 
		{
			super.added();
			
			addTween(targetResult1Tweener);
		}
		
		override public function removed():void 
		{
			super.removed();
		}
		
		public function ChangeCurrentResult1(result:int, position:Point):void
		{
			showCurrentResult1 = true;
			
			currentResultPosition1 = position.add(new Point(0, -Global.TILE_SIZE / 2));
			currentResult1Text.text = result.toString();
			currentResult1Text.centerOO();
		}
		
		public function ClearCurrentResult1():void
		{
			showCurrentResult1 = false;
		}
		
		public function ChangeFinalResult1(result:int):void
		{
			targetResult1Text.text = result.toString();
			targetResult1Text.centerOO();
			targetResult1Text.scale = 2;
			targetResult1Tweener.tween(targetResult1Text, "scale", 1, 20, Ease.backOut);
		}
		
		public function TutorialEnded():Boolean
		{
			return currentTutorialText >= tutorialArray.length;
		}
		
		public function GetNextTutorialText():void
		{
			currentTutorialText += 1;
			if (TutorialEnded())
			{
				return;
			}
			
			tutorialText.text = tutorialArray[currentTutorialText];
			tutorialText.centerOO();
			tutorialText.originY = tutorialText.height;
		}
		
		override public function update():void 
		{
			super.update();
			
		}
		
		private function renderTutorial():void
		{
			var tutorialPosition:Point = Global.GetPositionFromTile(new Point(1, 0));
			tutorialText.render(renderTarget? renderTarget : FP.buffer, tutorialPosition.add(new Point(0, 10)), FP.camera);
			
			var resultPosition:Point = Global.GetPositionFromTile(new Point(Math.floor(TutorialEntity.X_SIZE / 2), TutorialEntity.Y_SIZE));
			resultPosition = resultPosition.add(new Point(0, Global.TILE_SIZE / 2 - 10));
			
			tResultText.render(renderTarget? renderTarget : FP.buffer, resultPosition.add(new Point(0, -12)), FP.camera);
			targetResult1Text.render(renderTarget? renderTarget : FP.buffer, resultPosition.add(new Point(0, 12)), FP.camera);
			
			if (showCurrentResult1)
			{
				currentResultImage.render(renderTarget? renderTarget : FP.buffer, currentResultPosition1, FP.camera);
				currentResult1Text.render(renderTarget? renderTarget : FP.buffer, currentResultPosition1, FP.camera);
			}
		}
		
		override public function render():void 
		{
			super.render();
			
			renderTutorial();
			
			smallBlocks.render(FP.buffer, new Point(), FP.camera);
			gameLogo.render(FP.buffer, new Point(FP.halfWidth, 20), FP.camera);
			creditsText.render(FP.buffer, new Point(FP.halfWidth, FP.height), FP.camera);
		}
	}

}