--ディメンション・リフレクター
--Dimension Reflector
--Script by dest
function c100207021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c100207021.cost)
	e1:SetTarget(c100207021.target)
	e1:SetOperation(c100207021.activate)
	c:RegisterEffect(e1)
end
function c100207021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_MZONE,0,2,nil) end
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_MZONE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100207021.filter(c,tp)
	local atk=c:GetAttack()
	local def=c:GetDefence()
	return c:IsFaceup()
		and Duel.IsPlayerCanSpecialSummonMonster(tp,100207021,0,0x21,atk,def,4,RACE_SPELLCASTER,ATTRIBUTE_DARK)
end
function c100207021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c100207021.filter,tp,0,LOCATION_MZONE,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SelectTarget(tp,c100207021.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100207021.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (c:IsRelateToEffect(e) or tc:IsRelateToEffect(e) or tc:IsFaceup()) then return end
	local atk=tc:GetAttack()
	local def=tc:GetDefence()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,100207021,0,0x21,atk,def,4,RACE_SPELLCASTER,ATTRIBUTE_DARK) then return end
	c:AddTrapMonsterAttribute(TYPE_EFFECT,ATTRIBUTE_DARK,RACE_SPELLCASTER,4,atk,def)
	if Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP_ATTACK) then
		--damage
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(100207021,0))
		e1:SetCategory(CATEGORY_DAMAGE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetLabel(atk)
		e1:SetTarget(c100207021.damtg)
		e1:SetOperation(c100207021.damop)
		e1:SetReset(RESET_EVENT+0x17e0000)
		c:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
	c:TrapMonsterBlock()
end
function c100207021.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=e:GetLabel()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c100207021.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
