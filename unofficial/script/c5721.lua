--王魂調和
--Script by mercury233
function c5721.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c5721.condition)
	e1:SetOperation(c5721.activate)
	c:RegisterEffect(e1)
end
function c5721.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c5721.filter1(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:GetLevel()>0 and c:IsAbleToRemove(tp)
end
function c5721.filter2(c,e,tp)
	return not c:IsType(TYPE_TUNER) and c:GetLevel()>0 and c:IsAbleToRemove(tp)
end
function c5721.filter3(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:GetLevel()<=8 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c5721.mfilter(c,e,tp)
    if not c5721.filter3(c,e,tp) then return false end
    local is=false
    local tg=Duel.GetMatchingGroup(c5721.filter1,tp,LOCATION_GRAVE,0,nil,e,tp)
    local tc=tg:GetFirst()
    while(tc) do
        local max_lv=c:GetLevel()-tc:GetLevel()
        if max_lv>0 then
            local ntg=Duel.GetMatchingGroup(c5721.filter2,tp,LOCATION_GRAVE,0,nil,e,tp)
            if ntg:CheckWithSumEqual(Card.GetLevel,max_lv,1,99) then is=true end
        end
        tc=tg:GetNext()
    end
    return is
end
function c5721.tfilter(c,e,tp,mc)
    if not c5721.filter1(c,e,tp) then return false end
    local max_lv=mc:GetLevel()-c:GetLevel()
    if max_lv>0 then
        local ntg=Duel.GetMatchingGroup(c5721.filter2,tp,LOCATION_GRAVE,0,nil,e,tp)
        if ntg:CheckWithSumEqual(Card.GetLevel,max_lv,1,99) then return true end
    end
    return false
end
function c5721.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack()
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c5721.mfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,512) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local mc=Duel.SelectMatchingCard(tp,c5721.mfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tc=Duel.SelectMatchingCard(tp,c5721.tfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,mc):GetFirst()
		local max_lv=mc:GetLevel()-tc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local ntg=Duel.GetMatchingGroup(c5721.filter2,tp,LOCATION_GRAVE,0,nil,e,tp)
		local sntg=ntg:SelectWithSumEqual(tp,Card.GetLevel,max_lv,1,99)
		sntg:AddCard(tc)
		Duel.Remove(sntg,POS_FACEUP,REASON_EFFECT)
		Duel.SpecialSummon(mc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		mc:CompleteProcedure()
	end
end
