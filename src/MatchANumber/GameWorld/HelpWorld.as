package MatchANumber.GameWorld 
{
	import MatchANumber.GameEntity.HelpEntity;
	import MatchANumber.GameEntity.ImageButtonEntity;
	import MatchANumber.GameEntity.StartEntity;
	import MatchANumber.Global;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	/**
	 * ...
	 * @author Amidos
	 */
	public class HelpWorld extends World
	{
		public function HelpWorld() 
		{
			var backButton:ImageButtonEntity = new ImageButtonEntity(GraphicLoader.GetGraphics("backButton"), Back);
			backButton.x = 20;
			backButton.y = 20;
			add(backButton);
			
			var questionButton:ImageButtonEntity = new ImageButtonEntity(GraphicLoader.GetGraphics("questionButton"), Tutorial);
			questionButton.x = FP.width - 20;
			questionButton.y = 20;
			add(questionButton);
			
			add(new HelpEntity());
		}
		
		override public function begin():void 
		{
			super.begin();
			
			Global.backButtonFunction = Back;
		}
		
		private function Back():void
		{
			FP.world = new StartWorld();
		}
		
		private function Tutorial():void
		{
			FP.world = new TutorialWorld();
		}
	}

}