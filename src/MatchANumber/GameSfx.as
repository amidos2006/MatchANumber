package MatchANumber 
{
	import net.flashpunk.Sfx;
	/**
	 * ...
	 * @author Amidos
	 */
	public class GameSfx extends Sfx
	{
		public static var sfxVolume:Number = 1;
		
		public function GameSfx(source:*, complete:Function = null, type:String = null)
		{
			super(source, complete, type);
		}
		
		override public function play(vol:Number = 1, pan:Number = 0):void 
		{
			super.play(sfxVolume * vol, pan);
		}
	}

}