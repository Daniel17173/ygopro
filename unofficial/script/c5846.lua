--月光舞猫姫
--Scripted by Eerie Code
--multi atk by mercury233
function c5846.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0x209),2,true)
	c:EnableReviveLimit()
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Multiple attacks
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(5846,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c5846.condition)
	e2:SetCost(c5846.cost)
	e2:SetOperation(c5846.operation)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(5846,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetTarget(c5846.damtg)
	e3:SetOperation(c5846.damop)
	c:RegisterEffect(e3)
end
c5846_attacked=58461
c5846_indestructible=58462
function c5846.matfil(c)
	return c:IsSetCard(0xe1) or c:IsSetCard(0x209) and c:IsType(TYPE_MONSTER)
end
function c5846.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c5846.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c5846.matfil,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,c5846.matfil,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c5846.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		--indestructible
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DESTROY_REPLACE)
		e1:SetRange(LOCATION_SZONE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTarget(c5846.reptg)
		e1:SetValue(c5846.repval)
		Duel.RegisterEffect(e1,tp)
		local g=Group.CreateGroup()
		g:KeepAlive()
		e1:SetLabelObject(g)
		--infinte atk to monster
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetValue(9999)
		e2:SetCondition(c5846.atkcon)
		c:RegisterEffect(e2)
		--reg attacked flag to battle target
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_ATTACK_ANNOUNCE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
 		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e3:SetOperation(c5846.atkop)
		c:RegisterEffect(e3)
		--can not attack one monster more than 2 times
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
 		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e4:SetValue(c5846.atktg)
		c:RegisterEffect(e4)
	end
end
function c5846.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsReason(REASON_BATTLE) and c:GetFlagEffect(c5846_indestructible)==0
end
function c5846.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c5846.repfilter,1,nil,tp) end
	local g=eg:Filter(c5846.repfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(c5846_indestructible,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
		tc=g:GetNext()
	end
	e:GetLabelObject():Clear()
	e:GetLabelObject():Merge(g)
	return true
end
function c5846.repval(e,c)
	local g=e:GetLabelObject()
	return g:IsContains(c)
end
function c5846.atkcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)>0
end
function c5846.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if tc then
		tc:RegisterFlagEffect(c5846_attacked,RESET_PHASE+PHASE_END,0,1)
	end
end
function c5846.atktg(e,c)
	return c:GetFlagEffect(c5846_attacked)>=2
end

function c5846.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100)
end
function c5846.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end