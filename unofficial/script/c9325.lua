--RR－コール
function c9325.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9325)
	e1:SetCost(c9325.cost)
	e1:SetTarget(c9325.target)
	e1:SetOperation(c9325.activate)
	c:RegisterEffect(e1)
end
function c9325.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(9325,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9325.splimit)
	e1:SetReset(RESET_PHASE+RESET_END)
	Duel.RegisterEffect(e1,tp)
end
function c9325.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xba)
end

function c9325.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xba)
		and Duel.IsExistingMatchingCard(c9325.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,c:GetCode(),e,tp)
end
function c9325.filter2(c,code,e,tp)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9325.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9325.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9325.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local g=Duel.SelectTarget(tp,c9325.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c9325.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c9325.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,tc:GetCode(),e,tp)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
