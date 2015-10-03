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
	public class CreditsEntity extends Entity
	{
		private const TEXT_COLOR:uint = 0x666666;
		private const INTER_DISTANCE:int = 40;
		private const TEXT_DISTANCE:int = 30;
		private const HEAD_DISTANCE:int = 15;
		
		private var smallBlocks:BlockGridRender;
		private var gameLogo:Image;
		
		private var gameByText:Text;
		private var musicByText:Text;
		private var inspiredByText:Text;
		private var thanksToText:Text;
		
		private var amidosText:Text;
		private var agentWhiskerText:Text;
		private var inspirationGamesText:Text;
		private var thanksPeopleText:Text;
		
		public function CreditsEntity() 
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
			options["size"] = 20;
			options["align"] = "center";
			
			gameByText = new Text("game by", 0, 0, options);
			gameByText.centerOO();
			gameByText.originY = 0;
			
			musicByText = new Text("music by", 0, 0, options);
			musicByText.centerOO();
			musicByText.originY = 0;
			
			inspiredByText = new Text("inspired by", 0, 0, options);
			inspiredByText.centerOO();
			inspiredByText.originY = 0;
			
			thanksToText = new Text("thanks to", 0, 0, options);
			thanksToText.centerOO();
			thanksToText.originY = 0;
			
			options["size"] = 30;
			
			amidosText = new Text("amidos", 0, 0, options);
			amidosText.centerOO();
			amidosText.originY = 0;
			
			agentWhiskerText = new Text("agent whiskers", 0, 0, options);
			agentWhiskerText.centerOO();
			agentWhiskerText.originY = 0;
			
			inspirationGamesText = new Text("stickets\na game of numbers", 0, 0, options);
			inspirationGamesText.centerOO();
			inspirationGamesText.originY = 0;
			
			thanksPeopleText = new Text("chevy ray\ndanny day\nemamz\nmohamed assem\nrichard lord", 0, 0, options);
			thanksPeopleText.centerOO();
			thanksPeopleText.originY = 0;
			
			layer = LayerConstant.MAP_LAYER;
		}
		
		override public function added():void 
		{
			super.added();
		}
		
		override public function removed():void 
		{
			super.removed();
		}
		
		override public function render():void 
		{
			super.render();
			
			smallBlocks.render(FP.buffer, new Point(), FP.camera);
			
			var distanceInBetween:Number = (FP.height - gameLogo.height - 20) / 9;
			
			var renderPoint:Point = new Point(FP.halfWidth, gameLogo.height + 50);
			
			gameByText.render(FP.buffer, renderPoint, FP.camera);
			renderPoint.y += HEAD_DISTANCE;
			amidosText.render(FP.buffer, renderPoint, FP.camera);
			renderPoint.y += distanceInBetween;
			
			musicByText.render(FP.buffer, renderPoint, FP.camera);
			renderPoint.y += HEAD_DISTANCE;
			agentWhiskerText.render(FP.buffer, renderPoint, FP.camera);
			renderPoint.y += distanceInBetween;
			
			inspiredByText.render(FP.buffer, renderPoint, FP.camera);
			renderPoint.y += HEAD_DISTANCE;
			inspirationGamesText.render(FP.buffer, renderPoint, FP.camera);
			renderPoint.y += TEXT_DISTANCE + distanceInBetween;
			
			thanksToText.render(FP.buffer, renderPoint, FP.camera);
			renderPoint.y += HEAD_DISTANCE;
			thanksPeopleText.render(FP.buffer, renderPoint, FP.camera);
			
			gameLogo.render(FP.buffer, new Point(FP.halfWidth, 20), FP.camera);
		}
	}

}