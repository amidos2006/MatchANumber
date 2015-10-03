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
	public class MessageStripEntity extends Entity
	{
		private const COLOR:uint = 0x666666;
		
		private var alpha:Number;
		private var numTweener:NumTween;
		private var messageText:Text;
		private var alphaVisible:Boolean;
		private var hintText:Text;
		
		public var showHint:Boolean;
		
		public function MessageStripEntity(message:String) 
		{
			alpha = 0;
			alphaVisible = false;
			showHint = false;
			
			var options:Object = new Object();
			options["color"] = COLOR;
			options["size"] = 20;
			options["align"] = "center";
			
			messageText = new Text(message, 0, 0, options);
			messageText.centerOO();
			messageText.alpha = 0;
			
			options["size"] = 10;
			
			hintText = new Text("touch to close", 0, 0, options);
			hintText.centerOO();
			hintText.alpha = 0;
			
			numTweener = new NumTween(EndTween, Tween.PERSIST);
			
			layer = LayerConstant.HUD_LAYER;
		}
		
		override public function added():void 
		{
			super.added();
			
			addTween(numTweener, true);
		}
		
		private function EndTween():void
		{
			alphaVisible = false;
			if (alpha > 0.5)
			{
				alphaVisible = true;
			}
		}
		
		public function ShowBar():void
		{
			alphaVisible = true;
			numTweener.tween(alpha, 1, 20);
		}
		
		public function HideBar():void
		{
			numTweener.tween(alpha, 0, 20);
		}
		
		public function get isVisible():Boolean
		{
			return alphaVisible;
		}
		
		public function ChangeText(message:String):void
		{
			messageText.text = message;
			messageText.centerOO();
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
			messageText.alpha = alpha;
			hintText.alpha = alpha;
		}
		
		override public function render():void 
		{
			super.render();
			
			Draw.rectPlus( -10, FP.halfHeight - 60, FP.width + 20, 100, COLOR, alpha, true, 4);
			Draw.rectPlus( -10, FP.halfHeight - 57, FP.width + 20, 94, 0xFFFFFF, alpha, true, 0);
			
			messageText.render(FP.buffer, new Point(FP.halfWidth, FP.halfHeight - 10), FP.camera);
			if (showHint)
			{
				hintText.render(FP.buffer, new Point(FP.halfWidth, FP.halfHeight + 30), FP.camera);
			}
		}
	}

}