--九十九スラッシュ
--Script by mercury233
function c5714.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c5714.condition)
	e1:SetOperation(c5714.activate)
	c:RegisterEffect(e1)
end
function c5714.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return c:IsControler(tp) and c:GetAttack()<=d:GetAttack() and Duel.GetLP(tp)~=Duel.GetLP(1-tp)
end
function c5714.activate(e,tp,eg,ep,ev,re,r,rp)
	local atkval=Duel.GetLP(tp)-Duel.GetLP(1-tp)
	if atkval==0 then return end
	if atkval<0 then atkval=atkval*-1 end
	local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
    e1:SetValue(atkval)
	Duel.GetAttacker():RegisterEffect(e1)
end
