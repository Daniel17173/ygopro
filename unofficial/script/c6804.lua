--DDオルトロス
function c6804.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c6804.destg)
	e2:SetOperation(c6804.desop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_HAND)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCondition(c6804.spcon2)
	e3:SetTarget(c6804.sptg2)
	e3:SetOperation(c6804.spop2)
	c:RegisterEffect(e3)
end
function c6804.desfilter1(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c6804.desfilter2(c,e)
	return c~=e:GetHandler() and c:IsFaceup() and (c:IsSetCard(0xae)or c:IsSetCard(0xaf)) and c:IsDestructable()
        and Duel.IsExistingTarget(c6804.desfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,c)
end
function c6804.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c6804.desfilter2,0,LOCATION_ONFIELD,0,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(6804,1))
	local g1=Duel.SelectTarget(tp,c6804.desfilter2,tp,LOCATION_ONFIELD,0,1,1,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(6804,0))
	local g2=Duel.SelectTarget(tp,c6804.desfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,g1:GetFirst())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c6804.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c6804.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c6804.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c6804.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c6804.sumlimit)
	Duel.RegisterEffect(e2,tp)
	end
end
function c6804.sumlimit(e,c)
	return c:GetRace()~=RACE_FIEND
end