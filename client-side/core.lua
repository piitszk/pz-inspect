local Inspecting = false

function Preview(Entity, Settings, Callback)
    if Inspecting and Inspecting["Entity"] ~= Entity then
        Inspecting = false
    end 

    Inspecting = {}
    Inspecting["Entity"] = Entity
    Inspecting["OnClose"] = (type(Callback) == "function" or Callback.__cfx_functionReference) and Callback or false

    CreateThread(function()
        while Inspecting and DoesEntityExist(Inspecting["Entity"]) do
            SetLocalPlayerInvisibleLocally(true)
            Citizen.Wait(5)
        end

        SetNuiFocus(false, false)
    end)

    FreezeEntityPosition(Entity, true)
    SetNuiFocus(true, true)
    SendNUIMessage({ Action = "Reset", Heading = GetEntityHeading(Entity) })

    Inspecting["Position"] = {}
    Inspecting["Position"]["Coords"] = GetEntityCoords(Entity)
    Inspecting["Position"]["Rotation"] = GetEntityRotation(Entity)

    if not Settings or (Settings and (Settings["Camera"] == nil or Settings["Camera"] == true)) then
        Inspecting["Camera"] = CreateCam("DEFAULT_SCRIPTED_CAMERA",true)
        
        local MinDimension, MaxDimension = GetModelDimensions(Entity)
        local EntityFov = 35.0 + #(MinDimension - MaxDimension)
    
        SetCamCoord(Inspecting["Camera"], GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -1.5, 0.0))
        SetCamActive(Inspecting["Camera"], true)
        SetCamEffect(Inspecting["Camera"], 1)
        SetCamFov(Inspecting["Camera"], EntityFov)
        RenderScriptCams(true, true, 600, true, true)
        PointCamAtEntity(Inspecting["Camera"], Entity, 0.0, 0.0, 0.3, true)
    
        FocusEntity()
    end
end

function FocusEntity()
    local Entity = Inspecting["Entity"]
    local Current = GetEntityCoords(Entity)
    local End = Inspecting["Position"]["Coords"].z + 0.2

    while Current.z < End do
        SetEntityCoordsNoOffset(Entity, Current.xy, Current.z + 0.008, true, true, true)
        Current = GetEntityCoords(Entity)

        Citizen.Wait(10)
    end
end

function LoadModel(Model)
    local Timeout = GetGameTimer() + 2000 

    RequestModel(Model)

    while not HasModelLoaded(Model) and GetGameTimer() < Timeout do
        Citizen.Wait(1)    
    end

    return HasModelLoaded(Model)
end

AddEventHandler("onResourceStop", function(Resource)
    if Resource == GetCurrentResourceName() then
        if Inspecting then
            SetEntityCoords(Inspecting["Entity"], Inspecting["Position"]["Coords"])
            SetEntityRotation(Inspecting["Entity"], Inspecting["Position"]["Rotation"])

            if Inspecting["OnClose"] then
                Inspecting["OnClose"]
            end
        end
    end
end)

RegisterNUICallback("Rotate", function(Data)
    SetEntityRotation(Inspecting["Entity"], Data["y"], 0, Data["x"])
end)

RegisterNUICallback("CloseInspect", function()
    SetEntityCoords(Inspecting["Entity"], Inspecting["Position"]["Coords"])
    SetEntityRotation(Inspecting["Entity"], Inspecting["Position"]["Rotation"])

    if DoesCamExist(Inspecting["Camera"]) then
        RenderScriptCams(false,true,600,false,false)
        SetCamActive(Inspecting["Camera"], false)
        DestroyCam(Inspecting["Camera"])
    end

    if Inspecting["OnClose"] then
        Inspecting["OnClose"]
    end

    Inspecting = false
end)

RegisterNetEvent("Inspect:Preview", function(Data)
    if type(Data) == "table" then
        local Entity = Data[1]
    
        if not Inspecting and DoesEntityExist(Entity) then
            Preview(Entity)
        end
    end
end)

exports("Preview", Preview)