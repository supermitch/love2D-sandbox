log = require 'log'


function love.load()
    -- Screen properties
    love.window.setMode(800, 600, {resizable=true, minwidth=400, minheight=300})

    hero = {} -- new table for the hero
    hero.x = 300 -- x,y coordinates of the hero
    hero.y = 450
    hero.width = 30
    hero.height = 15
    hero.speed = 150

    words = {} -- Words contains all the words for a level?
    for i = 0, 5 do
        word = {}
        word.untyped = {'c', 'a', 't', 's'}
        word.typed = {}
        word.width = 40
        word.height = 20
        word.x = i * 60 + 100
        word.y = 100
        table.insert(words, word)
    end

    colors = {}
    colors['red'] = {255, 0, 0}
    colors['green'] = {0, 255, 0}
end


function updateCorrect(word)
    table.insert(word.typed, table.remove(word.untyped, 1))
    return word
end

function getNextWord(words)
    return words[1]
end


function getNextLetter(word)
    return word[1]
end


function love.keypressed(k)
    local next_word = words[1]
    local next_letter = next_word.untyped[1]
    log.debug('Next word is: ' .. table.concat(next_word.untyped))
    log.debug('Next letter: ' .. next_letter)

    if k == 'escape' then
        love.event.quit()
    elseif k == next_letter then
        log.info('Correct')
        updateCorrect(next_word) -- TODO: Method of next_word?
    else
        log.info('Wrong')
        -- TODO: death
    end
end


function love.update(dt)
    -- keyboard actions for our hero
end


function love.draw()
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle('fill', 0, 465, 800, 150) -- draw some ground

    love.graphics.setColor(255, 255, 0)
    love.graphics.rectangle('fill', hero.x, hero.y, hero.width, hero.height) -- draw our hero

    for _, word in ipairs(words) do -- Draw 'platforms'
        love.graphics.setColor(20, 85, 85)
        love.graphics.rectangle('fill', word.x, word.y, word.width, word.height)
    end

    for _, word in ipairs(words) do -- Draw words
        love.graphics.setColor(255, 255, 255)
        local untyped = table.concat(word.untyped)
        local typed = table.concat(word.typed)
        local colored_text = {colors.green, typed, colors.red, untyped}
        love.graphics.print(colored_text, word.x, word.y)
    end
end

-- Checks if rectangles a and b overlap.
function CheckCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)
  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end
