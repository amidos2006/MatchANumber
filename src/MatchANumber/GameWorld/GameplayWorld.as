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
	public class GameplayWorld extends World
	{
		private var hudEntity:HUDEntity;
		private var goalEntity:GoalEntity;
		private var mapEntity:MapEntity;
		private var backButton:ImageButtonEntity;
		private var restartButton:ImageButtonEntity;
		private var undoButton:ImageButtonEntity;
		private var redoButton:ImageButtonEntity;
		
		public function GameplayWorld() 
		{	
			hudEntity = new HUDEntity();
			add(hudEntity);
			
			MapEntity.Y_SIZE = 6;
			if (Global.gameplayMode == GameplayModes.PUZZLE)
			{
				switch (Global.difficultyMode) 
				{
					case DifficultyModes.EASY:
						MapEntity.Y_SIZE = 6;
						MapEntity.NUMBER_OF_SETS = 7;
						break;
					case DifficultyModes.MEDIUM:
						MapEntity.Y_SIZE = 5;
						MapEntity.NUMBER_OF_SETS = 6;
						break;
					case DifficultyModes.HARD:
						MapEntity.Y_SIZE = 4;
						MapEntity.NUMBER_OF_SETS = 5;
						break;
				}
			}
			
			mapEntity = new MapEntity(hudEntity);
			add(mapEntity);
			
			goalEntity = new GoalEntity(hudEntity);
			add(goalEntity);
			
			backButton = new ImageButtonEntity(GraphicLoader.GetGraphics("backButton"), Menu);
			backButton.x = 20;
			backButton.y = 20;
			
			add(backButton);
			
			restartButton = new ImageButtonEntity(GraphicLoader.GetGraphics("restartButton"), Restart);
			restartButton.x = FP.width - 20;
			restartButton.y = 20;
			
			add(restartButton);
			
			undoButton = new ImageButtonEntity(GraphicLoader.GetGraphics("undoButton"), mapEntity.Undo);
			undoButton.x = 20;
			undoButton.y = FP.height - 20;
			
			undoButton.active = mapEntity.UndoAllowed();
			undoButton.visible = mapEntity.UndoAllowed();
			
			redoButton = new ImageButtonEntity(GraphicLoader.GetGraphics("redoButton"), mapEntity.Redo);
			redoButton.x = FP.width - 20;
			redoButton.y = FP.height - 20;
			
			redoButton.active = mapEntity.RedoAllowed();
			redoButton.visible = mapEntity.RedoAllowed();
			
			if (Global.gameplayMode == GameplayModes.PUZZLE)
			{
				add(undoButton);
				add(redoButton);
			}
		}
		
		override public function begin():void 
		{
			super.begin();
			
			Global.backButtonFunction = Menu;
			if (Global.gameplayMode == GameplayModes.MULTIPLAYER)
			{
				TouchControl.MAX_NUMBER_OF_POINTS = 2;
			}
			else
			{
				TouchControl.MAX_NUMBER_OF_POINTS = 1;
			}
		}
		
		private function Menu():void
		{
			FP.world = new StartWorld();
		}
		
		private function Restart():void
		{
			if (Global.gameplayMode == GameplayModes.PUZZLE)
			{
				Global.numberOfResets -= 1;
			}
			
			FP.world = new GameplayWorld();
		}
		
		override public function update():void 
		{
			super.update();
			
			undoButton.active = mapEntity.UndoAllowed();
			undoButton.visible = mapEntity.UndoAllowed();
			redoButton.active = mapEntity.RedoAllowed();
			redoButton.visible = mapEntity.RedoAllowed();
		}
	}

}