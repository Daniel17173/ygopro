--希望の創造者
function c12000000.initial_effect(c)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c12000000.retcon)
	e2:SetOperation(c12000000.spr)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_PREDRAW)
	e3:SetCondition(c12000000.spcon)
	e3:SetTarget(c12000000.sptg)
	e3:SetOperation(c12000000.spop)
	c:RegisterEffect(e3)
end
function c12000000.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():GetReasonPlayer()~=tp
		and e:GetHandler():GetPreviousControler()==tp
end
function c12000000.spr(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetTurnPlayer()==tp then
		c:RegisterFlagEffect(12000000,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,3)
	else
		c:RegisterFlagEffect(12000000,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2)
	end
end
function c12000000.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.GetTurnPlayer()==tp and Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c12000000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(12000000)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local code=Duel.AnnounceCard(tp)
	e:SetLabel(code)
	e:GetHandler():ResetFlagEffect(12000000)
end
function c12000000.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()~=12000001 then return end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
	Duel.RegisterFlagEffect(tp,12000000,0,0,0)
end
