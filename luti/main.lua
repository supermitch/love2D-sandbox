log = require 'log'


function love.load()
    -- Screen properties
    screen = {width = 800, height = 600}
    love.window.setMode(screen.width, screen.height, {resizable=true, minwidth=400, minheight=300})

    hero = { -- new table for the hero
        x = 300,
        y = 450,
        width = 30,
        height = 15,
        speed = 150,
    }

    word_font = love.graphics.newFont(12)
    love.graphics.setFont(word_font)

    level_text = {'hats', 'horses', 'mouse', 'cats', 'ddd'}
    words = {done = {}, todo = {}}
    for i, text in ipairs(level_text) do
        local text_table = {}
        text:gsub('.', function(c) table.insert(text_table, c) end)
        local word = {
            untyped = text_table,
            typed = {},
            width = word_font:getWidth(text) * 1.1,
            height = 20,
            x = i * 60 + 100,
            y = 100,
        }
        table.insert(words.todo, word)
    end

    colors = {}
    colors['white'] = {255, 255, 255}
    colors['red'] = {255, 0, 0}
    colors['green'] = {0, 255, 0}
    colors['blue'] = {0, 0, 255}
    colors['yellow'] = {255, 255, 0}
    colors['gray'] = {128, 128, 128}
end


function updateCorrect(word)
    table.insert(word.typed, table.remove(word.untyped, 1))
    if next(word.untyped) == nil then -- If this word is now empty
        if next(words.todo) ~= nil then
            table.insert(words.done, table.remove(words.todo, 1)) -- Move into completed
            log.info('Word complete')
        end
    end
end


function love.keypressed(k)
    local current_word = words.todo[1]
    local next_letter = current_word.untyped[1]

    if k == 'escape' then
        love.event.quit()
    elseif k == next_letter then
        updateCorrect(current_word)
    elseif k == 'space' or k == 'return' then
        if next(current_word.typed) == ni then -- Did we just finish the last word?
            log.debug('Word complete')
        else
            log.debug('Typo')
        end
        -- We ignore space and enter at the end of words!
    else
        log.debug('Wrong') -- TODO: death
    end

    if next(words.todo) == nil then -- No more words
        log.info('Level complete!')
        love.event.quit() -- TODO: next level?
    end

end


function love.update(dt)
    -- keyboard actions for our hero
end


function love.draw()
    love.graphics.setColor(colors.green)
    love.graphics.rectangle('fill', 0, 465, screen.width, 150) -- some ground

    love.graphics.setColor(colors.yellow)
    love.graphics.rectangle('fill', hero.x, hero.y, hero.width, hero.height) -- our hero

    for _, category in pairs(words) do -- For both done & todo
        for _, word in ipairs(category) do -- Draw words

            love.graphics.setColor(colors.gray)
            love.graphics.rectangle('fill', word.x, word.y, word.width, word.height) -- platforms

            local typed = table.concat(word.typed)
            local untyped = table.concat(word.untyped)

            if untyped == '' then -- All typed
                love.graphics.setColor(colors.green)
                love.graphics.print(typed, word.x, word.y)
            elseif typed == '' then  -- Nothing typed
                love.graphics.setColor(colors.red)
                love.graphics.print(untyped, word.x, word.y)
            else -- In progress
                love.graphics.setColor(colors.white)
                local colored_text = {colors.green, typed, colors.red, untyped} -- Can't print empty strings this way
                love.graphics.print(colored_text, word.x, word.y)
            end
        end
    end
end

-- Checks if rectangles a and b overlap.
function CheckCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)
  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end
