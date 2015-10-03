package MatchANumber.GameEntity 
{
	import com.milkmangames.nativeextensions.GoogleGames;
	import flash.geom.Point;
	import MatchANumber.GameplayModes;
	import MatchANumber.GameWorld.GameplayWorld;
	import MatchANumber.GameWorld.MainMenuWorld;
	import MatchANumber.GameWorld.ScorePostingWorld;
	import MatchANumber.Global;
	import MatchANumber.LayerConstant;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.NumTween;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.World;
	/**
	 * ...
	 * @author Amidos
	 */
	public class GameoverEntity extends Entity
	{
		private const COLOR:uint = 0x666666;
		
		private var alpha:Number;
		private var numTweener:NumTween;
		private var gameoverText:Text;
		private var bestScoreText:Text;
		private var restartButton:TextButtonEntity;
		private var mainMenuButton:TextButtonEntity;
		private var submitScoreButton:TextButtonEntity;
		
		public function GameoverEntity() 
		{
			alpha = 0;
			
			var options:Object = new Object();
			options["color"] = COLOR;
			options["size"] = 50;
			options["align"] = "center";
			
			var displayedText:String = "time out";
			if (Global.gameplayMode == GameplayModes.PUZZLE)
			{
				displayedText = "gameover";
			}
			else if (Global.gameplayMode == GameplayModes.MULTIPLAYER)
			{
				if (Global.score1 > Global.score2)
				{
					displayedText = "player 1 wins"
				}
				else if (Global.score2 > Global.score1)
				{
					displayedText = "player 2 wins"
				}
				else
				{
					displayedText = "draw"
				}
			}
			gameoverText = new Text(displayedText, 0, 0, options);
			gameoverText.centerOO();
			gameoverText.y = 0;
			gameoverText.alpha = 0;
			
			options["size"] = 20;
			bestScoreText = new Text("", 0, 0, options);
			bestScoreText.centerOO();
			bestScoreText.alpha = 0;
			
			restartButton = new TextButtonEntity("restart", 25, COLOR, Restart);
			restartButton.alpha = 0;
			restartButton.x = FP.halfWidth - 110;
			restartButton.y = FP.halfHeight + 10;
			
			mainMenuButton = new TextButtonEntity("mainmenu", 25, COLOR, Menu);
			mainMenuButton.alpha = 0;
			mainMenuButton.x = FP.halfWidth + 110;
			mainMenuButton.y = FP.halfHeight + 10;
			
			if (!GoogleGames.isSupported() || Global.DISABLE_GAME_CENTER || Global.gameplayMode == GameplayModes.MULTIPLAYER)
			{
				restartButton.x = FP.halfWidth - 100;
				restartButton.y = FP.halfHeight + 20;
				
				mainMenuButton.x = FP.halfWidth + 100;
				mainMenuButton.y = FP.halfHeight + 20;
			}
			
			submitScoreButton = new TextButtonEntity("submit score", 24, COLOR, SubmitScore);
			submitScoreButton.alpha = 0;
			submitScoreButton.x = FP.halfWidth;
			submitScoreButton.y = FP.halfHeight + 40;
			
			numTweener = new NumTween(null, Tween.PERSIST);
			
			layer = LayerConstant.HUD_LAYER;
		}
		
		override public function added():void 
		{
			super.added();
			numTweener.tween(alpha, 1, 20);
			addTween(numTweener, true);
			
			FP.world.add(restartButton);
			FP.world.add(mainMenuButton);
			if (GoogleGames.isSupported() && !Global.DISABLE_GAME_CENTER && Global.gameplayMode != GameplayModes.MULTIPLAYER)
			{
				FP.world.add(submitScoreButton);
			}
			
			if (Global.gameplayMode != GameplayModes.MULTIPLAYER)
			{
				if (Global.score1 > Global.bestScore[Global.gameplayMode][Global.difficultyMode])
				{
					Global.bestScore[Global.gameplayMode][Global.difficultyMode] = Global.score1;
					Global.SaveGame();
				}
				
				bestScoreText.text = "best score: " + Global.bestScore[Global.gameplayMode][Global.difficultyMode];
				bestScoreText.centerOO();
			}
		}
		
		private function Restart():void
		{
			FP.world = new GameplayWorld();
		}
		
		private function Menu():void
		{
			FP.world = new MainMenuWorld();
		}
		
		private function SubmitScore():void
		{
			var oldWorld:World = FP.world;
			FP.world = new ScorePostingWorld(FP.buffer, oldWorld);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			FP.world.remove(restartButton);
			FP.world.remove(mainMenuButton);
			FP.world.remove(submitScoreButton);
		}
		
		override public function update():void 
		{
			super.update();
			
			alpha = numTweener.value;
			gameoverText.alpha = alpha;
			bestScoreText.alpha = alpha;
			restartButton.alpha = alpha;
			mainMenuButton.alpha = alpha;
			submitScoreButton.alpha = alpha;
		}
		
		override public function render():void 
		{
			super.render();
			
			Draw.rectPlus( -10, FP.halfHeight - 90, FP.width + 20, 150, COLOR, alpha, true, 4);
			Draw.rectPlus( -10, FP.halfHeight - 87, FP.width + 20, 144, 0xFFFFFF, alpha, true, 0);
			
			gameoverText.render(FP.buffer, new Point(FP.halfWidth, FP.halfHeight - 40), FP.camera);
			bestScoreText.render(FP.buffer, new Point(FP.halfWidth, FP.halfHeight - 15), FP.camera);
		}
	}

}