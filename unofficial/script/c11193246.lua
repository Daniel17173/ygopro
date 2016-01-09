--月光輪廻舞踊
--Script by mercury233
function c5871.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,5871)
	e1:SetCondition(c5871.condition)
	e1:SetTarget(c5871.target)
	e1:SetOperation(c5871.operation)
	c:RegisterEffect(e1)
end
function c5871.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c5871.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c5871.cfilter,1,nil,tp)
end
function c5871.thfilter(c,e,tp)
	return c:IsSetCard(0x209) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c5871.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5871.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c5871.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c5871.thfilter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local sg1=g:Select(tp,1,1,nil)
    if g:GetCount()>=2 and Duel.SelectYesNo(tp,210) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg2=g:Select(tp,1,1,sg1:GetFirst())
        sg1:Merge(sg2)
    end
    Duel.SendtoHand(sg1,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,sg1)
end
