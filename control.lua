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

-- runs each time any player writes a message to chat
script.on_event(defines.events.on_console_chat,
  function(event)
    local removeColor = {r = 1, g = 0, b = 0, a = 1}
    local addColor = {r = 0, g = 1, b = 0, a = 1}
    local listColor = {r = 0, g = 0.5, b = 0.5, a = 1}

    local player = game.get_player(event.player_index)
    local input = event.message

    local playerName = player.name

    local inputs = mysplit(input, " ")
    -- for k,v in pairs(inputs) do
    --   player.print(k .. " - " ..v)
    -- end

    local command = inputs[1]

    --global.chatCount = (global.chatCount or 0) + 1

    

    if command == "list" then
      
      player.clear_console()
      if global.todoList == nil then
        player.print("TODO List empty!", listColor)
      else
        player.print("TODO: ", listColor)
        for k,v in pairs(global.todoList) do
          player.print(k .. " - "..v, listColor)
        end
      end

    elseif command == "add" then

      player.clear_console()
      if global.todoList == nil then
        global.todoList = {}
      end
      table.insert(global.todoList, input)
      player.print("added to list!", addColor)

    elseif command == "remove" then

      player.clear_console()
      if global.todoList == nil then

        player.print("TODO List already empty!", removeColor)

      else

        if #inputs == 2 then

          local removeIndex = inputs[2]
          table.remove(global.todoList, removeIndex)
          player.print("removed item: " .. removeIndex .. " from list!", removeColor)

        elseif #inputs < 2 then

          player.print("You must choose an item index to remove!", listColor)

        else

          player.print("Too many arguments provided - remove should only include two!", listColor)

        end    

      end
      
    end

    --player.print("player: '" .. playerName .. "' command: '" .. command .. "' - count: ")
  end
)

