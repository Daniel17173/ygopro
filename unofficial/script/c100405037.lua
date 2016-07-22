--魅惑の堕天使
--Allure of Darklord
--Script by mercury233
function c100405037.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100405037+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100405037.cost)
	e1:SetTarget(c100405037.target)
	e1:SetOperation(c100405037.activate)
	c:RegisterEffect(e1)
end
function c100405037.costfilter(c)
	return (c:IsSetCard(0x1ef) or c:IsCode(67316075,57579381,47664723,85771019,11260714,40921744,55690251))
		and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToGraveAsCost()
end
function c100405037.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100405037.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100405037.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c100405037.filter(c)
	return c:IsControlerCanBeChanged() and c:IsFaceup()
end
function c100405037.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100405037.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function c100405037.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,c100405037.filter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.GetControl(tc,tp,PHASE_END,1)
	end
end
