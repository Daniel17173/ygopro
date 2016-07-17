--堕天使の追放
--Casting out the Darklords
--Script by nekrozar
function c100405034.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100405034+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100405034.target)
	e1:SetOperation(c100405034.activate)
	c:RegisterEffect(e1)
end
function c100405034.filter(c)
	return (c:IsSetCard(0x1ef) or c:IsCode(67316075,57579381,47664723,85771019,11260714,40921744,55690251)) and not c:IsCode(100405034) and c:IsAbleToHand()
end
function c100405034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100405034.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100405034.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100405034.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
