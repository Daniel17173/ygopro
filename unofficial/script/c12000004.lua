--奇跡の創造者
function c12000004.initial_effect(c)
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c12000004.target)
	e3:SetOperation(c12000004.operation)
	c:RegisterEffect(e3)
end
function c12000004.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1048) and c:IsSetCard(0x7f) and c:IsType(TYPE_XYZ) 
end
function c12000004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and c12000004.spfilter(chkc) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c12000004.spfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local code=Duel.AnnounceCard(tp)
	e:SetLabel(code)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c12000004.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c12000004.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()~=12000005 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		--destroy
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_BATTLE_DAMAGE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCondition(c12000004.condition)
		e2:SetOperation(c12000004.winop)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c12000004.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetFlagEffect(tp,12000000)>0
	 and Duel.GetFlagEffect(tp,12000002)>0
end
function c12000004.winop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_CARD,tp,12000004)
		local WIN_REASON_MIRACLE_CRETER=0x30
		Duel.Win(tp,WIN_REASON_MIRACLE_CRETER)
end
