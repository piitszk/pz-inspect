# 3D Entity Inspector

## Description

The 3D Entity Inspector provides a 3D effect for inspecting entities, commonly used in game puzzles where interaction with objects is required. This system allows players to view, rotate, and interact with objects in a three-dimensional space, enhancing the gaming experience by providing a more immersive and detailed view of the entities.

## Usage

### Events

**TriggerClientEvent("Inspect:Preview", source, ObjectId, Settings, Callback)**

### Exports

**exports["pz-inspect"]:Preview(ObjectId, Settings, Callback)**

## Parameters

- **ObjectId**: The ID of the object to be inspected.
- **Settings**: A table with the following property:
  - **Camera**: (Default: `true`) Defines whether a camera should be created for the object or not.
- **Callback**: The function that will be called when the inspection is closed.

## Example

```lua
local Entity = 98823
local Settings = { Camera = true } -- Can be nil
local Callback = function()
    -- Do Something when Close
end

TriggerClientEvent("Inspect:Preview", source, Entity, Settings, Callback)
exports["pz-inspect"]:Preview(Entity, Settings, Callback)
```