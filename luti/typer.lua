local typer = {}

function typer.updateCorrect(word)
    table.insert(word.typed, table.remove(word.untyped, 1))
    if next(word.untyped) == nil then -- If this word is now empty
        word.complete = true
        if next(words.todo) ~= nil then
            table.insert(words.done, table.remove(words.todo, 1)) -- Move into completed
            log.info('Word complete')
        end
    end
end

return typer
