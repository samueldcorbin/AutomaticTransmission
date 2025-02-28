ChatEdit_InsertLink = (function (hookedFunc)
    return function (text)
       if hookedFunc(text) then
            -- game already pasted the link somewhere
            return
        end

        local linkType, firstParam = strmatch(text, "|H(%a+):(%d+)")

        -- don't paste link if they were using Shift+click to split a stack
        if linkType == "item" then
            local itemID = tonumber(firstParam)
            local foci = GetMouseFoci()
            for i, region in ipairs(foci) do
                if region.GetSlotAndBagID then
                    local slot, bag = region:GetSlotAndBagID()
                    if slot and bag and C_Container.GetContainerItemID(bag, slot) == itemID then
                        if region.count > 1 then
                            return
                        end
                        break
                    end
                end
            end
        -- don't paste link if they were using Shift+click to track/untrack a quest
        elseif linkType == "quest" then
            local foci = GetMouseFoci()
            for i, region in ipairs(foci) do
                -- Shift+click on quest tracker entry
                local parent = region
                while parent do
                   if parent == ObjectiveTrackerFrame or parent == QuestScrollFrame then
                        return
                    end
                    parent = parent:GetParent()
                end

                -- Shift+click on quest map pin
                if region.GetQuestID then
                    return
                end
            end
        end

        local edit_box = LAST_ACTIVE_CHAT_EDIT_BOX
        if C_CVar.GetCVar("chatStyle") == "classic" then
            edit_box:Show()
        end
        edit_box:Insert(text)
    end
end)(ChatEdit_InsertLink)
