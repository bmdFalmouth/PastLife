package  
{
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLLoader;
	/**
	 * ...
	 * @author Brian McDonald
	 */
	public class HerokuStatsTracker extends StatsTracker 
	{
		
		public function HerokuStatsTracker() 
		{
			
		}
		
		override public function submitStats():void 
		{
			//super.submitStats();
			if (_trackStats){
				var submitVars : String = serialize();
				var url : String = "http://falconhoof.heroku.com/api/v1/report";
			
				var submitData : URLVariables = new URLVariables();
			
				for ( var i : Number = 0; i < trackedItems.length; i++) {
					var object : Object = trackedItems[i];
					submitData[object.item] = object.value;
				}

/*
curl -d "username=davidfarrell&email=dfarrell@davidlearnsgames.com&score=10&explosions=4&death=5&trees=4" http://falconhoof.heroku.com/api/v1/report
			*/
				var request:URLRequest = new URLRequest(url);
				request.method = "POST";
				request.data = submitData;
				FlxG.log("sendToURL: " + request.url + "?" + request.data);
				try {
					var urlLoader : URLLoader = new URLLoader(request);
					//urlLoader.addEventListener("complete", receiveUserScore, false, 0, true);
				}
				catch (e:Error) {
					// handle error here
					FlxG.log ("error! id:[" + e.errorID + "] name["+e.name+"] message["+e.message+"] stack["+e.getStackTrace+"]");
				}
			}			
		}
		
	}

}