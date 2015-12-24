--フレンドリーファイア
--Script by mercury233
function c5878.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c5878.condition)
	e1:SetTarget(c5878.target)
	e1:SetOperation(c5878.activate)
	c:RegisterEffect(e1)
end
function c5878.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c5878.filter(c,rc)
	return c~=rc and c:IsDestructable()
end
function c5878.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c5878.filter(chkc,re:GetHandler()) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c5878.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),re:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c5878.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),re:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c5878.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
