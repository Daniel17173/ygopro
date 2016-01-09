--アモルファージ・インフェクション
function c50554729.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c50554729.atktg)
	e2:SetValue(c50554729.value)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17626381,0))
	e3:SetCountLimit(1,50554729)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(c50554729.drcon)
	e3:SetTarget(c50554729.target)
	e3:SetOperation(c50554729.activate)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_RELEASE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_DEFENCE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c50554729.atktg)
	e5:SetValue(c50554729.value)
	c:RegisterEffect(e5)
end
function c50554729.atktg(e,c)
	return c:IsSetCard(0x1374) and c:IsFaceup()
end
function c50554729.filt(c)
	return c:IsSetCard(0x1374) and c:IsFaceup()
end
function c50554729.value(e,c)
	return Duel.GetMatchingGroupCount(c50554729.filt,c:GetControler(),LOCATION_ONFIELD,0,nil)*100
end
function c50554729.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT+REASON_RELEASE) and c:IsPreviousLocation(LOCATION_MZONE+LOCATION_HAND) and c:GetPreviousControler()==tp
end
function c50554729.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c50554729.cfilter,1,nil,tp)
end
function c50554729.filter(c)
	return c:IsSetCard(0x1374) and c:IsAbleToHand()
end
function c50554729.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50554729.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c50554729.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c50554729.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end