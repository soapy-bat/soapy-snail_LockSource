--[[

LockSource_ToggleLock

This file is part of the soapy-snail_LockSource package.

(C) 2024 the soapy zoo

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.
]]

-- ####### variables ####### --

local r = reaper

local numLanes = 0

-- ####### functions ####### --

function main()

  r.Undo_BeginBlock()
  -- DO NOT PREVENT THE UI FROM REFRESHING
  -- otherwise, the script will not work
  -- this is due to the way REAPER handles track lanes
  -- they are essentially a grid for "free item positioning"
  
  numLanes = GetNumLanes2()
  
  LockItemsInSourceLanes()
  
  r.Undo_EndBlock("Lock Items in Source Lanes", -1)

end

---------------------------------------------------------

function GetNumLanes2()

  local mediaTrack = r.GetSelectedTrack(0, 0)
  return r.GetMediaTrackInfo_Value(mediaTrack, "I_NUMFIXEDLANES") - 1

end

---------------------------------------------------------

function GetFirstPlayingLane(mediaTrack)

  local mediaTrack = mediaTrack
  
  for k = 0, numLanes + 1 do
  
    local laneCommand = "C_LANEPLAYS:" .. k
  
    local playingLane = r.GetMediaTrackInfo_Value(mediaTrack, laneCommand)
    
    if playingLane == 1 or playingLane == 2 then
    
      return laneCommand
    
    end
  end
end

---------------------------------------------------------

function LockItemsInSourceLanes()

  r.Main_OnCommand(40289, 0) -- Deselect all items
  
  local mediaTrack = r.GetSelectedTrack(0, 0)
  local playingLane = GetFirstPlayingLane(mediaTrack)
  
  r.Main_OnCommand(42790, 0) -- play only first lane
  r.Main_OnCommand(43098, 0) -- show/play only one lane
  
  for i = 1, numLanes, 1 do
  
    r.Main_OnCommand(42482, 0) -- play only next lane
     
    r.Main_OnCommand(40289, 0) -- Deselect all items 
    r.Main_OnCommand(40421, 0) -- Item: Select all items in track
    r.Main_OnCommand(40034, 0) -- Item grouping: Select all items in groups
    
    r.Main_OnCommand(40687, 0) -- Item properties: Toggle lock
  
  end
  
  r.Main_OnCommand(43099, 0) -- show/play all lanes
  r.Main_OnCommand(40289, 0) -- Deselect all items
  
  r.SetMediaTrackInfo_Value(mediaTrack, playingLane, 1)
  
  -- Notes:
  -- 40688 Item properties: Lock
  -- 40689 Item properties: Unlock
  -- 40687 Item properties: Toggle lock
  
  -- 42482 Track lanes: Play only next lane
  -- 42481 Track lanes: Play only previous lane
  -- 42790 Track lanes: Play only first lane
  
end

-- ####### code execution starts here ####### --

main()
