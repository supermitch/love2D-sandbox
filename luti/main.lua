log = require 'log'

renderer = require 'renderer'


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

    levels = {
        {'one', 'hats', 'horses', 'mouse', 'cats', 'ddd'},
        {'two', 'dead', 'sea', 'plant', 'car', 'dart'},
        {'three', 'jump', 'ant', 'art', 'fart', 'star'},
    }
    current_level = 2

    words = {done = {}, todo = {}}
    for i, text in ipairs(levels[current_level]) do
        local text_table = {}
        text:gsub('.', function(c) table.insert(text_table, c) end)
        local word = {
            untyped = text_table,
            typed = {},
            complete = false,
            width = word_font:getWidth(text) * 1.1,
            height = 20,
            x = i * 60 + 100,
            y = 100,
        }
        table.insert(words.todo, word)
    end

end


function updateCorrect(word)
    table.insert(word.typed, table.remove(word.untyped, 1))
    if next(word.untyped) == nil then -- If this word is now empty
        word.complete = true
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
        if next(current_word.typed) == nil and not current_word.complete then -- Did we just finish the last word?
            current_word.complete = true
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
    renderer.draw_ground(screen)
    renderer.draw_hero(hero)
    renderer.print_words(words)
end

-- Checks if rectangles a and b overlap.
function CheckCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)
  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end
