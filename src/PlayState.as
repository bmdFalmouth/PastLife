package
{
	import flash.display.BlendMode;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	
	import org.flixel.*;
	//import org.osmf.layout.AbsoluteLayoutFacet;
	
	public class PlayState extends FlxState
	{
		
		
		// graphics
		[Embed(source="../assets/bg_gradientA.png")] private var BgGradientA:Class;
		[Embed(source="../assets/fg_InverseVignette.png")] private static var FgInverseVignetteClass:Class;

		[Embed(source="../assets/fg_SunlightGradient.png")] private static var FgSunlightGradientClass:Class;
		[Embed(source = "../assets/fg_letterbox.png")] private static var FgLetterboxClass:Class;
		
		[Embed(source = "../assets/Audio_Ambience.mp3")] private var ambientSound:Class;
		[Embed(source = "../assets/Audio_Pickup.mp3")] private var pickUpSound:Class;
		private var ambientPlayback:FlxSound;

		[Embed(source="../assets/fg_mistFX.png")] private static var FgMistClass:Class;
		
		//Power UI Assets
		[Embed(source="../assets/ui_explodeIcon.png")] private static var explodeIconClass:Class;
		[Embed(source="../assets/ui_platformIcon.png")] private static var platformIconClass:Class;
		[Embed(source="../assets/ui_treeIcon.png")] private static var treeIcon:Class;
		
		// graphics classes
		private var fgInverseVignette : FlxSprite;
		private var fgMist : FlxSprite;
		private var fgLetterbox : FlxSprite;
		private var gradientA : FlxSprite;
		
		// movieclip
		private var mcLoader:Loader = new Loader();
		private var movieEffects : MovieClip;
		
		// stats tracking
		public var statsTracker : StatsTracker;
		private var loadJSONData : JSONLoad;
		
		//Button for restart

		
		// Some static constants for the size of the tilemap tiles
		private const TILE_WIDTH:uint = 16;
		private const TILE_HEIGHT:uint = 16;
		
		// The FlxTilemap we're using
		private var collisionMap:FlxTilemap;
		
		//This is the current map
		private var map:MapBase;
		
		// We need to know which level it is for logic
		private var levelId : Number;
		
		// Box to show the user where they're placing stuff
		private var highlightBox:FlxObject;
		
		// Player modified from "Mode" demo
		private var player:Player;
		
		private var exit:Exit;
		private var exitTransition:Boolean;
		protected var trees:FlxGroup;
		public var canopies:FlxGroup;
		protected var explosions:FlxGroup;
		protected var pickups:FlxGroup;
		protected var pickupScoreDisplay:FlxGroup;
		protected var iconDisplay:FlxGroup;

		// Some interface buttons and text
		private var autoAltBtn:FlxButton;
		private var resetBtn:FlxButton;
		private var quitBtn:FlxButton;
		private var helperTxt:FlxText;
		private var lastSacrifice:Number=0;
		
		
		private var sacrificeText:FlxText;
		
		public var tutorialTriggers : Array;
		public var levels:Array;
		
		public var endLevel:Boolean=false;
		
		public function PlayState(level:Number)
		{
			levelId=level;
		}
		
		//Callback function to retrieve sprites from map
		protected function onMapAddCallback(spr:FlxSprite):void
		{
			if(spr is Player) {
				player = spr as Player;
			}
			else if (spr is Exit)
			{
				exit=spr as Exit;
			}
			else if(spr is TutorialTrigger)
			{
				tutorialTriggers.push(spr as TutorialTrigger);
				//create text element and add
				//it to the 
			}
			else if (spr is Tree)
			{
				trees.add(spr as Tree);
				(spr as Tree).play("idle");
			}
			else if (spr is Pickup)
			{
				pickups.add(spr as Pickup);
			}
		}
		
		public function OnStartLevel():void
		{

			if (player!=null){
				player.active=false;
			}
			if (collisionMap!=null){
				collisionMap.active=false;
			}
			if (exit!=null){
				exit.active=false;
			}
			

			for each(var t:TutorialTrigger in tutorialTriggers)
			{
				remove(t);
			}
			for each(var tree:Tree in trees)
			{
				tree.kill();
				remove(tree);
			}
			remove(collisionMap);
			remove(player);
			remove(exit);
			remove(trees);
			
			tutorialTriggers = new Array(); 
			trees = new FlxGroup();

			canopies = new FlxGroup();
			explosions = new FlxGroup();

			pickups=new FlxGroup();
			
			

			map=levels[levelId];
			map.decorateBackground(levelId);
			
			//for ( var i : Number = 0; i < map.backgroundSprites.length; i++) {
				//var bgSprite : FlxSprite = map.backgroundSprites[i];
				//add(bgSprite);
			//}
			map.addSpritesToLayerMainGame(onMapAddCallback);
			
			//stop trees by falling by initialising group before map creation
			
			add(map.layerMainGame);
			collisionMap=map.layerMainGame;		
			
			
			setupPlayer();	
			player.treesLeft = map.treesAllowed;
			player.platformsLeft = map.platformsAllowed;
			player.respawnsLeft = map.respawnsAllowed;
			player.explosionsLeft = map.explosionsAllowed;
			//endLevel=false;
			ambientPlayback.loadEmbedded(ambientSound, true);
			ambientPlayback.play();
			FlxG.flash(0xFFFFFF,1);

		}
		
		public function OnRestartButtonClick():void
		{
			
			FlxG.fade(0xFF000000,1,OnResetFadeDone,true);
		}
		
		public function OnResetFadeDone():void
		{
			FlxG.flash();
			FlxG.switchState(new PlayState(levelId));
		}
		
		public function OnEndLevel():void
		{
			//check to see if we have levels left
			//if not go to exit screen(currently start screen)
			//endLevel=true;
			ambientPlayback.stop();
			
			levelId++;
			statsTracker.submitStats();

			if (levelId>levels.length-1)
			{
				//fade for second before End screen
				FlxG.fade(0xFFFFFFFF,1,OnEndGame);
			}
			else
			{
				//set flag to prevent exit collision being detected multiple times when fading
				exitTransition = true;
				//fade for second before summary screen
				FlxG.fade(0xFFFFFFFF,1,switchToSummary);	
			}
		}

		public function switchToSummary():void
		{
			
			FlxG.switchState(new SummaryState(levelId, statsTracker));
		}
		
		public function OnEndLevelFade():void
		{
			FlxG.fade(0xFFFFFFFF,1,OnStartFadeDone,true);
		}
		
		
		public function OnStartFadeDone():void
		{
			OnStartLevel();
		}
		
		public function OnEndGame():void
		{
			FlxG.switchState(new EndGameState(statsTracker));
			//FlxG.switchState(new MenuState());	
		}
		
		override public function create():void
		{
			//Uncomment for visual debug
			//FlxG.visualDebug = true;
			levels=new Array();
			tutorialTriggers = new Array(); 
			trees = new FlxGroup();
			pickups=new FlxGroup();
			
			//We only need to hide/show these
			pickupScoreDisplay=new FlxGroup();
			
			ambientPlayback = new FlxSound();
			FlxG.framerate = 50;
			
			// add background gradient
			gradientA = new FlxSprite(0,0, BgGradientA);
			gradientA.solid = false;
			gradientA.moves = false;
		//	gradientA.alpha = 1;
		//	gradientA.blend = "multiply";
			add(gradientA);
			
		
			map = new MapLevelZero();
			levels.push(map);
			
			map = new MapLevelOne();
			levels.push(map);
			
			map = new MapLevelTwo();
			levels.push(map);
			
			map = new MapLevelSeven();
			levels.push(map);
			
			map = new MapLevelThree();
			levels.push(map);
			
			map = new MapLevelFour();
			levels.push(map);
			
			map = new MapLevelFive();
			levels.push(map);
			
			map = new MapLevelSix();
			levels.push(map);
			
		
			

			
			OnStartLevel();
			
			
			
			
			
			
			explosions = new FlxGroup();
			
			fgMist = new FlxSprite(0, 0, FgMistClass);
			fgMist.blend = "screen";
			 add(fgMist);
			fgMist.x = 100;
			fgMist.y = -150;
			fgMist.alpha = 0.5;
			fgMist.angularVelocity = 10;
			
			/* add foreground stuff */
			fgInverseVignette = new FlxSprite(0, 0, FgInverseVignetteClass);
			fgInverseVignette.blend = "screen";
			fgInverseVignette.alpha = 1.0;
			add(fgInverseVignette);
			fgInverseVignette.visible = true;
			
			
			// initialise stats
			statsTracker  = new GAStatsTracker();
			statsTracker.trackItem("explosions");
			statsTracker.trackItem("platforms");
			statsTracker.trackItem("spawn_points");
			statsTracker.trackItem("trees");
			statsTracker.trackItem("levelId");
			statsTracker.trackItem("pickups");
			statsTracker.setValue("levelId", levelId);

			
			startEffects();
			//create button
			resetBtn = new FlxButton(FlxG.width - 100, FlxG.height - 150, "Reset", OnRestartButtonClick);
			add(resetBtn);
			
			
			iconDisplay=new FlxGroup();
			var pUISprite:PowerUISprite=new PowerUISprite(32,FlxG.height- 260);
			pUISprite.loadGraphic(platformIconClass,true,false,128,128,false);
			pUISprite.play("Idle");
			iconDisplay.add(pUISprite);
			
			
			
			pUISprite=new PowerUISprite(32,FlxG.height- 260);
			pUISprite.loadGraphic(explodeIconClass,true,false,128,128,false);
			pUISprite.play("Idle");
			pUISprite.visible=false;
			iconDisplay.add(pUISprite);
			
			pUISprite=new PowerUISprite(32,FlxG.height- 260);
			pUISprite.loadGraphic(treeIcon,true,false,128,128,false);
			pUISprite.play("Idle");
			pUISprite.visible=false;
			iconDisplay.add(pUISprite);
		
			add(iconDisplay);
			
			FlxG.mouse.show();
			
			
		}
		
		// Jon's function!
		private function startEffects() : void {
			// FlxG.camera.color = 0xecfbff; // add a light red tint to the camera to differentiate it from the other
			/*
			var whitePixel:FlxSprite
			
			//Here we actually initialize out emitter
			//The parameters are        X   Y                Size (Maximum number of particles the emitter can store)
			var theEmitter : FlxEmitter = new FlxEmitter(FlxG.width / 2, -500);
			
			//Now by default the emitter is going to have some properties set on it and can be used immediately
			//but we're going to change a few things.
			
			//First this emitter is on the side of the screen, and we want to show off the movement of the particles
			//so lets make them launch to the right.
			theEmitter.setXSpeed(-100, 100);
			
			//and lets funnel it a tad
			theEmitter.setYSpeed( -400, 400);
			
			//Let's also make our pixels rebound off surfaces
			//TODO: Need to check bounce, does it still work
			//theEmitter.bounce = .8;
			
			//Now let's add the emitter to the state.
			add(theEmitter);
			
			//Now it's almost ready to use, but first we need to give it some pixels to spit out!
			//Lets fill the emitter with some white pixels
			//Size has been replaced, we now use the end condition in a loop to dertmine how many particles to spit out.
			for (var i:int = 0; i < 25; i++) {
				whitePixel = new FlxSprite();
				whitePixel.makeGraphic(3, 3, 0xFFd9e2e5);
				whitePixel.visible = false; //Make sure the particle doesn't show up at (0, 0)
				theEmitter.add(whitePixel);
				whitePixel = new FlxSprite();
				whitePixel.makeGraphic(2, 2, 0xFFFFFFFF);
				whitePixel.visible = false;
				theEmitter.add(whitePixel);
			}
			
			//Now lets set our emitter free.
			//Params:        Explode, Particle Lifespan, Emit rate(in seconds)
			theEmitter.start(false, 5, .01);*/

			fgLetterbox = new FlxSprite(0, 0, FgLetterboxClass);
			add(fgLetterbox);
			
			sacrificeText = new FlxText(170,FlxG.height- 204,800,"0");
			sacrificeText.size = 16;
			sacrificeText.alignment = "left";
			sacrificeText.color=0xFF000000;
			add(sacrificeText);
			
		}
		
		public function switchPowerUI(current:Number):void
		{
			var uiElement:PowerUISprite=iconDisplay.members[lastSacrifice];
			uiElement.visible=false;
			lastSacrifice=current;
			uiElement=iconDisplay.members[current];
			uiElement.Play();
		}
		
		override public function update():void
		{
			FlxG.collide(player, collisionMap);
			FlxG.overlap(player, trees, climbTree);
			FlxG.collide(trees, collisionMap);
			FlxG.overlap(player, pickups, HandlePickUps);
			FlxG.collide(player, canopies);
			
			for each(var t:TutorialTrigger in tutorialTriggers)
			{
				if (player.overlaps(t))
				{
					t.ShowMessage();					
				}
				else
				{
					t.HideMessage();
				}
			}
				
			if(player.overlaps(exit) && !exitTransition)
			{
				
				OnEndLevel();
			}
			
			super.update();
		}
		
		public function HandlePickUps(p:Player, pUp:Pickup):void
		{
			FlxG.play(pickUpSound);
			pUp.kill();
			statsTracker.increment("pickups");
		}
		
		public function climbTree(p:Player, treeToClimb:Tree):void
		{
			
			player.play("climbTree");
			if (player.y > treeToClimb.y -5)
			{
				player.climbTree(treeToClimb);
			}
		}

		public function plantTreeFirmly(tree:Tree, m:FlxTilemap):void
		{
			tree.active = false;
			tree.acceleration.y = 0;
		}
		
		public function killTrees(X:Number, Y:Number):void
		{
			var exp:Explosion;
			
			exp = new Explosion(X-75,Y-75);
			explosions.add(exp);
			FlxG.overlap(explosions, trees, killThisTree);
		}

		
		public function killThisTree(Exp:Explosion, dieTree:Tree):void
		{
			dieTree.kill();
		}
		
		override public function draw():void 
		{
			var sacrificeLeft : String = "";
			
			if ( player.getSacrifice() == "Trees") {
				sacrificeLeft = ""+player.treesLeft;
			} else if ( player.getSacrifice() == "Explosions") {
				sacrificeLeft = ""+player.explosionsLeft;
			} if ( player.getSacrifice() == "Platforms") {
				sacrificeLeft = ""+player.platformsLeft;
			} 
			
			sacrificeText.text = "x " + sacrificeLeft;
						
			super.draw();
		}
		
		private function setupPlayer():void
		{
			player.setTileMap(collisionMap);
			player.kill();
			
		}
		
		public function addTree(tree:Tree):void
		{
			trees.add(tree);
		}
		
		private function wrap(obj:FlxObject):void
		{
			obj.x = (obj.x + obj.width / 2 + FlxG.width) % FlxG.width - obj.width / 2;
			obj.y = (obj.y + obj.height / 2) % FlxG.height - obj.height / 2;
		}
	}
}

