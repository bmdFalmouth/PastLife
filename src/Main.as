package
{
	import org.flixel.*;

	
	[SWF(width="1280", height="720", backgroundColor="#ffffff")]
	[Frame(factoryClass="Preloader")]

	public class Main extends FlxGame
	{
		public function Main()
		{
			
			//Uncomment for Intro
			super(1280, 720, IntroMovieState);
			//Get into menu state
			//super(1280, 720, MenuState, 1);
		}
	}
}
