local function MayCoSort(memberFrame1, memberFrame2)
  local roleOrder = {
    ["TANK"] = 3,
    ["HEALER"] = 1,
    ["DAMAGER"] = 2,
    ["NONE"] = 4
  }

  local unitName1 = memberFrame1:GetName().."Name"
  local unitName2 = memberFrame2:GetName().."Name"

  local name1 = _G[unitName1]:GetText()
  local name2 = _G[unitName2]:GetText()

  local role1 = UnitGroupRolesAssigned(memberFrame1.unit)
  local role2 = UnitGroupRolesAssigned(memberFrame2.unit)

  if (name1 and name2) then
      print("Comparing: ", name1, name2)
      print("Roles: ", role1, role2)
      print("Role order: ", roleOrder[role1], roleOrder[role2])

      -- If the roles are the same, fall back to sorting alphabetically
      if roleOrder[role1] == roleOrder[role2] then
          return strlower(name1) < strlower(name2)
      else
          return roleOrder[role1] < roleOrder[role2]
      end
  end
end

local function myUpdateLayoutFunc(frame)
  -- If the frame name starts with CompactRaidGroup
  local frameName = frame:GetName()
  if frameName and frameName:match("^CompactRaidGroup%d+$") then
    print("Updating frame: ", frameName)

    -- Clear existing positioning
    frame:ClearAllPoints()

    -- Change the group title to "Bananas"
    local title = _G[frame:GetName().."Title"]

    -- Get all of the member frames into an array
    local members = {}

    -- Get the number of members in this group
    local numMembers = GetNumGroupMembers()

    -- Add each member frame to the array
    for i=1, numMembers do
      local member = _G[frame:GetName().."Member"..i]
      table.insert(members, member)
    end

    -- Sort the member table by role and then name
    table.sort(members, MayCoSort)

    print("THEY HAVE BEEN SORTED")

    -- Reset positioning of all member frames
    for i=1, #members do
      local member = members[i]
      member:ClearAllPoints()
    end

    -- Reposition member frames based on sorted order
    for i=1, #members do
      local member = members[i]

      if i == 1 then
        -- If it's the first member, attach it to the bottom of the group title
        member:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, 0)
      else
        -- Otherwise, set it to the bottom of the previous member
        local previousMember = members[i-1]
        member:SetPoint("TOPLEFT", previousMember, "BOTTOMLEFT", 0, 0)
      end
    end
  end
end

local frame = CreateFrame("FRAME")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:SetScript("OnEvent", function(self, event, ...)
  if event == "GROUP_ROSTER_UPDATE" then
    C_Timer.After(0.5, function()


    -- START EVENT HANDLE
    -- Print the frame that was updated
    -- Iterate through groups 1 - 8
    for i=1, 8 do
      local frame = _G["CompactRaidGroup"..i]

      if frame then
        -- Iterate each child of the frame and increment a counter if
        -- it starts with CombatRaidGroupiMember
        local numMembers = 0
        for j=1, frame:GetNumChildren() do
          local child = select(j, frame:GetChildren())
          if string.find(child:GetName(), "CompactRaidGroup"..i.."Member") then
            -- Anmd that child has a unit attached
            if child.unit then
              numMembers = numMembers + 1
            end

          end
        end

        print("Group "..i.." has "..numMembers.." members")
        myUpdateLayoutFunc(frame)
      end



    end

    -- myUpdateLayoutFunc()
    end)
  end
  -- END EVENT HANDLE
end)

hooksecurefunc("CompactRaidGroup_UpdateLayout", myUpdateLayoutFunc)
print("Hi, I'am MayCo! <3")



-- hooksecurefunc("CRFSort_Group", function(token1, token2)
--   print("YEP", token1, token2)

--   local id1 = tonumber(string.sub(token1, 5));
--   local id2 = tonumber(string.sub(token2, 5));


--   if ( not id1 or not id2 ) then
--     return id1;
--   end

--   local _, _, subgroup1, _, _, _, _, _, _, _, _, role1 = GetRaidRosterInfo(id1);
--   local _, _, subgroup2, _, _, _, _, _, _, _, _, role2 = GetRaidRosterInfo(id2);

--   print(subgroup1, subgroup2)
--   print(role1, role2)
-- end)

-- hooksecurefunc("CompactRaidGroup_UpdateUnits", function(frame)
--   print("in update units")

--   if not frame.isParty and ShouldShowRaidFrames() then
-- 		local groupIndex = frame:GetID();
-- 		local frameIndex = 1;

-- 		for i=1, GetNumGroupMembers() do
--       local name, rank, subgroup, level, class, fileName, zone, online, isDead, dunno, foo, role, baz = GetRaidRosterInfo(i)

--       if ( subgroup == groupIndex and frameIndex <= MEMBERS_PER_RAID_GROUP ) then
--         local unitToken;
--         if IsInRaid() then
--           unitToken = "raid"..i;
--         else
--           if i == 1 then
--             unitToken = "player";
--           else
--             unitToken = "party"..(i - 1);
--           end
--         end

--         local thingy = _G[frame:GetName().."Member"..frameIndex]
--         print("thingy: ", thingy)
--         print("frame name:", frame:GetName())
--         print(unitToken)
--         print('frameIndex: ', frameIndex)

--         -- CompactUnitFrame_SetUnit(_G[frame:GetName().."Member"..frameIndex], unitToken);
--         frameIndex = frameIndex + 1;
--       end

--     end
--   end
-- end)

-- hooksecurefunc("CompactRaidFrame_UpdateVisible", function(frame)
--   print("I'ma lso in update visible for the frame: ", frame:GetName())
-- end)
-- hooksecurefunc("CompactRaidGroup_UpdateLayout", function(frame, header)
--   print("CompactRaidGroup_UpdateLayout - This frame is updating in hook")
--   print(frame:GetName())
--   print(header)



--   -- if frame and frame:GetName() == "CompactRaidFrameContainer" then
--   --   frame:SetSortFunction(MayCoSort)
--   -- end
-- end)

-- hooksecurefunc("CompactPartyFrame_SetFlowSortFunction", function(self, sortFunc)
--   print("The flow function is being changed: ")
--   print("To: ", sortFunc)
--   print("From: ", CompactPartyFrame.flowSortFunc)
-- end)

-- hooksecurefunc("CompactRaidFrameContainer_AddPlayers", function(self, header, ...)
--   if header and header:GetName() == "CompactRaidFrameManagerDisplayFrame" then
--     header:SetSortFunction(MayCoSort)
--   end
-- end)

-- hooksecurefunc("CompactRaidGroup_UpdateUnits", function(frame)
--   print("HOOKHOOK: ", frame)
--   if not frame.isParty and ShouldShowRaidFrames() then
--   	local groupIndex = frame:GetID();
-- 		local frameIndex = 1;

--     print("groupIndex: ", groupIndex)

--     print("num group members: ", GetNumGroupMembers())

--     for i=1, GetNumGroupMembers() do
--       local name, rank, subgroup, level, class, fileName, zone, online, isDead, role = GetRaidRosterInfo(i)
--       print(GetRaidRosterInfo(i))
--       print("NRS", name, rank, subgroup, role)

--       -- rank = party leader
--       -- subgroup = raid group number

--       if ( subgroup == groupIndex and frameIndex <= MEMBERS_PER_RAID_GROUP ) then
-- 				local unitToken;
-- 				if IsInRaid() then
-- 					unitToken = "raid"..i;
-- 				else
-- 					if i == 1 then
-- 						unitToken = "player";
-- 					else
-- 						unitToken = "party"..(i - 1);
-- 					end
-- 				end

--         print("unitToken = ", unitToken)

-- 				-- CompactUnitFrame_SetUnit(_G[frame:GetName().."Member"..frameIndex], unitToken);
-- 				frameIndex = frameIndex + 1;
-- 			end

--     end
--   end
-- end)
