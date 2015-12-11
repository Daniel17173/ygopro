--DDラミア
function c19580308.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(97439806,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e1:SetCountLimit(1,19580308)
	e1:SetCost(c19580308.cost)
	e1:SetTarget(c19580308.tg)
	e1:SetOperation(c19580308.op)
	c:RegisterEffect(e1)
end
function c19580308.costfilter(c)
	return (c:IsSetCard(0xae) or c:IsSetCard(0xaf)) and c:GetCode()~=19580308 and c:IsAbleToGraveAsCost()
end
function c19580308.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		loc=LOCATION_HAND+LOCATION_ONFIELD
	else
		loc=LOCATION_MZONE
	end
	if chk==0 then return Duel.IsExistingMatchingCard(c19580308.costfilter,tp,loc,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c19580308.costfilter,tp,loc,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c19580308.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c19580308.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0xfe0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end