--天魔大帝
--Script by mercury233
function c5838.initial_effect(c)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c5838.chainop)
	c:RegisterEffect(e1)
end
function c5838.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) and bit.band(rc:GetSummonType(),SUMMON_TYPE_NORMAL)~=0 then
		Duel.SetChainLimit(c5838.chainlm)
	end
end
function c5838.chainlm(e,rp,tp)
	return tp==rp
end
