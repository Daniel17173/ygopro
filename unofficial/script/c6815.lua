--黄昏の忍者－シンゲツ
function c6815.initial_effect(c)
	--untargetable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c6815.atlimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SELECT_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTargetRange(0,0xff)
	e2:SetValue(c6815.tglimit)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,6815)
	e3:SetCondition(c6815.thcon)
	e3:SetTarget(c6815.thtg)
	e3:SetOperation(c6815.thop)
	c:RegisterEffect(e3)
end
function c6815.atlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0x2b) and c~=e:GetHandler()
end
function c6815.tglimit(e,re,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x2b) and c~=e:GetHandler()
end
function c6815.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE)
		or (rp~=tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp)
end
function c6815.thfilter(c)
	return c:IsSetCard(0x2b) and c:IsType(TYPE_MONSTER) and c:GetCode()~=6815 and c:IsAbleToHand()
end
function c6815.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and c6815.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c6815.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c6815.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c6815.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

