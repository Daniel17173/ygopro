--Ultimate Providence
--Scripted by Eerie Code-6881
function c5901.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c5901.condition)
	e1:SetCost(c5901.cost)
	e1:SetTarget(c5901.target)
	e1:SetOperation(c5901.activate)
	c:RegisterEffect(e1)
end
function c5901.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c5901.cfilter(c,typ)
	return c:IsType(typ) and c:IsDiscardable()
end
function c5901.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.IsPlayerAffectedByEffect(tp,EFFECT_DISCARD_COST_CHANGE) then return true end
	local typ=0
	if re:IsActiveType(TYPE_MONSTER) then typ=TYPE_MONSTER
	elseif re:IsActiveType(TYPE_SPELL) then typ=TYPE_SPELL else typ=TYPE_TRAP end
	if chk==0 then return Duel.IsExistingMatchingCard(c5901.cfilter,tp,LOCATION_HAND,0,1,nil,typ) end
	--local g=Duel.SelectMatchingCard(tp,c5901.cfilter,tp,LOCATION_HAND,0,1,1,nil,typ)
	--Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	Duel.DiscardHand(tp,c5901.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c5901.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c5901.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
	if re:GetHandler():IsRelateToEffect(re) then 
		Duel.Destroy(eg,REASON_EFFECT)
	end
end