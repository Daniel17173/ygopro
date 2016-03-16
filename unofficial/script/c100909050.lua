--レッド・デーモンズ・ドラゴン・タイラント
--Red Dragon Archfiend Tyrant
--ygohack137-13790927
function c100909050.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c100909050.syncon)
	e1:SetOperation(c100909050.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,1009090501)
	e2:SetCost(c100909050.descost)
	e2:SetCondition(c100909050.sumcon)
	e2:SetTarget(c100909050.target)
	e2:SetOperation(c100909050.operation)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,1009090502)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c100909050.discon)
	e3:SetTarget(c100909050.distg)
	e3:SetOperation(c100909050.disop)
	c:RegisterEffect(e3)
end
function c100909050.matfilter1(c,syncard)
	return c:IsType(TYPE_TUNER) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCanBeSynchroMaterial(syncard)
end
function c100909050.matfilter2(c,syncard)
	return c:IsNotTuner() and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCanBeSynchroMaterial(syncard)
end
function c100909050.synfilter1(c,syncard,lv,g1,g2,g3,g4)
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	local f1=c.tuner_filter
	if c:IsHasEffect(EFFECT_HAND_SYNCHRO) then
		return g3:IsExists(c100909050.synfilter2,1,c,syncard,lv-tlv,g2,g4,f1,c)
	else
		return g1:IsExists(c100909050.synfilter2,1,c,syncard,lv-tlv,g2,g4,f1,c)
	end
end
function c100909050.synfilter2(c,syncard,lv,g2,g4,f1,tuner1)
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	local f2=c.tuner_filter
	if f1 and not f1(c) then return false end
	if f2 and not f2(tuner1) then return false end
	if (tuner1:IsHasEffect(EFFECT_HAND_SYNCHRO) and not c:IsLocation(LOCATION_HAND)) or c:IsHasEffect(EFFECT_HAND_SYNCHRO) then
		return g4:IsExists(c100909050.synfilter3,1,nil,syncard,lv-tlv,f1,f2)
	else
		return g2:IsExists(c100909050.synfilter3,1,nil,syncard,lv-tlv,f1,f2)
	end
end
function c100909050.synfilter3(c,syncard,lv,f1,f2)
	local mlv=c:GetSynchroLevel(syncard)
	local lv1=bit.band(mlv,0xffff)
	local lv2=bit.rshift(mlv,16)
	return (lv1==lv or lv2==lv) and (not f1 or f1(c)) and (not f2 or f2(c))
end
function c100909050.syncon(e,c,tuner,mg)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-2 then return false end
	local g1=nil
	local g2=nil
	local g3=nil
	local g4=nil
	if mg then
		g1=mg:Filter(c100909050.matfilter1,nil,c)
		g2=mg:Filter(c100909050.matfilter2,nil,c)
		g3=mg:Filter(c100909050.matfilter1,nil,c)
		g4=mg:Filter(c100909050.matfilter2,nil,c)
	else
		g1=Duel.GetMatchingGroup(c100909050.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(c100909050.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(c100909050.matfilter1,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
		g4=Duel.GetMatchingGroup(c100909050.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		local tlv=tuner:GetSynchroLevel(c)
		if lv-tlv<=0 then return false end
		local f1=tuner.tuner_filter
		if not pe then
			return g1:IsExists(c100909050.synfilter2,1,tuner,c,lv-tlv,g2,g4,f1,tuner)
		else
			return c100909050.synfilter2(pe:GetOwner(),c,lv-tlv,g2,nil,f1,tuner)
		end
	end
	if not pe then
		return g1:IsExists(c100909050.synfilter1,1,nil,c,lv,g1,g2,g3,g4)
	else
		return c100909050.synfilter1(pe:GetOwner(),c,lv,g1,g2,g3,g4)
	end
end
function c100909050.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local g=Group.CreateGroup()
	local g1=nil
	local g2=nil
	local g3=nil
	local g4=nil
	if mg then
		g1=mg:Filter(c100909050.matfilter1,nil,c)
		g2=mg:Filter(c100909050.matfilter2,nil,c)
		g3=mg:Filter(c100909050.matfilter1,nil,c)
		g4=mg:Filter(c100909050.matfilter2,nil,c)
	else
		g1=Duel.GetMatchingGroup(c100909050.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(c100909050.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(c100909050.matfilter1,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
		g4=Duel.GetMatchingGroup(c100909050.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		g:AddCard(tuner)
		local lv1=tuner:GetSynchroLevel(c)
		local f1=tuner.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner2=nil
		if not pe then
			local t2=g1:FilterSelect(tp,c100909050.synfilter2,1,1,tuner,c,lv-lv1,g2,g4,f1,tuner)
			tuner2=t2:GetFirst()
		else
			tuner2=pe:GetOwner()
			Group.FromCards(tuner2):Select(tp,1,1,nil)
		end
		g:AddCard(tuner2)
		local lv2=tuner2:GetSynchroLevel(c)
		local f2=tuner2.tuner_filter
		local m3=nil
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if tuner2:IsHasEffect(EFFECT_HAND_SYNCHRO) then
			m3=g4:FilterSelect(tp,c100909050.synfilter3,1,1,nil,c,lv-lv1-lv2,f1,f2)
		else
			m3=g2:FilterSelect(tp,c100909050.synfilter3,1,1,nil,c,lv-lv1-lv2,f1,f2)
		end
		g:Merge(m3)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tuner1=nil
		local hand=nil
		if not pe then
			local t1=g1:FilterSelect(tp,c100909050.synfilter1,1,1,nil,c,lv,g1,g2,g3,g4)
			tuner1=t1:GetFirst()
		else
			tuner1=pe:GetOwner()
			Group.FromCards(tuner1):Select(tp,1,1,nil)
		end
		g:AddCard(tuner1)
		local lv1=tuner1:GetSynchroLevel(c)
		local f1=tuner1.tuner_filter
		local tuner2=nil
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if tuner1:IsHasEffect(EFFECT_HAND_SYNCHRO) then
			local t2=g3:FilterSelect(tp,c100909050.synfilter2,1,1,tuner1,c,lv-lv1,g2,g4,f1,tuner1)
			tuner2=t2:GetFirst()
		else
			local t2=g1:FilterSelect(tp,c100909050.synfilter2,1,1,tuner1,c,lv-lv1,g2,g4,f1,tuner1)
			tuner2=t2:GetFirst()
		end
		g:AddCard(tuner2)
		local lv2=tuner2:GetSynchroLevel(c)
		local f2=tuner2.tuner_filter
		local m3=nil
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if (tuner1:IsHasEffect(EFFECT_HAND_SYNCHRO) and not tuner2:IsLocation(LOCATION_HAND))
			or tuner2:IsHasEffect(EFFECT_HAND_SYNCHRO) then
			m3=g4:FilterSelect(tp,c100909050.synfilter3,1,1,nil,c,lv-lv1-lv2,f1,f2)
		else
			m3=g2:FilterSelect(tp,c100909050.synfilter3,1,1,nil,c,lv-lv1-lv2,f1,f2)
		end
		g:Merge(m3)
	end
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end

function c100909050.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c100909050.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OATH)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c100909050.ftarget)
	e1:SetLabel(e:GetHandler():GetFieldID())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100909050.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c100909050.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c100909050.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(g,REASON_EFFECT)
end


function c100909050.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
	 and Duel.IsChainNegatable(ev) and Duel.GetCurrentPhase()==PHASE_BATTLE
end
function c100909050.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c100909050.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(500)
		c:RegisterEffect(e1)
	end
end
