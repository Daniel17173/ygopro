--オッドアイズ・ペルソナ・ドラゴン
function c100200114.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon reg
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c100200114.regcon)
	e1:SetOperation(c100200114.regop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c100200114.regcon)
	e2:SetOperation(c100200114.regop2)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100200114,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c100200114.spcon)
	e3:SetTarget(c100200114.sptg)
	e3:SetOperation(c100200114.spop)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100200114,1))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetTarget(c100200114.distg)
	e4:SetOperation(c100200114.disop)
	c:RegisterEffect(e4)
end
function c100200114.regfilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x99)
end
function c100200114.regcon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:GetCount()==1 and c100200114.regfilter(tg:GetFirst(),tp)
end
function c100200114.regop1(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(100200114,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c100200114.regop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(21250203,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c100200114.penfilter(c)
	return c:IsSetCard(0x99) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and not c:IsCode(100200114) and not c:IsForbidden()
end
function c100200114.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(100200114)>c:GetFlagEffect(21250203)
end
function c100200114.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100200114.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c100200114.penfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	elseif Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c100200114.disfilter(c)
	return aux.disfilter1(c) and c:GetSummonLocation()==LOCATION_EXTRA
end
function c100200114.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c100200114.disfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100200114.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c100200114.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c100200114.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
