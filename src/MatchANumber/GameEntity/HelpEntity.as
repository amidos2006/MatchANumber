package MatchANumber.GameEntity 
{
	import flash.geom.Point;
	import MatchANumber.DifficultyModes;
	import MatchANumber.GameplayModes;
	import MatchANumber.GameWorld.GameplayWorld;
	import MatchANumber.GameWorld.HelpWorld;
	import MatchANumber.GameWorld.MainMenuWorld;
	import MatchANumber.Global;
	import MatchANumber.LayerConstant;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Amidos
	 */
	public class HelpEntity extends Entity
	{
		private const TEXT_COLOR:uint = 0x666666;
		
		private var smallBlocks:BlockGridRender;
		private var gameLogo:Image;
		
		private var gameplayModeChoices:MultiChoiceEntity;
		private var gameHelpText:Array;
		
		private var creditsText:Text;
		
		public function HelpEntity() 
		{
			smallBlocks = new BlockGridRender();
			smallBlocks.RegisterColoumn(0);
			smallBlocks.RemovePoint(new Point());
			smallBlocks.RegisterColoumn(5);
			smallBlocks.RemovePoint(new Point(5, 0));
			
			gameLogo = new Image(GraphicLoader.GetGraphics("gamelogo"));
			gameLogo.originX = gameLogo.width / 2;
			gameLogo.originY = 0;
			
			var options:Object = new Object();
			options["color"] = TEXT_COLOR;
			options["size"] = 30;
			options["align"] = "center";
			
			var choicesArray:Array = new Array();
			var text:Text = new Text("normal", 0, 0, options);
			text.centerOO();
			choicesArray.push(text);
			text = new Text("puzzle", 0, 0, options);
			text.centerOO();
			choicesArray.push(text);
			text = new Text("multiplayer", 0, 0, options);
			text.centerOO();
			choicesArray.push(text);
			
			gameplayModeChoices = new MultiChoiceEntity("gameplay mode", choicesArray, GameplayModeChange, Global.gameplayMode);
			gameplayModeChoices.x = FP.halfWidth;
			gameplayModeChoices.y = FP.height - 45;
			
			options["size"] = 25;
			
			gameHelpText = new Array();
			
			gameHelpText.push(new Text("drag your fingers\nover numbers\n\nmatch two or more\ntiles result to get\nthe target value\n\nlonger chains give\nyou more bonus time", 0, 0, options));
			gameHelpText[gameHelpText.length - 1].height += 16;
			gameHelpText[gameHelpText.length - 1].centerOO();
			
			gameHelpText.push(new Text("drag your fingers\nover numbers\n\nmatch two or more\ntiles to get\none of the targeted\nvalues\n\nclear all target\nand get the highest\nscore", 0, 0, options));
			gameHelpText[gameHelpText.length - 1].height += 16;
			gameHelpText[gameHelpText.length - 1].centerOO();
			
			gameHelpText.push(new Text("drag your fingers\nover numbers\n\nmatch two or more\ntiles result to get\nthe target value\n\nfirst to 50 points\nwins the game\n\nboth players' target\nvalues change when\na successful match\nis made", 0, 0, options));
			gameHelpText[gameHelpText.length - 1].height += 16;
			gameHelpText[gameHelpText.length - 1].centerOO();
			
			options["size"] = 15;
			
			creditsText = new Text("game by amidos\nmusic by agent whiskers", 0, 0, options);
			creditsText.centerOO();
			creditsText.originY = creditsText.height;
			
			layer = LayerConstant.MAP_LAYER;
		}
		
		override public function added():void 
		{
			super.added();
			
			FP.world.add(gameplayModeChoices);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			FP.world.remove(gameplayModeChoices);
		}
		
		private function GameplayModeChange():void
		{
			Global.gameplayMode = gameplayModeChoices.currentChoice;
		}
		
		override public function render():void 
		{
			super.render();
			
			smallBlocks.render(FP.buffer, new Point(), FP.camera);
			
			var point:Point = new Point(FP.halfWidth, gameLogo.height);
			point = point.add(new Point(0, (FP.height - gameLogo.height - creditsText.height) / 2));
			gameHelpText[gameplayModeChoices.currentChoice].render(FP.buffer, point, FP.camera);
			
			gameLogo.render(FP.buffer, new Point(FP.halfWidth, 20), FP.camera);
			creditsText.render(FP.buffer, new Point(FP.halfWidth, FP.height), FP.camera);
		}
	}

}