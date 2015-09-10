--天帝アイテール
function c9800.initial_effect(c)
    --summon with 1 tribute
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(9800,0))
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SUMMON_PROC)
    e1:SetCondition(c9800.otcon)
    e1:SetOperation(c9800.otop)
    e1:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_SET_PROC)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCondition(c9800.spcon)
    e3:SetTarget(c9800.sptg)
    e3:SetOperation(c9800.spop)
    c:RegisterEffect(e3)
    --adsummon
    local e4=Effect.CreateEffect(c)
    --e4:SetDescription(aux.Stringid(9800,2))
    e4:SetCategory(CATEGORY_SUMMON)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetRange(LOCATION_HAND)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetHintTiming(0,TIMING_MAIN_END)
    e4:SetCondition(c9800.adcon)
    e4:SetCost(c9800.adcost)
    e4:SetTarget(c9800.adtg)
    e4:SetOperation(c9800.adop)
    e4:SetLabel(1)
    c:RegisterEffect(e4)
end
function c9800.otfilter(c)
    return bit.band(c:GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE
end
function c9800.otcon(e,c)
    if c==nil then return true end
    local mg=Duel.GetMatchingGroup(c9800.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
    return c:GetLevel()>6 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
        and Duel.GetTributeCount(c,mg)>0
end
function c9800.otop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c9800.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
    local sg=Duel.SelectTribute(tp,c,1,1,mg)
    c:SetMaterial(sg)
    Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c9800.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE
end
function c9800.tgfilter(c,tp)
    return c:IsSetCard(0xbe) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c9800.spfilter(c,e,tp)
    return c:IsAttackAbove(2400) and c:GetDefence()==1000 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9800.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local g=Duel.GetMatchingGroup(c9800.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
        return g:GetClassCount(Card.GetCode)>1
            and Duel.IsExistingMatchingCard(c9800.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9800.spop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c9800.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
    if g:GetClassCount(Card.GetCode)<2 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local tg1=g:Select(tp,1,1,nil)
    g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local tg2=g:Select(tp,1,1,nil)
    tg1:Merge(tg2)
    if Duel.SendtoGrave(tg1,REASON_EFFECT)~=0 then
        local g=Duel.SelectMatchingCard(tp,c9800.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
        local tc=g:GetFirst()
        if tc then
            Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e1:SetRange(LOCATION_MZONE)
            e1:SetCode(EVENT_PHASE+PHASE_END)
            e1:SetCountLimit(1)
            e1:SetOperation(c9800.thop)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            tc:RegisterEffect(e1,true)
        end
    end
end
function c9800.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end

function c9800.adcon(e,tp,eg,ep,ev,re,r,rp)
    local tn=Duel.GetTurnPlayer()
    local ph=Duel.GetCurrentPhase()
    return tn~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c9800.cfilter(c)
    return c:IsSetCard(0xbe) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function c9800.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c9800.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c9800.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9800.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(9800)==0 and (c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)) end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
    c:RegisterFlagEffect(9800,RESET_CHAIN,0,1)
end
function c9800.adop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if e:GetLabel()~=1 then return end
    if c and c:IsRelateToEffect(e) then
        local s1=c:IsSummonable(true,nil,1)
        local s2=c:IsMSetable(true,nil,1)
        if (s1 and s2 and Duel.SelectPosition(tp,c,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENCE)==POS_FACEUP_ATTACK) or not s2 then
            Duel.Summon(tp,c,true,nil)
        else
            Duel.MSet(tp,c,true,nil)
        end
    end
end
