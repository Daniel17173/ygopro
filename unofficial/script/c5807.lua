--Speedroid Pachingo-Kart
--ygohack137-13790817
function c5807.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c5807.descost)
	e1:SetTarget(c5807.destg)
	e1:SetOperation(c5807.desop)
	c:RegisterEffect(e1)
end
function c5807.cfilter(c)
	return c:IsDiscardable() and c:IsRace(RACE_MACHINE)
end
function c5807.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5807.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c5807.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c5807.filter(c)
	return c:IsDestructable()
end
function c5807.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c5807.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c5807.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c5807.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c5807.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end