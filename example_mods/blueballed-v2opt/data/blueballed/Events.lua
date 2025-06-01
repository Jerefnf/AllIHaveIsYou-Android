local BAR_WIDTH = 1500
local BAR_HEIGHT = 350
local BAR_OFFSET_Y = 90
local SCALE_APPLE_JUICE = 1.3
local SCALE_TITLE1 = 1.6
local SCALE_TITLE2 = 1.2
local SCALE_OH_YEAH_HA_HAHA = 1.1
local SCALE_YEAH_ANIM = 2.2
local SCALE_STATIC = 8
local SCALE_GLITCH = 10
local SCALE_DEAD = 2.0
local SCALE_BF_TRANSFORM = 1.5
local SCALE_BOYFRIEND_DEAD = 2.10

local spritesLoaded = {}

function doesSpriteExist(spriteName)
    return spritesLoaded[spriteName] == true
end

function createBasicSprite(name, imagePath, x, y, scaleX, scaleY, camera, addSprite, order, isHeavy)
    local finalImagePath = imagePath
    local finalScaleX = scaleX
    local finalScaleY = scaleY

    if isHeavy and lowQuality then
        finalImagePath = imagePath .. '_low'
        finalScaleX = scaleX * 2
        finalScaleY = scaleY * 2
    end

    makeLuaSprite(name, finalImagePath, x, y)
    if finalScaleX and finalScaleY then
        scaleObject(name, finalScaleX, finalScaleY)
    end
    if camera then
        setObjectCamera(name, camera)
    end
    if addSprite then
        addLuaSprite(name, true)
    end
    if order then
        setObjectOrder(name, order)
    end
    spritesLoaded[name] = true
end

function createAnimatedSprite(name, imagePath, x, y, scaleX, scaleY, animationPrefix, animationName, frameRate, loop, camera, addSprite, order, isHeavy)
    local finalImagePath = imagePath
    local finalScaleX = scaleX
    local finalScaleY = scaleY

    if isHeavy and lowQuality then
        finalImagePath = imagePath .. '_low'
        finalScaleX = scaleX * 2
        finalScaleY = scaleY * 2
    end

    makeAnimatedLuaSprite(name, finalImagePath, x, y)
    if finalScaleX and finalScaleY then
        scaleObject(name, finalScaleX, finalScaleY)
    end
    addAnimationByPrefix(name, animationPrefix, animationName, frameRate, loop)
    if camera then
        setObjectCamera(name, camera)
    end
    if addSprite then
        addLuaSprite(name, true)
    end
    if order then
        setObjectOrder(name, order)
    end
    spritesLoaded[name] = true
end

function onCreate()
    --luaDebugMode = true
    spritesLoaded = {}

    makeLuaSprite('UpperBar(With HUD)', '', -110, -260)
    makeGraphic('UpperBar(With HUD)', BAR_WIDTH, BAR_HEIGHT, '000000')
    setObjectCamera('UpperBar(With HUD)', 'camOther')
    addLuaSprite('UpperBar(With HUD)', false)
    spritesLoaded['UpperBar(With HUD)'] = true

    makeLuaSprite('LowerBar(With HUD)', '', -110, 630)
    makeGraphic('LowerBar(With HUD)', BAR_WIDTH, BAR_HEIGHT, '000000')
    setObjectCamera('LowerBar(With HUD)', 'camOther')
    addLuaSprite('LowerBar(With HUD)', false)
    spritesLoaded['LowerBar(With HUD)'] = true

    UpperBar = getProperty('UpperBar(With HUD).y')
    LowerBar = getProperty('LowerBar(With HUD).y')

    createBasicSprite('flashblack', '', 0, 0)
    makeGraphic('flashblack', 1280, 720, '000000')
    setScrollFactor('flashblack', 0, 0)
    setObjectCamera('flashblack', 'camGame')
    setProperty('flashblack.scale.x', 2)
    setProperty('flashblack.scale.y', 2)
    setProperty('flashblack.alpha', 1)
    spritesLoaded['flashblack'] = true

    createBasicSprite('AppleJuice', 'ex/AppleJuice', 0, 0, SCALE_APPLE_JUICE, SCALE_APPLE_JUICE, 'camOther', false)
    screenCenter('AppleJuice')
    setProperty('AppleJuice.alpha', 0)

    createAnimatedSprite('title1', 'ex/title1', 0, 0, SCALE_TITLE1, SCALE_TITLE1, 'ggds', 'play', 24, false, 'camOther', true)
    screenCenter('title1')
    if not lowQuality then
        setSpriteShader('title1', 'glitch')
    end

    createBasicSprite('title1Alt', 'ex/title1Alt', 0, 0, SCALE_TITLE1, SCALE_TITLE1, 'camOther', true)
    screenCenter('title1Alt')
    setProperty('title1Alt.alpha', 0)

    createAnimatedSprite('title2', 'ex/title2', 340, 130, SCALE_TITLE2, SCALE_TITLE2, 'ggdsw', 'play', 24, false, 'camOther', true)
    setProperty('camHUD.alpha', 0)
    setProperty('title1.alpha', 0)
    setProperty('title2.alpha', 0)

    createBasicSprite('OH', 'ex/OH', 0, 0, SCALE_OH_YEAH_HA_HAHA, SCALE_OH_YEAH_HA_HAHA, 'camOther', true)
    screenCenter('OH')
    setProperty('OH.alpha', 0)

    createBasicSprite('YEAH', 'ex/YEAH', 0, 0, SCALE_OH_YEAH_HA_HAHA, SCALE_OH_YEAH_HA_HAHA, 'camOther', true)
    screenCenter('YEAH')
    setProperty('YEAH.alpha', 0)

    createAnimatedSprite('yeahanim', 'ex/yeahanim', 0, 0, SCALE_YEAH_ANIM, SCALE_YEAH_ANIM, 'hehe', 'play', 200, true, 'camOther', true)
    screenCenter('yeahanim')
    setProperty('yeahanim.alpha', 0)

    createAnimatedSprite('Static', 'ex/Static', 0, 0, SCALE_STATIC, SCALE_STATIC, 'eferf', 'Static Madness', 24, true, 'camOther', true)
    screenCenter('Static')
    setProperty('Static.alpha', 0)

    createBasicSprite('HA', 'ex/HA', 0, 0, SCALE_OH_YEAH_HA_HAHA, SCALE_OH_YEAH_HA_HAHA, 'camOther', true)
    screenCenter('HA')
    setProperty('HA.alpha', 0)

    createBasicSprite('HAHA', 'ex/HAHA', 0, 0, SCALE_OH_YEAH_HA_HAHA, SCALE_OH_YEAH_HA_HAHA, 'camOther', true)
    screenCenter('HAHA')
    setProperty('HAHA.alpha', 0)

    createAnimatedSprite('glitch', 'ex/glitch', 340, 470, SCALE_GLITCH, SCALE_GLITCH, 'um', 'play', 90, true, nil, false, 1)

    local deadXPositions = {1000, 1350, 1700, 650, 300, -50, -400, 2050, 2400}
    for i, xPos in ipairs(deadXPositions) do
        local spriteName = 'dead' .. i
        createBasicSprite(spriteName, 'ex/dead', xPos, 400, SCALE_DEAD, SCALE_DEAD, nil, false, 2)
        setScrollFactor(spriteName, 1.25, 1.25)
    end

    createBasicSprite('deadclose', 'ex/deadclose', 1000, 400, SCALE_DEAD, SCALE_DEAD, nil, true)
    setScrollFactor('deadclose', 1.1, 1.1)
    setProperty('deadclose.alpha', 0)

    createBasicSprite('deadclose2', 'ex/deadclose2', 470, 400, SCALE_DEAD, SCALE_DEAD, nil, true)
    setScrollFactor('deadclose2', 1.1, 1.1)
    setProperty('deadclose2.alpha', 0)

    local veryDeadXPositions = {-1600, -300, 1000, 2300}
    for i, xPos in ipairs(veryDeadXPositions) do
        local spriteName = 'verydead' .. i
        createBasicSprite(spriteName, 'ex/verydead', xPos, 900, SCALE_DEAD, SCALE_DEAD, nil, true)
        setScrollFactor(spriteName, 1.1, 1.1)
        setProperty(spriteName .. '.alpha', 0)
    end

    createAnimatedSprite('bf_transform', 'ex/bf_transform', 1765, 726, SCALE_BF_TRANSFORM, SCALE_BF_TRANSFORM, 'playanim', 'bf transition', 24, false, nil, false, 22, true)
    setProperty('bf_transform.alpha', 0)

    makeAnimatedLuaSprite('BOYFRIEND_DEAD', 'characters/BOYFRIEND_DEAD', 1500, 770)
    scaleObject('BOYFRIEND_DEAD', SCALE_BOYFRIEND_DEAD, SCALE_BOYFRIEND_DEAD)
    addAnimationByPrefix('BOYFRIEND_DEAD', 'Die', 'BF dies', 24, false)
    addAnimationByPrefix('BOYFRIEND_DEAD', 'Loop', 'BF Dead Loop', 24, true)
    addLuaSprite('BOYFRIEND_DEAD', true)
    setObjectOrder('BOYFRIEND_DEAD', 12)
    setProperty('BOYFRIEND_DEAD.alpha', 0)
    setScrollFactor('BOYFRIEND_DEAD', 1.2, 1.2)
    spritesLoaded['BOYFRIEND_DEAD'] = true

    setProperty('defaultCamZoom', 2.0)
    setProperty('isCameraOnForcedPos', true)
    doTweenX('tween', 'camFollow', 1900, 0.2, 'expoOut')
    doTweenY('tweenY', 'camFollow', 570, 0.2, 'expoOut')

    addLuaSprite('AppleJuice', true)
    addLuaSprite('flashblack', true)

    setProperty('timeBarBG.visible', false)
    setProperty('timeBar.visible', false)
    setProperty('timeTxt.visible', false)
    setProperty('camZoomOnBeat', false)
end

local tweenSpeed = 0.1

function onCreatePost()
    setPropertyFromClass('ClientPrefs', 'comboOffset[0]', 100)
    setPropertyFromClass('ClientPrefs', 'comboOffset[3]', 300)
    setPropertyFromClass('ClientPrefs', 'comboOffset[2]', 200)
    setProperty('camHUD.alpha', 0)
    setProperty('introSoundsSuffix', '-void')
    setProperty("cameraSpeed", 3)
    setSpriteShader('iconP2', 'glitch')
end

function onSongStart()
    doTweenAlpha('yikes2', 'AppleJuice', 1, 1)
    doTweenAlpha('yikes', 'flashblack', 0, 2)
end

function onUpdate(elapsed)
    setProperty('camZooming', true)
end

function onTweenCompleted(tag)
    if tag == '2move4' then 
        setProperty('verydead4.x', -1600)  
        Tballs1 = getProperty('verydead1.x')
        Tballs2 = getProperty('verydead2.x')
        Tballs3 = getProperty('verydead3.x')
        Tballs4 = getProperty('verydead4.x')
  
  doTweenX('2move1start', 'verydead1', Tballs1 + 1300, tweenSpeed)
  doTweenX('2move2start', 'verydead2', Tballs2 + 1300, tweenSpeed)
  doTweenX('2move3', 'verydead3', Tballs3 + 1300, tweenSpeed)
  doTweenX('2move4done', 'verydead4', Tballs4 + 1300, tweenSpeed)
    end
    if tag == '2move3' then 
        setProperty('verydead3.x', -1600)  
        Tballs1 = getProperty('verydead1.x')
        Tballs2 = getProperty('verydead2.x')
        Tballs3 = getProperty('verydead3.x')
        Tballs4 = getProperty('verydead4.x')
  
  doTweenX('2move1start', 'verydead1', Tballs1 + 1300, tweenSpeed)
  doTweenX('2move2', 'verydead2', Tballs2 + 1300, tweenSpeed)
  doTweenX('2move3done', 'verydead3', Tballs3 + 1300, tweenSpeed)
  doTweenX('2move4done', 'verydead4', Tballs4 + 1300, tweenSpeed)
    end
    if tag == '2move2' then 
        setProperty('verydead2.x', -1600)  
        Tballs1 = getProperty('verydead1.x')
        Tballs2 = getProperty('verydead2.x')
        Tballs3 = getProperty('verydead3.x')
        Tballs4 = getProperty('verydead4.x')
  
  doTweenX('2move1', 'verydead1', Tballs1 + 1300, tweenSpeed)
  doTweenX('2move2done', 'verydead2', Tballs2 + 1300, tweenSpeed)
  doTweenX('2move3done', 'verydead3', Tballs3 + 1300, tweenSpeed)
  doTweenX('2move4done', 'verydead4', Tballs4 + 1300, tweenSpeed)
    end
    if tag == '2move1' then 
        setProperty('verydead1.x', -1600)  
        Tballs1 = getProperty('verydead1.x')
  Tballs2 = getProperty('verydead2.x')
  Tballs3 = getProperty('verydead3.x')
  Tballs4 = getProperty('verydead4.x')
  
  doTweenX('2move1done', 'verydead1', Tballs1 + 1300, tweenSpeed)
  doTweenX('2move2done', 'verydead2', Tballs2 + 1300, tweenSpeed)
  doTweenX('2move3done', 'verydead3', Tballs3 + 1300, tweenSpeed)
  doTweenX('2move4', 'verydead4', Tballs4 + 1300, tweenSpeed)
    end
    if tag == 'move7' then 
        setProperty('dead7.x', 2400)
        local balls1 = getProperty('dead1.x')
        local balls2 = getProperty('dead2.x')
        local balls3 = getProperty('dead3.x')
        local balls4 = getProperty('dead4.x')
        local balls5 = getProperty('dead5.x')
        local balls6 = getProperty('dead6.x')
        local balls7 = getProperty('dead7.x')
        local balls8 = getProperty('dead8.x')
        local balls9 = getProperty('dead9.x')
        doTweenX('move1start', 'dead1', balls1 - 350, tweenSpeed)
        doTweenX('move2start', 'dead2', balls2 - 350, tweenSpeed)
        doTweenX('move3start', 'dead3', balls3 - 350, tweenSpeed)
        doTweenX('move4start', 'dead4', balls4 - 350, tweenSpeed)
        doTweenX('move5start', 'dead5', balls5 - 350, tweenSpeed)
        doTweenX('move6', 'dead6', balls6 - 350, tweenSpeed)
        doTweenX('move7done', 'dead7', balls7 - 350, tweenSpeed)
        doTweenX('move8start', 'dead8', balls8 - 350, tweenSpeed)
        doTweenX('move9start', 'dead9', balls9 - 350, tweenSpeed)
    end
    if tag == 'move6' then 
        setProperty('dead6.x', 2400)
        local balls1 = getProperty('dead1.x')
        local balls2 = getProperty('dead2.x')
        local balls3 = getProperty('dead3.x')
        local balls4 = getProperty('dead4.x')
        local balls5 = getProperty('dead5.x')
        local balls6 = getProperty('dead6.x')
        local balls7 = getProperty('dead7.x')
        local balls8 = getProperty('dead8.x')
        local balls9 = getProperty('dead9.x')
        doTweenX('move1start', 'dead1', balls1 - 350, tweenSpeed)
        doTweenX('move2start', 'dead2', balls2 - 350, tweenSpeed)
        doTweenX('move3start', 'dead3', balls3 - 350, tweenSpeed)
        doTweenX('move4start', 'dead4', balls4 - 350, tweenSpeed)
        doTweenX('move5', 'dead5', balls5 - 350, tweenSpeed)
        doTweenX('move6done', 'dead6', balls6 - 350, tweenSpeed)
        doTweenX('move7done', 'dead7', balls7 - 350, tweenSpeed)
        doTweenX('move8start', 'dead8', balls8 - 350, tweenSpeed)
        doTweenX('move9start', 'dead9', balls9 - 350, tweenSpeed)
    end
    if tag == 'move5' then 
        setProperty('dead5.x', 2400)
        local balls1 = getProperty('dead1.x')
        local balls2 = getProperty('dead2.x')
        local balls3 = getProperty('dead3.x')
        local balls4 = getProperty('dead4.x')
        local balls5 = getProperty('dead5.x')
        local balls6 = getProperty('dead6.x')
        local balls7 = getProperty('dead7.x')
        local balls8 = getProperty('dead8.x')
        local balls9 = getProperty('dead9.x')
        doTweenX('move1start', 'dead1', balls1 - 350, tweenSpeed)
        doTweenX('move2start', 'dead2', balls2 - 350, tweenSpeed)
        doTweenX('move3start', 'dead3', balls3 - 350, tweenSpeed)
        doTweenX('move4', 'dead4', balls4 - 350, tweenSpeed)
        doTweenX('move5done', 'dead5', balls5 - 350, tweenSpeed)
        doTweenX('move6done', 'dead6', balls6 - 350, tweenSpeed)
        doTweenX('move7done', 'dead7', balls7 - 350, tweenSpeed)
        doTweenX('move8start', 'dead8', balls8 - 350, tweenSpeed)
        doTweenX('move9start', 'dead9', balls9 - 350, tweenSpeed)
    end
    if tag == 'move4' then 
        setProperty('dead4.x', 2400)
        local balls1 = getProperty('dead1.x')
        local balls2 = getProperty('dead2.x')
        local balls3 = getProperty('dead3.x')
        local balls4 = getProperty('dead4.x')
        local balls5 = getProperty('dead5.x')
        local balls6 = getProperty('dead6.x')
        local balls7 = getProperty('dead7.x')
        local balls8 = getProperty('dead8.x')
        local balls9 = getProperty('dead9.x')
        doTweenX('move1', 'dead1', balls1 - 350, tweenSpeed)
        doTweenX('move2start', 'dead2', balls2 - 350, tweenSpeed)
        doTweenX('move3start', 'dead3', balls3 - 350, tweenSpeed)
        doTweenX('move4done', 'dead4', balls4 - 350, tweenSpeed)
        doTweenX('move5done', 'dead5', balls5 - 350, tweenSpeed)
        doTweenX('move6done', 'dead6', balls6 - 350, tweenSpeed)
        doTweenX('move7done', 'dead7', balls7 - 350, tweenSpeed)
        doTweenX('move8start', 'dead8', balls8 - 350, tweenSpeed)
        doTweenX('move9start', 'dead9', balls9 - 350, tweenSpeed)
    end
    if tag == 'move1' then 
        setProperty('dead1.x', 2400)
        local balls1 = getProperty('dead1.x')
        local balls2 = getProperty('dead2.x')
        local balls3 = getProperty('dead3.x')
        local balls4 = getProperty('dead4.x')
        local balls5 = getProperty('dead5.x')
        local balls6 = getProperty('dead6.x')
        local balls7 = getProperty('dead7.x')
        local balls8 = getProperty('dead8.x')
        local balls9 = getProperty('dead9.x')
        doTweenX('move1done', 'dead1', balls1 - 350, tweenSpeed)
        doTweenX('move2', 'dead2', balls2 - 350, tweenSpeed)
        doTweenX('move3start', 'dead3', balls3 - 350, tweenSpeed)
        doTweenX('move4done', 'dead4', balls4 - 350, tweenSpeed)
        doTweenX('move5done', 'dead5', balls5 - 350, tweenSpeed)
        doTweenX('move6done', 'dead6', balls6 - 350, tweenSpeed)
        doTweenX('move7done', 'dead7', balls7 - 350, tweenSpeed)
        doTweenX('move8start', 'dead8', balls8 - 350, tweenSpeed)
        doTweenX('move9start', 'dead9', balls9 - 350, tweenSpeed)
    end
    if tag == 'move2' then 
        setProperty('dead2.x', 2400)
        local balls1 = getProperty('dead1.x')
        local balls2 = getProperty('dead2.x')
        local balls3 = getProperty('dead3.x')
        local balls4 = getProperty('dead4.x')
        local balls5 = getProperty('dead5.x')
        local balls6 = getProperty('dead6.x')
        local balls7 = getProperty('dead7.x')
        local balls8 = getProperty('dead8.x')
        local balls9 = getProperty('dead9.x')
        doTweenX('move1done', 'dead1', balls1 - 350, tweenSpeed)
        doTweenX('move2done', 'dead2', balls2 - 350, tweenSpeed)
        doTweenX('move3', 'dead3', balls3 - 350, tweenSpeed)
        doTweenX('move4done', 'dead4', balls4 - 350, tweenSpeed)
        doTweenX('move5done', 'dead5', balls5 - 350, tweenSpeed)
        doTweenX('move6done', 'dead6', balls6 - 350, tweenSpeed)
        doTweenX('move7done', 'dead7', balls7 - 350, tweenSpeed)
        doTweenX('move8start', 'dead8', balls8 - 350, tweenSpeed)
        doTweenX('move9start', 'dead9', balls9 - 350, tweenSpeed)
    end
    if tag == 'move3' then 
        setProperty('dead3.x', 2400)
        local balls1 = getProperty('dead1.x')
        local balls2 = getProperty('dead2.x')
        local balls3 = getProperty('dead3.x')
        local balls4 = getProperty('dead4.x')
        local balls5 = getProperty('dead5.x')
        local balls6 = getProperty('dead6.x')
        local balls7 = getProperty('dead7.x')
        local balls8 = getProperty('dead8.x')
        local balls9 = getProperty('dead9.x')
        doTweenX('move1done', 'dead1', balls1 - 350, tweenSpeed)
        doTweenX('move2done', 'dead2', balls2 - 350, tweenSpeed)
        doTweenX('move3done', 'dead3', balls3 - 350, tweenSpeed)
        doTweenX('move4done', 'dead4', balls4 - 350, tweenSpeed)
        doTweenX('move5done', 'dead5', balls5 - 350, tweenSpeed)
        doTweenX('move6done', 'dead6', balls6 - 350, tweenSpeed)
        doTweenX('move7done', 'dead7', balls7 - 350, tweenSpeed)
        doTweenX('move8', 'dead8', balls8 - 350, tweenSpeed)
        doTweenX('move9start', 'dead9', balls9 - 350, tweenSpeed)
    end
    if tag == 'move8' then 
        setProperty('dead8.x', 2400)
        local balls1 = getProperty('dead1.x')
        local balls2 = getProperty('dead2.x')
        local balls3 = getProperty('dead3.x')
        local balls4 = getProperty('dead4.x')
        local balls5 = getProperty('dead5.x')
        local balls6 = getProperty('dead6.x')
        local balls7 = getProperty('dead7.x')
        local balls8 = getProperty('dead8.x')
        local balls9 = getProperty('dead9.x')
        doTweenX('move1done', 'dead1', balls1 - 350, tweenSpeed)
        doTweenX('move2done', 'dead2', balls2 - 350, tweenSpeed)
        doTweenX('move3done', 'dead3', balls3 - 350, tweenSpeed)
        doTweenX('move4done', 'dead4', balls4 - 350, tweenSpeed)
        doTweenX('move5done', 'dead5', balls5 - 350, tweenSpeed)
        doTweenX('move6done', 'dead6', balls6 - 350, tweenSpeed)
        doTweenX('move7done', 'dead7', balls7 - 350, tweenSpeed)
        doTweenX('move8done', 'dead8', balls8 - 350, tweenSpeed)
        doTweenX('move9', 'dead9', balls9 - 350, tweenSpeed)
    end
    if tag == 'move9' then 
        setProperty('dead9.x', 2400)
        local balls1 = getProperty('dead1.x')
        local balls2 = getProperty('dead2.x')
        local balls3 = getProperty('dead3.x')
        local balls4 = getProperty('dead4.x')
        local balls5 = getProperty('dead5.x')
        local balls6 = getProperty('dead6.x')
        local balls7 = getProperty('dead7.x')
        local balls8 = getProperty('dead8.x')
        local balls9 = getProperty('dead9.x')
        doTweenX('move1done', 'dead1', balls1 - 350, tweenSpeed)
        doTweenX('move2done', 'dead2', balls2 - 350, tweenSpeed)
        doTweenX('move3done', 'dead3', balls3 - 350, tweenSpeed)
        doTweenX('move4done', 'dead4', balls4 - 350, tweenSpeed)
        doTweenX('move5done', 'dead5', balls5 - 350, tweenSpeed)
        doTweenX('move6done', 'dead6', balls6 - 350, tweenSpeed)
        doTweenX('move7', 'dead7', balls7 - 350, tweenSpeed)
        doTweenX('move8done', 'dead8', balls8 - 350, tweenSpeed)
        doTweenX('move9done', 'dead9', balls9 - 350, tweenSpeed)
    end
end

function onStepHit()
    if curStep == 1 then
        triggerEvent('RalZoom-setZoom', 'game', '1/15/quadInOut')
        setProperty('isCameraOnForcedPos', true)
        doTweenX('tween', 'camFollow', 1200, 13.5, 'quadInOut')
        doTweenY('tweenY', 'camFollow', 770, 13.5, 'quadInOut')
    elseif curStep == 20 then
        doTweenAlpha('ummm3', 'AppleJuice', 0, 1)
    elseif curStep == 30 then
        doTweenAlpha('title1AltA', 'title1Alt', 0.5, 0.5)
        addAnimationByPrefix('title1', 'ggds', 'play', 24, false)
        playAnim('title1', 'ggds', false)
        setProperty('title1.alpha', 1)
    elseif curStep == 64 then
        addAnimationByPrefix('title2', 'ggdsw', 'play', 24, false)
        setProperty('title2.alpha', 1)
    elseif curStep == 118 then
        doTweenY('With HUD1', 'UpperBar(With HUD)', UpperBar - 90, 1, 'QuadIn')
        doTweenY('With HUD2', 'LowerBar(With HUD)', LowerBar + 90, 1, 'QuadIn')
        doTweenAlpha('ummm1', 'title1', 0, 1)
        doTweenAlpha('ummm2', 'title2', 0, 1)
        doTweenAlpha('title1AltA', 'title1Alt', 0, 0.5)
    elseif curStep == 128 then
        setProperty('isCameraOnForcedPos', false)
        doTweenAlpha('huddy', 'camHUD', 1, 1)
        triggerEvent('RalZoom-setZoom', 'game', '1.2/2/expoOut')
    elseif curStep == 230 then
        setProperty('isCameraOnForcedPos', true)
        doTweenX('tween', 'camFollow', 850, 2.1, 'quadInOut')
        doTweenY('tweenY', 'camFollow', 770, 2.1, 'quadInOut')
        triggerEvent('RalZoom-setZoom', 'game', '1.4/3/quadInOut')
    elseif curStep >= 248 and curStep <= 254 then
        setProperty('OH.alpha', 0)
        setProperty('YEAH.alpha', 0)
        setProperty('HA.alpha', 0)
        setProperty('HAHA.alpha', 0)

        if curStep == 248 then
            setProperty('OH.alpha', 1)
        elseif curStep == 250 then
            setProperty('YEAH.alpha', 1)
        elseif curStep == 252 then
            setProperty('HA.alpha', 1)
        elseif curStep == 254 then
            setProperty('HAHA.alpha', 1)
        end
    elseif curStep == 256 then
        doTweenAlpha('textgone', 'HAHA', 0, 1)
        doTweenX('tween', 'camFollow', 1170, 2, 'quadInOut')
        doTweenY('tweenY', 'camFollow', 770, 2, 'quadInOut')
        triggerEvent('RalZoom-setZoom', 'game', '.95/2/quadInOut')
    elseif curStep == 358 then
        setProperty('isCameraOnForcedPos', true)
        doTweenX('tween', 'camFollow', 850, 2.1, 'quadInOut')
        doTweenY('tweenY', 'camFollow', 770, 2.1, 'quadInOut')
        triggerEvent('RalZoom-setZoom', 'game', '1.4/3/quadInOut')
    elseif curStep >= 376 and curStep <= 382 then
        setProperty('OH.alpha', 0)
        setProperty('YEAH.alpha', 0)
        setProperty('HA.alpha', 0)
        setProperty('HAHA.alpha', 0)

        if curStep == 376 then
            setProperty('OH.alpha', 1)
        elseif curStep == 378 then
            setProperty('YEAH.alpha', 1)
        elseif curStep == 380 then
            setProperty('HA.alpha', 1)
        elseif curStep == 382 then
            setProperty('HAHA.alpha', 1)
        end
    elseif curStep == 384 then
        doTweenAlpha('textgone', 'HAHA', 0, 1)
        setProperty('isCameraOnForcedPos', true)
        doTweenX('tween', 'camFollow', 1000, 2.1, 'quadInOut')
        doTweenY('tweenY', 'camFollow', 770, 2.1, 'quadInOut')
        doTweenY('With HUD1', 'UpperBar(With HUD)', UpperBar - 20, 1, 'QuadIn')
        doTweenY('With HUD2', 'LowerBar(With HUD)', LowerBar + 20, 1, 'QuadIn')
        triggerEvent('RalZoom-setZoom', 'game', '1.2/4/quadInOut')
        setObjectCamera('UpperBar(With HUD)', 'camHUD')
        setObjectCamera('LowerBar(With HUD)', 'camHUD')
    elseif curStep == 400 then
        setProperty('isCameraOnForcedPos', false)
    elseif curStep == 512 then
        setProperty('isCameraOnForcedPos', true)
        doTweenX('tween', 'camFollow', 1170, 2.1, 'quadInOut')
        doTweenY('tweenY', 'camFollow', 770, 2.1, 'quadInOut')
        triggerEvent('RalZoom-setZoom', 'game', '.95/2/quadInOut')
    elseif curStep == 566 then
        triggerEvent('RalZoom-setZoom', 'game', '1.4/.1/expoOut')
        setProperty('cameraSpeed', 1000)
        doTweenX('tween', 'camFollow', 950, 0.01, 'expoOut')
    elseif curStep == 567 then
        setProperty('cameraSpeed', 4)
        doTweenX('tween', 'camFollow', 800, 0.5, 'expoOut')
    elseif curStep == 570 then
        setProperty('cameraSpeed', 1000)
        doTweenX('tween', 'camFollow', 1450, 0.01, 'expoOut')
    elseif curStep == 571 then
        setProperty('cameraSpeed', 4)
        doTweenX('tween', 'camFollow', 1600, 0.5, 'expoOut')
    elseif curStep == 573 then
        setProperty('cameraSpeed', 1000)
        doTweenX('tween', 'camFollow', 950, 0.01, 'expoOut')
    elseif curStep == 574 then
        setProperty('cameraSpeed', 2.3)
        doTweenX('tween', 'camFollow', 800, 1, 'expoOut')
    elseif curStep == 576 then
        setProperty('cameraSpeed', 1)
        doTweenX('tween', 'camFollow', 1170, 2.1, 'quadInOut')
        doTweenY('tweenY', 'camFollow', 770, 2.1, 'quadInOut')
        triggerEvent('RalZoom-setZoom', 'game', '.95/2/quadInOut')
    elseif curStep == 624 then
        doTweenY('With HUD1', 'UpperBar(With HUD)', UpperBar - 90, 1, 'QuadIn')
        doTweenY('With HUD2', 'LowerBar(With HUD)', LowerBar + 90, 1, 'QuadIn')
    elseif curStep == 640 then
        doTweenX('tween', 'camFollow', 1000, 2.1, 'quadInOut')
        doTweenY('tweenY', 'camFollow', 770, 2.1, 'quadInOut')
        triggerEvent('RalZoom-setZoom', 'game', '1.1/3/quadInOut')
    elseif curStep == 660 then
        setProperty('isCameraOnForcedPos', false)
    elseif curStep == 742 then
        setProperty('isCameraOnForcedPos', true)
        doTweenX('tween', 'camFollow', 850, 2.1, 'quadInOut')
        doTweenY('tweenY', 'camFollow', 770, 2.1, 'quadInOut')
        triggerEvent('RalZoom-setZoom', 'game', '1.4/3/quadInOut')
    elseif curStep >= 760 and curStep <= 766 then
        -- Agrupa las lógicas de aparición de texto similar
        setProperty('OH.alpha', 0)
        setProperty('yeahanim.alpha', 0)
        setProperty('HA.alpha', 0)
        setProperty('HAHA.alpha', 0)

        if curStep == 760 then
            setProperty('OH.alpha', 1)
        elseif curStep == 762 then
            setProperty('yeahanim.alpha', 1)
        elseif curStep == 764 then
            setProperty('HA.alpha', 1)
        elseif curStep == 766 then
            setProperty('HAHA.alpha', 1)
        end
    elseif curStep == 768 then
        doTweenAlpha('textgone', 'HAHA', 0, 1)
        setProperty('isCameraOnForcedPos', true)
        doTweenX('tween', 'camFollow', 1170, 1, 'quadInOut')
        doTweenY('tweenY', 'camFollow', 770, 1, 'quadInOut')
        triggerEvent('RalZoom-setZoom', 'game', '1.1/1/quadInOut')
    elseif curStep == 782 then
        triggerEvent('RalZoom-setZoom', 'game', '.95/1/expoOut')
    elseif curStep == 896 then
        setProperty('isCameraOnForcedPos', true)
        doTweenX('tween', 'camFollow', 850, 2.1, 'quadInOut')
        doTweenY('tweenY', 'camFollow', 770, 2.1, 'quadInOut')
        triggerEvent('RalZoom-setZoom', 'game', '1.4/3/quadInOut')
        doTweenY('With HUD1', 'UpperBar(With HUD)', UpperBar - 20, 1, 'QuadIn')
        doTweenY('With HUD2', 'LowerBar(With HUD)', LowerBar + 20, 1, 'QuadIn')
    elseif curStep == 960 then
        setProperty('cameraSpeed', 1)
        doTweenX('tween', 'camFollow', 1170, 2.1, 'quadInOut')
        doTweenY('tweenY', 'camFollow', 770, 2.1, 'quadInOut')
        triggerEvent('RalZoom-setZoom', 'game', '.95/2/quadInOut')
    elseif curStep == 1001 then
        setProperty('isCameraOnForcedPos', true)
        doTweenX('tween', 'camFollow', 1540, 2, 'expoInOut')
        doTweenY('tweenY', 'camFollow', 870, 2, 'expoInOut')
        setProperty('cameraSpeed', 0.9)
    elseif curStep == 1018 then
        triggerEvent('RalZoom-setZoom', 'game', '10/1.00/expoInOut')
    elseif curStep == 1024 then
        playAnim('BOYFRIEND_DEAD', 'Loop', false)
        setProperty('BOYFRIEND_DEAD.alpha', 1)
        setProperty('boyfriend.alpha', 1)
        playAnim('BOYFRIEND_DEAD', 'Die', true)
        setProperty('bg.alpha', 0)
        setProperty('crowd.alpha', 0)
        setProperty('server.alpha', 0)
        setProperty('lightAbove.alpha', 0)
        setProperty('brightLightSmall.alpha', 0)
        setProperty('backDark.alpha', 0)
        setProperty('lights.alpha', 0)
        setProperty('orangeLight.alpha', 0)
        setProperty('GlitchCart.alpha', 0)
        setProperty('bottomFloor.alpha', 0)
        setProperty('deadclose.alpha', 1)
        setProperty('deadclose2.alpha', 1)
    elseif curStep == 1025 then
        triggerEvent('RalZoom-setZoom', 'game', '.8/3.4/expoOut')
    elseif curStep == 1128 then
        doTweenY('With HUD1', 'UpperBar(With HUD)', UpperBar - 90, 1, 'QuadIn')
        doTweenY('With HUD2', 'LowerBar(With HUD)', LowerBar + 90, 1, 'QuadIn')
    elseif curStep == 1136 then
        setProperty('flashblack.alpha', 1)
        setProperty('boyfriend.alpha', 0)
        setProperty('dad.alpha', 0)
    end
    if curStep == 1152 then 
               setSpriteShader('dad', 'glitch')
                   setProperty('flashblack.alpha',0)
                setProperty('glitch.alpha', 1)
               setProperty('bf_transform.alpha',1)
setProperty('boyfriend.alpha', 0)
setProperty('dad.alpha', 1)
               playAnim('bf_transform', 'playanim', true)
               --setProperty('camGame.alpha', 1)
               cameraFlash('camOther', 'FFFFFF', 1)
               triggerEvent('RalZoom-setZoom', 'game', '.7/.01/expoOut')  
                setProperty('deadclose.alpha', 0)
        setProperty('deadclose2.alpha', 0)
        setProperty('verydead1.alpha', 1)
        setProperty('verydead2.alpha', 1)
        setProperty('verydead3.alpha', 1)
        setProperty('verydead4.alpha', 1)
                balls1 = getProperty('dead1.x')
                balls2 = getProperty('dead2.x')
                balls3 = getProperty('dead3.x')
                balls4 = getProperty('dead4.x')
                balls5 = getProperty('dead5.x')
                balls6 = getProperty('dead6.x')
                balls7 = getProperty('dead7.x')
                balls8 = getProperty('dead8.x')
                balls9 = getProperty('dead9.x')
            
              doTweenX('move1start', 'dead1', balls1 - 350, tweenSpeed)
              doTweenX('move2start', 'dead2', balls2 - 350, tweenSpeed)
              doTweenX('move3start', 'dead3', balls3 - 350, tweenSpeed)
              doTweenX('move4start', 'dead4', balls4 - 350, tweenSpeed)
              doTweenX('move5start', 'dead5', balls5 - 350, tweenSpeed)
              doTweenX('move6start', 'dead6', balls6 - 350, tweenSpeed)
              doTweenX('move7', 'dead7', balls7 - 350, tweenSpeed)
              doTweenX('move8start', 'dead8', balls8 - 350, tweenSpeed)
              doTweenX('move9start', 'dead9', balls9 - 350, tweenSpeed)
              runTimer('reset1', 2.01)
            
            
              Tballs1 = getProperty('verydead1.x')
              Tballs2 = getProperty('verydead2.x')
              Tballs3 = getProperty('verydead3.x')
              Tballs4 = getProperty('verydead4.x')
              
              doTweenX('2move1start', 'verydead1', Tballs1 + 1300, tweenSpeed)
              doTweenX('2move2start', 'verydead2', Tballs2 + 1300, tweenSpeed)
              doTweenX('2move3start', 'verydead3', Tballs3 + 1300, tweenSpeed)
              doTweenX('2move4', 'verydead4', Tballs4 + 1300, tweenSpeed)
            end
            if curStep == 1294 then 
               triggerEvent('RalZoom-setZoom', 'game', '.6/1/expoOut')  
            end
             if curStep == 1408 then 
               triggerEvent('RalZoom-setZoom', 'game', '2.1/4/quadInOut')  
            end
            if curStep == 1416 then 
               doTweenAlpha('staticup', 'Static', 1, 1)
               doTweenAlpha('dhdhd', 'camHUD', 0, 1)
            end
end

function onUpdatePost()
    if doesSpriteExist('BOYFRIEND_DEAD') then
        if getProperty('BOYFRIEND_DEAD.animation.curAnim.name') == 'Die' and getProperty('BOYFRIEND_DEAD.animation.curAnim.finished') then
            playAnim('BOYFRIEND_DEAD', 'Loop', true)
        end
    end

    if doesSpriteExist('bf_transform') and getProperty('bf_transform.animation.curAnim.finished') then
        setProperty('boyfriend.alpha', 1)
        setProperty('bf_transform.alpha', 0)
    end
end
