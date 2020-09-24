-- constants
local NOTIFICATION_COLOR = {r = 0.7, g = 0, b = 0.3, a = 1}
local REMOVE_COLOR = {r = 1, g = 0, b = 0, a = 1}
local ADD_COLOR = {r = 0, g = 1, b = 0, a = 1}
local LIST_COLOR = {r = 0, g = 0.7, b = 0.3, a = 1}


function mysplit (inputstr, sep)
  if sep == nil then
          sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
          table.insert(t, str)
  end
  return t
end

-- returns true if the list is uninitialized or has fewer than 1 items, false otherwise
function isListEmpty(todoList)
  if todoList == nil or #todoList < 1 then
    return true
  end

  return false
end

-- displays TODO list command options overview
function displayHelpMessage(player)
  player.clear_console()
  player.print("The following commands are available:", NOTIFICATION_COLOR)
  player.print("\t- list: shows the player's TODO list with index", LIST_COLOR)
  player.print("\t- add [item name]: add a new item to the TODO list", ADD_COLOR)
  player.print("\t- remove [item index]: removes item from TODO list at the index", REMOVE_COLOR)
end

-- displays the current list of TODO items to the player
function showTodoList(player, todoList)
  player.clear_console()
  if isListEmpty(todoList) then
    player.print("Nothing TODO!", LIST_COLOR)
  else
    player.print("TODO: ", LIST_COLOR)
    for k,v in pairs(todoList) do
      player.print(k .. " - "..v, LIST_COLOR)
    end
  end
end

-- adds a new TODO item to the player's list
function addTodo(player, inputs)
  player.clear_console()
  if global.todoList == nil then
    global.todoList = {}
  end

  -- strip the command word from the todo item
  local todoItem = ""
  for k,v in pairs(inputs) do
    -- last item in list
    if k == #inputs then
      todoItem = todoItem .. v
    elseif k ~= 1 then
      todoItem = todoItem .. v .. " "
    end
  end

  table.insert(global.todoList, todoItem)
  player.print("TODO added: '" .. todoItem .. "'", ADD_COLOR)
end

-- removes a TODO item from the player's list
function removeTodo(player, inputs)
  player.clear_console()
  if isListEmpty(global.todoList) then
    player.print("Nothing TODO!", REMOVE_COLOR)
  else
    -- check that there are exactly two inputs
    if #inputs == 2 then
      local removeIndex = tonumber(inputs[2])
      if removeIndex == nil then
        player.print("The index provided must be a number!", NOTIFICATION_COLOR)
      else
        if #global.todoList < removeIndex then
          player.print("There are not that many items in the TODO list!", NOTIFICATION_COLOR)
        elseif removeIndex < 1 then
          player.print("You cannot use an index that is less than one!", NOTIFICATION_COLOR)
        else
          local removedItem = global.todoList[removeIndex]
          table.remove(global.todoList, removeIndex)
          player.print("TODO removed: '" .. removedItem .. "'", REMOVE_COLOR)
        end
      end
    elseif #inputs < 2 then
      player.print("You must choose an item index to remove!", NOTIFICATION_COLOR)
    else
      player.print("Too many arguments provided - remove should only include two!", NOTIFICATION_COLOR)
    end
  end
end


-- runs each time any player writes a message to chat
script.on_event(defines.events.on_console_chat,
  function(event)
    local player = game.get_player(event.player_index)
    local input = event.message
    local inputs = mysplit(input, " ")
    local command = inputs[1]
    local playerName = player.name

    -- based on the command entered take the appropriate action
    if command == "help" then
      displayHelpMessage(player)
    elseif command == "list" then
      showTodoList(player, global.todoList)
    elseif command == "add" then
      addTodo(player, inputs)
    elseif command == "remove" then
      removeTodo(player, inputs)
    end

  end
)