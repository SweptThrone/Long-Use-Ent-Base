AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Progress Usable"
ENT.Author = "SweptThrone"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.AutomaticFrameAdvance = true
ENT.ProgPerTick = 0 -- used internally, this should not be changed
ENT.TimeToUse = ENT.TimeToUse or 1.5 -- the user can edit this
ENT.LastProg = -1 -- used internally, this should not be changed
--ENT.DrawKeyPrompt = true -- deprecated, use self:SetDrawKeyPrompt( b )
--ENT.DrawProgress = true -- deprecated, use self:SetProgress( b )

ENT.PartialUses = {}
--[[ this is an example of a filled-in PartialUses table
	if your TimeToUse is too short,
	some intermittent steps may not get called.
	for example, this very table on a TimeToUse = 0.5 or even 1
	only calls 0, 60, and 99.
	i'm sure if you did any amount of research,
	you could get this down to a science.
	TimeToUse = 1.5 (default) works fine with this table.

ENT.PartialUses = {
	[0] = function( ent )
		ent:EmitSound( "buttons/blip1.wav", 75, 38 )
	end,
	[20] = function( ent )
		ent:EmitSound( "buttons/blip1.wav", 75, 50 )
	end,
	[40] = function( ent )
		ent:EmitSound( "buttons/blip1.wav", 75, 63 )
	end,
	[60] = function( ent )
		ent:EmitSound( "buttons/blip1.wav", 75, 75 )
	end,
	[80] = function( ent )
		ent:EmitSound( "buttons/blip1.wav", 75, 88 )
	end,
	[99] = function( ent )
		ent:EmitSound( "buttons/blip1.wav", 75, 99 )
	end
}
]]

function ENT:SetupDataTables()
	self:NetworkVar( "Float", 0, "Progress" )
	self:NetworkVar( "Entity", 0, "User" )
	self:NetworkVar( "Bool", 0, "DrawKeyPrompt" )
	self:NetworkVar( "Bool", 1, "DrawProgress" )

	if SERVER then
		self:SetProgress( -1.0 )
		self:SetDrawKeyPrompt( true )
		self:SetDrawProgress( true )
		self.ProgPerTick = 1 / ( self.TimeToUse * ( 1 / FrameTime() ) / 100 )
	end
end

function ENT:IsProgressUsable()
	return true
end

if SERVER then

	function ENT:Initialize()
		self:SetModel("models/Items/item_item_crate.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then phys:Wake() end
	end

	function ENT:Use( ply, act, typ )
		if IsValid( self:GetUser() ) and self:GetUser() != ply then return end

		self:SetUser( ply )
		if !ply:KeyDownLast( IN_USE ) then
			self:SetProgress( 0 )
			self:OnUseStart( ply )
			self.starttime = CurTime()
		end
		if ply:KeyDownLast( IN_USE ) then
			if self:GetProgress() == -1 then
				return 
			end
			self:SetProgress( self:GetProgress() + self.ProgPerTick )
		end

		if self:GetProgress() >= 100 then
			self:OnUseFinish( ply )
			self:SetProgress( -1 )
			self:SetUser( nil )
		end

		if self.PartialUses[ self:GetProgress() ] != nil then
			self.PartialUses[ self:GetProgress() ]( self )
		end

	end

	function ENT:OnUseFinish( ply )
		self:EmitSound( "items/gift_pickup.wav" )
	end

	function ENT:OnUseStart( ply )
		self:EmitSound( "items/ammopickup.wav" )
	end

	function ENT:OnUseCancel( ply )
		self:EmitSound( "buttons/button10.wav" )
	end

	function ENT:OnRemove()
		
	end

	function ENT:Think()

		if IsValid( self:GetUser() ) then
            if !IsValid( self:GetUser():GetUseEntity() ) and self:GetUser():GetUseEntity() != self then
                self:SetUser( nil )
                self:SetProgress( -1 )
            end
        end

		if self:GetProgress() == self.LastProg and self:GetProgress() != -1 then
			self:OnUseCancel( self:GetUser() )
            self:SetUser( nil )
            self:SetProgress( -1 )
		end

		self.LastProg = self:GetProgress()

		--[[
			usually you'd just use CurTime() here,
			but on 66-tick servers, it's extremely unreliable.
			sometimes it will cancel using even if you're holding it.
			this is a bit of a fix, but it runs this entity
			at 33-tick i think...
		]]--
		self:NextThink( CurTime() + 0.03 )

		return true

	end

end

if CLIENT then

	function ENT:Draw()
		self:DrawModel()
	end
	
end
