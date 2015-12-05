--左腕の代償
function c5518.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c5518.condition)
	e1:SetCost(c5518.cost)
	e1:SetTarget(c5518.target)
	e1:SetOperation(c5518.activate)
	c:RegisterEffect(e1)
	if not c5518.global_check then
		c5518.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(c5518.setcheck)
		Duel.RegisterEffect(ge1,0)
	end
end
function c5518.setcheck(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,5518,RESET_PHASE+PHASE_END,0,1)
end
function c5518.cfilter(c)
	return c:IsAbleToRemoveAsCost()
end
function c5518.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,5518)==0
end
function c5518.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(c5518.cfilter,e:GetHandler())
	if chk==0 then return g:GetCount()>=2 end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	--cannot set
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SSET)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(aux.TRUE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c5518.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c5518.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5518.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c5518.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c5518.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
   end
end