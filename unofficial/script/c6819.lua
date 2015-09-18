--破壊剣士の伴竜
function c6819.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c6819.target)
	e1:SetOperation(c6819.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,6819)
	e2:SetCost(c6819.spcost)
	e2:SetTarget(c6819.sptg)
	e2:SetOperation(c6819.spop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(24861088,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,6819)
	e3:SetCondition(c6819.spcon2)
	e3:SetCost(c6819.spcost2)
	e3:SetTarget(c6819.sptg2)
	e3:SetOperation(c6819.spop2)
	c:RegisterEffect(e3)
end
function c6819.filter(c)
	return c:IsSetCard(0x1e7) and not c:IsCode(6819) and c:IsAbleToHand()
end
function c6819.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6819.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c6819.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c6819.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c6819.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c6819.spfilter(c,e,tp)
	return c:IsCode(78193831) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c6819.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c6819.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c6819.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c6819.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c6819.bbfilter(c)
	return c:GetCode()==78193831 and c:IsAbleToHand()
end
function c6819.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
		and Duel.IsExistingMatchingCard(c6819.bbfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c6819.costfilter(c)
	return c:IsSetCard(0x1e7) and c:IsAbleToGraveAsCost()
end
function c6819.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6819.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c6819.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c6819.aclimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0x70)
end
function c6819.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c6819.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
