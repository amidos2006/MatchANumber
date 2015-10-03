package MatchANumber.GameEntity 
{
	import flash.geom.Point;
	import MatchANumber.GameSfx;
	import MatchANumber.LayerConstant;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Text;
	/**
	 * ...
	 * @author Amidos
	 */
	public class MultiChoiceEntity extends Entity
	{
		private const TEXT_COLOR:uint = 0x666666;
		
		[Embed(source = "../../../assets/click.mp3")]private var clickClass:Class;
		
		private var choices:Array;
		private var changeFunction:Function;
		private var titleText:Text;
		private var leftButton:ImageButtonEntity;
		private var rightButton:ImageButtonEntity;
		
		private var clickSfx:GameSfx;
		
		public var currentChoice:int;
		
		public function MultiChoiceEntity(title:String, choices:Array, changeFunction:Function, currentChoice:int = 0) 
		{
			this.choices = choices;
			this.changeFunction = changeFunction;
			this.currentChoice = currentChoice;
			
			clickSfx = new GameSfx(clickClass);
			
			var options:Object = new Object();
			options["size"] = 20;
			options["color"] = TEXT_COLOR;
			options["align"] = "center";
			titleText = new Text(title, 0, 0, options);
			titleText.centerOO();
			
			leftButton = new ImageButtonEntity(GraphicLoader.GetGraphics("leftbutton"), LeftPressed);
			rightButton = new ImageButtonEntity(GraphicLoader.GetGraphics("rightbutton"), RightPressed);
			
			layer = LayerConstant.BUTTON_LAYER;
		}
		
		override public function added():void 
		{
			super.added();
			
			leftButton.x = x - 130;
			leftButton.y = y;
			FP.world.add(leftButton);
			
			rightButton.x = x + 130;
			rightButton.y = y;
			FP.world.add(rightButton);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			FP.world.remove(leftButton);
			FP.world.remove(rightButton);
		}
		
		private function LeftPressed():void
		{
			currentChoice -= 1;
			if (currentChoice < 0)
			{
				currentChoice = choices.length - 1;
			}
			
			clickSfx.play();
			changeFunction();
		}
		
		private function RightPressed():void
		{
			currentChoice += 1;
			if (currentChoice > choices.length - 1)
			{
				currentChoice = 0;
			}
			
			clickSfx.play();
			changeFunction();
		}
		
		override public function render():void 
		{
			super.render();
			
			titleText.render(FP.buffer, new Point(x, y - 20), FP.camera);
			(choices[currentChoice] as Graphic).render(FP.buffer, new Point(x, y), FP.camera);
		}
	}

}