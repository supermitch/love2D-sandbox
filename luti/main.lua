log = require 'log'

renderer = require 'renderer'
typer = require 'typer'
collider = require 'collider'

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

function love.keypressed(k)
    local current_word = words.todo[1]
    local next_letter = current_word.untyped[1]

    if k == 'escape' then
        love.event.quit()
    elseif k == next_letter then
        typer.updateCorrect(current_word)
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
