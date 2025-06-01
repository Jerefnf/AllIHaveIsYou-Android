package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxObject;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import options.OptionsState;
import states.editors.MasterEditorMenu;
import flixel.math.FlxMath;
import backend.Song;

enum MainMenuColumn {
    LEFT;
    CENTER;
    RIGHT;
}

class MainMenuState extends MusicBeatState
{
    public static var psychEngineVersion:String = '1.0.4';
    public static var curSelected:Int = 0;
    public static var curColumn:MainMenuColumn = CENTER;
    var allowMouse:Bool = true;
    var options:Array<FlxSprite>;
    var magenta:FlxSprite;
    var camFollow:FlxObject;
    var optionSquare:FlxSprite;
    var optionText:FlxText;
    static var showOutdatedWarning:Bool = true;
    var selectedSomethin:Bool = false;
    var timeNotMoving:Float = 0;
    var optionShit:Array<String> = [
        'story_mode',
        'credits'
    ];
    var leftOption:String = #if ACHIEVEMENTS_ALLOWED 'achievements' #else null #end;
    var rightOption:String = null;

    override function create()
    {
        super.create();

        #if MODS_ALLOWED
        Mods.pushGlobalMods();
        #end
        Mods.loadTopMod();
        #if DISCORD_ALLOWED
        DiscordClient.changePresence("In the Menus", null);
        #end

        persistentUpdate = persistentDraw = true;
        
        // Fondo principal: personaje con alas y aro, centrado y escalado
        var centerImage = new FlxSprite();
        centerImage.loadGraphic(Paths.image('xanthustitlescreen'));
        centerImage.setGraphicSize(Std.int(FlxG.width * 0.8), Std.int(FlxG.height * 0.8));
        centerImage.updateHitbox();
        centerImage.screenCenter();
        add(centerImage);

        // Menuitems por encima del fondo
        options = [];
        for (num => option in optionShit)
        {
            var item:FlxSprite = createMenuItem(option, 0, (num == 0) ? FlxG.height * 0.62 : FlxG.height * 0.75);
            item.screenCenter(X);
            options.push(item);
            add(item);
        }
        curSelected = 0;
        curColumn = CENTER;
        updateSelection();

        // Botón de opciones y su texto (encima de los menuitems)
        var squareSize = 180;
        optionSquare = new FlxSprite(FlxG.width - squareSize - 25, 25);
        optionSquare.makeGraphic(squareSize, squareSize, 0xA0FFFFFF);
        optionSquare.antialiasing = true;
        optionSquare.alpha = 0.93;
        add(optionSquare);

        optionText = new FlxText(optionSquare.x, optionSquare.y + squareSize/2 - 22, squareSize, "Options");
        optionText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.BLACK, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.WHITE);
        optionText.alignment = "center";
        add(optionText);

        #if ACHIEVEMENTS_ALLOWED
        var leDate = Date.now();
        if (leDate.getDay() == 5 && leDate.getHours() >= 18)
            Achievements.unlock('friday_night_play');
        #if MODS_ALLOWED
        Achievements.reloadList();
        #end
        #end
        #if CHECK_FOR_UPDATES
        if (showOutdatedWarning && ClientPrefs.data.checkForUpdates && substates.OutdatedSubState.updateVersion != psychEngineVersion) {
            persistentUpdate = false;
            showOutdatedWarning = false;
            openSubState(new substates.OutdatedSubState());
        }
        #end

        camFollow = new FlxObject(0, 0, 1, 1);
        add(camFollow);
        FlxG.camera.follow(camFollow, null, 0.15);

        magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
        magenta.antialiasing = ClientPrefs.data.antialiasing;
        magenta.scrollFactor.set(0, 0.25);
        magenta.setGraphicSize(Std.int(magenta.width * 1.175));
        magenta.updateHitbox();
        magenta.screenCenter();
        magenta.visible = false;
        magenta.color = 0xFFfd719b;
        add(magenta);

        var psychVer:FlxText = new FlxText(12, FlxG.height - 44, 0, "Porteado y Optimizado por Jere", 12);
        psychVer.scrollFactor.set();
        psychVer.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(psychVer);

        var fnfVer:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version') + " | Psych Engine v1.0.4", 12);
        fnfVer.scrollFactor.set();
        fnfVer.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(fnfVer);

        addTouchPad('NONE', 'E');
    }

    function createMenuItem(name:String, x:Float, y:Float):FlxSprite
    {
        var menuItem:FlxSprite = new FlxSprite(x, y);
        menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_$name');
        menuItem.animation.addByPrefix('idle', '$name idle', 24, true);
        menuItem.animation.addByPrefix('selected', '$name selected', 24, true);
        menuItem.animation.play('idle');
        menuItem.antialiasing = ClientPrefs.data.antialiasing;
        menuItem.scrollFactor.set();
        return menuItem;
    }

    function updateSelection()
    {
        for (i in 0...options.length)
        {
            if (i == curSelected) {
                options[i].animation.play('selected');
                options[i].alpha = 1;
            } else {
                options[i].animation.play('idle');
                options[i].alpha = 0.65;
            }
        }
    }

    override function update(elapsed:Float)
    {
        if (FlxG.sound.music.volume < 0.8)
            FlxG.sound.music.volume = Math.min(FlxG.sound.music.volume + 0.5 * elapsed, 0.8);

        if (!selectedSomethin)
        {
            if (controls.UI_UP_P)
            {
                curSelected = (curSelected - 1 + options.length) % options.length;
                updateSelection();
            }
            if (controls.UI_DOWN_P)
            {
                curSelected = (curSelected + 1) % options.length;
                updateSelection();
            }
            var allowMouseNow:Bool = allowMouse;
            if (allowMouseNow && ((FlxG.mouse.deltaScreenX != 0 && FlxG.mouse.deltaScreenY != 0) || FlxG.mouse.justPressed))
            {
                allowMouse = false;
                FlxG.mouse.visible = true;
                timeNotMoving = 0;
                for (i in 0...options.length)
                {
                    if (FlxG.mouse.overlaps(options[i]))
                    {
                        if (curSelected != i)
                        {
                            curSelected = i;
                            updateSelection();
                        }
                        if (FlxG.mouse.justPressed)
                        {
                            selectMenuOption(i);
                            return;
                        }
                    }
                }
            }
            else
            {
                timeNotMoving += elapsed;
                if(timeNotMoving > 2) FlxG.mouse.visible = false;
            }
            if (FlxG.mouse.overlaps(optionSquare) || FlxG.mouse.overlaps(optionText))
            {
                optionSquare.alpha = 1;
                if (FlxG.mouse.justPressed)
                {
                    FlxG.sound.play(Paths.sound('confirmMenu'));
                    selectedSomethin = true;
                    FlxG.mouse.visible = false;
                    MusicBeatState.switchState(new OptionsState());
                    return;
                }
            }
            else
                optionSquare.alpha = 0.93;
            if (controls.ACCEPT)
            {
                selectMenuOption(curSelected);
            }
            if (controls.BACK)
            {
                selectedSomethin = true;
                FlxG.mouse.visible = false;
                FlxG.sound.play(Paths.sound('cancelMenu'));
                MusicBeatState.switchState(new TitleState());
            }
            if (controls.justPressed('debug_1') || touchPad.buttonE.justPressed)
            {
                selectedSomethin = true;
                FlxG.mouse.visible = false;
                MusicBeatState.switchState(new MasterEditorMenu());
            }
        }
        super.update(elapsed);
    }

    function selectMenuOption(idx:Int)
    {
        selectedSomethin = true;
        FlxG.mouse.visible = false;
        var option = optionShit[idx];
        var item = options[idx];
        FlxG.sound.play(Paths.sound('confirmMenu'));
        if (ClientPrefs.data.flashing)
            FlxFlicker.flicker(magenta, 1.1, 0.15, false);
        FlxFlicker.flicker(item, 1, 0.06, false, false, function(flick:FlxFlicker)
        {
            switch (option)
            {
                case 'story_mode':
                    PlayState.SONG = Song.loadFromJson('allihaveisyou', 'allihaveisyou');
                    PlayState.isStoryMode = false;
                    PlayState.storyDifficulty = 2;
                    MusicBeatState.switchState(new PlayState());
                case 'credits':
                    MusicBeatState.switchState(new CreditsState());
                default:
                    selectedSomethin = false;
                    item.visible = true;
            }
        });
        for (memb in options)
        {
            if(memb == item)
                continue;
            FlxTween.tween(memb, {alpha: 0}, 0.4, {ease: FlxEase.quadOut});
        }
    }
}
