# Creating Extensions

ZEN is designed to be extended.  
No roleplay, survival, or gameplay logic is hard coded into the core.  
Everything comes from the extensions you create.

You should know some basic coding, but ZEN is simple enough to understand.

---

## Folder Structure

| Folder         | Description                                                      |
| -------------- | ----------------------------------------------------------------|
| `core/`        | Core files handling main logic. Rarely needs changing.          |
| `extensions/`  | Your custom extensions live here. Each extension is its own folder.|

---

## How to Extend the Player Class

If you want to add new features to the ZEN player, you **must**:

* Place your extension files inside the correct `extensions/` subfolder.
* Your **player class file** goes in `extensions/classes/` and should be named after your extension.
* Optional logic for other runtime contexts goes into `client/`, `server/`, or `shared/` as needed — also named after your extension.

Example structure:

```
extensions/
├── classes/example.lua    -- Core player extension logic
├── client/example.lua     -- (Optional) Client-side logic
├── server/example.lua     -- (Optional) Server-side logic
└── shared/example.lua     -- (Optional) Shared logic
```

The **`classes/` file** is required for any extension that hooks into the player lifecycle.
The **`client/`, `server/`, and `shared/`** files are optional and should be added only if needed for your feature.

---

## Player Functions

ZEN comes equiped with a solid suite of player functions to allow you to hook into the main player object's activity and run your own custom code.
These functions let you build modular, maintainable extensions that hook into the player's lifecycle and data seamlessly.

### Lifecycle Functions

| Function     | Description                                                       |
| ------------ | -----------------------------------------------------------------|
| `:on_load`   | Called when the extension is loaded for a player. Use this to initialize your extension, add methods, and set up any needed data. |
| `:on_unload` | Called when the extension is unloaded or the player disconnects. Use this to clean up resources or save temporary data. |
| `:on_save`   | Called when player data is being saved. Use this to persist any custom data your extension manages. |

### Extension Functions

Extensions can add dynamic methods and data to players using the Player API. Here are some key functions available to your extensions when extending the player:

| Function                      | Description                                                                                          |
| ----------------------------- | -------------------------------------------------------------------------------------------------- |
| `player:add_method(name, fn)` | Adds a new callable method to the player object.                                                   |
| `player:run_method(name, ...)`| Runs a previously added method by name with optional arguments. Returns the method's result.       |
| `player:add_data(category, value, replicate)` | Adds a new data category to the player, optionally replicating it to the client.          |
| `player:get_data(category)`   | Retrieves data stored in a given category or all data if no category is specified.                  |
| `player:set_data(category, updates, sync)` | Updates keys inside a data category and optionally syncs it to the client.                |
| `player:sync_data(category)`  | Syncs specified or all replicated data categories from the server to the client.                   |
| `player:add_extension(name, ext)` | Registers a new extension table on the player, allowing modular functionality.                  |
| `player:get_extension(name)`  | Retrieves a registered extension by name.                                                          |
| `player:list_extensions()`    | Returns a list of all currently registered extension names for the player.                         |

---

## The Code

Now we get to the important stuff, how to actually code your first extension. 
I will try to explain this as simple as possible for non-coders out there. 

### 1. Structure

Every class file **must** follow this same starting structure. 

```lua
local Example = {}

function Example:on_load()
    local player = self.player --- Shorthand access to self.player

    --- This runs when the ZEN core player object is initially created.
    --- Your extension **must** have the :on_load() function, otherwise ZEN will not load it.
    --- Here you use extension functions to build your player object how you want.
end

function Example:on_save()
    local player = self.player
    
    --- This runs when player data is saved.
    --- Players are saved automatically by ZEN on disconnect or resource stop.
    --- All extension :on_save() functions will be called if they exist.
end

function Example:on_unload()
    local player = self.player
    
    --- This runs when a player is unloaded from ZEN.
    --- Called automatically when a player disconnects.
end
```

### 2. Adding Data

If you're building a full server, you'll need to store some kind of data.  
Whether it's player statuses, inventory items, or stats like how many times someone kicked a pigeon it's all up to you to define and manage.

ZEN does **not** provide built-in gameplay data except for a basic `user` account.  
You are **expected** to design and code your own data structures and handle saving/loading.

Here's how to add custom data to your player inside your extension:

```lua
function Example:on_load()
    local player = self.player

    --- Add a new data category called "stats" with default values
    player:add_data("stats", {
        pigeons_kicked = 0
    }, true)  -- 'true' means this data will be replicated to the client

    --- Sync data so the client receives updates
    player:sync_data("stats")
end
```

* Use `player:add_data(category, value, replicate)` to add your custom data category.
* Call `player:sync_data(category)` whenever you want to update the client with changes.

That's it!
You've now extended ZEN with your own custom data.
The core player functions `:has_data`, `:get_data`, `:remove_data`, `:set_data`, and `:sync_data` will work with your data category seamlessly.

### 3. Adding Methods

Now that you've added data for your extension, you’ll probably want to add ways to interact with it.  
You can do this by using the `:add_method` function. That's it — simple, right?

Here's an example that adds a method to increment the number of pigeons kicked by the player:

```lua
function Example:on_load()
    local player = self.player

    --- (Assume you already added 'stats' data in on_load)

    --- Add a new method called "kicked_pigeon" to increase the counter
    player:add_method("kicked_pigeon", function(p)
        local stats = p:get_data("stats")
        if stats then
            stats.pigeons_kicked = (stats.pigeons_kicked or 0) + 1
            p:set_data("stats", stats, true) -- Update and sync the data
        end
    end)

    --- You can run your method immediately like so on the player if you need to
    player:run_method("kicked_pigeon")
end
```

* `:add_method(name, fn)` registers a new callable method on the player object.
* Inside the method, use `:get_data` and `:set_data` to read and update your stored data.
* The third argument in `:set_data` (`true`) syncs the updated data with the client automatically.

Now you can call this method anywhere like:

```lua
player:run_method("kicked_pigeon")
```

This makes extending your player with custom logic and data interactions a walk in the park!

### 4. Saving Players

Need to save something custom?  
You probably will — you're building a server core.

Use the `:on_save()` function in your extension to handle saving your custom data.  
This function is called automatically when a player disconnects or when the server shuts down.

```lua
function Example:on_save()
    local player = self.player

    -- Retrieve your custom data
    local stats = player:get_data("stats")

    if stats then
        -- Save your data to a database, file, or external storage here
        -- For example, a hypothetical function:
        SavePlayerStatsToDatabase(player.unique_id, stats)
    end
end
```

* Make sure to save all important custom data here to avoid losing progress.
* The core ZEN system will call all extensions' `:on_save()` functions automatically.

That way, your player data stays consistent and persistent.

### 5. Player Unload

This function runs when a player is unloaded from ZEN — usually when they disconnect from the server.  
You can use `:on_unload()` to clean up resources, save temporary data, or perform any final logic.

```lua
function Example:on_unload()
    local player = self.player

    --- Log that the player is unloading
    print(("Player %s (%d) is unloading. Saving data..."):format(player.unique_id, player.source))

    --- You could perform any final save or cleanup here
    --- e.g. save custom data to database

    --- (Optional) call save explicitly if needed
    player:save()
end
```

Use this hook to keep your extension's data consistent and clean when players leave.

---

## Wrapping Up

There you have it you've just extended ZEN!  
From adding custom data to creating methods and handling saves, you now have the tools to build anything from simple stats tracking to full gameplay systems.

Remember:  
* Keep your extensions modular.  
* Use lifecycle functions to hook into player events cleanly.  
* Always save important data in `:on_save()` and clean up in `:on_unload()`.

Now go build something awesome, or something crappy, no-ones judging you.