local stateStack = {}
stateStack.states = {}

function stateStack.update(dt)
    stateStack.states[#stateStack.states].update(dt)
end

function stateStack.draw()
    for i = 1, #stateStack.states do
        stateStack.states[i].draw()
    end
end

function stateStack.push(state)
    table.insert(stateStack.states, state)
end

function stateStack.pop()
    table.remove(stateStack.states)
end

function stateStack.clear()
    stateStack.states = {}
end

return stateStack
