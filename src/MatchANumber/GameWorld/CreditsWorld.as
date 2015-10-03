package MatchANumber.GameWorld 
{
	import MatchANumber.GameEntity.CreditsEntity;
	import MatchANumber.GameEntity.ImageButtonEntity;
	import MatchANumber.GameEntity.OptionsEntity;
	import MatchANumber.Global;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	/**
	 * ...
	 * @author Amidos
	 */
	public class CreditsWorld extends World
	{
		public function CreditsWorld() 
		{
			var backButton:ImageButtonEntity = new ImageButtonEntity(GraphicLoader.GetGraphics("backButton"), Menu);
			backButton.x = 20;
			backButton.y = 20;
			add(backButton);
			
			add(new CreditsEntity());
		}
		
		override public function begin():void 
		{
			super.begin();
			Global.backButtonFunction = Menu;
		}
		
		private function Menu():void
		{
			Global.SaveGame();
			FP.world = new MainMenuWorld();
		}
	}

}