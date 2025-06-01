-- allihaveisyou.lua
-- odio bolivia

local videoName = "allihaveisyou2"
local windowTitleDefault = "All I Have Is You"
local windowTitleAlt = "All You Have Is Me"
local crtShaderName, glareShaderName = "noWayCrt", "glare"

local time, missVolume = 0, 1
local useShaders = false
local upload = nil

local camTarget = {x = nil, y = nil}
local singer, offset = 'boyfriend', 50

function onCreate()
    setProperty('skipCountdown', true)
    setProperty("dad.alpha", 0)
    makeLuaSprite('blackBox', nil, -500, -250)
    makeGraphic('blackBox', screenWidth, screenHeight, 'black')
    scaleObject("blackBox", 10, 10, true)
    addLuaSprite("blackBox", true)
    makeLuaSprite('whiteBox', nil, -500, -450)
    makeGraphic('whiteBox', screenWidth, screenHeight, '#8f8f8f')
    scaleObject("whiteBox", 10, 10, true)
    addLuaSprite("whiteBox", true)
    setProperty("whiteBox.alpha", 0)
    
    makeLuaSprite('shaderXF', nil, -500, -250)
    makeGraphic('shaderXF', screenWidth, screenHeight, 'black')
    setObjectCamera('shaderXF', 'other')
    setBlendMode('shaderXF', 'multiply')
    setProperty('shaderXF.alpha', 0.4)
    scaleObject("shaderXF", 10, 10, true)
    addLuaSprite("shaderXF", true)
end

-- creo que esto es redundante XDDD
local function safeGetUpload()
    if getfenv and getfenv().getUpload then
        local ok, val = pcall(getUpload)
        if ok then return val end
    end
    return false
end

function initShaders()
    useShaders = runHaxeCode("return ClientPrefs.data.shaders;")
    if not useShaders then return end
    runHaxeCode([[
        var crt = game.createRuntimeShader("]]..crtShaderName..[[");
        var glare = game.createRuntimeShader("]]..glareShaderName..[[");
        game.variables.set("crtShader", crt);
        game.variables.set("glareShader", glare);
        if (FlxG.game != null) FlxG.game.setFilters([new ShaderFilter(crt)]);
    ]])
    time = 0
end

local function setGameShaders(filtersString)
    runHaxeCode([[
        if (FlxG.game != null) FlxG.game.setFilters(]]..filtersString..[[);
    ]])
end

function createMainVideo()
    runHaxeCode([[
        import objects.VideoSprite;
        var vid = new VideoSprite(Paths.video("]]..videoName..[["), true, false, false, false);
        vid.cameras = [game.camGame];
        vid.scrollFactor.set(1, 1);
        vid.visible = true;
        vid.alpha = 1;
        vid.videoSprite.bitmap.onFormatSetup.add(function()
		{
			vid.videoSprite.setGraphicSize(2320);
			vid.videoSprite.updateHitbox();
			vid.videoSprite.screenCenter();
		});
        game.variables.set("videoCutscene", vid);
        game.add(vid);
    ]])
    setObjectOrder("videoCutscene", 1)
end

function onCreatePost()
    luaDebugMode = true 
    upload = safeGetUpload()
    setProperty('healthLoss', 0)
    setProperty('healthBar.visible', false)
    setProperty('iconP1.visible', false)
    setProperty('iconP2.visible', false)
    setProperty('scoreTxt.alpha', 0)
    setObjectOrder("whiteBox", 1)
    setProperty("dad.flipX", false)
    setProperty("dad.x", getProperty("boyfriend.x") + 180)
    setProperty("dad.y", getProperty("boyfriend.y") - 75)

    initShaders()
    createMainVideo()

    camTarget.x = getMidpointX("boyfriend") - 80 + getProperty("boyfriend.cameraPosition")[1] + getProperty("boyfriendCameraOffset")[1]
    camTarget.y = getMidpointY("boyfriend") - 20 + getProperty("boyfriend.cameraPosition")[2] + getProperty("boyfriendCameraOffset")[2]
    callMethod('camGame.snapToTarget', {'boyfriend'})

    if upload then
        setupUploadMode()
    else
        setupNormalMode()
    end
    
    runHaxeCode([[
    if (PlayState.instance != null) {
        PlayState.instance.showRating = true;
        PlayState.instance.showComboNum = true;
        PlayState.instance.showCombo = true;
    }
    ClientPrefs.data.hideHud = false;
    ClientPrefs.data.comboStacking = false;
    ]])
end

function setupNormalMode()
    for i = 0, 7 do
        setPropertyFromGroup("strumLineNotes", i, "x", 787 + (100 * (i % 4)))
        setPropertyFromGroup("strumLineNotes", i, "scale.x", 0.55)
        setPropertyFromGroup("strumLineNotes", i, "scale.y", 0.55)
        setPropertyFromGroup("strumLineNotes", i, "y", runHaxeCode("return ClientPrefs.data.downScroll;") and 590 or 19)
    end
    for i = 4, 7 do
        setPropertyFromGroup("strumLineNotes", i, "x", getPropertyFromGroup("strumLineNotes", i, "x") - 360)
    end
    for i = 0, 3 do setPropertyFromGroup("strumLineNotes", i, "alpha", 0) end
    setProperty("timeBar.visible", false)
    setProperty("timeTxt.visible", false)
end

function setupUploadMode()
    for i = 0, 7 do
        setObjectCamera("strumLineNotes.members["..i.."]", "game")
        callMethod("strumLineNotes.members["..i.."].scrollFactor.set", {0.8, 0.8})
        setPropertyFromGroup("strumLineNotes", i, "x", 72 + (300 * (i % 4)))
        setPropertyFromGroup("strumLineNotes", i, "y", getProperty("boyfriend.y") - 420)
    end
    runHaxeCode([[
        game.timeBar.visible = false;
        game.timeTxt.visible = false;
        game.noteGroup.remove(game.strumLineNotes);
        game.noteGroup.remove(game.notes);
        for (strum in game.strumLineNotes) {
            if (PlayState.instance != null && PlayState.instance.addBehindDad != null)
                PlayState.instance.addBehindDad(strum);
        }
    ]])
end

function onSongStart()
    runHaxeCode([[
        var v = game.variables.get('videoCutscene');
        if (v != null) {
            v.x += 200;
            v.y -= 500;
            v.play();
        }
        game.canPause = true;
    ]])
    doTweenAlpha("arrise", "blackBox", 0, 1, "squareIn")
end

function onEvent(n, v1, v2)
    if n ~= 'transition' then return end

    if v1 == 'nameChange' then
        runHaxeCode([[FlxG.stage.application.window.title = "]]..windowTitleAlt..[[";]])
    elseif v1 == 'darkness1' then
        setProperty("blackBox.alpha", 1)
        doTweenAlpha("waf", "blackBox", 0, 0.8, "quartIn")
    elseif v1 == "glare" then
        cameraFlash("hud", "white", 0.8, "quartOut")
        setProperty("dad.alpha", 0.5)
        if useShaders then
            setGameShaders("[new ShaderFilter(game.variables.get('crtShader')), new ShaderFilter(game.variables.get('glareShader'))]")
        end
    elseif v1 == 'darkness2' then
        setProperty("blackBox.alpha", 1)
        setProperty('camGame.zoom', 0.6)
        camTarget.x = camTarget.x - 20
        setProperty('camHUD.alpha', 0)
        setProperty('defaultCamZoom', 0.6)
    elseif v1 == 'hudBack' then
        doTweenAlpha("hudBack", "camHUD", 1, 0.8, "quartOut")
    elseif v1 == 'return' then
        triggerEvent("Change Character", "BF", "xanthKing")
        setProperty("boyfriend.y", getProperty("boyfriend.y") + 75)
        setProperty("blackBox.alpha", 0)
        setProperty("dad.alpha", 0)
        cameraFlash("game", "#f2fb3a", 0.8, nil)
        offset = 70
        if useShaders then
            setGameShaders("[new ShaderFilter(game.variables.get('crtShader'))]")
        end
    elseif v1 == 'byeXanthus' then
        doTweenAlpha('seeYa', 'boyfriend', 0, 0.3, 'quartInOut')
    elseif v1 == 'byeHud' then
        doTweenAlpha('seeYaHud', 'camHUD', 0, 1, 'quartInOut')
        for i = 0, 7 do noteTweenAlpha('seeYaNote'..i, i, 0, 1, 'quartInOut') end
    elseif v1 == "zoomBop" and getVar("missVolume") > 0.4 then
        setProperty('camGame.zoom', getProperty('defaultCamZoom') + 0.05)
        setProperty('camHUD.zoom', 1.08)
        doTweenZoom("zoomin", "camGame", getProperty('defaultCamZoom'), 0.5, "quartOut")
        doTweenZoom("zoomin2", "camHUD", 1, 0.5, "quartOut")
    end
end

function onTweenCompleted(tag)
    if tag == 'zoomin' then
        setProperty('camGame.zoom', getProperty('defaultCamZoom'))
    end
end

function camMove(x, y)
    triggerEvent('Camera Follow Pos', x, y)
end

function onUpdatePost(elapsed)
    setVar("missVolume", missVolume)
    if useShaders then
        time = time + elapsed
        runHaxeCode([[
            var crtShader = game.variables.get("crtShader");
            var glareShader = game.variables.get("glareShader");
            if (crtShader != null) crtShader.setFloat("iTime", ]]..time..[[);
            if (glareShader != null) glareShader.setFloat("iTime", ]]..time..[[);
        ]])
    end

    local anim = getProperty(singer..'.animation.curAnim.name')
    if anim == 'singLEFT' then
        camMove(camTarget.x - offset, camTarget.y)
    elseif anim == 'singRIGHT' then
        camMove(camTarget.x + offset, camTarget.y)
    elseif anim == 'singUP' then
        camMove(camTarget.x, camTarget.y - (offset - 5))
    elseif anim == 'singDOWN' then
        camMove(camTarget.x, camTarget.y + 30)
    elseif anim == 'idle' then
        camMove(camTarget.x, camTarget.y)
    end
end

function onSpawnNote(membersIndex, _, _, isSustainNote, _)
    if not isSustainNote and not upload then
        setPropertyFromGroup("notes", membersIndex, "scale.x", 0.55)
        setPropertyFromGroup("notes", membersIndex, "scale.y", 0.55)
    end
    if upload then
        setObjectCamera("notes.members["..membersIndex.."]", "game")
        callMethod("notes.members["..membersIndex.."].scrollFactor.set", {0.8, 0.8})
        runHaxeCode([[
            if (PlayState.instance != null && PlayState.instance.addBehindDad != null && game.notes.members.length > ]]..membersIndex..[[)
                PlayState.instance.addBehindDad(game.notes.members[]]..membersIndex..[[);
        ]])
    end
end

function goodNoteHit(membersIndex, noteData, _, isSustainNote)
    if upload then
        for i = 0, getProperty("grpNoteSplashes.length")-1 do
            setObjectCamera("grpNoteSplashes.members["..membersIndex.."]", "game")
        end
    end
    if not isSustainNote then
        missVolume = 1
        setPropertyFromClass("flixel.FlxG", "sound.music.volume", missVolume)
    end
    
    if not isSustainNote and noteData < 4 then
        handleCombosOffsets(noteData, {
		    perNoteOffsetX = { [0]=30, [1]=-70, [2]=-170, [3]=-270 },
		    digitsOffsetX = 270,
		    ratingOffsetX = 0,
		    showComboWord = true,
		})
    end
end

--- Como 3 putas horas desarrollando esta mierds y al fin funciona:'D
function handleCombosOffsets(noteData, opts)
    opts = type(opts) == "table" and opts or {}
    local sepX = opts.sepX or 0
    local sepY = opts.sepY or 0
    local chainSpacing = opts.chainSpacing or 2
    local maxNumbers = opts.maxNumbers or 3
    local showRating = opts.showRating ~= false
    local showComboWord = opts.showComboWord ~= false
    local ratingOffsetX = opts.ratingOffsetX or 0
    local ratingOffsetY = opts.ratingOffsetY or 0
    local comboWordOffsetX = opts.comboWordOffsetX or 0
    local comboWordOffsetY = opts.comboWordOffsetY or 0
    local digitsOffsetX = opts.digitsOffsetX or 0
    local digitsOffsetY = opts.digitsOffsetY or 0
    local digitsScale = opts.digitsScale or 1
    local ratingScale = opts.ratingScale or 1
    local comboWordScale = opts.comboWordScale or 1

    local perNoteOffsetX = opts.perNoteOffsetX or {}
    local perNoteOffsetY = opts.perNoteOffsetY or {}

    local extraOffsetX = perNoteOffsetX[noteData] or 0
    local extraOffsetY = perNoteOffsetY[noteData] or 0

    -- Inicializa el chain si no existe
    if getVar("combo10Chain") == nil then setVar('combo10Chain', 0) end

    runHaxeCode([[
        var strum = PlayState.instance.playerStrums.members[]]..noteData..[[];
        if (strum == null) return;

        var grp = PlayState.instance.comboGroup;
        if (grp == null || grp.length == 0) return;

        var digits = [];
        var foundRating = false;
        var startIndex = 0;

        if (grp.members[startIndex] != null && grp.members[startIndex].graphic != null
            && grp.members[startIndex].graphic.key.indexOf('num') == -1) {
            foundRating = true;
            startIndex++;
        }

        // Recoge los dígitos (en orden)
        for (i in startIndex...grp.length) {
            var spr = grp.members[i];
            if(spr != null && spr.graphic != null && spr.graphic.key != null && spr.graphic.key.indexOf('num') != -1)
                digits.push(spr);
        }

        var extraOffsetX = ]]..extraOffsetX..[[;
        var extraOffsetY = ]]..extraOffsetY..[[;

        // Posicionar los dígitos (en orden)
        for (i in 0...digits.length) {
            var spr = digits[i];
            spr.x = strum.x + strum.width + ]]..sepX..[[ + (i * (spr.width * ]]..digitsScale..[[ + ]]..chainSpacing..[[)) + ]]..digitsOffsetX..[[ + extraOffsetX;
            spr.y = strum.y + (strum.height - spr.height * ]]..digitsScale..[[) / 2 + ]]..sepY..[[ + ]]..digitsOffsetY..[[ + extraOffsetY;
            spr.setGraphicSize(Std.int(spr.width * ]]..digitsScale..[[), Std.int(spr.height * ]]..digitsScale..[[));
        }

        // Posicionar y escalar rating
        if (foundRating && ]]..tostring(showRating)..[[) {
            var ratingSpr = grp.members[0];
            if (ratingSpr != null) {
                ratingSpr.x = strum.x - ratingSpr.width * ]]..ratingScale..[[ - ]]..sepX..[[ + ]]..ratingOffsetX..[[ + extraOffsetX;
                ratingSpr.y = strum.y + (strum.height - ratingSpr.height * ]]..ratingScale..[[) / 2 + ]]..sepY..[[ + ]]..ratingOffsetY..[[ + extraOffsetY;
                ratingSpr.setGraphicSize(Std.int(ratingSpr.width * ]]..ratingScale..[[), Std.int(ratingSpr.height * ]]..ratingScale..[[));
                ratingSpr.visible = true;
            }
        } else if (foundRating) {
            var ratingSpr = grp.members[0];
            if (ratingSpr != null) ratingSpr.visible = false;
        }

        // Buscar comboSpr de manera robusta por su key
        var comboSpr:FlxSprite = null;
        for (i in 0...grp.length) {
            var spr = grp.members[i];
            if (spr != null && spr.graphic != null && spr.graphic.key != null && spr.graphic.key.indexOf('combo') != -1) {
                comboSpr = spr;
                break;
            }
        }

        var comboValue = combo;
        var showComboSpr = false;
        if (comboValue > 0 && comboValue % 10 == 0) showComboSpr = true;

        //--- Usar getVar/setVar para la chain de múltiples de 10
        var combo10Chain = getVar('combo10Chain');
        if (combo10Chain == null) combo10Chain = 0;

        if (showComboSpr) {
            combo10Chain++;
            setVar('combo10Chain', combo10Chain);
        } else if (comboValue == 0 || comboValue % 10 != 0) {
            combo10Chain = 0;
            setVar('combo10Chain', combo10Chain);
        }

        // SIEMPRE ocultar el comboSpr original (para evitar parpadeos y cortes)
        if (comboSpr != null) {
            comboSpr.visible = false;
            comboSpr.alpha = 0;

            // Sólo clonar cuando showComboSpr sea true
            if (showComboSpr) {
                var scaleBoost = 1 + 0.15 * (combo10Chain-1); // cada múltiplo de 10 aumenta la escala un 15%
                var tgtScale = ]]..comboWordScale..[[ * scaleBoost;
                var clone = new FlxSprite(comboSpr.x, comboSpr.y);
                clone.loadGraphic(comboSpr.graphic);
                clone.setGraphicSize(Std.int(comboSpr.width * tgtScale), Std.int(comboSpr.height * tgtScale));
                clone.updateHitbox();
                clone.scrollFactor.set();
                clone.cameras = comboSpr.cameras;
                clone.alpha = 0;
                clone.x = FlxG.width - clone.width - 70 + ]]..comboWordOffsetX..[[;
                clone.y = 40 + ]]..comboWordOffsetY..[[;

                PlayState.instance.add(clone);

                // Animación: crece y luego vuelve a la escala final
                clone.scale.set(2 * tgtScale, 2 * tgtScale);
                FlxTween.tween(clone.scale, {x: tgtScale, y: tgtScale}, 0.25, {ease: FlxEase.circOut});

                FlxTween.tween(clone, {alpha: 1}, 0.2, {
                    ease: FlxEase.quadOut,
                    onComplete: function(_){
                        FlxTween.tween(clone, {alpha: 0}, 0.65, {
                            ease: FlxEase.quadIn,
                            onComplete: function(_) clone.destroy()
                        });
                    }
                });
            }
        }
    ]])
end

function noteMiss(_, _, _, isSustainNote)
    if not isSustainNote then
        if missVolume > 0 then
            missVolume = missVolume - 0.03
            setPropertyFromClass("flixel.FlxG", "sound.music.volume", missVolume)
        end
        if missVolume <= 0 then
            runHaxeCode("var v = game.variables.get('videoCutscene'); if (v != null) v.pause();")
            openCustomSubstate("KILLME", true)
        end
    end
end

function onCustomSubstateCreatePost(name)
    if name == "KILLME" then
        makeLuaText("warningTxt", "Not Playing Along Mildred?", 1100, 0, 0)
        setTextFont("warningTxt", "Plaza Regular.ttf")
        setTextSize("warningTxt", 80)
        setTextBorder("warningTxt", 5, "black")
        setTextAlignment("warningTxt", "center")
        addLuaText("warningTxt")
        setProperty("warningTxt.antialiasing", true)
        screenCenter("warningTxt", "xy")
        setProperty("warningTxt.alpha", 0)
        runTimer("warning", 8)
    end
end

function onTimerCompleted(t)
    if t == "warning" then
        setProperty("warningTxt.alpha", 1)
        runTimer("warning2", 4)
    elseif t == "warning2" then
        setTextString("warningTxt", "Fine. But When You Come Back")
        screenCenter("warningTxt", "xy")
        runTimer("warning3", 4)
    elseif t == "warning3" then
        setTextString("warningTxt", "Don't Waste My Time Again. Got It?")
        screenCenter("warningTxt", "xy")
        runTimer("closeGame", 6)
    elseif t == "closeGame" then
        os.exit()
    end
end

function onPause()
    callMethod("videoCutscene.pause")

end



function onResume()
    callMethod("videoCutscene.resume")

end

function onDestroy()
    setPropertyFromClass('states.PlayState', 'SONG.song', songName)
    if useShaders then setGameShaders("[]") end
end