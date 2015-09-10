--真源の帝王
function c9805.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_ATTACK)
    e1:SetTarget(c9805.acttg)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCost(c9805.drcost)
    e2:SetTarget(c9805.drtg)
    e2:SetOperation(c9805.drop)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCountLimit(1,9805)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCost(c9805.spcost)
    e3:SetTarget(c9805.sptg)
    e3:SetOperation(c9805.spop)
    c:RegisterEffect(e3)
end
function c9805.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    if c9805.drcost(e,tp,eg,ep,ev,re,r,rp,0) and c9805.drtg(e,tp,eg,ep,ev,re,r,rp,0)
        and Duel.SelectYesNo(tp,aux.Stringid(9805,0)) then
        e:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
        e:SetProperty(EFFECT_FLAG_CARD_TARGET)
        e:SetOperation(c9805.drop)
        c9805.drcost(e,tp,eg,ep,ev,re,r,rp,1)
        c9805.drtg(e,tp,eg,ep,ev,re,r,rp,1)
        e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9805,1))
    else
        e:SetCategory(0)
        e:SetProperty(0)
        e:SetOperation(nil)
    end
end
function c9805.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetFlagEffect(9805)==0 end
    e:GetHandler():RegisterFlagEffect(9805,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c9805.tdfilter(c)
    return c:IsSetCard(0xbe) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function c9805.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9805.tdfilter(chkc) end
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
        and Duel.IsExistingTarget(c9805.tdfilter,tp,LOCATION_GRAVE,0,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c9805.tdfilter,tp,LOCATION_GRAVE,0,2,2,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9805.drop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if tg:GetCount()<=0 then return end
    Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
    Duel.ShuffleDeck(tp)
    Duel.BreakEffect()
    Duel.Draw(tp,1,REASON_EFFECT)
end
function c9805.cfilter(c)
    return c:IsSetCard(0xbe) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function c9805.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c9805.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler())
        and e:GetHandler():GetFlagEffect(9805)==0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c9805.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
    e:GetHandler():RegisterFlagEffect(9805,RESET_CHAIN,0,1)
end
function c9805.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,9805,0,0x11,5,1000,2400,RACE_FAIRY,ATTRIBUTE_LIGHT) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9805.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e)
        and Duel.IsPlayerCanSpecialSummonMonster(tp,9805,0,0x11,5,1000,2400,RACE_FAIRY,ATTRIBUTE_LIGHT) then
        c:SetStatus(STATUS_NO_LEVEL,false)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
        e1:SetReset(RESET_EVENT+0x47c0000)
        c:RegisterEffect(e1,true)
        Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENCE)
    end
end
