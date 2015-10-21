--RR－サテライト・キャノン・ファルコン
function c9324.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WINDBEAST),8,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9324,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c9324.destg)
	e1:SetOperation(c9324.desop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9324,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9324.condition)
	e2:SetCost(c9324.cost)
	e2:SetTarget(c9324.target)
	e2:SetOperation(c9324.operation)
	c:RegisterEffect(e2)
end
function c9324.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c9324.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if e:GetHandler():GetSummonType()~=SUMMON_TYPE_XYZ then return end
	if chkc then return chkc:IsOnField() and c9324.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9324.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) 
	and e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0xba) end
	local g=Duel.GetMatchingGroup(c9324.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c9324.chlimit)
end
function c9324.chlimit(e,ep,tp)
	return tp==ep
end
function c9324.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9324.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end

function c9324.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c9324.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9324.filter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c9324.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9324.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9324.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9324.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c9324.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
	local atk=Duel.GetMatchingGroupCount(Card.IsSetCard,c:GetControler(),LOCATION_GRAVE,0,nil,0xba)*800
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(-atk)
		tc:RegisterEffect(e1)
	end
end