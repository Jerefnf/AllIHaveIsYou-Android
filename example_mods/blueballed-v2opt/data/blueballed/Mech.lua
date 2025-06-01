local working = true
function onCreate()

    makeLuaSprite('DownDad', 'noteThing/Down', 700, 800)
    addLuaSprite('DownDad', false)
    makeLuaSprite('UpDad', 'noteThing/Up', 700, 800)
    addLuaSprite('UpDad', false)
    makeLuaSprite('RightDad', 'noteThing/Right', 700, 800)
    addLuaSprite('RightDad', false)
    makeLuaSprite('LeftDad', 'noteThing/Left', 700, 800)
    addLuaSprite('LeftDad', false)


    makeLuaSprite('DownBf', 'noteThing/Down', 700, 800)
    addLuaSprite('DownBf', false)
    makeLuaSprite('UpBf', 'noteThing/Up', 700, 800)
    addLuaSprite('UpBf', false)
    makeLuaSprite('RightBf', 'noteThing/Right', 700, 800)
    addLuaSprite('RightBf', false)
    makeLuaSprite('LeftBf', 'noteThing/Left', 700, 800)
    addLuaSprite('LeftBf', false)

    setProperty('DownBf.alpha', 0)
    setProperty('UpBf.alpha', 0)
    setProperty('LeftBf.alpha', 0)
    setProperty('RightBf.alpha', 0)

    setProperty('DownDad.alpha', 0)
    setProperty('UpDad.alpha', 0)
    setProperty('LeftDad.alpha', 0)
    setProperty('RightDad.alpha', 0)

  
    setBlendMode('DownBf', 'add')
    setBlendMode('UpBf', 'add')
    setBlendMode('LeftBf', 'add')
    setBlendMode('RightBf', 'add')

    setBlendMode('DownDad', 'add')
    setBlendMode('UpDad', 'add')
    setBlendMode('LeftDad', 'add')
    setBlendMode('RightDad', 'add')
    
end

function onStepHit()
    if curStep == 1024 then 
        working = false
    end
end

function opponentNoteHit(id, dir, type, isSustainNote)
    if working == true then 
        if getProperty('health') > 0.1 then
	setProperty('health', getProperty('health') - .02)
	end
    if type == '' then 
        if dir == 1 then 
           setProperty('DownDad.x', 700)
          setProperty('DownDad.y', 800)
            setProperty('DownDad.angle', 0)
            setProperty('DownDad.alpha', 1)
            doTweenX('DownDadNoteAttack', 'DownDad', bfx, .1)
            runTimer('DownDadFade', .1)
         --   setProperty('boyfriend.x', bfx + 1)
          --  setProperty('dad.x', dadx + 1)
            doTweenColor('DownHitBf', 'boyfriend', '90fcfc', .1, 'expoOut')
           
        end
        if dir == 0 then 
          setProperty('LeftDad.x', 700)
           setProperty('LeftDad.y', 800)
            setProperty('LeftDad.angle', 0)
            setProperty('LeftDad.alpha', 1)
            doTweenX('LeftDadNoteAttack', 'LeftDad', bfx, .1)
            runTimer('LeftDadFade', .1)
       --     setProperty('boyfriend.x', bfx + 1)
       --     setProperty('dad.x', dadx + 1)
            doTweenColor('DownHitBf', 'boyfriend', 'f48cf4', .1, 'expoOut')
        end
        if dir == 2 then 
          setProperty('UpDad.x', 700)
           setProperty('UpDad.y', 800)
            setProperty('UpDad.angle', 0)
            setProperty('UpDad.alpha', 1)
            doTweenX('UpDadNoteAttack', 'UpDad', bfx, .1)
            runTimer('UpDadFade', .1)
       --     setProperty('boyfriend.x', bfx + 1)
       --     setProperty('dad.x', dadx + 1)
            doTweenColor('DownHitBf', 'boyfriend', 'b0fcbc', .1, 'expoOut')
        end
        if dir == 3 then 
           setProperty('RightDad.x', 700)
           setProperty('RightDad.y', 800)
            setProperty('RightDad.angle', 0)
            setProperty('RightDad.alpha', 1)
            doTweenX('RightDadNoteAttack', 'RightDad', bfx, .1)
            runTimer('RightDadFade', .1)
        --    setProperty('boyfriend.x', bfx + 1)
        --    setProperty('dad.x', dadx + 1)
            doTweenColor('DownHitBf', 'boyfriend', 'fc4c79', .1, 'expoOut')
        end
    end

    if type == 'clash' then 
            
        if dir == 1 then 
         setProperty('DownDad.x', 700)
           setProperty('DownDad.y', 800)
            setProperty('DownDad.angle', 0)
            setProperty('DownDad.alpha', 1)
            doTweenX('DownDadClash', 'DownDad', bfx * .78, .1)
            runTimer('DownDadFade', .2)
           
            --setProperty('dad.x', dadx - .5)
            --setProperty('boyfriend.x', bfx - .5)
           
        end
        if dir == 0 then 
           setProperty('LeftDad.x', 700)
         setProperty('LeftDad.y', 800)
            setProperty('LeftDad.angle', 0)
            setProperty('LeftDad.alpha', 1)
            doTweenX('LeftDadClash', 'LeftDad', bfx * .78, .1)
            runTimer('LeftDadFade', .2)
           -- setProperty('dad.x', dadx - .5)
           -- setProperty('boyfriend.x', bfx - .5)
        end
        if dir == 2 then 
            setProperty('UpDad.x', 700)
         setProperty('UpDad.y', 800)
            setProperty('UpDad.angle', 0)
            setProperty('UpDad.alpha', 1)
            doTweenX('UpDadClash', 'UpDad', bfx * .78, .1)
            runTimer('UpDadFade', .2)
           -- setProperty('dad.x', dadx - .5)
           -- setProperty('boyfriend.x', bfx - .5)
        end
        if dir == 3 then 
          setProperty('RightDad.x', 700)
          setProperty('RightDad.y', 800)
            setProperty('RightDad.angle', 0)
            setProperty('RightDad.alpha', 1)
            doTweenX('RightDadClash', 'RightDad', bfx * .78, .1)
            runTimer('RightDadFade', .2)
           -- setProperty('dad.x', dadx - .5)
           -- setProperty('boyfriend.x', bfx - .5)
        end
    end
end
end

function goodNoteHit(id, dir, type, isSustainNote)
     if working == true then 
    if type == '' then 
        if dir == 1 then 
           setProperty('DownBf.x', bfx)
          setProperty('DownBf.y', 800)
                setProperty('DownBf.angle', 0)
            setProperty('DownBf.alpha', 1)
            doTweenX('DownBfNoteAttack', 'DownBf', dadx, .1)
            runTimer('DownBfFade', .1)
        --    setProperty('dad.x', dadx - 1)
       --     setProperty('boyfriend.x', bfx - 1)
            doTweenColor('DownHitBf', 'dad', '90fcfc', .1, 'expoOut')
           
        end
        if dir == 0 then 
          setProperty('LeftBf.x', bfx)
         setProperty('LeftBf.y', 800)
                setProperty('LeftBf.angle', 0)
            setProperty('LeftBf.alpha', 1)
            doTweenX('LeftBfNoteAttack', 'LeftBf', dadx, .1)
            runTimer('LeftBfFade', .1)
        --    setProperty('dad.x', dadx - 1)
        --    setProperty('boyfriend.x', bfx - 1)
            doTweenColor('DownHitBf', 'dad', 'f48cf4', .1, 'expoOut')
        end
        if dir == 2 then 
           setProperty('UpBf.x', bfx)
            setProperty('UpBf.y', 800)
            setProperty('UpBf.angle', 0)
            setProperty('UpBf.alpha', 1)
            doTweenX('UpBfNoteAttack', 'UpBf', dadx, .1)
            runTimer('UpBfFade', .1)
         --   setProperty('dad.x', dadx - 1)
         --   setProperty('boyfriend.x', bfx - 1)
            doTweenColor('DownHitBf', 'dad', 'b0fcbc', .1, 'expoOut')
        end
        if dir == 3 then 
           setProperty('RightBf.x', bfx)
         setProperty('RightBf.y', 800)
            setProperty('RightBf.angle', 0)
            setProperty('RightBf.alpha', 1)
            doTweenX('RightBfNoteAttack', 'RightBf', dadx, .1)
            runTimer('RightBfFade', .1)
          --  setProperty('dad.x', dadx - 1)
          --  setProperty('boyfriend.x', bfx - 1)
            doTweenColor('DownHitBf', 'dad', 'fc4c79', .1, 'expoOut')
        end
    end
        if type == 'clash' then 
            
            if dir == 1 then 
                setProperty('DownBf.x', bfx)
                setProperty('DownBf.y', 800)
                setProperty('DownBf.angle', 0)
                setProperty('DownBf.alpha', 1)
                doTweenX('DownBfClash', 'DownBf', dadx * 1.2, .1)
                runTimer('DownBfFade', .2)
                --setProperty('dad.x', dadx - .5)
                --setProperty('boyfriend.x', bfx - .5)
               
            end
            if dir == 0 then 
                setProperty('LeftBf.x', bfx)
                setProperty('LeftBf.y', 800)
                setProperty('LeftBf.angle', 0)
                setProperty('LeftBf.alpha', 1)
                doTweenX('LeftBfClash', 'LeftBf', dadx * 1.2, .1)
                runTimer('LeftBfFade', .2)
               -- setProperty('dad.x', dadx - .5)
               -- setProperty('boyfriend.x', bfx - .5)
            end
            if dir == 2 then 
                setProperty('UpBf.x', bfx)
                setProperty('UpBf.y', 800)
                setProperty('UpBf.angle', 0)
                setProperty('UpBf.alpha', 1)
                doTweenX('UpBfClash', 'UpBf', dadx * 1.2, .1)
                runTimer('UpBfFade', .2)
               -- setProperty('dad.x', dadx - .5)
               -- setProperty('boyfriend.x', bfx - .5)
            end
            if dir == 3 then 
                setProperty('RightBf.x', bfx)
                setProperty('RightBf.y', 800)
                setProperty('RightBf.angle', 0)
                setProperty('RightBf.alpha', 1)
                doTweenX('RightBfClash', 'RightBf', dadx * 1.2, .1)
                runTimer('RightBfFade', .2)
               -- setProperty('dad.x', dadx - .5)
               -- setProperty('boyfriend.x', bfx - .5)
            end
        end
    end
end

function onTweenCompleted(tag)
    if tag == 'UpBfClash' then 
       doTweenAngle('UpBfClashA', 'UpBf', 50, .1)
       doTweenY('UpBfClashUpY', 'UpBf', upNoteBfY - 50, .1, 'expoOut')
       doTweenX('UpBfClashUpX', 'UpBf', upNoteBfX + 50, .1, 'expoOut')
    end
    if tag == 'DownBfClash' then 
        doTweenAngle('DownBfClashA', 'DownBf', 50, .1)
        doTweenY('DownBfClashUpY', 'DownBf', downNoteBfY - 50, .1, 'expoOut')
       doTweenX('DownBfClashUpX', 'DownBf', downNoteBfX + 50, .1, 'expoOut')
     end
     if tag == 'RightBfClash' then 
        doTweenAngle('RightBfClashA', 'RightBf', 50, .1)
        doTweenY('RightBfClashUpY', 'RightBf', rightNoteBfY - 50, .1, 'expoOut')
       doTweenX('RightBfClashUpX', 'RightBf', rightNoteBfX + 50, .1, 'expoOut')
     end
     if tag == 'LeftBfClash' then 
        doTweenAngle('LeftBfClashA', 'LeftBf', 50, .1)
        doTweenY('LeftBfClashUpY', 'LeftBf', leftNoteBfY - 50, .1, 'expoOut')
       doTweenX('LeftBfClashUpX', 'LeftBf', leftNoteBfX + 50, .1, 'expoOut')
     end

     if tag == 'UpDadClash' then 
        doTweenAngle('UpDadClashA', 'UpDad', -50, .1)
        doTweenY('UpDadClashUpY', 'UpDad', upNoteDadY - 50, .1, 'expoOut')
        doTweenX('UpDadClashUpX', 'UpDad', upNoteDadX - 50, .1, 'expoOut')
     end
     if tag == 'DownDadClash' then 
         doTweenAngle('DownDadClashA', 'DownDad', -50, .1)
         doTweenY('DownDadClashUpY', 'DownDad', downNoteDadY - 50, .1, 'expoOut')
         doTweenX('DownDadClashUpX', 'DownDad', downNoteDadX - 50, .1, 'expoOut')
      end
      if tag == 'RightDadClash' then 
         doTweenAngle('RightDadClashA', 'RightDad', -50, .1)
         doTweenY('RightDadClashUpY', 'RightDad', rightNoteDadY - 50, .1, 'expoOut')
         doTweenX('RightDadClashUpX', 'RightDad', rightNoteDadX - 50, .1, 'expoOut')
      end
      if tag == 'LeftDadClash' then 
         doTweenAngle('LeftDadClashA', 'LeftDad', -50, .1)
         doTweenY('LeftDadClashUpY', 'LeftDad', leftNoteDadY - 50, .1, 'expoOut')
         doTweenX('LeftDadClashUpX', 'LeftDad', leftNoteDadX - 50, .1, 'expoOut')
      end
end
function onTimerCompleted(tag)
    if tag == 'DownBfFade' then 
        doTweenAlpha('DownBfNoteFade', 'DownBf', 0, .05)
        doTweenColor('DownHitBf', 'boyfriend', 'ffffff', .1, 'expoOut')
    end
    if tag == 'LeftBfFade' then 
        doTweenAlpha('LeftBfNoteFade', 'LeftBf', 0, .05) 
        doTweenColor('DownHitBf', 'boyfriend', 'ffffff', .1, 'expoOut')  
    end
    if tag == 'UpBfFade' then 
        doTweenAlpha('UpBfNoteFade', 'UpBf', 0, .05)
        doTweenColor('DownHitBf', 'boyfriend', 'ffffff', .1, 'expoOut')
    end 
    if tag == 'RightBfFade' then 
        doTweenAlpha('RightBfNoteFade', 'RightBf', 0, .05)
        doTweenColor('DownHitBf', 'boyfriend', 'ffffff', .1, 'expoOut')
    end

    if tag == 'DownDadFade' then 
        doTweenAlpha('DownDadNoteFade', 'DownDad', 0, .05)
        doTweenColor('DownHitBf', 'dad', 'ffffff', .1, 'expoOut')
    end
    if tag == 'LeftDadFade' then 
        doTweenAlpha('LeftDadNoteFade', 'LeftDad', 0, .05)   
        doTweenColor('DownHitBf', 'dad', 'ffffff', .1, 'expoOut')
    end
    if tag == 'UpDadFade' then 
        doTweenAlpha('UpDadNoteFade', 'UpDad', 0, .05)
        doTweenColor('DownHitBf', 'dad', 'ffffff', .1, 'expoOut')
    end 
    if tag == 'RightDadFade' then 
        doTweenAlpha('RightDadNoteFade', 'RightDad', 0, .05)
        doTweenColor('DownHitBf', 'dad', 'ffffff', .1, 'expoOut')
    end
end
--[[function goodNoteHit(id, dir, type, isSustainNote)
    if type == '' then 
        if dir == 1 then 
            doTweenAlpha('DownNoteFade', 'Down', 0, .15)
        end
    end
end ]]


function onUpdate()
    bfx = getProperty('boyfriend.x')
    dadx = getProperty('dad.x')

    upNoteBfY = getProperty('UpBf.y')
    upNoteBfX = getProperty('UpBf.x')

    leftNoteBfY = getProperty('LeftBf.y')
    leftNoteBfX = getProperty('LeftBf.x')

    downNoteBfY = getProperty('DownBf.y')
    downNoteBfX = getProperty('DownBf.x')

    rightNoteBfY = getProperty('RightBf.y')
    rightNoteBfX = getProperty('RightBf.x')

    upNoteDadY = getProperty('UpDad.y')
    upNoteDadX = getProperty('UpDad.x')

    leftNoteDadY = getProperty('LeftDad.y')
    leftNoteDadX = getProperty('LeftDad.x')

    downNoteDadY = getProperty('DownDad.y')
    downNoteDadX = getProperty('DownDad.x')

    rightNoteDadY = getProperty('RightDad.y')
    rightNoteDadX = getProperty('RightDad.x')
end
            
