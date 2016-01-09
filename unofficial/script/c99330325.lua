--Disrupted Kaiju Dream
--Scripted by Eerie Code @ Ygoproco - 99330325
function c99330325.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,99330325+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c99330325.target)
	e1:SetOperation(c99330325.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c99330325.thcost)
	e2:SetTarget(c99330325.thtg)
	e2:SetOperation(c99330325.thop)
	c:RegisterEffect(e2)
end

function c99330325.filter1(c,e,tp)
	--return c:IsSetCard(0xd3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and Duel.IsExistingMatchingCard(c99330325.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
	--if c:IsSetCard(0xd3) and c:IsType(TYPE_MONSTER) then
	--  if not c:IsCanBeSpecialSummoned(e,0,tp,false,true,POS_FACEUP_ATTACK) then
			--Debug.Message("First card cannot be special summoned (no limit)")
	--	  return false
	--  else return Duel.IsExistingMatchingCard(c99330325.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode()) end
	--else return false end
	return c:IsSetCard(0xd3) and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c99330325.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c99330325.filter2(c,e,tp,cd)
	--return c:IsSetCard(0xd3) and not c:IsCode(cd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,1-tp)
	--if c:IsSetCard(0xd3) and c:IsType(TYPE_MONSTER) and not c:IsCode(cd) then
	--  if not c:IsCanBeSpecialSummoned(e,0,tp,false,true,POS_FACEUP_ATTACK,1-tp) then
	--	  --Debug.Message("Second card cannot be special summoned (no limit)")
	--	  return false
	--  else return true end
	--else return false end
	return c:IsSetCard(0xd3) and c:IsType(TYPE_MONSTER) and not c:IsCode(cd)
end
function c99330325.filter3(c,e,tp)
	--return c:IsSetCard(0xd3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and Duel.IsExistingMatchingCard(c99330325.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
	if c:IsSetCard(0xd3) and c:IsType(TYPE_MONSTER) then
		if not c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) then
			--Debug.Message("First card cannot be special summoned")
			return false
		else return Duel.IsExistingMatchingCard(c99330325.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode()) end
	else return false end
end
function c99330325.filter4(c,e,tp,cd)
	--return c:IsSetCard(0xd3) and not c:IsCode(cd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,1-tp)
	if c:IsSetCard(0xd3) and c:IsType(TYPE_MONSTER) and not c:IsCode(cd) then
		if not c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,1-tp) then
			--Debug.Message("Second card cannot be special summoned")
			return false
		else return true end
	else return false end
end
function c99330325.target(e,tp,eg,ep,ev,re,r,rp,chk)
	--if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c99330325.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	if chk==0 then
		if not Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
			--Debug.Message("No destructable card")
			return false
		else return Duel.IsExistingMatchingCard(c99330325.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c99330325.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	Duel.Destroy(g,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99330325,0))
		local g1=Duel.SelectMatchingCard(tp,c99330325.filter3,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g1:GetCount()==0 then return end
		local tc1=g1:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99330325,1))
		local g2=Duel.SelectMatchingCard(tp,c99330325.filter4,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc1:GetCode())
		if g2:GetCount()==0 then return end
		local tc2=g2:GetFirst()
		Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		Duel.SpecialSummonStep(tc2,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc1:RegisterEffect(e1)
		local e2=e1:Clone()
		tc2:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_MUST_ATTACK)
		tc1:RegisterEffect(e3)
		local e4=e3:Clone()
		tc2:RegisterEffect(e4)
		Duel.SpecialSummonComplete()
	end
end

function c99330325.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c99330325.thfilter(c)
	return c:IsSetCard(0xd3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c99330325.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99330325.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99330325.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99330325.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end