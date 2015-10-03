package 
{
	import com.mesmotronic.ane.AndroidFullScreen;
	import com.milkmangames.nativeextensions.GoogleGames;
	import flash.desktop.NativeApplication;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import MatchANumber.GameWorld.MainMenuWorld;
	import MatchANumber.Global;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.TouchControl;
	
	/**
	 * ...
	 * @author Amidos
	 */
	public class Main extends Sprite 
	{
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			stage.addEventListener(Event.ACTIVATE, activate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// entry point
			Intialize();
		}
		
		private function Intialize():void
		{
			Global.DISABLE_GAME_CENTER = false;
			
			if (!Global.DISABLE_GAME_CENTER && GoogleGames.isSupported())
			{
				GoogleGames.create();
			}
			
			TouchControl.ENABLE_DEBUG = false;
			
			var currentHeight:Number = stage.fullScreenHeight / stage.fullScreenWidth * 384;
			
			var engine:Engine = new Engine(384, currentHeight, 60, true);
			
			FP.screen.color = 0xFFFFFF;
			
			var screenWidth:Number = stage.fullScreenWidth;
			var screenHeight:Number = stage.fullScreenHeight;
			if (AndroidFullScreen.isSupported && AndroidFullScreen.isImmersiveModeSupported)
			{
				screenWidth = AndroidFullScreen.immersiveWidth;
				screenHeight = AndroidFullScreen.immersiveHeight;
				
				AndroidFullScreen.immersiveMode();
			}
			
			var scaleX:Number = screenWidth / FP.width;
			var scaleY:Number = screenHeight / FP.height;
			FP.screen.scale = Math.min(scaleX, scaleY);
			
			FP.screen.x = (screenWidth - FP.screen.scale * FP.width) / 2;
			FP.screen.y = (screenHeight - FP.screen.scale * FP.height) / 2;
			
			Global.Intialize();
			if (!Global.DISABLE_GAME_CENTER)
			{
				Global.SignInGameCenter();
			}
			
			GraphicLoader.Intialize();
			GraphicLoader.ApplyColorScheme(Global.colorScheme);
			
			stage.quality = StageQuality.LOW;
			
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, CheckBackButton);
			
			FP.world = new MainMenuWorld();
			
			addChild(engine);
		}
		
		public static function deactivate(e:Event):void 
		{
			FP.volume = 0;
			Global.PauseMusic();
			FP.engine.paused = true;
		}
		
		public static function activate(e:Event):void 
		{
			FP.volume = 1;
			Global.ResumeMusic();
			FP.engine.paused = false;
		}
		
		public static function CheckBackButton(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.BACK)
			{
				if (Global.backButtonFunction != null)
				{
					e.preventDefault();
					Global.backButtonFunction();
				}
			}
		}
	}
	
}