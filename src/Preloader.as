package
{
	import org.flixel.system.FlxPreloader
	import com.google.analytics.AnalyticsTracker; 
	import com.google.analytics.GATracker;
	
	public class Preloader extends FlxPreloader
	{
		public function Preloader()
		{
			GAStatsTracker.tracker = new GATracker( this, "UA-33397681-1", "AS3", true ); 
			className = "Main";
			super();
		}
	}
}
