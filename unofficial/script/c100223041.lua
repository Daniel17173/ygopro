--フレッシュマドルチェ・シスタルト
--Fresh Madolche Sistart
--Scripted by Eerie Code
function c100223041.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FitlerBoolFunction(Card.IsSetCard,0x71),2,2)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetCondition(c100223041.indescon)
	e1:SetTarget(c100223041.indestg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c100223041.desreptg)
	e3:SetOperation(c100223041.desrepop)
	c:RegisterEffect(e3)
end
function c100223041.indesfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x71)
end
function c100223041.indescon(e)
	return e:GetHandler():GetLinkedGroup():IsExists(c100223041.indesfilter,1,nil)
end
function c100223041.indestg(e,c)
	return c:IsSetCard(0x71) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c100223041.desrepfilter(c)
	return c:IsSetCard(0x71) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c100223041.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReason(REASON_BATTLE+REASON_EFFECT)
		and Duel.IsExistingMatchingCard(c100223041.desrepfilter,tp,LOCATION_GRAVE,0,1,nil) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c100223041.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100223041.desrepfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT+REASON_REPLACE)
end
