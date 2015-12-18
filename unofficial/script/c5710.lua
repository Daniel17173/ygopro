--Number 35: Ravenous Tarantula
--ygohack137-13701836
function c5710.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,2)
	c:EnableReviveLimit()
	--boost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c5710.indcon)
	e1:SetOperation(c5710.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c5710.lpval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c5710.indcon)
	e4:SetCost(c5710.spcost)
	e4:SetTarget(c5710.destg)
	e4:SetOperation(c5710.desop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c5710.drcon1)
	e5:SetOperation(c5710.drop1)
	e5:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e5)
end
c5710.xyz_number=35
function c5710.lpval(e,c)
	local c=e:GetHandler()
	local lp1=Duel.GetLP(c:GetControler())
	local lp2=Duel.GetLP(1-c:GetControler())
	
	if lp1<lp2 then 
	return lp2-lp1 end
	
	if lp1>lp2 then 
	return lp1-lp2 end
end
function c5710.indcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c5710.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end
function c5710.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c5710.filter(c,atk)
	return c:IsFaceup() and c:GetAttack()<atk and c:IsDestructable()
end
function c5710.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk=e:GetHandler():GetAttack()
	if chk==0 then return Duel.IsExistingMatchingCard(c5710.filter,tp,0,LOCATION_MZONE,1,nil,atk) end
	local g=Duel.GetMatchingGroup(c5710.filter,tp,0,LOCATION_MZONE,nil,atk)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c5710.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local atk=c:GetAttack()
	local g=Duel.GetMatchingGroup(c5710.filter,tp,0,LOCATION_MZONE,nil,atk)
	Duel.Destroy(g,REASON_EFFECT)
end
function c5710.filter1(c,sp)
	return c:GetSummonPlayer()==sp
end
function c5710.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c5710.filter1,1,nil,1-tp) 
		--and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c5710.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end