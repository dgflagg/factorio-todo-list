script.on_event(defines.events.on_player_changed_position,
  function(event)
    local player = game.get_player(event.player_index) -- get the player that moved            
    -- if they're wearing our armor
    if player.character and player.get_inventory(defines.inventory.character_armor).get_item_count("fire-armor") >= 1 then
       -- create the fire where they're standing
       player.surface.create_entity{name="fire-flame", position=player.position, force="neutral"}
       player.color = {r = 1, g = 0, b = 0, a = 0}
    end
  end
)

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
function displayHelpMessage(player, notificationColor, listColor, addColor, removeColor)
  player.clear_console()
  player.print("The following commands are available:", notificationColor)
  player.print("\t- list: shows the player's TODO list with index", listColor)
  player.print("\t- add [item name]: add a new item to the TODO list", addColor)
  player.print("\t- remove [item index]: removes item from TODO list at the index", removeColor)
end

function showTodoList(player, todoList, listColor)
  player.clear_console()
  if isListEmpty(todoList) then
    player.print("TODO List empty!", listColor)
  else
    player.print("TODO: ", listColor)
    for k,v in pairs(todoList) do
      player.print(k .. " - "..v, listColor)
    end
  end
end

function addTodo(player, input, addColor)
  player.clear_console()
  if global.todoList == nil then
    global.todoList = {}
  end

  -- TODO: make this so it does not add the entire input with the "add" command keyword

  table.insert(global.todoList, input)
  player.print("Added '" .. input .. "' to list!", addColor)
end


-- runs each time any player writes a message to chat
script.on_event(defines.events.on_console_chat,
  function(event)
    local notificationColor = {r = 0.7, g = 0, b = 0.3, a = 1}
    local removeColor = {r = 1, g = 0, b = 0, a = 1}
    local addColor = {r = 0, g = 1, b = 0, a = 1}
    local listColor = {r = 0, g = 0.7, b = 0.3, a = 1}

    local player = game.get_player(event.player_index)
    local input = event.message
    local inputs = mysplit(input, " ")
    local command = inputs[1]
    local playerName = player.name


    if command == "help" then

      displayHelpMessage(player, notificationColor, listColor, addColor, removeColor)

    -- shows all of the items on the player's TODO list
    elseif command == "list" then

      showTodoList(player, global.todoList, listColor)

    -- adds an item to the bottom of the player's TODO list
    elseif command == "add" then

      addTodo(player, input, addColor)

    -- removes the item at the index provided from the player's TODO list
    elseif command == "remove" then

      player.clear_console()
      if isListEmpty(global.todoList) then
        player.print("TODO List already empty!", removeColor)
      else

        -- check that there are exactly two inputs
        if #inputs == 2 then

          local removeIndex = tonumber(inputs[2])
          if removeIndex == nil then
            player.print("The index provided must be a number!", notificationColor)
          else

            if #global.todoList < removeIndex then
              player.print("There are not that many items in the TODO list!", notificationColor)
            else
              table.remove(global.todoList, removeIndex)
              player.print("Removed item: " .. removeIndex .. " from list!", removeColor)
            end

          end

        elseif #inputs < 2 then

          player.print("You must choose an item index to remove!", notificationColor)

        else

          player.print("Too many arguments provided - remove should only include two!", notificationColor)

        end

      end

    end

    --player.print("player: '" .. playerName .. "' command: '" .. command .. "' - count: ")
  end
)