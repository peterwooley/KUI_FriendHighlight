local addon = KuiNameplates
local mod = addon:NewPlugin('FriendHighlight',1005)

local UnitIsPlayer,UnitIsOtherPlayersPet,GetGuildInfo=
      UnitIsPlayer,UnitIsOtherPlayersPet,GetGuildInfo

local function Frame_UpdateGuildText(f)
    f.FriendHighlight_UpdateGuildText(f);

    -- Check if unit is a player and--importantly--not you
    -- Fix provided by tflo
    -- https://github.com/peterwooley/KUI_FriendHighlight/issues/1
    if UnitIsPlayer(f.unit) and not UnitIsUnit(f.unit, 'player') then
        local friend = C_FriendList.IsFriend(UnitGUID(f.unit))
        if friend then
            mod:ShowFriendIcon(f)
            return
        end

        local guild = f.state.guild_text
        if not guild then 
            if f.FriendHighlight ~= nil then f.FriendHighlight:Hide() end
            return
        end

        local myGuild = GetGuildInfo("player")
        if not myGuild then
            return
        end

        if guild == myGuild then
            --print(f.state.name .. " is not in your guild.")
            mod:ShowGuildIcon(f)
        else
            --print(f.state.name .. " is not in your guild.")
            if f.FriendHighlight ~= nil then f.FriendHighlight:Hide() end
        end
    else
        if f.FriendHighlight ~= nil then f.FriendHighlight:Hide() end
    end
end

function mod:ShowGuildIcon(f)
    local i = f:CreateTexture()
    i:SetAtlas("hud-microbutton-communities-icon-notification")
    i:SetHeight(17)
    i:SetWidth(17)

    mod:ShowIcon(f, i)
end

function mod:ShowFriendIcon(f)
    local i = f:CreateTexture()
    i:SetAtlas("friendslist-favorite", true)

    mod:ShowIcon(f, i)
end

function mod:ShowIcon(f, i)
    if f.FriendHighlight ~= nil then
        f.FriendHighlight:Hide()
        f.FriendHighlight = nil
    end

    i:SetPoint('LEFT',f.NameText,'RIGHT')
    f.FriendHighlight = i
end

function mod:Create(f)
    f.FriendHighlight_UpdateGuildText = f.UpdateGuildText
    f.UpdateGuildText = Frame_UpdateGuildText
end

function mod:OnEnable()
    self:RegisterMessage('Create')
end

