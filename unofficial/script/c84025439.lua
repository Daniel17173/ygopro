--超量機神王グレート・マグナス
function c84025439.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,3)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(84025439,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c84025439.con1)
	e1:SetCost(c84025439.tdcost)
	e1:SetTarget(c84025439.tdtg)
	e1:SetOperation(c84025439.tdop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c84025439.con1)
	e2:SetValue(c84025439.efilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c84025439.con3)
	e3:SetTargetRange(0,LOCATION_DECK)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c84025439.condition)
	e4:SetTarget(c84025439.sptg)
	e4:SetOperation(c84025439.spop)
	c:RegisterEffect(e4)
end
function c84025439.con1(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and e:GetHandler():GetOverlayCount()>=2
end
function c84025439.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c84025439.tdfilter(c)
	return c:IsAbleToDeck()
end
function c84025439.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c84025439.tdfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c84025439.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c84025439.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c84025439.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c84025439.con2(e)
	return e:GetHandler():GetOverlayCount()>=4
end
function c84025439.efilter(e,te)
	local c=te:GetHandler()
	return not c:IsSetCard(0x1e72)
end
function c84025439.con3(e)
	return e:GetHandler():GetOverlayCount()>=5
end
function c84025439.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_RETURN)
end

function c84025439.filter(c,e,tp)
	return c:IsSetCard(0x20d5) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c84025439.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c84025439.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingTarget(c84025439.filter,tp,LOCATION_GRAVE,0,3,nil,e,tp) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c84025439.filter,tp,LOCATION_GRAVE,0,3,3,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c84025439.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<g:GetCount() then return end
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end