--インフェルニティ·ビショップ
function c9109.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9109.spcon)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c9109.reptg)
	e2:SetValue(c9109.repval)
	e2:SetOperation(c9109.repop)
	c:RegisterEffect(e2)
end
function c9109.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)==1
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c9109.filter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation

(LOCATION_MZONE)
		and c:IsSetCard(0xb) and not c:IsReason(REASON_REPLACE)
end
function c9109.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
		and eg:IsExists(c9109.filter,1,nil,tp) and e:GetHandler

():IsAbleToRemove() end
	return Duel.SelectYesNo(tp,aux.Stringid(9109,0))
end
function c9109.repval(e,c)
	return c9109.filter(c,e:GetHandlerPlayer())
end
function c9109.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
