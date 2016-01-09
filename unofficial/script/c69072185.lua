--アモルファージ・イリテュム
function c69072185.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--maintain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c69072185.descon)
	e2:SetOperation(c69072185.desop)
	c:RegisterEffect(e2)
	--spsummon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e3:SetTargetRange(1,1)
	e3:SetTarget(c69072185.sumlimit)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e4:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCondition(c69072185.rmcon)
	e4:SetTarget(c69072185.rmtarget)
	e4:SetTargetRange(0xff,0xff)
	e4:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e4)
end
function c69072185.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c69072185.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,c:GetCode())
	if Duel.CheckReleaseGroup(tp,Card.IsReleasableByEffect,1,c) and Duel.SelectYesNo(tp,500) then
		local g=Duel.SelectReleaseGroup(tp,Card.IsReleasableByEffect,1,1,c)
		Duel.Release(g,REASON_RULE)
	else Duel.Destroy(c,REASON_RULE) end
end
function c69072185.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0xe0)
end
function c69072185.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe0)
end
function c69072185.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c69072185.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c69072185.rmtarget(e,c)
	return not c:IsSetCard(0xe0)
end