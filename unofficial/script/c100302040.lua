--AtoZ−ドラゴン・バスターキャノン
--AtoZ Dragon Buster Cannon
--Script by dest
function c100302040.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,100302041,91998119,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c100302040.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c100302040.spcon)
	e2:SetOperation(c100302040.spop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100302040,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c100302040.discon)
	e3:SetCost(c100302040.discost)
	e3:SetTarget(c100302040.distg)
	e3:SetOperation(c100302040.disop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100302040,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,0x1e0)
	e4:SetCost(c100302040.spcost)
	e4:SetTarget(c100302040.sptg)
	e4:SetOperation(c100302040.spop2)
	c:RegisterEffect(e4)
end
function c100302040.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c100302040.spfilter(c,code)
	return c:GetOriginalCode()==code and c:IsAbleToRemoveAsCost()
end
function c100302040.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<-1 then return false end
	local g1=Duel.GetMatchingGroup(c100302040.spfilter,tp,LOCATION_ONFIELD,0,nil,100302041)
	local g2=Duel.GetMatchingGroup(c100302040.spfilter,tp,LOCATION_ONFIELD,0,nil,91998119)
	if g1:GetCount()==0 or g2:GetCount()==0 then return false end
	if ft>0 then return true end
	local f1=g1:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)
	local f2=g2:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)
	if ft==-1 then return f1>0 and f2>0
	else return f1>0 or f2>0 end
end
function c100302040.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g1=Duel.GetMatchingGroup(c100302040.spfilter,tp,LOCATION_ONFIELD,0,nil,100302041)
	local g2=Duel.GetMatchingGroup(c100302040.spfilter,tp,LOCATION_ONFIELD,0,nil,91998119)
	g1:Merge(g2)
	local g=Group.CreateGroup()
	local tc=nil
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		if ft<=0 then
			tc=g1:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE):GetFirst()
			ft=ft+1
		else
			tc=g1:Select(tp,1,1,nil):GetFirst()
		end
		g:AddCard(tc)
		if i==1 then
			g1:Clear()
			if tc:IsFusionCode(100302041) then
				local sg=Duel.GetMatchingGroup(c100302040.spfilter,tp,LOCATION_ONFIELD,0,tc,91998119)
				g1:Merge(sg)
			end
			if tc:IsFusionCode(91998119) then
				local sg=Duel.GetMatchingGroup(c100302040.spfilter,tp,LOCATION_ONFIELD,0,tc,100302041)
				g1:Merge(sg)
			end
		end
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100302040.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler() and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c100302040.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c100302040.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c100302040.disop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
	if re:GetHandler():IsRelateToEffect(re) then 
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c100302040.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c100302040.spfilter2(c,e,tp)
	return c:IsFaceup() and c:IsCode(100302041) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c100302040.spfilter3,tp,LOCATION_REMOVED,0,1,nil,e,tp)
end
function c100302040.spfilter3(c,e,tp)
	return c:IsFaceup() and c:IsCode(91998119) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100302040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingTarget(c100302040.spfilter2,tp,LOCATION_REMOVED,0,1,nil,e,tp)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c100302040.spfilter2,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c100302040.spfilter3,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,2,tp,LOCATION_REMOVED)
end
function c100302040.spop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local ct=sg:GetCount()
	if ct>0 and (ct==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133)) then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
