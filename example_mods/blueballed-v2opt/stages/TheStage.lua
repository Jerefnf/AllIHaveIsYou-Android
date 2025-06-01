function onCreate()
    makeLuaSprite('backDark', 'erect/backDark', 1500)
    scaleObject('backDark', 2, 2)
    addLuaSprite('backDark', 'backDark')

    makeAnimatedLuaSprite('crowd', 'erect/crowd', 1200, 370)
    addAnimationByPrefix('crowd','Dance','Symbol 2 instance',13,true)
    scaleObject('crowd', 2.8, 2.8)
    setScrollFactor('crowd', 1.3, 1.1)
    addLuaSprite('crowd', 'crowd')
    setSpriteShader('crowd', 'glitch')

    makeLuaSprite('bg', 'erect/bg')
    scaleObject('bg', 2, 2)
    addLuaSprite('bg', 'bg')

    um = 1.8
    makeAnimatedLuaSprite('bottomFloor', 'erect/bottomFloor', -560, 760)
    addAnimationByPrefix('bottomFloor','Dance','Idle',13,true)
    scaleObject('bottomFloor', 3.6, 3.6)
    addLuaSprite('bottomFloor', false)

    makeLuaSprite('server', 'erect/server', 200, 450)
    scaleObject('server', 1, 1)
    addLuaSprite('server', 'server')

    makeLuaSprite('lightAbove', 'erect/lightAbove', 1500)
    scaleObject('lightAbove', 1, 1)
    addLuaSprite('lightAbove', true)
    setScrollFactor('lightAbove', 1.2, .9)
    setBlendMode('lightAbove', 'subtract')
    setProperty('lightAbove.alpha', 0)

    makeLuaSprite('brightLightSmall', 'erect/brightLightSmall', 1550, 100)
    scaleObject('brightLightSmall', 1, 1)
    addLuaSprite('brightLightSmall', true)
    setScrollFactor('brightLightSmall', 1.2, .9)
    setBlendMode('brightLightSmall', 'subtract')
    setProperty('brightLightSmall.alpha', 0)

    makeLuaSprite('lighting', 'erect/lighting', 460, 130)
    scaleObject('lighting', 2, 2)
    addLuaSprite('lighting', true)
    setScrollFactor('lighting', 1.2, .9)
    setProperty('lighting.alpha', .3)
    setBlendMode('lighting', 'add')
    doTweenAlpha('lightingA1', 'lighting', .2, 0.02)

    makeLuaSprite('lights', 'erect/lights', -100, -100)
    scaleObject('lights', 2, 2)
    addLuaSprite('lights', true)
    setScrollFactor('lights', 1.2, .9)
    setProperty('lights.flipX', true)
    setProperty('lights.angle', 20)

    makeLuaSprite('orangeLight', 'erect/orangeLight', -800, 100)
    scaleObject('orangeLight', 6, 2)
    addLuaSprite('orangeLight', true)
    setScrollFactor('orangeLight', 1.2, .9)
    setBlendMode('orangeLight', 'subtract')

    makeLuaSprite('orangeLight2', 'erect/orangeLight', -800, 100)
    scaleObject('orangeLight2', 6, 2)
    addLuaSprite('orangeLight2', true)
    setScrollFactor('orangeLight2', 1.2, .9)
    setBlendMode('orangeLight2', 'subtract')

    makeAnimatedLuaSprite('GlitchCart', 'erect/GlitchCart', 400, 260)
    addAnimationByPrefix('GlitchCart','Dance','GlitchOnCart',16,true)
    scaleObject('GlitchCart', 8.4, 8.4)
    setScrollFactor('GlitchCart', 1.1, 1.1)
    addLuaSprite('GlitchCart', true)
end

function onCreatePost()
end

function onTweenCompleted(tag)
    local lightingTweens = {
        lightingA1 = {alpha = .32, next = 'lightingA2'},
        lightingA2 = {alpha = .2, next = 'lightingA1'},
        lightingA3 = {alpha = .1, next = 'lightingA4'},
        lightingA4 = {alpha = .21, next = 'lightingA3'},
        lightingA5 = {alpha = .3, next = 'lightingA6'},
        lightingA6 = {alpha = .19, next = 'lightingA5'},
        lightingA7 = {alpha = .38, next = 'lightingA8'},
        lightingA8 = {alpha = .23, next = 'lightingA1'},
        lightingA9 = {alpha = .3, next = 'lightingA10'},
        lightingA10 = {alpha = .2, next = 'lightingA9'},
        lightingA11 = {alpha = .4, next = 'lightingA12'},
        lightingA12 = {alpha = .3, next = 'lightingA11'},
        lightingA13 = {alpha = .5, next = 'lightingA14'},
        lightingA14 = {alpha = .4, next = 'lightingA13'},
        lightingA15 = {alpha = .3, next = nil}
    }

    local tweenInfo = lightingTweens[tag]
    if tweenInfo then
        if tweenInfo.next then
            doTweenAlpha(tweenInfo.next, 'lighting', tweenInfo.alpha, 0.02)
        end
    end
end

function cancelAllLightingTweensAndHide()
    local tweenTags = {
        'lightingA1', 'lightingA2', 'lightingA3', 'lightingA4', 'lightingA5', 'lightingA6',
        'lightingA7', 'lightingA8', 'lightingA9', 'lightingA10', 'lightingA11', 'lightingA12',
        'lightingA13', 'lightingA14', 'lightingA15', 'lightingA16'
    }
    for _, tag in ipairs(tweenTags) do
        cancelTween(tag)
    end
    setProperty('lighting.alpha', 0)
end

function onStepHit()
   if curStep == 1024 then
      cancelAllLightingTweensAndHide()
   end
end
