--オッドアイズ・グラビティ・ドラゴン
function c9743.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81896370,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9743)
	e1:SetTarget(c9743.target)
	e1:SetOperation(c9743.operation)
	c:RegisterEffect(e1)
	--activate cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetTarget(c9743.actarget)
	e2:SetCost(c9743.costchk)
	e2:SetOperation(c9743.costop)
	c:RegisterEffect(e2)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(0x10000000+9743)
	e7:SetRange(LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(0,1)
	c:RegisterEffect(e7)
end
function c9743.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c9743.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9743.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(c9743.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
	Duel.SetChainLimit(c9743.chlimit)
end
function c9743.chlimit(e,ep,tp)
	return tp==ep
end
function c9743.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c9743.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end

function c9743.actarget(e,te,tp)
	return te:GetHandler():GetControler()~=tp
end
function c9743.costcon(e)
	c9743[0]=false
	return true
end
function c9743.costchk(e,te_or_c,tp)
	return Duel.CheckLPCost(tp,500)
end
function c9743.costop(e,tp,eg,ep,ev,re,r,rp)
	if c9743[0] then return end
	Duel.PayLPCost(tp,Duel.GetFlagEffect(tp,9743)*500)
	c9743[0]=true
end

