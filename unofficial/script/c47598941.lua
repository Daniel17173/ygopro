--アモルファージ・ライシス
--Script by mercury233
function c5872.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DESTROY,TIMING_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c5872.target1)
	e1:SetOperation(c5872.operation)
	c:RegisterEffect(e1)
	--set p
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c5872.condition)
	e2:SetTarget(c5872.target2)
	e2:SetOperation(c5872.operation)
	c:RegisterEffect(e2)
	--atk/def down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTarget(c5872.atktg)
	e3:SetValue(c5872.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e4)
end
function c5872.filter(c,e,tp)
	return c:IsSetCard(0x1374) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c5872.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_SZONE) and (c:GetPreviousSequence()==6 or c:GetPreviousSequence()==7) and c:GetPreviousControler()==tp
end
function c5872.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_DESTROYED,true)
	if res
		and Duel.GetFlagEffect(tp,47598941)==0
		and Duel.IsExistingMatchingCard(c5872.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7))
		and teg:IsExists(c5872.cfilter,1,nil,tp)
		and Duel.SelectYesNo(tp,94) then
		Duel.RegisterFlagEffect(tp,47598941,RESET_PHASE+PHASE_END,0,1)
	end
end
function c5872.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c5872.cfilter,1,nil,tp)
end
function c5872.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e)
		and Duel.GetFlagEffect(tp,47598941)==0
		and (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7))
		and Duel.IsExistingMatchingCard(c5872.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.RegisterFlagEffect(tp,47598941,RESET_PHASE+PHASE_END,0,1)
end
function c5872.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetFlagEffect(tp,47598941)==0 then return end
	if not (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c5872.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c5872.atktg(e,c)
	return c:IsFaceup() and not c:IsSetCard(0x1374)
end
function c5872.vfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1374)
end
function c5872.atkval(e)
	return Duel.GetMatchingGroupCount(c5872.vfilter,e:GetOwnerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*-100
end
