package  
{
	
	import com.google.analytics.AnalyticsTracker; 
	import com.google.analytics.GATracker;

	/**
	 * ...
	 * @author Brian McDonald
	 */
	
	//http://philprogramming.blogspot.co.uk/2009/07/how-to-use-google-analytics-in-flash.html
	//http://forums.tigsource.com/index.php?topic=3934.0
	
	public class GAStatsTracker extends StatsTracker
	{
		public static var tracker:AnalyticsTracker;
		
		public function GAStatsTracker() 
		{
			//tracker = new GATracker( this, "UA-33397681-1", "AS3", true ); 
		}
		
		override public function submitStats():void 
		{
			for ( var i : Number = 0; i < trackedItems.length; i++) {
					var object : Object = trackedItems[i];
					//submitData[object.item] = object.value;
					tracker.trackPageview("/" + object.item + "?value=" + object.value);
			}			
		}
	}

}