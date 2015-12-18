--レッド・スプレマシー
--Script by mercury233
function c5720.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c5720.cost)
	e1:SetTarget(c5720.target)
	e1:SetOperation(c5720.operation)
	c:RegisterEffect(e1)
end
function c5720.cfilter1(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x1045) and c:IsAbleToRemoveAsCost()
end
function c5720.cfilter2(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x1045) and c:IsFaceup()
end
function c5720.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5720.cfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,c5720.cfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	e:SetLabel(rg:GetFirst():GetOriginalCode())
end
function c5720.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingMatchingCard(c5720.cfilter1,tp,LOCATION_GRAVE,0,1,nil,tc)
        and Duel.IsExistingTarget(c5720.cfilter2,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c5720.cfilter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c5720.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local code=e:GetLabel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		tc:RegisterEffect(e1)
		tc:CopyEffect(code,RESET_EVENT+0x1fe0000,1)
	end
end