--冥帝エレボス
function c9801.initial_effect(c)
    --summon with 1 tribute
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(9801,0))
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SUMMON_PROC)
    e1:SetCondition(c9801.otcon)
    e1:SetOperation(c9801.otop)
    e1:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_SET_PROC)
    c:RegisterEffect(e2)
    --send to grave
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCondition(c9801.tdcon)
    e3:SetTarget(c9801.tdtg)
    e3:SetOperation(c9801.tdop)
    c:RegisterEffect(e3)
    --tohand
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetCountLimit(1)
    e4:SetCondition(c9801.thcon)
    e4:SetCost(c9801.thcost)
    e4:SetTarget(c9801.thtg)
    e4:SetOperation(c9801.thop)
    c:RegisterEffect(e4)
end
function c9801.otfilter(c)
    return bit.band(c:GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE
end
function c9801.otcon(e,c)
    if c==nil then return true end
    local mg=Duel.GetMatchingGroup(c9801.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
    return c:GetLevel()>6 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
        and Duel.GetTributeCount(c,mg)>0
end
function c9801.otop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c9801.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
    local sg=Duel.SelectTribute(tp,c,1,1,mg)
    c:SetMaterial(sg)
    Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c9801.tdcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE
end
function c9801.tgfilter(c,tp)
    return c:IsSetCard(0xbe) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c9801.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local g=Duel.GetMatchingGroup(c9801.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
        return g:GetClassCount(Card.GetCode)>1
            and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c9801.tdop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c9801.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
    if g:GetClassCount(Card.GetCode)<2 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local tg1=g:Select(tp,1,1,nil)
    g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local tg2=g:Select(tp,1,1,nil)
    tg1:Merge(tg2)
    if Duel.SendtoGrave(tg1,REASON_EFFECT)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
        if tg:GetCount()>0 then
            Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
        end
    end
end
function c9801.thcon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c9801.cfilter(c)
    return c:IsSetCard(0xbe) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function c9801.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c9801.cfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,c9801.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c9801.thfilter(c)
    return c:IsAttackAbove(2400) and c:GetDefence()==1000 and c:IsAbleToHand()
end
function c9801.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9801.thfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c9801.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local sg=Duel.SelectTarget(tp,c9801.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9801.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
    end
end
