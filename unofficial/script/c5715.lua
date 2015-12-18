--輝望道
--Script by mercury233
function c5715.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c5715.condition)
	e1:SetTarget(c5715.target)
	e1:SetOperation(c5715.activate)
	c:RegisterEffect(e1)
end
function c5715.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0
end

function c5715.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeEffectTarget(e)
end
function c5715.xyzfilter(c,mg)
	if c.xyz_count~=3 then return false end
	return c:IsXyzSummonable(mg)
end
function c5715.mfilter1(c,exg)
	return exg:IsExists(c5715.mfilter2,1,nil,c)
end
function c5715.mfilter2(c,mc)
	return c.xyz_filter(mc)
end

function c5715.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c5715.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,3)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=3 and mg:GetCount()>=3
		and Duel.IsExistingMatchingCard(c5715.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg) end
	local exg=Duel.GetMatchingGroup(c5715.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:FilterSelect(tp,c5715.mfilter1,1,1,nil,exg)
	local tc1=sg1:GetFirst()
	local exg2=exg:Filter(c5715.mfilter2,nil,tc1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=mg:FilterSelect(tp,c5715.mfilter1,1,1,tc1,exg2)
	sg1:Merge(sg2)
	local tc2=sg2:GetFirst()
	local exg3=exg2:Filter(c5715.mfilter2,nil,tc2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg3=mg:Filter(Auxiliary.TRUE,tc1):FilterSelect(tp,c5715.mfilter1,1,1,tc2,exg3)
	sg1:Merge(sg3)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,2,0,0)
end
function c5715.rfilter(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c5715.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>=3 and g:FilterCount(c5715.rfilter,nil,e,tp)==3 then
        local tc1=g:GetFirst()
        local tc2=g:GetNext()
        local tc3=g:GetNext()
        Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP)
        Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP)
        Duel.SpecialSummonStep(tc3,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        tc1:RegisterEffect(e1)
        tc1:RegisterEffect(e2)
        local e21=e1:Clone()
        local e22=e2:Clone()
        tc2:RegisterEffect(e21)
        tc2:RegisterEffect(e22)
        local e31=e1:Clone()
        local e32=e2:Clone()
        tc3:RegisterEffect(e31)
        tc3:RegisterEffect(e32)
        Duel.SpecialSummonComplete()
        Duel.BreakEffect()
        local xyzg=Duel.GetMatchingGroup(c5715.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
        if xyzg:GetCount()>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
            Duel.XyzSummon(tp,xyz,g)
        end
    end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
