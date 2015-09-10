---Kuzunoha, the Onmyojin
function c11000022.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11000022,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c11000022.skcon)
	e2:SetCost(c11000022.skcos)
	e2:SetTarget(c11000022.sktg)
	e2:SetOperation(c11000022.skop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(c11000022.splimit)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRIBUTE_LIMIT)
	e4:SetValue(c11000022.tlimit)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(11000022,0))
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e5:SetCondition(c11000022.ttcon)
	e5:SetOperation(c11000022.ttop)
	e5:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e6)
	--
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_MATCH_KILL)
	e7:SetCondition(c11000022.wincon)
	c:RegisterEffect(e7)
end
function c11000022.skcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return (c:GetSequence()==6 or c:GetSequence()==7)
end
function c11000022.skfilter1(c,e,tp)
	return c:IsAbleToRemoveAsCost()
	and c:IsRace(RACE_SPELLCASTER)
	and c:IsType(TYPE_PENDULUM)
	and Duel.IsExistingMatchingCard(c11000022.skfilter2,tp,LOCATION_MZONE,0,1,nil,e,tp,c)
end
function c11000022.skfilter2(c,e,tp,tc1)
	return c:IsAbleToRemoveAsCost()
	and c:IsRace(RACE_SPELLCASTER)
	and c:IsType(TYPE_PENDULUM)
	and c~=tc1
	and Duel.IsExistingMatchingCard(c11000022.skfilter3,tp,LOCATION_MZONE,0,1,nil,e,tp,tc1,c)
end
function c11000022.skfilter3(c,e,tp,tc1,tc2)
	return c:IsAbleToRemoveAsCost()
	and c:IsRace(RACE_SPELLCASTER)
	and c:IsType(TYPE_PENDULUM)
	and c~=tc1
	and c~=tc2
	and Duel.IsExistingMatchingCard(c11000022.skfilter4,tp,LOCATION_MZONE,0,1,nil,e,tp,tc1,tc2,c)
end
function c11000022.skfilter4(c,e,tp,tc1,tc2,tc3)
	return c:IsFaceup()
	and c:IsCanBeEffectTarget(e)
	and c:IsType(TYPE_PENDULUM)
	and c~=tc1
	and c~=tc2
	and c~=tc3
end
function c11000022.skfilter5(c)
	return c:IsFaceup()
	and c:IsType(TYPE_PENDULUM)
end
function c11000022.skcos(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return Duel.IsExistingMatchingCard(c11000022.skfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local g1=Duel.SelectMatchingCard(tp,c11000022.skfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc1=g1:GetFirst()
	local g2=Duel.SelectMatchingCard(tp,c11000022.skfilter2,tp,LOCATION_MZONE,0,1,1,nil,e,tp,tc1)
	local tc2=g2:GetFirst()
	local g3=Duel.SelectMatchingCard(tp,c11000022.skfilter3,tp,LOCATION_MZONE,0,1,1,nil,e,tp,tc1,tc2)
	local tc3=g3:GetFirst()
	local g=Group.CreateGroup()
	g:AddCard(tc1)
	g:AddCard(tc2)
	g:AddCard(tc3)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end 
function c11000022.sktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return true end
	Duel.SelectTarget(tp,c11000022.skfilter5,tp,LOCATION_MZONE,0,1,1,nil)
end 
function c11000022.skop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		--
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_MATCH_KILL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		tc:RegisterEffect(e1)
	end
end 
function c11000022.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c11000022.tlimit(e,c)
	return not c:IsRace(RACE_SPELLCASTER)
end
function c11000022.ttcon(e,c)
	if c==nil then return true end
	return Duel.GetTributeCount(c)>=3
	and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-3
end
function c11000022.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c11000022.wincon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
end
