local x, y = guiGetScreenSize()
local link = "http://mta/"..getResourceName(getThisResource()).."/web-side/index.html"
local browser = createBrowser(x, y, true, true, false)
local voice = -1

addEventHandler("onClientBrowserCreated", browser, function()
   loadBrowserURL(source, link)
end)


function SendNUIMessage(browser, table)
   if isElement(browser) and type(table) == "table" then
      return executeBrowserJavascript(browser, 'window.postMessage('..toJSON(table)..'[0])')
   end
end

function dxNUI()

    dxDrawImage(0, 0, x, y, browser)
    local time = getRealTime()
    hour = time.hour
    minute = time.minute
    local health = getElementHealth(localPlayer)
    local armour = getPlayerArmor(localPlayer)
    local x,y,z = getElementPosition(localPlayer)
    local city = getZoneName(x, y, z, true)
    local zone = getZoneName(x, y, z)
    local radiof = getElementData(localPlayer, config.elementradio) or 1
    local oxygen = getPedOxygenLevel ( localPlayer ) or 100

      if isPedInVehicle(localPlayer) then
        local veh = getPedOccupiedVehicle(localPlayer)
        local gas = getElementData(veh, config.elementgas) or 100
        local velocity = ( function( x, y, z ) return math.floor( math.sqrt( x*x + y*y + z*z ) * 155 ) end )( getElementVelocity( getPedOccupiedVehicle(localPlayer) ) ) 
        if armour > 1 then
        SendNUIMessage(browser, {  screen = false, vehicle = true, voice = voice, health = health, armour = armour, oxigen = oxygen, street = city.." - "..zone.."", radio = "Radio F: "..radiof, hours = hour, minutes = minute,  fuel = gas, speed = velocity.."kmh" })
    else
        SendNUIMessage(browser, { screen = false, vehicle = true, voice = voice, health = health, oxigen = oxygen, street = city.." - "..zone.."", radio = "Radio F: "..radiof, hours = hour, minutes = minute,  fuel = gas, speed = velocity.."kmh" })
      end
   else
      if armour > 1 then
        SendNUIMessage(browser, { screen = false, vehicle = false, voice = voice, health = health, armour = armour, oxigen = oxygen, street = city.." - "..zone.."", radio = "Radio F: "..radiof, hours = hour, minutes = minute })
      else
        SendNUIMessage(browser, { screen = false, vehicle = false, voice = voice, health = health,  armour = armour, oxigen = oxygen, radio = "Radio F: "..radiof, street = city.." - "..zone.."", hours = hour, minutes = minute })
    end
 end
end
addEventHandler('onClientRender', getRootElement(), dxNUI) 


function VoiceStart()
   voice = 100
 end
 addEventHandler("onClientPlayerVoiceStart", localPlayer, VoiceStart)
 
 function VoiceStop()
   voice = -1
 end
 addEventHandler("onClientPlayerVoiceStop", localPlayer, VoiceStop)