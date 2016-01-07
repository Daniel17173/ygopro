--RR－ペイン・レイニアス
--Script by mercury233
function c5815.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,5815)
	e1:SetTarget(c5815.sptg)
	e1:SetOperation(c5815.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e2:SetValue(c5815.xyzlimit)
	c:RegisterEffect(e2)
end
function c5815.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xba) and c:IsLevelAbove(1)
end
function c5815.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c5815.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c5815.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c5815.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local c=g:GetFirst()
	local atk=c:GetAttack()
	local def=c:GetDefence()
	local val=0
	if atk<=def and atk>=0 then val=atk
	elseif def>=0 then val=def end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,val)
end
function c5815.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then return end
	local atk=tc:GetAttack()
	local def=tc:GetDefence()
	local val=0
	if atk<=def and atk>=0 then val=atk
	elseif def>=0 then val=def end
	Duel.Damage(tp,val,REASON_EFFECT)
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetLevel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function c5815.xyzlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_WINDBEAST)
end
