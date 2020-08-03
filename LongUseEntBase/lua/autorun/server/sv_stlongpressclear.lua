hook.Add( "Tick", "OhFuckCheckForUsers", function()

    for k,v in pairs( ents.GetAll() ) do
        if v.IsProgressUsable and IsValid( v:GetUser() ) then
            if !IsValid( v:GetUser():GetUseEntity() ) and v:GetUser():GetUseEntity() != v then
                v:SetUser( nil )
                v:SetProgress( -1 )
            end
        end
    end

end )