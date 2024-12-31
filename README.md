# Weave v1.0
A module loader for roblox, yes this is a glorified module loader, yes it might not be super useful, yes its very cool.

Credit me if you want, I dont really care.

I've never done github before so you may find mistakes.

# Up-To Date documentation, you can find per version docs within the module script.

## Functions:

### `Weave.new()` -> Creates a new Weave instance.
  - Initializes Weave instance with handlers.
  
  **Example:**
  ```
  local weaveInstance = Weave.new()
  ```

### `Weave:log(message, level)` -> Logs a message with an optional log level ("INFO", "WARN", "ERROR").
  - `message`: The message to log.
  - `level`: The log level (default: "INFO").
  
  **Example:**
  ```
  weaveInstance:log("Module loaded successfully.")
  weaveInstance:log("An error occurred.", "ERROR")
  ```

### `Weave:sendMessage(channel, message)` -> Sends a message to all subscribers on a channel.
  - `channel`: The channel to send the message to.
  - `message`: The message to send.
  
  **Example:**
  ```
  weaveInstance:sendMessage("gameStart", "Game has started!")
  weaveInstance:sendMessage("levelUp", {player = "Player1", level = 5})
  ```

### `Weave:subscribeToChannel(channel, callback)` -> Subscribes a function to a message channel.
  - `channel`: The channel to subscribe to.
  - `callback`: The function to run when a message is sent on the channel.
  
  **Example:**
  ```
  weaveInstance:subscribeToChannel("gameStart", function(message)
      print("Received message: " .. message)
  end)
  weaveInstance:subscribeToChannel("levelUp", function(message)
      print("Player " .. message.player .. " leveled up to " .. message.level)
  end)
  ```

### `Weave:loadFolder(folder)` -> Loads modules from a specified folder.
  - `folder`: The Folder instance containing ModuleScripts to load.
  
  **Example:**
  ```
  local folder = game.ServerStorage.Modules
  weaveInstance:loadFolder(folder)
  ```

### `Weave:cleanup()` -> Cleans up and calls the `cleanup` function on all loaded modules (if exists).
  
  **Example:**
  ```
  weaveInstance:cleanup()
  ```

## Load Order:
- Modules can specify their load order with `Module.LoadOrder = <number>`. Higher numbers load first. Default is 1 if not specified.

## Template Module Example:
```
local TemplateModule = {}
TemplateModule.LoadOrder = 1

function TemplateModule:init(Weave)
    self.Weave = Weave
    -- Initialize module with Weave instance, in order for sendMessage and subscribeToChannel you must use the same instance to both send it and receive it. The Log table is also localized to that Weave instance.
end

function TemplateModule:Heartbeat(dt)
    -- Run on RunService Heartbeat event
end

function TemplateModule:RenderStepped(dt)
    -- Run on RunService RenderStepped event
end

function TemplateModule:Stepped(dt)
    -- Run on RunService Stepped event
end

function TemplateModule:cleanup()
    -- Clean up resources, disconnect events, etc.
end

return TemplateModule
```
