--方界業
--Houkai Karma
--Script by mercury233
function c100207041.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100207041.target)
	c:RegisterEffect(e1)
	--lp halve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100207041,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c100207041.lpcon)
	e2:SetOperation(c100207041.lpop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100207041,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c100207041.thcost)
	e3:SetTarget(c100207041.thtg)
	e3:SetOperation(c100207041.thop)
	c:RegisterEffect(e3)
end
function c100207041.tgfilter(c)
	return c:IsCode(100207032) and c:IsAbleToGrave()
end
function c100207041.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xe3) and c:IsType(TYPE_MONSTER) and not c:IsCode(100207032)
end
function c100207041.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingTarget(c100207041.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c100207041.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(100207041,0)) then
		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOGRAVE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c100207041.activate)
		Duel.SelectTarget(tp,c100207041.filter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	end
end
function c100207041.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100207041.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,99,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		local n=g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and n>0 then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(n*800)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			tc:RegisterEffect(e1)
		end
	end
end
function c100207041.lpcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return Duel.GetTurnPlayer()~=tp and rc and rc:IsSetCard(0xe3) and rc:IsType(TYPE_MONSTER)
		and eg:IsExists(Card.IsCode,1,nil,100207032)
end
function c100207041.lpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_GRAVE) then	
		Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
	end
end
function c100207041.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c100207041.thfilter(c)
	return c:IsSetCard(0xe3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c100207041.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100207041.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100207041.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100207041.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
