package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import MatchANumber.ColorScheme;
	import MatchANumber.GameEntity.MathOperation;
	import MatchANumber.Global;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Amidos
	 */
	public class GraphicLoader 
	{
		[Embed(source = "../assets/backButton.png")]private static var backButton:Class;
		[Embed(source = "../assets/questionButton.png")]private static var questionButton:Class;
		[Embed(source = "../assets/redoButton.png")]private static var redoButton:Class;
		[Embed(source = "../assets/restartButton.png")]private static var restartButton:Class;
		[Embed(source = "../assets/undoButton.png")]private static var undoButton:Class;
		[Embed(source = "../assets/arrowLeft.png")]private static var leftButton:Class;
		[Embed(source = "../assets/arrowRight.png")]private static var rightButton:Class;
		[Embed(source = "../assets/googleplayButton.png")]private static var gamecenterButton:Class;
		[Embed(source = "../assets/colorScheme1.png")]private static var color1SchemeClass:Class;
		[Embed(source = "../assets/colorScheme2.png")]private static var color2SchemeClass:Class;
		[Embed(source = "../assets/gameLogo.png")]private static var gameLogoClass:Class;
		
		private static var inGameGraphics:Array;
		
		private static var plusLowSign:BitmapData;
		private static var subtractLowSign:BitmapData;
		private static var multiplyLowSign:BitmapData;
		
		private static var plusHighSign:BitmapData;
		private static var subtractHighSign:BitmapData;
		private static var multiplyHighSign:BitmapData;
		
		private static var blueHighBox:BitmapData;
		private static var blueLowBox:BitmapData;
		
		private static var redHighBox:BitmapData;
		private static var redLowBox:BitmapData;
		
		private static var yellowHighBox:BitmapData;
		private static var yellowLowBox:BitmapData;
		
		public static function Intialize():void
		{
			var bitmapData:BitmapData;
			var options:Object;
			var shift:Number = 12;
			var text:Text;
			inGameGraphics = new Array();
			
			bitmapData = new BitmapData(Global.TILE_SIZE, Global.TILE_SIZE, true, 0);
			Draw.setTarget(bitmapData);
			Draw.rectPlus((Global.TILE_SIZE - Global.LOW_BLOCK_SIZE) / 2, (Global.TILE_SIZE - Global.LOW_BLOCK_SIZE) / 2, 
							Global.LOW_BLOCK_SIZE, Global.LOW_BLOCK_SIZE, 0x5959FF, 1, true, 0);
			Draw.resetTarget();
			blueLowBox = bitmapData;
			inGameGraphics["lownumberblock" + MathOperation.ADD] = bitmapData;
			
			bitmapData = new BitmapData(Global.TILE_SIZE, Global.TILE_SIZE, true, 0);
			Draw.setTarget(bitmapData);
			Draw.rectPlus((Global.TILE_SIZE - Global.LOW_BLOCK_SIZE) / 2, (Global.TILE_SIZE - Global.LOW_BLOCK_SIZE) / 2, 
							Global.LOW_BLOCK_SIZE, Global.LOW_BLOCK_SIZE, 0xFF5959, 1, true, 0);
			Draw.resetTarget();
			redLowBox = bitmapData;
			inGameGraphics["lownumberblock" + MathOperation.SUBTRACT] = bitmapData;
			
			bitmapData = new BitmapData(Global.TILE_SIZE, Global.TILE_SIZE, true, 0);
			Draw.setTarget(bitmapData);
			Draw.rectPlus((Global.TILE_SIZE - Global.LOW_BLOCK_SIZE) / 2, (Global.TILE_SIZE - Global.LOW_BLOCK_SIZE) / 2, 
							Global.LOW_BLOCK_SIZE, Global.LOW_BLOCK_SIZE, 0xFFE359, 1, true, 0);
			Draw.resetTarget();
			yellowLowBox = bitmapData;
			inGameGraphics["lownumberblock" + MathOperation.MULTIPLY] = bitmapData;
			
			bitmapData = new BitmapData(Global.TILE_SIZE, Global.TILE_SIZE, true, 0);
			Draw.setTarget(bitmapData);
			Draw.rectPlus((Global.TILE_SIZE - Global.HIGH_BLOCK_SIZE) / 2, (Global.TILE_SIZE - Global.HIGH_BLOCK_SIZE) / 2, 
							Global.HIGH_BLOCK_SIZE, Global.HIGH_BLOCK_SIZE, 0x4B4BD8, 1, true, 0);
			Draw.resetTarget();
			blueHighBox = bitmapData;
			inGameGraphics["highnumberblock" + MathOperation.ADD] = bitmapData;
			
			bitmapData = new BitmapData(Global.TILE_SIZE, Global.TILE_SIZE, true, 0);
			Draw.setTarget(bitmapData);
			Draw.rectPlus((Global.TILE_SIZE - Global.HIGH_BLOCK_SIZE) / 2, (Global.TILE_SIZE - Global.HIGH_BLOCK_SIZE) / 2, 
							Global.HIGH_BLOCK_SIZE, Global.HIGH_BLOCK_SIZE, 0xD84B4B, 1, true, 0);
			Draw.resetTarget();
			redHighBox = bitmapData;
			inGameGraphics["highnumberblock" + MathOperation.SUBTRACT] = bitmapData;
			
			bitmapData = new BitmapData(Global.TILE_SIZE, Global.TILE_SIZE, true, 0);
			Draw.setTarget(bitmapData);
			Draw.rectPlus((Global.TILE_SIZE - Global.HIGH_BLOCK_SIZE) / 2, (Global.TILE_SIZE - Global.HIGH_BLOCK_SIZE) / 2, 
							Global.HIGH_BLOCK_SIZE, Global.HIGH_BLOCK_SIZE, 0xD8BE4B, 1, true, 0);
			Draw.resetTarget();
			yellowHighBox = bitmapData;
			inGameGraphics["highnumberblock" + MathOperation.MULTIPLY] = bitmapData;
			
			bitmapData = new BitmapData(Global.TILE_SIZE, Global.TILE_SIZE, true, 0);
			Draw.setTarget(bitmapData);
			Draw.rectPlus(0, 0, Global.TILE_SIZE, Global.TILE_SIZE, 0x999999, 1, true, 0);
			Draw.resetTarget();
			inGameGraphics["selectedblock1"] = bitmapData;
			
			bitmapData = new BitmapData(Global.TILE_SIZE, Global.TILE_SIZE, true, 0);
			Draw.setTarget(bitmapData);
			Draw.rectPlus(0, 0, Global.TILE_SIZE, Global.TILE_SIZE, 0xCCCCCC, 1, true, 0);
			Draw.resetTarget();
			inGameGraphics["selectedblock2"] = bitmapData;
			
			bitmapData = new BitmapData(Global.TILE_SIZE, Global.TILE_SIZE, true, 0);
			Draw.setTarget(bitmapData);
			Draw.rectPlus((Global.TILE_SIZE - Global.BACK_BLOCK_SIZE) / 2, (Global.TILE_SIZE - Global.BACK_BLOCK_SIZE) / 2, 
							Global.BACK_BLOCK_SIZE, Global.BACK_BLOCK_SIZE, 0xE5E5E5, 1, true, 0);
			Draw.resetTarget();
			inGameGraphics["backblock"] = bitmapData;
			
			bitmapData = new BitmapData(Global.TILE_SIZE, Global.TILE_SIZE, true, 0);
			Draw.setTarget(bitmapData);
			Draw.rectPlus((Global.TILE_SIZE - Global.RESULT_BLOCK_SIZE) / 2, (Global.TILE_SIZE - Global.RESULT_BLOCK_SIZE) / 2, 
							Global.RESULT_BLOCK_SIZE, Global.RESULT_BLOCK_SIZE, 0x73CC47, 1, true, 0);
			Draw.resetTarget();
			inGameGraphics["resultblock"] = bitmapData;
			
			options = new Object();
			options["size"] = 10;
			options["align"] = "center";
			options["color"] = 0xFFFFFF;
			
			bitmapData = new BitmapData(Global.TILE_SIZE, Global.TILE_SIZE, true, 0);
			text = new Text("+", 0, 0, options);
			text.centerOO();
			text.render(bitmapData, new Point(shift, shift), new Point());
			//text.render(bitmapData, new Point(Global.TILE_SIZE - shift, shift), new Point());
			//text.render(bitmapData, new Point(shift, Global.TILE_SIZE - shift), new Point());
			text.render(bitmapData, new Point(Global.TILE_SIZE - shift, Global.TILE_SIZE - shift), new Point());
			plusLowSign = bitmapData;
			
			bitmapData = new BitmapData(Global.TILE_SIZE, Global.TILE_SIZE, true, 0);
			text = new Text("-", 0, 0, options);
			text.centerOO();
			text.render(bitmapData, new Point(shift, shift), new Point());
			//text.render(bitmapData, new Point(Global.TILE_SIZE - shift, shift), new Point());
			//text.render(bitmapData, new Point(shift, Global.TILE_SIZE - shift), new Point());
			text.render(bitmapData, new Point(Global.TILE_SIZE - shift, Global.TILE_SIZE - shift), new Point());
			subtractLowSign = bitmapData;
			
			bitmapData = new BitmapData(Global.TILE_SIZE, Global.TILE_SIZE, true, 0);
			text = new Text("x", 0, 0, options);
			text.centerOO();
			text.render(bitmapData, new Point(shift, shift), new Point());
			//text.render(bitmapData, new Point(Global.TILE_SIZE - shift, shift), new Point());
			//text.render(bitmapData, new Point(shift, Global.TILE_SIZE - shift), new Point());
			text.render(bitmapData, new Point(Global.TILE_SIZE - shift, Global.TILE_SIZE - shift), new Point());
			multiplyLowSign = bitmapData;
			
			options = new Object();
			options["size"] = 15;
			options["align"] = "center";
			options["color"] = 0xFFFFFF;
			
			bitmapData = new BitmapData(Global.TILE_SIZE, Global.TILE_SIZE, true, 0);
			text = new Text("+", 0, 0, options);
			text.centerOO();
			text.render(bitmapData, new Point(shift, shift), new Point());
			//text.render(bitmapData, new Point(Global.TILE_SIZE - shift, shift), new Point());
			//text.render(bitmapData, new Point(shift, Global.TILE_SIZE - shift), new Point());
			text.render(bitmapData, new Point(Global.TILE_SIZE - shift, Global.TILE_SIZE - shift), new Point());
			plusHighSign = bitmapData;
			
			bitmapData = new BitmapData(Global.TILE_SIZE, Global.TILE_SIZE, true, 0);
			text = new Text("-", 0, 0, options);
			text.centerOO();
			text.render(bitmapData, new Point(shift, shift), new Point());
			//text.render(bitmapData, new Point(Global.TILE_SIZE - shift, shift), new Point());
			//text.render(bitmapData, new Point(shift, Global.TILE_SIZE - shift), new Point());
			text.render(bitmapData, new Point(Global.TILE_SIZE - shift, Global.TILE_SIZE - shift), new Point());
			subtractHighSign = bitmapData;
			
			bitmapData = new BitmapData(Global.TILE_SIZE, Global.TILE_SIZE, true, 0);
			text = new Text("x", 0, 0, options);
			text.centerOO();
			text.render(bitmapData, new Point(shift, shift), new Point());
			//text.render(bitmapData, new Point(Global.TILE_SIZE - shift, shift), new Point());
			//text.render(bitmapData, new Point(shift, Global.TILE_SIZE - shift), new Point());
			text.render(bitmapData, new Point(Global.TILE_SIZE - shift, Global.TILE_SIZE - shift), new Point());
			multiplyHighSign = bitmapData;
			
			var bitmap:Bitmap = new undoButton();
			inGameGraphics["undobutton"] = bitmap.bitmapData;
			
			bitmap = new redoButton();
			inGameGraphics["redobutton"] = bitmap.bitmapData;
			
			bitmap = new restartButton();
			inGameGraphics["restartbutton"] = bitmap.bitmapData;
			
			bitmap = new backButton();
			inGameGraphics["backbutton"] = bitmap.bitmapData;
			
			bitmap = new questionButton();
			inGameGraphics["questionbutton"] = bitmap.bitmapData;
			
			bitmap = new leftButton();
			inGameGraphics["leftbutton"] = bitmap.bitmapData;
			
			bitmap = new rightButton();
			inGameGraphics["rightbutton"] = bitmap.bitmapData;
			
			bitmap = new gamecenterButton();
			inGameGraphics["gamecenterbutton"] = bitmap.bitmapData;
			
			bitmap = new color1SchemeClass();
			inGameGraphics["colorscheme1"] = bitmap.bitmapData;
			
			bitmap = new color2SchemeClass();
			inGameGraphics["colorscheme2"] = bitmap.bitmapData;
			
			bitmap = new gameLogoClass();
			inGameGraphics["gamelogo"] = bitmap.bitmapData;
		}
		
		public static function ApplyColorScheme(colorScheme:int):void
		{
			inGameGraphics["lownumberblock" + MathOperation.ADD] = new BitmapData(Global.TILE_SIZE, Global.TILE_SIZE, true, 0);
			inGameGraphics["lownumberblock" + MathOperation.SUBTRACT] = new BitmapData(Global.TILE_SIZE, Global.TILE_SIZE, true, 0);
			inGameGraphics["lownumberblock" + MathOperation.MULTIPLY] = new BitmapData(Global.TILE_SIZE, Global.TILE_SIZE, true, 0);
			inGameGraphics["highnumberblock" + MathOperation.ADD] = new BitmapData(Global.TILE_SIZE, Global.TILE_SIZE, true, 0);
			inGameGraphics["highnumberblock" + MathOperation.SUBTRACT] = new BitmapData(Global.TILE_SIZE, Global.TILE_SIZE, true, 0);
			inGameGraphics["highnumberblock" + MathOperation.MULTIPLY] = new BitmapData(Global.TILE_SIZE, Global.TILE_SIZE, true, 0);
			
			if (colorScheme == ColorScheme.BLUE_POS_RED_NEG_YELL_MUL)
			{
				inGameGraphics["lownumberblock" + MathOperation.ADD].draw(blueLowBox);
				inGameGraphics["lownumberblock" + MathOperation.SUBTRACT].draw(redLowBox);
				inGameGraphics["lownumberblock" + MathOperation.MULTIPLY].draw(yellowLowBox);
				
				inGameGraphics["highnumberblock" + MathOperation.ADD].draw(blueHighBox);
				inGameGraphics["highnumberblock" + MathOperation.SUBTRACT].draw(redHighBox);
				inGameGraphics["highnumberblock" + MathOperation.MULTIPLY].draw(yellowHighBox);
			}
			
			if (colorScheme == ColorScheme.RED_POS_BLUE_NEG_YELL_MUL)
			{
				inGameGraphics["lownumberblock" + MathOperation.ADD].draw(redLowBox);
				inGameGraphics["lownumberblock" + MathOperation.SUBTRACT].draw(blueLowBox);
				inGameGraphics["lownumberblock" + MathOperation.MULTIPLY].draw(yellowLowBox);
				
				inGameGraphics["highnumberblock" + MathOperation.ADD].draw(redHighBox);
				inGameGraphics["highnumberblock" + MathOperation.SUBTRACT].draw(blueHighBox);
				inGameGraphics["highnumberblock" + MathOperation.MULTIPLY].draw(yellowHighBox);
			}
			
			if (Global.hints)
			{
				inGameGraphics["lownumberblock" + MathOperation.ADD].draw(plusLowSign);
				inGameGraphics["lownumberblock" + MathOperation.SUBTRACT].draw(subtractLowSign);
				inGameGraphics["lownumberblock" + MathOperation.MULTIPLY].draw(multiplyLowSign);
				
				inGameGraphics["highnumberblock" + MathOperation.ADD].draw(plusHighSign);
				inGameGraphics["highnumberblock" + MathOperation.SUBTRACT].draw(subtractHighSign);
				inGameGraphics["highnumberblock" + MathOperation.MULTIPLY].draw(multiplyHighSign);
			}
		}
		
		public static function GetGraphics(name:String):BitmapData
		{
			return inGameGraphics[name.toLowerCase()];
		}
	}

}