package MatchANumber.GameWorld 
{
	import MatchANumber.DifficultyModes;
	import MatchANumber.GameEntity.MainMenuEntity;
	import MatchANumber.GameEntity.MapEntity;
	import MatchANumber.GameplayModes;
	import MatchANumber.Global;
	import net.flashpunk.World;
	/**
	 * ...
	 * @author Amidos
	 */
	public class MainMenuWorld extends World
	{
		public function MainMenuWorld() 
		{
			add(new MainMenuEntity());
		}
	}

}