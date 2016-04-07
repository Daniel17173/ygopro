--メタモルF
--Metamor Formation
--Script by mercury233
function c100909060.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xe2))
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e3)
	--immune effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(c100909060.condition)
	e4:SetTarget(c100909060.etarget)
	e4:SetValue(c100909060.efilter)
	c:RegisterEffect(e4)
end
function c100909060.condition(e)
	local tp=e:GetHandlerPlayer()
	local c1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local c2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	return (c1 and c1:IsSetCard(0xe2)) or (c2 and c2:IsSetCard(0xe2))
end
function c100909060.etarget(e,c)
	return c:IsSetCard(0xe2) and not c:IsType(TYPE_EFFECT)
end
function c100909060.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
