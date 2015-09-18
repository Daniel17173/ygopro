-- ダイナミスト・レックス
function c6829.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c6829.discon)
	e2:SetOperation(c6829.disop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c6829.cost1)
	e3:SetCondition(c6829.condition1)
	e3:SetTarget(c6829.target1)
	e3:SetOperation(c6829.operation1)
	c:RegisterEffect(e3)
end
function c6829.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x1e71)
end
function c6829.discon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c6829.cfilter,1,nil)
end
function c6829.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(6829,0)) then
		Duel.NegateEffect(ev)
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	else end
end

function c6829.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,e:GetHandler(),0x1e71) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,e:GetHandler(),0x1e71)
	Duel.Release(g,REASON_COST)
end
function c6829.condition1(e,tp,eg,ep,ev,re,r,rp)
	local atg=Duel.GetAttackTarget()
	return Duel.GetAttacker()==e:GetHandler()
end
function c6829.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(6829)==0 or c:GetFlagEffect(63612443)==0 end
	local t1=c:GetFlagEffect(6829)
	local t2=c:GetFlagEffect(63612443)
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(6829,0))
	if t1==0 and t2==0 then
		op=Duel.SelectOption(tp,aux.Stringid(6829,1),aux.Stringid(6829,2))
	elseif t1==0 then op=Duel.SelectOption(tp,aux.Stringid(6829,1))
	else Duel.SelectOption(tp,aux.Stringid(6829,2)) op=1 end
	e:SetLabel(op)
	if op==0 then c:RegisterFlagEffect(6829,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	else c:RegisterFlagEffect(63612443,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1) end
end
function c6829.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_PIERCE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_EXTRA_ATTACK)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e2:SetCondition(c6829.dircon)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	else
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local opt=0
		if g1:GetCount()>0 and g2:GetCount()>0 then
			opt=Duel.SelectOption(tp,aux.Stringid(44595286,0),aux.Stringid(44595286,1))+1
		elseif g1:GetCount()>0 then opt=1
		elseif g2:GetCount()>0 then opt=2
		end
		if opt==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local g=g1:Select(tp,1,1,nil)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		elseif opt==2 then
			Duel.ConfirmCards(tp,g2)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local g=g2:RandomSelect(tp,1)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
			Duel.ShuffleHand(1-tp)
		end
	end
end
function c6829.dircon(e)
	return e:GetHandler():GetAttackAnnouncedCount()>0
end
