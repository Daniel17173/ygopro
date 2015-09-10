--髑髏の司祭ヤスシ
function c12000008.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,78010363,80604091,false,false)
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(0x7F)   
	e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetOperation(c12000008.operation)
	c:RegisterEffect(e3)
end
function c12000008.filter(c)
	return c:IsCode(80604091) and c:GetFlagEffect(12000008)==0
end
function c12000008.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local wg=Duel.GetMatchingGroup(c12000008.filter,c:GetControler(),0x3F,0x3F,nil)
	local wbc=wg:GetFirst()
	while wbc do
		local e1=Effect.CreateEffect(wbc)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetValue(TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x1fe0000+EVENT_ADJUST,1)
		wbc:RegisterEffect(e1)
		local e3=Effect.CreateEffect(c)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SPSUMMON_CONDITION)
		e3:SetReset(RESET_EVENT+0x1fe0000+EVENT_ADJUST,1)
		wbc:RegisterEffect(e3)
		wbc:RegisterFlagEffect(12000008,RESET_EVENT+0x1fe0000+EVENT_ADJUST,0,1) 
		wbc=wg:GetNext()
	end
end
