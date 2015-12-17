--ダーク・アドバンス
--Script by mercury233
function c5719.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c5719.target)
	e1:SetOperation(c5719.activate)
	c:RegisterEffect(e1)
end
function c5719.filter(c)
	return c:IsAttackAbove(2400) and c:GetDefence()==1000 and c:IsAbleToHand()
end
function c5719.filter2(c)
	return c:IsSummonable(true,nil,1) and c:IsAttackAbove(2400) and c:GetDefence()==1000
end
function c5719.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c5719.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c5719.filter,tp,LOCATION_GRAVE,0,1,nil)
        and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 or Duel.GetCurrentPhase()==PHASE_BATTLE) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c5719.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c5719.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
    Duel.SendtoHand(tc,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,tc)
    Duel.BreakEffect()
    if Duel.IsExistingMatchingCard(c5719.filter2,tp,LOCATION_HAND,0,1,nil)
		and Duel.SelectYesNo(tp,91) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SelectMatchingCard(tp,c5719.filter2,tp,LOCATION_HAND,0,1,1,nil)
        local tc=g:GetFirst()
		Duel.Summon(tp,tc,true,nil,1)
    end
end
