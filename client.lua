local CurrentData = {
    image =         nil,
    name =          nil,
    age =           nil,
    sex =           nil,
    number_id =     nil,
    rank =          nil,
    department =    nil
}

RegisterCommand("showid", function()
    ShowID()
end, false)

RegisterCommand("editid", function()
    EditID()
end, false)

RegisterCommand("hideid", function()
    SendNUIMessage({type = "hide"})
    SetNuiFocus(false, false)
end, false)

RegisterNUICallback("editSubmit", function(data, cb)
    if not (Config.Functions.CanEditIdentity()) then return end
    local data = Config.Functions.OnEditSubmit(data)
    SetIdentification(data)
    SetNuiFocus(false, false)
end)

RegisterNetEvent("lg-identification:identify")
AddEventHandler("lg-identification:identify", function(data, coords)
    SendNUIMessage({type = "id", data = data})
end)

Citizen.CreateThread(function() 
    local data = GetResourceKvpString("ID_DATA")
    if data then
        CurrentData = json.decode(data)
    else 
        SetIdentification(CurrentData)
    end
    Citizen.Wait(100)
    SendNUIMessage({type = "config", data = Config.Data})
end)

function SetIdentification(data)
    CurrentData = data
    SetResourceKvp("ID_DATA", json.encode(CurrentData))
end

function GetIdentification()
    return CurrentData
end

function ShowID()
    if not Config.Functions.CanDisplayIdentity() then return end

    TriggerServerEvent("lg-identification:identify", CurrentData)
    
    local model = GetHashKey("prop_fib_badge")
    local anim = {dictionary = "paper_1_rcm_alt1-9", animation = "player_one_dual-9"}
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(10)
    end
    RequestAnimDict(anim.dictionary)
    while not HasAnimDictLoaded(anim.dictionary) do
        Citizen.Wait(100)
    end
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local badgeProp = CreateObject(model, coords.x, coords.y, coords.z + 0.2, true, true, true)
    local boneIndex = GetPedBoneIndex(ped, 28422)
    
    AttachEntityToEntity(badgeProp, ped, boneIndex, 0.065, 0.029, -0.035, 80.0, -1.90, 75.0, true, true, false, true, 1, true)
    TaskPlayAnim(ped, anim.dictionary, anim.animation, 8.0, -8, 10.0, 49, 0, 0, 0, 0)
    Citizen.Wait(3000)
    ClearPedSecondaryTask(ped)
    DeleteObject(badgeProp)
end

function EditID()
    if not (Config.Functions.CanEditIdentity()) then return end
    SendNUIMessage({type = "edit", data = CurrentData})
    SetNuiFocus(true, true)
end

RegisterNetEvent("lg-identification:editID")
AddEventHandler("lg-identification:editID", function(data)
    EditID()
end)

RegisterNetEvent("lg-identification:showID")
AddEventHandler("lg-identification:showID", function()
    ShowID()
end)

RegisterNetEvent("lg-identification:set")
AddEventHandler("lg-identification:set", function(data)
    SetIdentification(data)
end)

exports("EditID", EditID)
exports("ShowID", ShowID)
exports("SetIdentification", SetIdentification)
exports("GetIdentification", GetIdentification)
