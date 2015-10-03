package MatchANumber.GameEntity 
{
	import flash.geom.Point;
	import MatchANumber.GameplayModes;
	import MatchANumber.GameWorld.GameplayWorld;
	import MatchANumber.GameWorld.MainMenuWorld;
	import MatchANumber.Global;
	import MatchANumber.LayerConstant;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.NumTween;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.TouchControl;
	import net.flashpunk.World;
	/**
	 * ...
	 * @author Amidos
	 */
	public class GoalEntity extends Entity
	{
		private const COLOR:uint = 0x666666;
		
		private var alpha:Number;
		private var hudEntity:HUDEntity;
		private var numTweener:NumTween;
		private var goalText:Text;
		private var hintText:Text;
		
		public function GoalEntity(hud:HUDEntity) 
		{
			hudEntity = hud;
			alpha = 0;
			
			var options:Object = new Object();
			options["color"] = COLOR;
			options["size"] = 20;
			options["align"] = "center";
			
			var goalString:String = "";
			switch(Global.gameplayMode)
			{
				case GameplayModes.NORMAL:
					goalString = "survive for longest time\n\nlonger chains give you more\nbonus time";
					break;
				case GameplayModes.PUZZLE:
					goalString = "try to clear all target results\nand get the highest score";
					break;
				case GameplayModes.MULTIPLAYER:
					goalString = "first to 50 points wins\n\nboth players' target values\nchange when a successful match\nis made";
					break;
			}
			
			goalText = new Text(goalString, 0, 0, options);
			goalText.centerOO();
			goalText.alpha = 0;
			
			options["size"] = 10;
			
			hintText = new Text("touch to close", 0, 0, options);
			hintText.centerOO();
			hintText.alpha = 0;
			
			numTweener = new NumTween(null, Tween.PERSIST);
			
			layer = LayerConstant.HUD_LAYER;
		}
		
		override public function added():void 
		{
			super.added();
			
			addTween(numTweener, true);
			
			if (Global.firstTimeGoal[Global.gameplayMode])
			{
				ShowBar();
			}
		}
		
		public function ShowBar():void
		{
			MapEntity.DisableControl = true;
			numTweener.tween(alpha, 1, 20);
		}
		
		public function HideBar():void
		{
			MapEntity.DisableControl = false;
			if (Global.gameplayMode == GameplayModes.NORMAL)
			{
				hudEntity.StartAlarm();
			}
			Global.firstTimeGoal[Global.gameplayMode] = false;
			Global.SaveGame();
			numTweener.tween(alpha, 0, 20);
		}
		
		override public function removed():void 
		{
			super.removed();
		}
		
		override public function update():void 
		{
			super.update();
			
			alpha = numTweener.value;
			goalText.alpha = alpha;
			hintText.alpha = alpha;
			
			if (alpha > 0 && !numTweener.active && TouchControl.TouchReleased() > 0)
			{
				HideBar();
			}
		}
		
		override public function render():void 
		{
			super.render();
			
			Draw.rectPlus( -10, FP.halfHeight - 70, FP.width + 20, 120, COLOR, alpha, true, 4);
			Draw.rectPlus( -10, FP.halfHeight - 67, FP.width + 20, 114, 0xFFFFFF, alpha, true, 0);
			
			goalText.render(FP.buffer, new Point(FP.halfWidth, FP.halfHeight - 15), FP.camera);
			hintText.render(FP.buffer, new Point(FP.halfWidth, FP.halfHeight + 40), FP.camera);
		}
	}

}