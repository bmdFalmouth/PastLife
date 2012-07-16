package 
{
	import com.adobe.serialization.json.JSON;
	
	import flash.display.Sprite;

	
	import org.flixel.*;
	

	
	public class StatsTracker extends Sprite
	{
		protected var trackedItems : Array;
		//Added property to enable/disable tracking of stats - BMD 16/6/12
		protected var _trackStats:Boolean = false;
		
		
		public function get trackStats():Boolean
		{
			return trackStats;
		}
		
		public function set trackStats(value:Boolean):void {
				_trackStats = value;
		}
		
		public function StatsTracker()
		{
			trackedItems = new Array();
			/*trackItem("username", "string");
			setString("username", "davidfarrell");
			trackItem("email", "string");
			setString("email", "dfarrell@davidlearnsgames.com");
		*/	
		}
		
		public function trackItem( item : String, type : String = "number") : void {
			var object : Object = new Object();
			if ( type == "number" ) {
				object.item = item;
				object.value = 0;
				trackedItems.push(object);
			} else if ( type == "string" ) {
				object.item = item;
				object.value = "";
				trackedItems.push(object); 
			}
		}
		
		public function increment(item : String, quantity : Number = 1) : void {
			for ( var i : Number = 0; i < trackedItems.length; i++ ) {
				var trackedItem : Object = trackedItems[i];
				var itemString : String = trackedItem.item as String;
				if (trackedItem.item == item ) {
					trackedItems[i].value += quantity;
				}
			}
		}
		
		public function decrement(item : String, quantity : Number = 1) : void {
			for ( var i : Number = 0; i < trackedItems.length; i++ ) {
				var trackedItem : Object = trackedItems[i];
				if ( trackedItem.item == item ) {
					trackedItems[i].value -= quantity;
				}
			}
		}
		
		public function setString(item : String, value : String) : void {
			 for ( var i : Number = 0; i < trackedItems.length; i++ ) {
				var trackedItem : Object = trackedItems[i];
				if ( trackedItem.item == item ) {
					trackedItems[i].value = value;
				}
			}
		}
		
		public function setValue(item : String, value : Number) : void {
			for ( var i : Number = 0; i < trackedItems.length; i++ ) {
				var trackedItem : Object = trackedItems[i];
				if ( trackedItem.item == item ) {
					trackedItems[i].value = value;
				}
			}
		}
		
		public function getValue(item : String) : Number {
				for ( var i : Number = 0; i < trackedItems.length; i++ ) {
				var trackedItem : Object = trackedItems[i];
				if ( trackedItem.item == item ) {
					return trackedItems[i].value;
				}
			}
			return 0;
		}
		
		public function getString(item : String) : String {
				for ( var i : Number = 0; i < trackedItems.length; i++ ) {
				var trackedItem : Object = trackedItems[i];
				if ( trackedItem.item == item ) {
					return trackedItems[i].value;
				}
			}
			return null;
		}
		
		public function serialize() : String {
			
			for ( var i : Number = 0; i < trackedItems.length; i++) {
				var trackedItem : Object = trackedItems[i];
			//	trace ("Name of tracked variable" + trackedItem["item"] + " and value " + trackedItem["value"]);
			}
			
			//trace ( JSON.encode(trackedItems)); 
			
			return com.adobe.serialization.json.JSON.encode(trackedItems);
		}
		
		public function report() : void {
			FlxG.log("Stats Output:");
			for ( var i : Number = 0; i < trackedItems.length; i++) {
				var item : Object = trackedItems[i];
				FlxG.log("     ["+item.item+"]["+item.value+"]");
				
			}
		}
		
		public function submitStats() : void {

			
			
		}
	}
}