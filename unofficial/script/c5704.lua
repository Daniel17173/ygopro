--魔帝アングマール
function c5704.initial_effect(c)
	--To Hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c5704.condition)
	e1:SetCost(c5704.cost)
	e1:SetTarget(c5704.target)
	e1:SetOperation(c5704.operation)
	c:RegisterEffect(e1)
end
function c5704.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE
end
function c5704.filter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c5704.cfilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c5704.filter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c5704.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5704.cfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c5704.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	local tg=g:GetFirst()
	e:SetLabel(tg:GetCode())
	Duel.Remove(tg,POS_FACEUP,REASON_COST)
end
function c5704.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5704.cfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,1,1,0,LOCATION_DECK)
end
function c5704.operation(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local g=Duel.GetMatchingGroup(c5704.filter,tp,LOCATION_DECK,0,nil,code)
	local tg=g:GetFirst()
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end