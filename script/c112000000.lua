--Hasty Horse Rules
--alternative format from an MBT video
--this script is a Normal Spell that initializes the game at the start
--all cards used are in the Main Deck of this card's owner, and go to their GY
--the other player's Main Deck is irrelevant, but has to contain cards for the starting hand
--both Extra Decks have to be empty

--the cards that interact with the Deck or GY have rewritten scripts

local s,id=GetID()
function s.initial_effect(c)
	aux.EnableExtraRules(c,s,s.init)
end
function s.init(c)
    --register the player whose deck is used
    Duel.RegisterFlagEffect(0,id,0,0,99,c:GetOwner())
    local dp=Duel.GetFlagEffectLabel(0,id)
    --check whether deck is correct
    local ag=Duel.GetFieldGroup(dp,LOCATION_HAND|LOCATION_DECK,0)
    local corr=(#ag==80
        and ag:IsExists(Card.IsOriginalCode,3,nil,112000001) --Archfiend's Oath
        and ag:IsExists(Card.IsOriginalCode,3,nil,88086137) --Broken Line
        and ag:IsExists(Card.IsOriginalCode,3,nil,112000002) --Compulsory Evacuation Device
        and ag:IsExists(Card.IsOriginalCode,3,nil,112000003) --Conscription
        and ag:IsExists(Card.IsOriginalCode,3,nil,112000004) --Dark Bribe
        and ag:IsExists(Card.IsOriginalCode,3,nil,47475363) --Drowning Mirror Force
        and ag:IsExists(Card.IsOriginalCode,3,nil,60082869) --Dust Tornado
        and ag:IsExists(Card.IsOriginalCode,3,nil,112000005) --Fruits of Kozaky's Studies
        and ag:IsExists(Card.IsOriginalCode,3,nil,51091138) --Fuse Line
        and ag:IsExists(Card.IsOriginalCode,3,nil,112000006) --Good Goblin Housekeeping
        and ag:IsExists(Card.IsOriginalCode,3,nil,112000007) --Hand Destruction
        and ag:IsExists(Card.IsOriginalCode,3,nil,112000008) --Jar of Greed
        and ag:IsExists(Card.IsOriginalCode,3,nil,41440817) --Jelly Cannon
        and ag:IsExists(Card.IsOriginalCode,3,nil,112000009) --Kingyo Sukui
        and ag:IsExists(Card.IsOriginalCode,3,nil,15800838) --Mind Crush
        and ag:IsExists(Card.IsOriginalCode,7,nil,63356631) --Phoenix Wing Wind Blast
        and ag:IsExists(Card.IsOriginalCode,3,nil,112000010) --Pot of Duality
        and ag:IsExists(Card.IsOriginalCode,10,nil,19636995) --Red-Hared Hasty Horse
        and ag:IsExists(Card.IsOriginalCode,3,nil,112000011) --Spellbook Organization
        and ag:IsExists(Card.IsOriginalCode,3,nil,98495314) --Sword of Deep-Seated
        and ag:IsExists(Card.IsOriginalCode,3,nil,112000012) --Terrors of the Overroot
        and ag:IsExists(Card.IsOriginalCode,3,nil,46652477) --The Transmigration Prophecy
        and ag:IsExists(Card.IsOriginalCode,3,nil,35316708) --Time Seal
    )
    
    --if user's main deck is not correct and extra deck is not empty,
    --opponent decides if they want to continue
    if not corr or not Duel.GetFieldGroupCount(dp,LOCATION_EXTRA,0)>0 then
        local cont=Duel.SelectYesNo(1-dp,aux.Stringid(id,3))
        if not cont then
            Duel.Win(1-dp,1)
        end
    end
    --if opponent's extra deck is not empty, user decides if they want to continue
    if not corr or not Duel.GetFieldGroupCount(1-dp,LOCATION_EXTRA,0)>0 then
        local cont=Duel.SelectYesNo(dp,aux.Stringid(id,3))
        if not cont then
            Duel.Win(dp,1)
        end
    end

    -- --if main deck is not correct, opponent wins
    -- if not corr then
    --     Duel.Hint(HINT_MESSAGE,0,aux.Stringid(id,0))
    --     Duel.Hint(HINT_MESSAGE,1,aux.Stringid(id,0))
    --     Duel.Win(1-dp,1)
    -- end
    -- --if extra deck is not empty, other player wins
    -- if Duel.GetFieldGroupCount(dp,LOCATION_EXTRA,0)>0 then
    --     Duel.Hint(HINT_MESSAGE,dp,aux.Stringid(id,1))
    --     Duel.Hint(HINT_MESSAGE,1-dp,aux.Stringid(id,2))
    --     Duel.Win(1-dp,1)
    -- end
    -- if Duel.GetFieldGroupCount(1-dp,LOCATION_EXTRA,0)>0 then
    --     Duel.Hint(HINT_MESSAGE,dp,aux.Stringid(id,2))
    --     Duel.Hint(HINT_MESSAGE,1-dp,aux.Stringid(id,1))
    --     Duel.Win(dp,1)
    -- end

    --shuffle opponent's hand into the deck and give them new hand
    local hg=Duel.GetFieldGroup(1-dp,LOCATION_HAND,0)
    local sthc=hg:GetCount()
	Duel.SendtoDeck(hg,nil,SEQ_DECKTOP,REASON_RULE)
    local rdg=Duel.GetDecktopGroup(dp,sthc)
    Duel.SendtoHand(rdg,1-dp,REASON_RULE)
    Duel.ShuffleHand(1-dp)

    --replace normal draw for player without deck
    --currently this works, caused some issues before
    local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PREDRAW)
	e3:SetOperation(s.drawop)
	Duel.RegisterEffect(e3,1-dp)

    --prevent summoning from opponent's deck
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,dp)

    --if opponent draws, shuffle it into the deck and add from other deck
    --does not work perfectly for draw cards
    --only here as a backup
    local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCode(EVENT_DRAW)
	e8:SetOperation(s.reshuffop)
	Duel.RegisterEffect(e8,1-dp)

    
end
function s.drawop(e,tp,eg,ep,ev,re,r,rp)
    local tup=Duel.GetTurnPlayer()
    local dp=Duel.GetFlagEffectLabel(0,id)
    local dc=Duel.GetDrawCount(tup)
    --Debug.Message("tup:",tup," dp:",dp," dc:",dc)
    --Debug.Message("turn count",Duel.GetTurnCount())
    if tup==dp or dc==0 or Duel.GetTurnCount()==1 then return end
    --Debug.Message("second part of draw reached")
    if Duel.GetFieldGroupCount(dp,LOCATION_DECK,0)<dc then
        --if number of cards to draw in deck is too small, opponent wins by deckout
        Duel.Win(dp,2)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_DRAW_COUNT)
    e1:SetTargetRange(1,0)
    e1:SetReset(RESET_PHASE|PHASE_DRAW)
    e1:SetValue(0)
    Duel.RegisterEffect(e1,tup)
    Duel.DisableShuffleCheck()
    local ddg=Duel.GetDecktopGroup(dp,dc)
    Duel.SendtoHand(ddg,tup,REASON_RULE)
end
function s.reshuffop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then return end
    local ecount=#eg
    Duel.SendtoDeck(eg,nil,SEQ_DECKTOP,REASON_RULE)
    local dcount=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
    --if number of cards to draw in deck is too small, opponent wins by deckout
    if ecount>dcount then Duel.Win(1-tp,2) end
	local rdg=Duel.GetDecktopGroup(1-tp,ecount)
    Duel.SendtoHand(rdg,tp,r)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_DECK) and c:IsControler(1-e:GetHandlerPlayer())
end