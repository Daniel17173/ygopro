--堕天使イシュタム
--Darklord Ixtab
--Script by nekrozar
function c100405030.initial_effect(c)
	c:SetSPSummonOnce(100405030)
	--cannot spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100405030,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100405030)
	e1:SetCost(c100405030.drcost)
	e1:SetTarget(c100405030.drtg)
	e1:SetOperation(c100405030.drop)
	c:RegisterEffect(e1)
	--copy effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100405030,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,100405130)
	e2:SetCost(c100405030.cpcost)
	e2:SetTarget(c100405030.cptg)
	e2:SetOperation(c100405030.cpop)
	c:RegisterEffect(e2)
end
function c100405030.cfilter(c)
	return (c:IsSetCard(0x1ef) or c:IsCode(67316075,57579381,47664723,85771019,11260714,40921744,55690251)) and c:IsDiscardable()
end
function c100405030.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable()
		and Duel.IsExistingMatchingCard(c100405030.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c100405030.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
end
function c100405030.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c100405030.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c100405030.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c100405030.cpfilter(c)
	return (c:IsSetCard(0x1ef) or c:IsCode(67316075,57579381,47664723,85771019,11260714,40921744,55690251)) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck() and c:CheckActivateEffect(false,true,false)~=nil
end
function c100405030.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(c100405030.cpfilter,tp,LOCATION_GRAVE,0,1,nil) end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c100405030.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local tg=te:GetTarget()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c100405030.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	if not te:GetHandler():IsRelateToEffect(e) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	Duel.BreakEffect()
	Duel.SendtoDeck(te:GetHandler(),nil,2,REASON_EFFECT)
end
