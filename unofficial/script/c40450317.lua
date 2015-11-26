--同胞の絆
function c40450317.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c40450317.cost)
	e1:SetTarget(c40450317.target)
	e1:SetOperation(c40450317.operation)
	c:RegisterEffect(e1)
end
function c40450317.filter(c,e,tp)
	return c:IsFaceup() and c:IsLevelBelow(4)
		and Duel.IsExistingMatchingCard(c40450317.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode(),c:GetAttribute(),c:GetRace(),c:GetLevel())
end
function c40450317.spfilter1(c,e,tp,code,attribute,race,level)
	return c:IsAttribute(attribute) and c:IsRace(race) and c:GetLevel()==level and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and Duel.IsExistingMatchingCard(c40450317.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,code,c:GetCode(),c:GetAttribute(),c:GetRace(),c:GetLevel())
end
function c40450317.spfilter2(c,e,tp,code1,code2,attribute,race,level)
	return c:IsAttribute(attribute) and c:IsRace(race) and c:GetLevel()==level and not (c:IsCode(code1) or c:IsCode(code2))  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40450317.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()==PHASE_MAIN1 end
	Duel.PayLPCost(tp,2000)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c40450317.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c40450317.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local g=Duel.SelectTarget(tp,c40450317.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c40450317.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and tc:IsRelateToEffect(e) and tc:IsFaceup() then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c40450317.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode(),tc:GetAttribute(),tc:GetRace(),tc:GetLevel())
		local sc=g1:GetFirst()
		if sc then 
			local g2=Duel.SelectMatchingCard(tp,c40450317.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,sc:GetCode(),tc:GetCode(),tc:GetAttribute(),tc:GetRace(),tc:GetLevel())
			g1:Merge(g2)
			if g1:GetCount()==2 then
				Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end