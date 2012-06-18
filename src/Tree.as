package
{
	import org.flixel.*;
	
	public class Tree extends FlxSprite
	{
		[Embed(source="../assets/TreeBurstAnimScaled.png")] protected var ImgTree:Class;
		
		public var canopy:FlxSprite;
		
		public function Tree(X:Number=0, Y:Number=0)
		{
			super(X, Y);
			loadGraphic(ImgTree,true,true,128, 128);
			this.alpha = 0.4;
			
			//bounding box tweaks
			width = 64;
			height = 128;
			offset.x = 1;
			offset.y = 1;
			
			
			//immovable = true;
			
			acceleration.y = 200;
			
			
			
			//animations
			addAnimation("idle", [28]);
			addAnimation("grow", [0, 1, 2, 3,4,5,6,7,8,9,10,10,10,10,10,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29], 24, false);	
			
			
			//add collisionalble canopy, add to groups in playState
			canopy = new FlxSprite(X, Y-5);
			canopy.makeGraphic(64, 5);
			canopy.width = 64;
			canopy.height = 5;
			canopy.immovable = true;
			canopy.visible = false;
			
			(FlxG.state as PlayState).canopies.add(canopy);
			(FlxG.state as PlayState).add(canopy);
			allowCollisions = FlxObject.LEFT | FlxObject.RIGHT|FlxObject.DOWN;
			
		}
		
		public override function kill():void
		{
			//canopy.kill();
			super.kill();
		}
	}
}