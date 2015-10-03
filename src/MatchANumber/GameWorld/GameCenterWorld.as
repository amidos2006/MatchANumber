package MatchANumber.GameWorld 
{
	import com.milkmangames.nativeextensions.events.GoogleGamesEvent;
	import com.milkmangames.nativeextensions.GoogleGames;
	import flash.display.BitmapData;
	import MatchANumber.GameEntity.GameoverEntity;
	import MatchANumber.GameEntity.MessageStripEntity;
	import MatchANumber.Global;
	import MatchANumber.LayerConstant;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.TouchControl;
	import net.flashpunk.World;
	/**
	 * ...
	 * @author Amidos
	 */
	public class GameCenterWorld extends World
	{
		private var pausedWorld:World;
		private var messageStripEntity:MessageStripEntity;
		private var failedAuth:Boolean;
		private var closing:Boolean;
		private var waiting:Boolean;
		
		public function GameCenterWorld(buffer:BitmapData, returnWorld:World) 
		{
			pausedWorld = returnWorld;
			
			var image:Image = new Image(buffer);
			addGraphic(image, LayerConstant.MAP_LAYER);
			
			messageStripEntity = new MessageStripEntity("authenticating...");
			add(messageStripEntity);
			messageStripEntity.ShowBar();
			
			failedAuth = false;
			closing = false;
			waiting = false;
		}
		
		override public function begin():void 
		{
			super.begin();
			Global.backButtonFunction = BackFunction;
			
			if (GoogleGames.games.isSignedIn())
			{
				messageStripEntity.ChangeText("retriving leaderboard...");
				GetLeaderBoard();
			}
			else
			{	
				if (!GoogleGames.games.isSignedIn())
				{	
					Global.authenticating = true;
					
					GoogleGames.games.addEventListener(GoogleGamesEvent.SIGN_IN_SUCCEEDED, UserAuth);
					GoogleGames.games.addEventListener(GoogleGamesEvent.SIGN_IN_FAILED, UserNotAuth);
					
					GoogleGames.games.signIn();
				}
				else
				{
					waiting = true;
				}
			}
		}
		
		private function GetLeaderBoard():void
		{
			GoogleGames.games.addEventListener(GoogleGamesEvent.LEADERBOARD_VIEW_DISMISSED, GameCenterClose);
			
			GoogleGames.games.showLeaderboard(Global.GetLeaderBoardName(Global.gameplayMode, Global.difficultyMode));
		}
		
		private function ReturnBack():void
		{
			FP.world = pausedWorld;
		}
		
		private function UserAuth(e:GoogleGamesEvent):void
		{
			Global.authenticating = false;
			
			GoogleGames.games.removeEventListener(GoogleGamesEvent.SIGN_IN_SUCCEEDED, UserAuth);
			GoogleGames.games.removeEventListener(GoogleGamesEvent.SIGN_IN_FAILED, UserNotAuth);
			
			messageStripEntity.ChangeText("retriving leaderboard...");
			GetLeaderBoard();
		}
		
		private function UserNotAuth(e:GoogleGamesEvent):void
		{
			Global.authenticating = false;
			
			GoogleGames.games.removeEventListener(GoogleGamesEvent.SIGN_IN_SUCCEEDED, UserAuth);
			GoogleGames.games.removeEventListener(GoogleGamesEvent.SIGN_IN_FAILED, UserNotAuth);
			
			messageStripEntity.showHint = true;
			messageStripEntity.ChangeText("authentication failed");
			
			failedAuth = true;
		}
		
		private function GameCenterClose(e:GoogleGamesEvent):void
		{
			GoogleGames.games.removeEventListener(GoogleGamesEvent.LEADERBOARD_VIEW_DISMISSED, GameCenterClose);
			
			Main.activate(null);
			messageStripEntity.HideBar();
		}
		
		private function BackFunction():void
		{
			closing = true;
			messageStripEntity.HideBar();
		}
		
		override public function update():void 
		{
			super.update();
			
			if (waiting)
			{
				if (!Global.authenticating)
				{
					waiting = false;
					
					if (GoogleGames.games.isSignedIn())
					{
						UserAuth(null);
					}
					else
					{
						UserNotAuth(null);
					}
				}
			}
			
			if (!messageStripEntity.isVisible)
			{
				ReturnBack();
			}
			else
			{
				if (TouchControl.TouchReleased() > 0 && !closing)
				{
					BackFunction();
				}
			}
		}
	}

}