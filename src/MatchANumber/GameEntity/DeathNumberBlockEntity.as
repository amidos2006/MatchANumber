package MatchANumber.GameEntity 
{
	import flash.geom.Point;
	import MatchANumber.GameplayModes;
	import MatchANumber.Global;
	import MatchANumber.LayerConstant;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.NumTween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Ease;
	/**
	 * ...
	 * @author Amidos
	 */
	public class DeathNumberBlockEntity extends Entity
	{
		public var xTile:int;
		public var yTile:int;
		
		public var dataBlock:DataBlock;
		
		private var numberText:Text;
		private var blockImage:Image;
		
		private var currentScale:Number;
		private var scaleTweener:NumTween;
		private var removeFunction:Function;
		
		public function DeathNumberBlockEntity(xTileIn:int, yTileIn:int, data:DataBlock, endFunction:Function) 
		{
			dataBlock = data;
			
			xTile = xTileIn;
			yTile = yTileIn;
			
			removeFunction = endFunction;
			
			var currentPosition:Point = Global.GetPositionFromTile(new Point(xTile, yTile));
			x = currentPosition.x + Global.TILE_SIZE / 2;
			y = currentPosition.y + Global.TILE_SIZE / 2;
			
			var options:Object = new Object();
			options["color"] = 0xFFFFFF;
			options["size"] = 30;
			options["align"] = "center";
			
			if (Global.gameplayMode == GameplayModes.MULTIPLAYER)
			{
				options["size"] = 20;
			}
			
			numberText = new Text(dataBlock.number.toString(), 0, 0, options);
			numberText.scale = 0;
			numberText.angle = dataBlock.direction;
			numberText.centerOO();
			
			blockImage = new Image(GraphicLoader.GetGraphics("highnumberblock" + dataBlock.operation));
			blockImage.centerOO();
			blockImage.scale = 1;
			
			currentScale = 1;
			scaleTweener = new NumTween(TweenFinished, Tween.ONESHOT);
			
			graphic = new Graphiclist(blockImage);
			layer = LayerConstant.BLOCKS_LAYER;
		}
		
		override public function added():void 
		{
			super.added();
			
			scaleTweener.tween(currentScale, 0, 20, Ease.backIn);
			addTween(scaleTweener, true);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			removeFunction(xTile, yTile);
		}
		
		private function TweenFinished():void
		{
			FP.world.remove(this);
		}
		
		override public function update():void 
		{
			super.update();
			
			currentScale = scaleTweener.value;
			numberText.scale = currentScale;
			blockImage.scale = currentScale;
		}
		
		override public function render():void 
		{
			super.render();
			
			numberText.render(FP.buffer, new Point(x, y), FP.camera);
		}
	}

}