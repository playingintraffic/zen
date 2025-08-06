![pit_zen_thumb](https://playingintraffic.site/site/public/assets/images/resource_thumbnails/pit_zen_thumb.jpg)

# ZEN - Zero Extra Nonsense

## Overview

ZEN is a server core.
It's not a roleplay kit, it's not a city template, and it's not a collection of thrown together bloat.

It's a core built around one principle: **Only build what you need.**

* No hardcoded jobs.  
* No baked-in inventories.  
* No spaghetti dependencies to untangle.  

Just a clean, memory-safe core that gives every player their own scoped Lua object, created on join, destroyed on leave, and isolated the entire time.

You get full control.  
You write the extensions.  
You decide what loads.  
You don't fight the core.
If other cores make you unbuild before you build, ZEN lets you start clean and stay clean.

---

## Why This Exists

Because sometimes you just want to build what you need and nothing else.

Every other core ships with someone else's idea of what a server should be.  

ZEN was built to fix that.

If you want a full RP city, you can build it.  
If you want a lightweight minigame server with just names and ranks, you can build that too.  
No rewrites. No fighting the core.

---

## Core Concepts

### Class-Based Player Objects

Every player gets their own `Player` object, created with `Player.new(source)`.  
It exists for the entire sessios and handles:

* **Private state**: internal memory, fully encapsulated  
* **Public data**: accessible, dynamic, and optionally replicated  
* **Extensions**: modular logic injected per player  
* **Lifecycle**: `load`, `save`, and `unload` events  
* **Runtime methods**: logic attached at runtime

No shared buckets. No mystery data. Just a clean object per player.

### Weak-Keyed Private Memory

Internal state is stored using:

```lua
Private = setmetatable({}, { __mode = "k" })
```

Which means:

* Memory cleans itself up when the object is gone
* Private data stays private not exposed or leaked
* You never have to think about manual cleanup

No ghosts. No leaks. No surprises.

### Modular Extensions

Extensions are fully optional components that hook into each player.

They can:

* Register lifecycle logic (`on_load`, `on_save`, `on_unload`)
* Inject new methods
* Store their own isolated data

Extensions don't talk to each other.
They don't break each other.
And they don't require some central config file from 2019.

Load one. Load five. Or load nothing. It still works.

---

## Lifecycle

| Function               | Description                                           |
| -------------------- | ----------------------------------------------------- |
| `Player.new(source)` | Creates a new player object for a source              |
| `:load()`            | Triggers all extension `on_load` hooks and syncs data |
| `:save()`            | Triggers all `on_save` hooks and fires save event     |
| `:unload()`          | Triggers all `on_unload` hooks and cleans up memory   |
| `:has_loaded()`      | Returns whether the player has completed `:load()`    |

---

## Data

| Function                             | Description                                            |
| ---------------------------------- | ------------------------------------------------------ |
| `:add_data(key, value, replicate)` | Adds new data under a category (optionally replicated) |
| `:get_data(key)`                   | Gets a specific category or all data                   |
| `:set_data(key, updates, sync)`    | Updates an existing data table and optionally syncs    |
| `:remove_data(key)`                | Deletes a category and syncs its removal               |
| `:has_data(key)`                   | Checks if the category exists                          |
| `:sync_data(key?)`                 | Sends replicated data to the client                    |
| `:update_user_data(tbl)`           | Updates persistent graft user data safely              |

---

## Extensions

| Function                      | Description                                     |
| --------------------------- | ----------------------------------------------- |
| `:add_extension(name, ext)` | Attaches a new extension instance to the player |
| `:get_extension(name)`      | Returns an attached extension                   |
| `:has_extension(name)`      | Checks if an extension is present               |
| `:list_extensions()`        | Returns a list of loaded extension names        |

Lifecycle hooks that extensions can define:

* `on_load(self)`
* `on_save(self)`
* `on_unload(self)`

All are triggered automatically via lifecycle events.

---

## Methods

| Function                   | Description                                                 |
| ------------------------ | ----------------------------------------------------------- |
| `:add_method(name, fn)`  | Adds a named method callable on this player object          |
| `:remove_method(name)`   | Removes a method by name                                    |
| `:run_method(name, ...)` | Runs a method if it exists, passing the player as first arg |
| `:has_method(name)`      | Returns whether a method exists                             |
| `:get_method(name)`      | Returns the function reference if defined                   |

Extensions use this to inject flexible logic without needing to touch the core files.

---

## Debug

| Function         | Description                           |
| -------------- | ------------------------------------- |
| `:dump_data()` | Logs the player's full public dataset |

---

## Design Principles

* Each player gets a real Lua object (`Player.new(source)`), not a shared table
* All player state is encapsulated no external table mutation allowed
* Private memory is weak-keyed and auto-released on disconnect
* Systems are written as extensions, not crammed into the core
* You choose what data to replicate clients only get what you send
* Globals are intentional, static, and scoped. No bleed, no magic

---

## Summary

ZEN is a clean, class-based server core.

It doesn't decide what your server is, it just gives you a secure, scalable foundation to build on.

You control what gets added.
You control what gets saved.
You control what gets synced.

ZEN just handles the structure.
You handle the systems.

--- 

## Support

Need help or found a bug?

Join the PIT Discord and shout your issues: [https://discord.gg/MUckUyS5Kq](https://discord.gg/MUckUyS5Kq)

**Support Hours:** Mon–Fri, 10AM–10PM GMT
Bring your config file. And a shovel.
