--DD魔導賢者ニコラ
--D/D Savant Nikola
--Scripted by Eerie Code
function c100909011.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(aux.nfbdncon)
	e1:SetTarget(c100909011.splimit)
	c:RegisterEffect(e1)
	--Increase
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100909011,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(c100909011.atkcost)
	e2:SetTarget(c100909011.atktg)
	e2:SetOperation(c100909011.atkop)
	c:RegisterEffect(e2)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCountLimit(1,100909011)
	e6:SetCondition(c100909011.thcon)
	e6:SetTarget(c100909011.thtg)
	e6:SetOperation(c100909011.thop)
	c:RegisterEffect(e6)
end
function c100909011.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0xaf) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c100909011.atkcfilter(c)
	return c:IsSetCard(0x10af) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c100909011.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100909011.atkcfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c100909011.atkcfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c100909011.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaf) and c:IsLevelBelow(6)
end
function c100909011.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100909011.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100909011.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c100909011.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c100909011.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(2000)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENCE)
		tc:RegisterEffect(e2)
	end
end
function c100909011.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_SZONE) and (c:GetPreviousSequence()==6 or c:GetPreviousSequence()==7)
end
function c100909011.thfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x10af) and c:IsAbleToHand()
end
function c100909011.thfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0xaf) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c100909011.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100909011.thfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100909011.thfilter1,tp,LOCATION_MZONE,0,1,nil) 
		and (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7))
		and Duel.IsExistingMatchingCard(c100909011.thfilter2,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c100909011.thfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c100909011.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=0
	if Duel.CheckLocation(tp,LOCATION_SZONE,6) then ct=ct+1 end
	if Duel.CheckLocation(tp,LOCATION_SZONE,7) then ct=ct+1 end
	if ct==0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0
		and tc:IsLocation(LOCATION_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c100909011.thfilter2,tp,LOCATION_EXTRA,0,1,ct,nil)
		local pc=g:GetFirst()
		while pc do
			Duel.MoveToField(pc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			pc:RegisterEffect(e1)
			pc=g:GetNext()
		end
	end
end
