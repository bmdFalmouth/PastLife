//Code generated by Flan. http://www.tbam.com.ar/utility--flan.php

package  {
	import org.flixel.*;
	
	public class MapLevelTwo extends MapBase {
		//Media content declarations
		[Embed(source="../assets/MapCSV_LevelTwo_MainGame.txt", mimeType="application/octet-stream")] public var CSV_MainGame:Class;
		[Embed(source="../assets/game_tilesheetA32wide.png")] public var Img_MainGame:Class;
		
		
		public function MapLevelTwo() {
			treesAllowed = 0;
			platformsAllowed = 0;
			explosionsAllowed = 5;
			
			_setCustomValues();
			
			bgColor = 0xffffffff;
			
			layerMainGame = new FlxTilemap();
			layerMainGame.loadMap(new CSV_MainGame, Img_MainGame,32,32);
			layerMainGame.x = 0;
			layerMainGame.y = 0;
			layerMainGame.scrollFactor.x = 1.000000;
			layerMainGame.scrollFactor.y = 1.000000;

			allLayers = [ layerMainGame ];


			boundsMinX = 0;
			boundsMinY = 0;
			boundsMaxX = 1280;
			boundsMaxY = 704;
		}

		override public function addSpritesToLayerMainGame(onAddCallback:Function = null):void {
			var obj:FlxSprite;
			
			obj = new Exit(886, 318);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new DestroyTutorialTrigger(306, 303);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Player(197, 319);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
		}

		override public function customFunction(param:* = null):* {

		}

		private function _setCustomValues():void {
		}

	}
}
