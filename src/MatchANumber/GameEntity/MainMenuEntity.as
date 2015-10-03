package MatchANumber.GameEntity 
{
	import flash.geom.Point;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import MatchANumber.DifficultyModes;
	import MatchANumber.GameplayModes;
	import MatchANumber.GameWorld.CreditsWorld;
	import MatchANumber.GameWorld.GameplayWorld;
	import MatchANumber.GameWorld.OptionsWorld;
	import MatchANumber.GameWorld.StartWorld;
	import MatchANumber.GameWorld.TutorialWorld;
	import MatchANumber.Global;
	import MatchANumber.LayerConstant;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.World;
	/**
	 * ...
	 * @author Amidos
	 */
	public class MainMenuEntity extends Entity
	{
		private const TEXT_COLOR:uint = 0x666666;
		
		private var smallBlocks:BlockGridRender;
		private var gameLogo:Image;
		private var startGameButton:TextButtonEntity;
		private var optionsButton:TextButtonEntity;
		private var creditsButton:TextButtonEntity;
		private var getOSTButton:TextButtonEntity;
		private var creditsText:Text;
		
		public function MainMenuEntity() 
		{
			smallBlocks = new BlockGridRender();
			smallBlocks.RegisterColoumn(0);
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
			
			startGameButton = new TextButtonEntity("start", 40, TEXT_COLOR, StartGame);
			startGameButton.x = FP.halfWidth;
			startGameButton.y = FP.halfHeight - 1.5 * distanceInBetween + gameLogo.height / 2 + 10;
			
			optionsButton = new TextButtonEntity("options", 40, TEXT_COLOR, StartOptions);
			optionsButton.x = startGameButton.x;
			optionsButton.y = startGameButton.y + distanceInBetween;
			
			creditsButton = new TextButtonEntity("credits", 40, TEXT_COLOR, StartCredits);
			creditsButton.x = optionsButton.x;
			creditsButton.y = optionsButton.y + distanceInBetween;
			
			getOSTButton = new TextButtonEntity("get ost", 40, TEXT_COLOR, GetOST);
			getOSTButton.x = creditsButton.x;
			getOSTButton.y = creditsButton.y + distanceInBetween;
			
			layer = LayerConstant.MAP_LAYER;
		}
		
		override public function added():void 
		{
			super.added();
			
			Global.backButtonFunction = null;
			
			FP.world.add(startGameButton);
			FP.world.add(optionsButton);
			FP.world.add(creditsButton);
			FP.world.add(getOSTButton);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			FP.world.remove(startGameButton);
			FP.world.remove(optionsButton);
			FP.world.remove(creditsButton);
			FP.world.remove(getOSTButton);
		}
		
		private function StartGame():void
		{
			if (Global.firstTime)
			{
				FP.world = new TutorialWorld();
			}
			else
			{
				FP.world = new StartWorld();
			}
		}
		
		private function StartCredits():void
		{
			FP.world = new CreditsWorld();
		}
		
		private function StartOptions():void
		{
			FP.world = new OptionsWorld();
		}
		
		private function GetOST():void
		{
			var targetURL:URLRequest = new URLRequest("http://nameofwebsite.com/about.htm");
			navigateToURL(new URLRequest("http://agentwhiskers.bandcamp.com/track/match-a-number"), "_blank");
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