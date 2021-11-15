# Long-Use-Ent-Base

### What is it?
Long Use Ent Base is an entity base for Garry's Mod that allows you to create hold-to-use entities.  

### How do I use it?
Have this addon on your server and base your desired entities on "long_use_base".  
There's a lot more to it, so I'm just gonna copy+paste the workshop description.  

To use this entity base, set your custom entity's ENT.Base to "long_use_base" and then make sure you take the following steps to make your entity utilize this base properly:  
• In your `ENT:Initialize function`, set your use type to continuous via `self:SetUseType( CONTINUOUS_USE )`.  
• Remove your `ENT:Use` function entirely.  
• Set `ENT.TimeToUse` to however many seconds you want your players to have to hold your entity for.  
• Optionally `ENT:SetDrawKeyPrompt( false )` if you don't want the E key to show on screen.  
• Optionally `ENT:SetDrawProgress( false )` if you don't want the progress ring to show on screen.  
• Create a server function `ENT:OnUseStart( ply )` that gets called when a player starts holding E on the entity.  
• Create a server function `ENT:OnUseFinish( ply )` that gets called when a player has held E for TimeToUse seconds.  
• Create a server function `ENT:OnUseCancel( ply )` that gets called when a player releases E early.  This can be empty, but it needs to be there.  
• Optionally create a shared `ENT.PartialUses` table with values being tables with a number "prog" as the percentage of use to call the function "func" to do at the respective step (with the entity as its parameter).  
And that's all!  Your long-use entity should be ready to go!  

**If you need a custom SetupDataTables hook, you must do the following:**  
• Add the line `DEFINE_BASECLASS( ENT.Base )` somewhere near the top of the file.  
• Add your NetworkVars.  **If you need a Float and/or an Entity, start at 1 for each instead of 0, and for Bool, start at 2!**  This base uses Float and Entity slot 0 and Bool slots 0 and 1 to work!  
• Do all of the rest of your SetupDataTables code.  
• As the last line of your SetupDataTables hook, add the line `BaseClass.SetupDataTables( self )`.  

**If you need a custom Think hook, you must do the following:**  
• Add the line `DEFINE_BASECLASS( ENT.Base )` somewhere near the top of the file.  
• Do all of your Think code.  
• As the last line of your Think hook, add the line `BaseClass.Think( self )`.  

This entity adds a server function unique to it and derived entities, `ENT:CancelUse()`, which will successfully cancel use if called.  

Better documentation can be found at https://sweptthr.one/docs/long_use_entity_base  

### Where's the workshop version?
Here: https://steamcommunity.com/sharedfiles/filedetails/?id=2151694210
