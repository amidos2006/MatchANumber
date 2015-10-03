package MatchANumber.GameWorld 
{
	import com.milkmangames.nativeextensions.GoogleGames;
	import MatchANumber.GameEntity.ImageButtonEntity;
	import MatchANumber.GameEntity.StartEntity;
	import MatchANumber.Global;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	/**
	 * ...
	 * @author Amidos
	 */
	public class StartWorld extends World
	{
		public function StartWorld() 
		{
			var backButton:ImageButtonEntity = new ImageButtonEntity(GraphicLoader.GetGraphics("backButton"), Menu);
			backButton.x = 20;
			backButton.y = 20;
			add(backButton);
			
			var gamecenterButton:ImageButtonEntity = new ImageButtonEntity(GraphicLoader.GetGraphics("gamecenterButton"), GameCenterFunc);
			gamecenterButton.x = FP.width - 20;
			gamecenterButton.y = 20;
			
			if (GoogleGames.isSupported() && !Global.DISABLE_GAME_CENTER)
			{
				add(gamecenterButton);
			}
			
			add(new StartEntity());
		}
		
		override public function begin():void 
		{
			super.begin();
			
			Global.backButtonFunction = Menu;
		}
		
		private function Menu():void
		{
			FP.world = new MainMenuWorld();
		}
		
		private function GameCenterFunc():void
		{
			FP.world = new GameCenterWorld(FP.buffer, this);
		}
	}

}