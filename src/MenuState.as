package
{
	import flash.display.MovieClip;
	
	import org.flixel.*;

	public class MenuState extends FlxState
	{
		[Embed(source="../assets/title_screen.png")] private static var ImgBackground:Class;
		
		
		public  function MenuState(m : MovieClip=null) {
			super();
			
			if ( m != null) {
				try {
				FlxG.stage.removeChild(m); 
				} catch (error: Error) {
					//dunno!
				}
			}
		}
		
		override public function create():void
		{
			var background:FlxSprite=new FlxSprite(0,0,ImgBackground);
			add(background);
			
			
			
			FlxG.mouse.hide();
		}

		override public function update():void
		{
			super.update();

			if(FlxG.mouse.justPressed() || FlxG.keys.any()){
				FlxG.switchState(new PlayState(0));
			}
		}
	}
}
