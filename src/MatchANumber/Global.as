package MatchANumber 
{
	import com.milkmangames.nativeextensions.events.GoogleGamesEvent;
	import com.milkmangames.nativeextensions.GoogleGames;
	import flash.events.Event;
	import flash.geom.Point;
	import MatchANumber.GameEntity.MathOperation;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Data;
	/**
	 * ...
	 * @author Amidos
	 */
	public class Global 
	{
		[Embed(source = "../../assets/visitor1.ttf", embedAsCFF = "false", fontFamily = 'gameFont')]private static var fontClass:Class;
		[Embed(source = "../../assets/MatchANumber_v_5_2.mp3")]private static var musicClass:Class;
		
		private static const SAVE_FILENAME:String = "MatchANumber_Save";
		
		public static var TILE_SIZE:int = 64;
		public static var LOW_BLOCK_SIZE:int = 54;
		public static var HIGH_BLOCK_SIZE:int = 58;
		public static var BACK_BLOCK_SIZE:int = 16;
		public static var RESULT_BLOCK_SIZE:int = 30;
		public static var DISABLE_GAME_CENTER:Boolean = false;
		public static var ALLOWED_NUMBER_RESET:int = 3;
		
		public static var X_SHIFT:int = 64;
		public static var Y_SHIFT:int = 64;
		
		private static var musicSfx:Sfx;
		
		public static var numberOfResets:int;
		public static var score1:int;
		public static var score2:int;
		public static var puzzleNumber:int;
		public static var player1Hand:int;
		public static var player2Hand:int;
		public static var hints:Boolean;
		public static var colorScheme:int;
		public static var gameplayMode:int;
		public static var difficultyMode:int;
		public static var firstTime:Boolean;
		public static var firstTimeGoal:Array;
		public static var bestScore:Array;
		public static var authenticating:Boolean;
		public static var backButtonFunction:Function;
		
		public static function isiPhone():Boolean
		{
			return FP.height > 512;
		}
		
		public static function isiPhone5():Boolean
		{
			return FP.height > 600;
		}
		
		public static function Intialize():void
		{
			//iphone resolution
			if (isiPhone() || isiPhone5())
			{
				var iphoneIncrease:Number = 15;
				TILE_SIZE += iphoneIncrease;
				LOW_BLOCK_SIZE += iphoneIncrease;
				HIGH_BLOCK_SIZE += iphoneIncrease;
				RESULT_BLOCK_SIZE += iphoneIncrease;
			}
			
			UpdateShift(6, 4);
			
			musicSfx = new Sfx(musicClass);
			musicSfx.loop();
			
			colorScheme = ColorScheme.BLUE_POS_RED_NEG_YELL_MUL;
			
			score1 = 0;
			score2 = 0;
			puzzleNumber = 1;
			numberOfResets = ALLOWED_NUMBER_RESET;
			
			player1Hand = PlayerHand.RIGHT_HANDED;
			player2Hand = PlayerHand.RIGHT_HANDED;
			hints = true;
			
			gameplayMode = GameplayModes.NORMAL;
			difficultyMode = DifficultyModes.EASY;
			
			firstTimeGoal = new Array();
			firstTimeGoal[GameplayModes.NORMAL] = true;
			firstTimeGoal[GameplayModes.PUZZLE] = true;
			firstTimeGoal[GameplayModes.MULTIPLAYER] = true;
			firstTime = true;
			
			bestScore = new Array();
			bestScore[GameplayModes.NORMAL] = new Array();
			bestScore[GameplayModes.PUZZLE] = new Array();
			bestScore[GameplayModes.NORMAL][DifficultyModes.EASY] = 0;
			bestScore[GameplayModes.NORMAL][DifficultyModes.MEDIUM] = 0;
			bestScore[GameplayModes.NORMAL][DifficultyModes.HARD] = 0;
			bestScore[GameplayModes.PUZZLE][DifficultyModes.EASY] = 0;
			bestScore[GameplayModes.PUZZLE][DifficultyModes.MEDIUM] = 0;
			bestScore[GameplayModes.PUZZLE][DifficultyModes.HARD] = 0;
			
			Text.font = "gameFont";
			
			authenticating = false;
			backButtonFunction = null;
			
			LoadGame();
		}
		
		public static function PauseMusic():void
		{
			if (musicSfx != null && musicSfx.playing)
			{
				musicSfx.stop();
			}
		}
		
		public static function ResumeMusic():void
		{
			if (musicSfx != null && !musicSfx.playing)
			{
				musicSfx.resume();
			}
		}
		
		public static function LoadGame():void
		{
			Data.load(SAVE_FILENAME);
			
			GameSfx.sfxVolume = Data.readBool("sfxVolume")? 1 : 0;
			musicSfx.volume = Data.readBool("musicVolume")? 1 : 0;
			player1Hand = Data.readInt("player1Hand", PlayerHand.RIGHT_HANDED);
			player2Hand = Data.readInt("player2Hand", PlayerHand.RIGHT_HANDED);
			hints = Data.readBool("hints", true);
			colorScheme = Data.readInt("colorScheme", ColorScheme.BLUE_POS_RED_NEG_YELL_MUL);
			
			firstTimeGoal[GameplayModes.NORMAL] = Data.readBool("firstTimeGoal" + GameplayModes.NORMAL, true);
			firstTimeGoal[GameplayModes.PUZZLE] = Data.readBool("firstTimeGoal" + GameplayModes.PUZZLE, true);
			firstTimeGoal[GameplayModes.MULTIPLAYER] = Data.readBool("firstTimeGoal" + GameplayModes.MULTIPLAYER, true);
			firstTime = Data.readBool("firstTime", true);
			
			bestScore[GameplayModes.NORMAL][DifficultyModes.EASY] = Data.readInt("bestScore" + GameplayModes.NORMAL + DifficultyModes.EASY, 0);
			bestScore[GameplayModes.NORMAL][DifficultyModes.MEDIUM] = Data.readInt("bestScore" + GameplayModes.NORMAL + DifficultyModes.MEDIUM, 0);
			bestScore[GameplayModes.NORMAL][DifficultyModes.HARD] = Data.readInt("bestScore" + GameplayModes.NORMAL + DifficultyModes.HARD, 0);
			bestScore[GameplayModes.PUZZLE][DifficultyModes.EASY] = Data.readInt("bestScore" + GameplayModes.PUZZLE + DifficultyModes.EASY, 0);
			bestScore[GameplayModes.PUZZLE][DifficultyModes.MEDIUM] = Data.readInt("bestScore" + GameplayModes.PUZZLE + DifficultyModes.MEDIUM, 0);
			bestScore[GameplayModes.PUZZLE][DifficultyModes.HARD] = Data.readInt("bestScore" + GameplayModes.PUZZLE + DifficultyModes.HARD, 0);
		}
		
		public static function SaveGame():void
		{
			Data.writeBool("sfxVolume", GameSfx.sfxVolume == 1);
			Data.writeBool("musicVolume", musicSfx.volume == 1);
			Data.writeInt("player1Hand", player1Hand);
			Data.writeInt("player2Hand", player2Hand);
			Data.writeBool("hints", hints);
			Data.writeInt("colorScheme", colorScheme);
			
			Data.writeBool("firstTimeGoal" + GameplayModes.NORMAL, firstTimeGoal[GameplayModes.NORMAL]);
			Data.writeBool("firstTimeGoal" + GameplayModes.PUZZLE, firstTimeGoal[GameplayModes.PUZZLE]);
			Data.writeBool("firstTimeGoal" + GameplayModes.MULTIPLAYER, firstTimeGoal[GameplayModes.MULTIPLAYER]);
			Data.writeBool("firstTime", firstTime);
			
			Data.writeInt("bestScore" + GameplayModes.NORMAL + DifficultyModes.EASY, bestScore[GameplayModes.NORMAL][DifficultyModes.EASY]);
			Data.writeInt("bestScore" + GameplayModes.NORMAL + DifficultyModes.MEDIUM, bestScore[GameplayModes.NORMAL][DifficultyModes.MEDIUM]);
			Data.writeInt("bestScore" + GameplayModes.NORMAL + DifficultyModes.HARD, bestScore[GameplayModes.NORMAL][DifficultyModes.HARD]);
			Data.writeInt("bestScore" + GameplayModes.PUZZLE + DifficultyModes.EASY, bestScore[GameplayModes.PUZZLE][DifficultyModes.EASY]);
			Data.writeInt("bestScore" + GameplayModes.PUZZLE + DifficultyModes.MEDIUM, bestScore[GameplayModes.PUZZLE][DifficultyModes.MEDIUM]);
			Data.writeInt("bestScore" + GameplayModes.PUZZLE + DifficultyModes.HARD, bestScore[GameplayModes.PUZZLE][DifficultyModes.HARD]);
			
			Data.save(SAVE_FILENAME);
		}
		
		public static function SetMusicVolume(value:Number):void
		{
			musicSfx.volume = value;
		}
		
		public static function GetMusicVolume():Number
		{
			return musicSfx.volume;
		}
		
		public static function UpdateShift(rows:int, coloums:int):void
		{
			X_SHIFT = (FP.width - coloums * TILE_SIZE) / 2;
			Y_SHIFT = (FP.height - rows * TILE_SIZE) / 2;
			
			if (isiPhone() && !isiPhone5())
			{
				if (Global.gameplayMode == GameplayModes.PUZZLE && Global.difficultyMode == DifficultyModes.EASY)
				{
					Y_SHIFT += 25;
				}
				
				if (Global.gameplayMode ==  GameplayModes.NORMAL) 
				{
					Y_SHIFT += 25;
				}
			}
		}
		
		public static function GetPositionFromTile(tile:Point):Point
		{
			return new Point(tile.x * TILE_SIZE + X_SHIFT, tile.y * TILE_SIZE + Y_SHIFT);
		}
		
		public static function GetTileFromPosition(position:Point):Point
		{
			return new Point(Math.floor((position.x - X_SHIFT) / TILE_SIZE), Math.floor((position.y - Y_SHIFT) / TILE_SIZE));
		}
		
		public static function ShuffleArray(list:Array):void
		{
			for (var i:int = 0; i < 2 * list.length; i++) 
			{
				var random1:int = FP.rand(list.length);
				var random2:int = FP.rand(list.length);
				
				var temp:Object = list[random1];
				list[random1] = list[random2];
				list[random2] = temp;
			}
		}
		
		public static function SignInGameCenter():void
		{
			if (GoogleGames.isSupported())
			{
				if (!Global.authenticating && !GoogleGames.games.isSignedIn())
				{
					Global.authenticating = true;
					
					GoogleGames.games.addEventListener(GoogleGamesEvent.SIGN_IN_SUCCEEDED, UserAuth);
					GoogleGames.games.addEventListener(GoogleGamesEvent.SIGN_IN_FAILED, UserNotAuth);
					
					GoogleGames.games.signIn();
				}
			}
		}
		
		public static function GetLeaderBoardName(gameplay:int, difficulty:int):String
		{
			if (gameplay == GameplayModes.NORMAL)
			{
				if (difficulty == DifficultyModes.EASY)
				{
					return "CgkIg5H4pv0EEAIQAQ";
				}
				else if (difficulty == DifficultyModes.MEDIUM)
				{
					return "CgkIg5H4pv0EEAIQAg"
				}
				else if (difficulty == DifficultyModes.HARD)
				{
					return "CgkIg5H4pv0EEAIQAw"
				}
			}
			else if (gameplay == GameplayModes.PUZZLE)
			{
				if (difficulty == DifficultyModes.EASY)
				{
					return "CgkIg5H4pv0EEAIQBA";
				}
				else if (difficulty == DifficultyModes.MEDIUM)
				{
					return "CgkIg5H4pv0EEAIQBQ"
				}
				else if (difficulty == DifficultyModes.HARD)
				{
					return "CgkIg5H4pv0EEAIQBg"
				}
			}
			
			return "";
		}
		
		public static function UserAuth(e:GoogleGamesEvent):void
		{
			Global.authenticating = false;
			
			GoogleGames.games.removeEventListener(GoogleGamesEvent.SIGN_IN_SUCCEEDED, UserAuth);
			GoogleGames.games.removeEventListener(GoogleGamesEvent.SIGN_IN_FAILED, UserNotAuth);
		}
		
		public static function UserNotAuth(e:GoogleGamesEvent):void
		{
			Global.authenticating = false;
			
			GoogleGames.games.removeEventListener(GoogleGamesEvent.SIGN_IN_SUCCEEDED, UserAuth);
			GoogleGames.games.removeEventListener(GoogleGamesEvent.SIGN_IN_FAILED, UserNotAuth);
		}
	}

}