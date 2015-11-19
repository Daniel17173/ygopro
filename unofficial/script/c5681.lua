--青眼の双爆裂龍
function c5681.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeRep(c,89631139,2,true,true)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c5681.spcon)
	e1:SetOperation(c5681.spop)
	c:RegisterEffect(e1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Extra attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Banish
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetCondition(c5681.rmcon)
	e4:SetOperation(c5681.rmop)
	c:RegisterEffect(e4)
end
function c5681.spfilter(c)
	return c:IsFaceup() and c:IsCode(89631139) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c5681.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c5681.spfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,2,nil)
end
function c5681.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c5681.spfilter,tp,LOCATION_MZONE,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c5681.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc
	if not c:IsRelateToBattle() then return false end
	if c==Duel.GetAttacker() then
		tc=Duel.GetAttackTarget()
	elseif c==Duel.GetAttackTarget() then
		tc=Duel.GetAttacker()
	end
	if tc and tc:IsLocation(LOCATION_MZONE) then
		e:SetLabelObject(tc)
		return true
	else
		return false
	end
end
function c5681.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end