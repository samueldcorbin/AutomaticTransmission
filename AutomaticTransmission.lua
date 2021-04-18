-- This returns true when ChatEdit_InsertLink would return true, but without the side effects
local function link_was_inserted(text)

    if MacroFrameText and MacroFrameText:HasFocus() then
        return true
    end

    if TradeSkillFrame and TradeSkillFrame.SearchBox:HasFocus() then
        local item
        if strfind(text, "item:", 1, true) then
            item = GetItemInfo(text)
        end
        if item then
            return true
        end
    end

    if CommunitiesFrame and CommunitiesFrame.ChatEditBox:HasFocus() then
        return true
    end

    if ChatEdit_GetActiveWindow() then
        return true
    end

    if AuctionHouseFrame and AuctionHouseFrame:IsVisible() then
        local item
        if strfind(text, "battlepet:") then
            local petName = strmatch(text, "%[(.+)%]")
            item = petName
        elseif strfind(text, "item:", 1, true) then
            item = GetItemInfo(text)
        end
        if item then
            local display_modes = {[AuctionHouseFrameDisplayMode.Buy] = true,
                                   [AuctionHouseFrameDisplayMode.ItemBuy] = true,
                                   [AuctionHouseFrameDisplayMode.WoWTokenBuy] = true,
                                   [AuctionHouseFrameDisplayMode.CommoditiesBuy] = true}
            if display_modes[AuctionHouseFrame.displayMode] then
                return true
            end
        end
    end

    return false
end

hooksecurefunc("ChatEdit_InsertLink", function (text)
    if not text then
        return
    end

    if link_was_inserted(text) then
        return
    end

    local edit_box = LAST_ACTIVE_CHAT_EDIT_BOX
    if C_CVar.GetCVar("chatStyle") == "classic" then
        edit_box:Show()
    end
    edit_box:Insert(text)
    edit_box:SetFocus()
end)
