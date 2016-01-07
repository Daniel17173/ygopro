--サイコロプス
--Script by mercury233
function c5843.initial_effect(c)
	--dice
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c5843.target)
	e1:SetOperation(c5843.operation)
	c:RegisterEffect(e1)
end
function c5843.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local g2=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	g1:Merge(g2)
	if chk==0 then return g1:GetCount()~=0 end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,g1,1,0,0)
end
function c5843.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local g2=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if g1:GetCount()+g2:GetCount()==0 then return end
	local d=Duel.TossDice(tp,1)
	if d==1 then
		Duel.ConfirmCards(tp,g1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg1,REASON_EFFECT+REASON_DISCARD)
		Duel.ShuffleHand(1-tp)
	elseif d==6 then
		Duel.SendtoGrave(g2,REASON_EFFECT+REASON_DISCARD)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local sg1=g2:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg1,REASON_EFFECT+REASON_DISCARD)
		Duel.ShuffleHand(tp)
	end
end
