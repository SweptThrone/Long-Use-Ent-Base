AddCSLuaFile()

ENT.Type = "anim"
--ENT.Base = "base_gmodentity"
ENT.PrintName = "Long-Use Usable"
ENT.Author = "SweptThrone"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.ProgPerTick = 0
ENT.TimeToUse = ENT.TimeToUse or 1.5 -- the user can edit this
ENT.DrawKeyPrompt = true -- the user can edit this
ENT.DrawProgress = true -- the user can edit this
--ENT.SingleUser = false -- the user can edit this

function ENT:SetupDataTables()
	self:NetworkVar( "Float", 0, "Progress" )
	self:NetworkVar( "Entity", 0, "User" )

	if SERVER then
		self:SetProgress( -1 )
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

	function ENT:Use( act, ply, typ )
		if --[[self.SingleUser and]] self:GetUser() then return end

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
	end

	function ENT:OnUseFinish( ply )
		self:EmitSound( "items/gift_pickup.wav" )
	end

	function ENT:OnUseStart( ply )
		self:EmitSound( "items/ammopickup.wav" )
	end

	function ENT:OnRemove()
		
	end

	function ENT:Think()
	end

end

if CLIENT then

	function ENT:Draw()
		self:DrawModel()
	end
	
end