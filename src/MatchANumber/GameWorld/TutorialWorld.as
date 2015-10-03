package MatchANumber.GameWorld 
{
	import flash.geom.Point;
	import MatchANumber.DifficultyModes;
	import MatchANumber.GameEntity.*;
	import MatchANumber.GameplayModes;
	import MatchANumber.Global;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.TouchControl;
	import net.flashpunk.World;
	/**
	 * ...
	 * @author Amidos
	 */
	public class TutorialWorld extends World
	{
		private var hudEntity:TutorialHUDEntity;
		private var tutorialEntity:TutorialEntity;
		private var backButton:ImageButtonEntity;
		
		public function TutorialWorld() 
		{	
			hudEntity = new TutorialHUDEntity();
			add(hudEntity);
			
			tutorialEntity = new TutorialEntity(hudEntity);
			add(tutorialEntity);
			
			backButton = new ImageButtonEntity(GraphicLoader.GetGraphics("backButton"), HelpOrMain);
			backButton.x = 20;
			backButton.y = 20;
			
			add(backButton);
		}
		
		override public function begin():void 
		{
			super.begin();
			
			Global.backButtonFunction = HelpOrMain;
		}
		
		private function HelpOrMain():void
		{
			if (Global.firstTime)
			{
				Global.firstTime = false;
				Global.SaveGame();
				FP.world = new StartWorld();
			}
			else
			{
				FP.world = new HelpWorld();
			}
		}
		
		override public function update():void 
		{
			super.update();
		}
	}

}