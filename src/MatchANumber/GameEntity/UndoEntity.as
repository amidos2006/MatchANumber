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
	import net.flashpunk.World;
	/**
	 * ...
	 * @author Amidos
	 */
	public class UndoEntity extends Entity
	{
		private const COLOR:uint = 0x666666;
		
		private var alpha:Number;
		private var numTweener:NumTween;
		private var undoText:Text;
		
		public function UndoEntity() 
		{
			alpha = 0;
			
			var options:Object = new Object();
			options["color"] = COLOR;
			options["size"] = 50;
			options["align"] = "center";
			
			undoText = new Text("press undo", 0, 0, options);
			undoText.centerOO();
			undoText.alpha = 0;
			
			numTweener = new NumTween(null, Tween.PERSIST);
			
			layer = LayerConstant.HUD_LAYER;
		}
		
		override public function added():void 
		{
			super.added();
			
			addTween(numTweener, true);
		}
		
		public function ShowBar():void
		{
			numTweener.tween(alpha, 1, 20);
		}
		
		public function HideBar():void
		{
			numTweener.tween(alpha, 0, 20);
		}
		
		private function Restart():void
		{
			FP.world = new GameplayWorld();
		}
		
		private function Menu():void
		{
			FP.world = new MainMenuWorld();
		}
		
		override public function removed():void 
		{
			super.removed();
		}
		
		override public function update():void 
		{
			super.update();
			
			alpha = numTweener.value;
			undoText.alpha = alpha;
		}
		
		override public function render():void 
		{
			super.render();
			
			Draw.rectPlus( -10, FP.halfHeight - 60, FP.width + 20, 100, COLOR, alpha, true, 4);
			Draw.rectPlus( -10, FP.halfHeight - 57, FP.width + 20, 94, 0xFFFFFF, alpha, true, 0);
			
			undoText.render(FP.buffer, new Point(FP.halfWidth, FP.halfHeight - 10), FP.camera);
		}
	}

}