RegisterServerEvent("lg-identification:identify")
AddEventHandler("lg-identification:identify", function(identity)
    local src = source
    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    for k,v in ipairs(GetPlayers()) do
        if #(playerCoords - GetEntityCoords(GetPlayerPed(v))) < Config.Data.DisplayDistance then
            TriggerClientEvent("lg-identification:identify", v, identity)
        end
    end
end)

function SetIdentification(source, identity)
    if (source == -1) then return end
    TriggerEvent("lg-identification:set", source, identity)
end

exports("SetIdentification", SetIdentification)