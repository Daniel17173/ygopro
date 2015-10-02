--ダイナミスト·ケラトプス
function c6828.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(c6828.reptg)
	e2:SetValue(c6828.repval)
	e2:SetOperation(c6828.repop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c6828.spcon)
	c:RegisterEffect(e3)
end
function c6828.filter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x1e71) and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT))
end
function c6828.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c6828.filter,1,e:GetHandler(),tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectYesNo(tp,aux.Stringid(6828,0))
end
function c6828.repval(e,c)
	return c6828.filter(c,e:GetHandlerPlayer())
end
function c6828.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end

function c6828.sdfilter(c)
	return c:GetCode()==6828 or c:IsFacedown()
end
function c6828.sdfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x1e71)
end
function c6828.spcon(e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c6828.sdfilter2,tp,LOCATION_MZONE,0,1,nil)
		and not Duel.IsExistingMatchingCard(c6828.sdfilter,tp,LOCATION_MZONE,0,1,nil)
end