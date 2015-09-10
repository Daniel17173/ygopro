--勝利の方程式
function c12000002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c12000002.condition)
	e1:SetTarget(c12000002.target)
	e1:SetOperation(c12000002.activate)
	c:RegisterEffect(e1)
end
function c12000002.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c12000002.spfilter(c,e,tp)
	return (c:IsSetCard(0x48) and not c:IsSetCard(0x1048) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) or (c:IsCode(511000296) and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c12000002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c12000002.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local code=Duel.AnnounceCard(tp)
	e:SetLabel(code)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function c12000002.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()~=12000003 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12000002.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)~=0 then
		c:CancelToGrave()
		Duel.Overlay(tc,Group.FromCards(c))
		tc:CompleteProcedure()
	end
	Duel.RegisterFlagEffect(tp,12000002,0,0,0)
end
