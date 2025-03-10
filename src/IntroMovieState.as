package
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.flixel.*;
	public class IntroMovieState extends FlxState
	{
		//----------------------------------------------------------------------
		[Embed(source = '../assets/frontend_titlesplash.swf')] private var SwfClass:Class;
		//----------------------------------------------------------------------
		protected var m_swf   	: MovieClip = null;
		private var timer		: Number	= 0;
		private var exit : Boolean = false;
		//----------------------------------------------------------------------
		public function IntroMovieState() : void
		{
			super();
			
			
			var timer:Timer = new Timer(13000, 2);
			
			timer.addEventListener(TimerEvent.TIMER, nextScene);
			
			timer.start();
		}
		
		override public function create():void 
		{
			super.create();
			m_swf = new SwfClass();
			m_swf.x = 0;
			m_swf.y = 0;
			
			m_swf.addEventListener(MouseEvent.MOUSE_DOWN, nextScene);
			
			
			FlxG.stage.addChild(m_swf);			
		}
		
		public function nextScene( e : Event) : void {
			if (!exit) {
				exit = true;
				//BUG - This leaves the camera very zoomed in
				FlxG.switchState(new MenuState(m_swf));
			}
		}
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
	}
}