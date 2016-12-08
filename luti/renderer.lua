local renderer = {}

colors = {}
colors['white'] = {255, 255, 255}
colors['red'] = {255, 0, 0}
colors['green'] = {0, 255, 0}
colors['blue'] = {0, 0, 255}
colors['yellow'] = {255, 255, 0}
colors['gray'] = {128, 128, 128}


function renderer.draw_ground(screen)
    love.graphics.setColor(colors.green)
    love.graphics.rectangle('fill', 0, 465, screen.width, 150) -- some ground
end


function renderer.draw_hero(hero)
    love.graphics.setColor(colors.yellow)
    love.graphics.rectangle('fill', hero.x, hero.y, hero.width, hero.height) -- our hero
end


function renderer.print_words(words)
    for _, category in pairs(words) do -- For both done & todo
        for _, word in ipairs(category) do -- Draw words

            draw_platform(word)

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


function draw_platform(word)
    love.graphics.setColor(colors.gray)
    love.graphics.rectangle('fill', word.x, word.y, word.width, word.height) -- platforms
end

return renderer
