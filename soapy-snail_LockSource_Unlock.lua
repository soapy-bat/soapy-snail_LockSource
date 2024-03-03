--[[

LockSource_Unlock

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

-- ####### user settings ####### --

local safeLanes = 1 -- Lanes that will not be locked, indexed from the topmost lane

-- ####### variables ####### --

local r = reaper

-- ####### functions ####### --

function main()

  r.Undo_BeginBlock()
  
  r.PreventUIRefresh(1)

  UnlockItemsInSourceLanes()
  
  r.PreventUIRefresh(-1)
  r.UpdateArrange()
  r.Undo_EndBlock("Unlock Items in Source Lanes", -1)

end

---------------------------------------------------------

function UnlockItemsInSourceLanes()

  r.Main_OnCommand(40289, 0) -- Deselect all items

  r.SelectAllMediaItems(0, 1)

  for i = 0, r.CountSelectedMediaItems(0) - 1 do

    local mediaItem = r.GetSelectedMediaItem(0, i)

    local itemLane = r.GetMediaItemInfo_Value(mediaItem, "I_FIXEDLANE")

    if itemLane >= safeLanes then

      r.SetMediaItemInfo_Value(mediaItem, "C_LOCK", 0)

    end

  end

  r.Main_OnCommand(40289, 0) -- Deselect all items

end

-- ####### code execution starts here ####### --
main()
