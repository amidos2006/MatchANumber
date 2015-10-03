package MatchANumber.GameEntity 
{
	import flash.geom.Point;
	import MatchANumber.DifficultyModes;
	import MatchANumber.GameplayModes;
	import MatchANumber.GameSfx;
	import MatchANumber.GameWorld.GameplayWorld;
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
	public class OptionsEntity extends Entity
	{
		private const TEXT_COLOR:uint = 0x666666;
		
		private var gameLogo:Image;
		private var helpText:Text;
		private var smallBlocks:BlockGridRender;
		
		private var player1HandChoices:MultiChoiceEntity;
		private var player2HandChoices:MultiChoiceEntity;
		private var hintChoices:MultiChoiceEntity;
		private var musicChoices:MultiChoiceEntity;
		private var sfxChoices:MultiChoiceEntity;
		private var colorSchemeChoices:MultiChoiceEntity;
		
		private var creditsText:Text;
		
		public function OptionsEntity() 
		{
			smallBlocks = new BlockGridRender();
			smallBlocks.RegisterColoumn(0);
			smallBlocks.RemovePoint(new Point());
			smallBlocks.RegisterColoumn(5);
			
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
			
			var distanceInBetween:Number = (FP.height - gameLogo.height - creditsText.height - 20) / 6;
			
			options["size"] = 30;
			
			var choicesArray:Array = new Array();
			var textChoice:Text = new Text("right handed", 0, 0, options);
			textChoice.centerOO();
			choicesArray.push(textChoice);
			textChoice = new Text("left handed", 0, 0, options);
			textChoice.centerOO();
			choicesArray.push(textChoice);
			
			player1HandChoices = new MultiChoiceEntity("first player", choicesArray, Player1ChoiceChange, Global.player1Hand);
			player1HandChoices.x = FP.halfWidth;
			player1HandChoices.y = gameLogo.height + 65;
			
			choicesArray = new Array();
			textChoice = new Text("right handed", 0, 0, options);
			textChoice.centerOO();
			choicesArray.push(textChoice);
			textChoice = new Text("left handed", 0, 0, options);
			textChoice.centerOO();
			choicesArray.push(textChoice);
			
			player2HandChoices = new MultiChoiceEntity("second player", choicesArray, Player2ChoiceChange, Global.player2Hand);
			player2HandChoices.x = player1HandChoices.x;
			player2HandChoices.y = player1HandChoices.y + distanceInBetween;
			
			choicesArray = new Array();
			textChoice = new Text("on", 0, 0, options);
			textChoice.centerOO();
			choicesArray.push(textChoice);
			textChoice = new Text("off", 0, 0, options);
			textChoice.centerOO();
			choicesArray.push(textChoice);
			
			hintChoices = new MultiChoiceEntity("hints", choicesArray, HintsChange, Global.hints? 0:1);
			hintChoices.x = player2HandChoices.x;
			hintChoices.y = player2HandChoices.y + distanceInBetween;
			
			choicesArray = new Array();
			var imageChoice:Image = new Image(GraphicLoader.GetGraphics("colorscheme1"));
			imageChoice.centerOO();
			choicesArray.push(imageChoice);
			imageChoice = new Image(GraphicLoader.GetGraphics("colorscheme2"));
			imageChoice.centerOO();
			choicesArray.push(imageChoice);
			
			colorSchemeChoices = new MultiChoiceEntity("color scheme", choicesArray, ColorChoiceChange, Global.colorScheme);
			colorSchemeChoices.x = hintChoices.x;
			colorSchemeChoices.y = hintChoices.y + distanceInBetween;
			
			choicesArray = new Array();
			textChoice = new Text("off", 0, 0, options);
			textChoice.centerOO();
			choicesArray.push(textChoice);
			textChoice = new Text("on", 0, 0, options);
			textChoice.centerOO();
			choicesArray.push(textChoice);
			
			musicChoices = new MultiChoiceEntity("music", choicesArray, MusicChoiceChange, Global.GetMusicVolume());
			musicChoices.x = colorSchemeChoices.x;
			musicChoices.y = colorSchemeChoices.y + distanceInBetween;
			
			choicesArray = new Array();
			textChoice = new Text("off", 0, 0, options);
			textChoice.centerOO();
			choicesArray.push(textChoice);
			textChoice = new Text("on", 0, 0, options);
			textChoice.centerOO();
			choicesArray.push(textChoice);
			
			sfxChoices = new MultiChoiceEntity("sfx", choicesArray, SfxChoiceChange, GameSfx.sfxVolume);
			sfxChoices.x = musicChoices.x;
			sfxChoices.y = musicChoices.y + distanceInBetween;
			
			layer = LayerConstant.MAP_LAYER;
		}
		
		override public function added():void 
		{
			super.added();
			
			FP.world.add(player1HandChoices);
			FP.world.add(player2HandChoices);
			FP.world.add(hintChoices);
			FP.world.add(colorSchemeChoices);
			FP.world.add(musicChoices);
			FP.world.add(sfxChoices);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			FP.world.remove(player1HandChoices);
			FP.world.remove(player2HandChoices);
			FP.world.remove(hintChoices);
			FP.world.remove(colorSchemeChoices);
			FP.world.remove(musicChoices);
			FP.world.remove(sfxChoices);
		}
		
		private function Player1ChoiceChange():void
		{
			Global.player1Hand = player1HandChoices.currentChoice;
		}
		
		private function Player2ChoiceChange():void
		{
			Global.player2Hand = player2HandChoices.currentChoice;
		}
		
		private function HintsChange():void
		{
			Global.hints = hintChoices.currentChoice == 0;
			GraphicLoader.ApplyColorScheme(Global.colorScheme);
		}
		
		private function ColorChoiceChange():void
		{
			Global.colorScheme = colorSchemeChoices.currentChoice;
			GraphicLoader.ApplyColorScheme(Global.colorScheme);
		}
		
		private function MusicChoiceChange():void
		{
			Global.SetMusicVolume(musicChoices.currentChoice);
		}
		
		private function SfxChoiceChange():void
		{
			GameSfx.sfxVolume = sfxChoices.currentChoice;
		}
		
		override public function render():void 
		{
			super.render();
			
			smallBlocks.render(FP.buffer, new Point(0, 0), FP.camera);
			gameLogo.render(FP.buffer, new Point(FP.halfWidth, 20), FP.camera);
			creditsText.render(FP.buffer, new Point(FP.halfWidth, FP.height), FP.camera);
		}
	}

}