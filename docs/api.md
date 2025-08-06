# API

ZEN exposes its functionality through a simple API.

The api is namespaced, so you must get the namespace into your project first.

This is common practice and most people should be familiar with doing this.

## Getting the API

To use ZEN functions in any resource, retrieve the API object:

```lua
local zen <const> = exports.zen:api()

AddEventHandler("playerJoining", function()
    local src = source

    -- Create and register player
    local player = zen.create_player(src)

    -- Add some data
    zen.add_player_data(src, "stats", { health = 100 }, true)

    -- Log when loaded
    if zen.has_player_loaded(src) then
        print(("Player %s is loaded"):format(src))
    end
end)
```

---

## Server Functions

### create_player
Creates and registers a new player instance.

#### Params
* `source` (number): Player server ID.

#### Returns
* `Player|nil`

```lua
local player = zen.create_player(source)
```

---

### get_player

Returns the Player instance for a given source.

#### Params

* `source` (number)

#### Returns

* `Player|nil`

```lua
local player = zen.get_player(source)
```

---

### remove_player

Removes a Player from the registry.

#### Params

* `source` (number)

```lua
zen.remove_player(source)
```

---

### save_player

Calls `:save()` on the Player instance.

#### Params

* `source` (number)

```lua
zen.save_player(source)
```

---

### unload_player

Unloads a Player and removes from registry.

#### Params

* `source` (number)

```lua
zen.unload_player(source)
```

---

### has_player_loaded

Checks if a Player has completed loading.

#### Params

* `source` (number)

#### Returns

* `boolean`

```lua
if zen.has_player_loaded(source) then
    print("Player is loaded")
end
```

---

### add_player_data

Adds a new data category to a Player.

#### Params

* `source` (number)
* `category` (string)
* `value` (any)
* `replicate` (boolean, optional)

#### Returns

* `boolean`

```lua
zen.add_player_data(source, "inventory", {}, true)
```

---

### get_player_data

Gets Player data for a category or all categories.

#### Params

* `source` (number)
* `category` (string, optional)

#### Returns

* `any`

```lua
local inv = zen.get_player_data(source, "inventory")
```

---

### has_player_data

Checks if Player has a specific data category.

#### Params

* `source` (number)
* `category` (string)

#### Returns

* `boolean`

```lua
if zen.has_player_data(source, "stats") then
    print("Player stats exist")
end
```

---

### set_player_data

Updates a data category.

#### Params

* `source` (number)
* `category` (string)
* `updates` (table)
* `sync` (boolean, optional)

#### Returns

* `boolean`

```lua
zen.set_player_data(source, "stats", { health = 90 }, true)
```

---

### remove_player_data

Removes a Player data category.

#### Params

* `source` (number)
* `category` (string)

```lua
zen.remove_player_data(source, "temporary_buff")
```

---

### sync_player_data

Forces sync of a category to the client.

#### Params

* `source` (number)
* `category` (string, optional)

```lua
zen.sync_player_data(source, "inventory")
```

---

### update_user_data

Updates `user` data and propagates to Graft.

#### Params

* `source` (number)
* `updates` (table)

#### Returns

* `boolean`

```lua
zen.update_user_data(source, { rank = "admin" })
```

---

### add_player_method

Adds a method to Player.

#### Params

* `source` (number)
* `name` (string)
* `fn` (function)

#### Returns

* `boolean`

```lua
zen.add_player_method(source, "heal", function(self, amount)
    self:set_data("stats", { health = self:get_data("stats").health + amount }, true)
end)
```

---

### remove_player_method

Removes a method from Player.

#### Params

* `source` (number)
* `name` (string)

```lua
zen.remove_player_method(source, "heal")
```

---

### run_player_method

Executes a registered Player method.

#### Params

* `source` (number)
* `name` (string)
* `...` (any)

#### Returns

* `any`

```lua
zen.run_player_method(source, "heal", 25)
```

---

### has_player_method

Checks if Player has a method.

#### Params

* `source` (number)
* `name` (string)

#### Returns

* `boolean`

```lua
if zen.has_player_method(source, "heal") then
    print("Heal method available")
end
```

---

### get_player_method

Retrieves a method function.

#### Params

* `source` (number)
* `name` (string)

#### Returns

* `function|nil`

```lua
local heal = zen.get_player_method(source, "heal")
```

---

### add_player_extension

Adds an extension to Player.

#### Params

* `source` (number)
* `name` (string)
* `ext` (table)

#### Returns

* `boolean`

```lua
zen.add_player_extension(source, "inventory_system", my_inventory_ext)
```

---

### get_player_extension

Gets an extension from Player.

#### Params

* `source` (number)
* `name` (string)

#### Returns

* `table|nil`

```lua
local inv_ext = zen.get_player_extension(source, "inventory_system")
```

---

### has_player_extension

Checks if Player has an extension.

#### Params

* `source` (number)
* `name` (string)

#### Returns

* `boolean`

```lua
if zen.has_player_extension(source, "inventory_system") then
    print("Inventory extension exists")
end
```

---

### list_player_extensions

Lists all registered extensions.

#### Params

* `source` (number)

#### Returns

* `table`: Array of extension names.

```lua
local exts = zen.list_player_extensions(source)
```

---

### dump_player_data

Logs Player data.

#### Params

* `source` (number)

```lua
zen.dump_player_data(source)
```

---

## Client Functions

### get_player_data

Gets synced Player data (all or category).

#### Params

* `category` (string, optional)

#### Returns

* `any`

```lua
local stats = zen.get_player_data("stats")
```

---

### has_player_data

Checks if category exists in client-side Player data.

#### Params

* `category` (string)

#### Returns

* `boolean`

```lua
if zen.has_player_data("inventory") then
    print("Client inventory exists")
end
```

---

### dump_player_data

Logs all client-side Player data.

```lua
zen.dump_player_data()
```

---

## Server Events

### `zen:sv:player_loaded`

Triggered when a Player finishes loading (after hooks and extensions).

#### Params

* `player` (Player): Player instance

```lua
AddEventHandler("zen:sv:player_loaded", function(player)
    print(("Player %s loaded"):format(player.unique_id))
end)
```

---

### `zen:sv:player_unload`

Triggered before a Player is removed from the registry.

#### Params

* `player` (Player): Player instance

```lua
AddEventHandler("zen:sv:player_unload", function(player)
    print(("Player %s unloading"):format(player.unique_id))
end)
```

---

### `zen:sv:player_save`

Triggered when a Player is saved (manual save or on disconnect).

#### Params

* `player` (Player): Player instance

```lua
AddEventHandler("zen:sv:player_save", function(player)
    print(("Player %s saved"):format(player.unique_id))
end)
```

---

## **Client Events**

### `zen:cl:sync_data`

Triggered when the server sends updated Player data to the client.

#### Params

* `payload` (table): Key-value pairs of synced categories

```lua
RegisterNetEvent("zen:cl:sync_data", function(payload)
    print("Received data sync:", json.encode(payload))
end)
```

---

### `zen:cl:player_loaded`

Triggered when the Player finishes loading on the server and sends a client-safe initial version of their data.

#### Params

* `meta` (table): Safe Player metadata
  * `source` (number) — Player source ID
  * `username` (string) — Player username (sanitized)
  * Other safe public fields

```lua
RegisterNetEvent("zen:cl:player_loaded", function(meta)
    if type(meta) ~= "table" or not meta.source then 
        log("error", "player_meta_missing")
        return 
    end
    log("info", translate("player_loaded_client", meta.username, meta.source))
end)
```