--竜呼相打つ
function c6861.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,6861+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c6861.target)
	e1:SetOperation(c6861.activate)
	c:RegisterEffect(e1)
end
function c6861.d1filter(c,e,tp)
	local tc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xc7) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or (tc1==nil or tc2==nil))
end
function c6861.d2filter(c,e,tp)
	local tc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	return c:IsType(TYPE_PENDULUM) and c:IsCode(69512157) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or (tc1==nil or tc2==nil))
end
function c6861.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6861.d1filter,tp,LOCATION_DECK,0,1,nil,e,tp)
	and Duel.IsExistingMatchingCard(c6861.d2filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c6861.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c6861.d1filter,tp,LOCATION_DECK,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c6861.d2filter,tp,LOCATION_DECK,0,nil,e,tp)
	local tc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if g:GetCount()>=1 and g2:GetCount()>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		local sg2=g2:Select(tp,1,1,nil)
		sg:Merge(sg2)
		local tg=sg:Select(1-tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.ConfirmCards(tp,tc)
		sg:RemoveCard(tc)
		local tc3=sg:GetFirst()
		if not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and (tc1==nil or tc2==nil) then op=Duel.SelectOption(tp,aux.Stringid(6861,1))
		elseif tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and (tc1~=nil or tc2~=nil) then op=Duel.SelectOption(tp,aux.Stringid(6861,0))
		elseif tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and (tc1==nil or tc2==nil) 
		then op=Duel.SelectOption(tp,aux.Stringid(6861,0),aux.Stringid(6861,1))
		end
		if op==1 then Duel.MoveToField(tc3,tp,tp,LOCATION_SZONE,POS_FACEUP,true) Duel.Destroy(tc3,REASON_RULE)
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)	   
		else Duel.MoveToField(tc3,tp,tp,LOCATION_MZONE,POS_FACEUP_DEFENCE,true) Duel.Destroy(tc3,REASON_RULE)
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
	end
end
