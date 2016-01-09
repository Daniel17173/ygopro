--Digital Bug - Corebage
--Scripted by Eerie Code-6999
function c58600555.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c58600555.xyzcon)
	e1:SetOperation(c58600555.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--Back to Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(58600555,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c58600555.tdcost)
	e2:SetTarget(c58600555.tdtg)
	e2:SetOperation(c58600555.tdop)
	c:RegisterEffect(e2)
	--Change position
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(58600555,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetTarget(c58600555.target)
	e3:SetOperation(c58600555.operation)
	c:RegisterEffect(e3)
end
c58600555.xyz_count=2
function c58600555.ovfilter(c,tp,xyzc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and (c:GetRank()==3 or c:GetRank()==4) and c:IsRace(RACE_INSECT) and c:IsCanBeXyzMaterial(xyzc)
		and c:CheckRemoveOverlayCard(tp,2,REASON_COST)
end
function c58600555.ovfilter2(c,tp,xyzc)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetLevel()==5 and c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeXyzMaterial(xyzc)
end
function c58600555.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	if 2<=ct then return false end
	if ct<1 and not og and Duel.IsExistingMatchingCard(c58600555.ovfilter,tp,LOCATION_MZONE,0,1,nil,tp,c) then
		return true
	end
	return Duel.CheckXyzMaterial(c,c58600555.ovfilter2,5,2,2,og)
end
function c58600555.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	if og then
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ct=-ft
		local b1=Duel.CheckXyzMaterial(c,c58600555.ovfilter2,5,2,2,og)
		local b2=ct<1 and Duel.IsExistingMatchingCard(c58600555.ovfilter,tp,LOCATION_MZONE,0,1,nil,tp,c)
		if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(58600555,0))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local mg=Duel.SelectMatchingCard(tp,c58600555.ovfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
			mg:GetFirst():RemoveOverlayCard(tp,2,2,REASON_COST)
			local mg2=mg:GetFirst():GetOverlayGroup()
			if mg2:GetCount()~=0 then
				Duel.Overlay(c,mg2)
			end
			c:SetMaterial(mg)
			Duel.Overlay(c,mg)
		else
			local mg=Duel.SelectXyzMaterial(tp,c,c58600555.ovfilter2,5,2,2)
			c:SetMaterial(mg)
			Duel.Overlay(c,mg)
		end
	end
end
function c58600555.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c58600555.tdfil(c)
	return c:IsPosition(POS_DEFENCE) and c:IsAbleToDeck()
end
function c58600555.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c58600555.tdfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c58600555.tdfil,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,c58600555.tdfil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c58600555.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c58600555.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_GRAVE,0,1,nil,RACE_INSECT) end
end
function c58600555.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,Card.IsRace,tp,LOCATION_GRAVE,0,1,1,nil,RACE_INSECT)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		Duel.Overlay(c,g)
	end
end