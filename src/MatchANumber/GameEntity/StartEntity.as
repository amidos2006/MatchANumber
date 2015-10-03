package MatchANumber.GameEntity 
{
	import com.milkmangames.nativeextensions.GoogleGames;
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
	public class StartEntity extends Entity
	{
		private const TEXT_COLOR:uint = 0x666666;
		
		private var gameLogo:Image;
		
		private var smallBlocks:BlockGridRender;
		private var gameplayModeChoices:MultiChoiceEntity;
		private var difficultyChoices:MultiChoiceEntity;
		private var startGameButton:TextButtonEntity;
		private var helpButton:TextButtonEntity;
		
		private var creditsText:Text;
		
		public function StartEntity() 
		{
			smallBlocks = new BlockGridRender();
			smallBlocks.RegisterColoumn(0);
			smallBlocks.RemovePoint(new Point());
			smallBlocks.RegisterColoumn(5);
			if (GoogleGames.isSupported() && !Global.DISABLE_GAME_CENTER)
			{
				smallBlocks.RemovePoint(new Point(5, 0));
			}
			
			gameLogo = new Image(GraphicLoader.GetGraphics("gamelogo"));
			gameLogo.originX = gameLogo.width / 2;
			gameLogo.originY = 0;
			
			var options:Object = new Object();
			options["color"] = TEXT_COLOR;
			options["size"] = 15;
			options["align"] = "center";
			
			creditsText = new Text("game by amidos\nmusic by agent whiskers", 0, 0, options);
			creditsText.centerOO();
			creditsText.originY = creditsText.height;
			
			options["size"] = 30;
			
			var choicesArray:Array = new Array();
			var textChoice:Text = new Text("normal", 0, 0, options);
			textChoice.centerOO();
			choicesArray.push(textChoice);
			textChoice = new Text("puzzle", 0, 0, options);
			textChoice.centerOO();
			choicesArray.push(textChoice);
			textChoice = new Text("multiplayer", 0, 0, options);
			textChoice.centerOO();
			choicesArray.push(textChoice);
			
			gameplayModeChoices = new MultiChoiceEntity("gameplay mode", choicesArray, GameplayModeChange, Global.gameplayMode);
			gameplayModeChoices.x = FP.halfWidth;
			gameplayModeChoices.y = FP.halfHeight - 25;
			
			choicesArray = new Array();
			textChoice = new Text("easy", 0, 0, options);
			textChoice.centerOO();
			choicesArray.push(textChoice);
			textChoice = new Text("medium", 0, 0, options);
			textChoice.centerOO();
			choicesArray.push(textChoice);
			textChoice = new Text("hard", 0, 0, options);
			textChoice.centerOO();
			choicesArray.push(textChoice);
			
			difficultyChoices = new MultiChoiceEntity("difficulty", choicesArray, DifficultyChange, Global.difficultyMode);
			difficultyChoices.x = gameplayModeChoices.x;
			difficultyChoices.y = gameplayModeChoices.y + 50;
			
			startGameButton = new TextButtonEntity("start", 40, TEXT_COLOR, StartGame);
			startGameButton.x = difficultyChoices.x;
			startGameButton.y = difficultyChoices.y + 75;
			
			helpButton = new TextButtonEntity("help", 40, TEXT_COLOR, Help);
			helpButton.x = startGameButton.x;
			helpButton.y = startGameButton.y + 45;
			
			layer = LayerConstant.MAP_LAYER;
		}
		
		override public function added():void 
		{
			super.added();
			
			FP.world.add(gameplayModeChoices);
			FP.world.add(difficultyChoices);
			FP.world.add(startGameButton);
			FP.world.add(helpButton);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			FP.world.remove(gameplayModeChoices);
			FP.world.remove(difficultyChoices);
			FP.world.remove(startGameButton);
			FP.world.remove(helpButton);
		}
		
		private function GameplayModeChange():void
		{
			Global.gameplayMode = gameplayModeChoices.currentChoice;
		}
		
		private function DifficultyChange():void
		{
			Global.difficultyMode = difficultyChoices.currentChoice;
		}
		
		private function StartGame():void
		{
			Global.numberOfResets = Global.ALLOWED_NUMBER_RESET;
			FP.world = new GameplayWorld();
		}
		
		private function Help():void
		{
			FP.world = new HelpWorld();
		}
		
		override public function render():void 
		{
			super.render();
			
			smallBlocks.render(FP.buffer, new Point(), FP.camera);
			gameLogo.render(FP.buffer, new Point(FP.halfWidth, 20), FP.camera);
			creditsText.render(FP.buffer, new Point(FP.halfWidth, FP.height), FP.camera);
		}
	}

}