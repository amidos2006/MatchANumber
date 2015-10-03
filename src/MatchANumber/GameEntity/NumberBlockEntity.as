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
	public class NumberBlockEntity extends Entity
	{
		public var xTile:int;
		public var yTile:int;
		
		public var dataBlock:DataBlock;
		
		private var numberText:Text;
		private var grayBlock1Image:Image;
		private var grayBlock2Image:Image;
		private var lowBlockImage:Image;
		private var highBlockImage:Image;
		
		private var currentScale:Number;
		private var scaleTweener:NumTween;
		
		private var isHigh:Boolean;
		private var isPressed:Boolean;
		private var isPlayerOne:Boolean;
		
		public function NumberBlockEntity(xTileIn:int, yTileIn:int, data:DataBlock) 
		{
			dataBlock = data;
			
			xTile = xTileIn;
			yTile = yTileIn;
			
			var currentPosition:Point = Global.GetPositionFromTile(new Point(xTile, yTile));
			x = currentPosition.x + Global.TILE_SIZE / 2;
			y = currentPosition.y + Global.TILE_SIZE / 2;
			
			var options:Object = new Object();
			options["color"] = 0xFFFFFF;
			options["size"] = 30;
			options["align"] = "center";
			
			numberText = new Text(dataBlock.number.toString(), 0, 0, options);
			numberText.scale = 0;
			numberText.angle = dataBlock.direction;
			numberText.smooth = false;
			numberText.centerOO();
			
			grayBlock1Image = new Image(GraphicLoader.GetGraphics("selectedblock1"));
			grayBlock1Image.centerOO();
			grayBlock1Image.scale = 0;
			
			grayBlock2Image = new Image(GraphicLoader.GetGraphics("selectedblock2"));
			grayBlock2Image.centerOO();
			grayBlock2Image.scale = 0;
			
			lowBlockImage = new Image(GraphicLoader.GetGraphics("lownumberblock" + dataBlock.operation));
			lowBlockImage.centerOO();
			lowBlockImage.scale = 0;
			
			highBlockImage = new Image(GraphicLoader.GetGraphics("highnumberblock" + dataBlock.operation));
			highBlockImage.centerOO();
			highBlockImage.scale = 0;
			
			isHigh = false;
			isPressed = false;
			
			currentScale = 0;
			scaleTweener = new NumTween(null, Tween.ONESHOT);
			
			layer = LayerConstant.BLOCKS_LAYER;
		}
		
		override public function added():void 
		{
			super.added();
			
			GoLow();
			scaleTweener.tween(currentScale, 1, 20, Ease.bounceOut);
			addTween(scaleTweener, true);
		}
		
		public function GoLow():void
		{
			isPressed = false;
			isHigh = false;
		}
		
		public function GoHigh1():void
		{
			isPlayerOne = true;
			isPressed = true;
			isHigh = true;
		}
		
		public function GoHigh2():void
		{
			isPlayerOne = false;
			isPressed = true;
			isHigh = true;
		}
		
		override public function update():void 
		{
			super.update();
			
			currentScale = scaleTweener.value;
			
			grayBlock1Image.scale = currentScale;
			grayBlock2Image.scale = currentScale;
			lowBlockImage.scale = currentScale;
			highBlockImage.scale = currentScale;
			numberText.scale = currentScale;
			if (isPressed)
			{
				numberText.scale += (Global.HIGH_BLOCK_SIZE - Global.LOW_BLOCK_SIZE) / Global.LOW_BLOCK_SIZE;
			}
		}
		
		override public function render():void 
		{
			super.render();
			
			if (isPressed)
			{
				if (isPlayerOne)
				{
					grayBlock1Image.render(FP.buffer, new Point(x, y), FP.camera);
				}
				else
				{
					grayBlock2Image.render(FP.buffer, new Point(x, y), FP.camera);
				}
			}
			
			if (!isHigh)
			{
				lowBlockImage.render(FP.buffer, new Point(x, y), FP.camera);
			}
			else
			{
				highBlockImage.render(FP.buffer, new Point(x, y), FP.camera);
			}
			
			numberText.render(FP.buffer, new Point(x, y), FP.camera);
		}
	}

}