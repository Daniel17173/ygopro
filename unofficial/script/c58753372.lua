--超量妖精アルファン
function c58753372.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(58753372,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c58753372.target)
	e1:SetOperation(c58753372.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(58753372,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,58753372)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c58753372.cost)
	e2:SetTarget(c58753372.thtg)
	e2:SetOperation(c58753372.thop)
	c:RegisterEffect(e2)
end
function c58753372.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x1e72) and c:GetLevel()>0
end
function c58753372.filter2(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function c58753372.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c58753372.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c58753372.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c58753372.filter2,tp,LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c58753372.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c58753372.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.GetMatchingGroup(c58753372.filter2,tp,LOCATION_MZONE,0,tc)
		local lc=g:GetFirst()
		local lv=tc:GetLevel()
		while lc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
			e1:SetValue(lv)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			lc:RegisterEffect(e1)
			lc=g:GetNext()
		end
	end
end
function c58753372.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c58753372.thfilter(c,e,tp)
	return c:IsSetCard(0x1e72) and c:IsType(TYPE_MONSTER)
end
function c58753372.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c58753372.thfilter,tp,LOCATION_DECK,0,3,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c58753372.thop(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(c58753372.thfilter,tp,LOCATION_DECK,0,nil,e,tp)
		if g:GetCount()<=2 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local g2=g:Select(tp,1,1,nil)
			g:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
			g1:Merge(g2)
			if g:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
				local g3=g:Select(tp,1,1,nil)
				g1:Merge(g3)
			end
		end
		Duel.ConfirmCards(1-tp,g1)
		Duel.ShuffleDeck(tp)
        local cg=g1:Select(1-tp,1,1,nil)
        local tc=cg:GetFirst()
        Duel.Hint(HINT_CARD,0,tc:GetCode())
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		g1:RemoveCard(tc)
		Duel.SendtoGrave(g1,REASON_EFFECT)
end