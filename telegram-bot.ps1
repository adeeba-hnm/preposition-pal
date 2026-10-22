# ============================================================
#  Preposition Pal — Telegram Bot (Pure PowerShell, no Node/Python)
#  Run:  powershell -ExecutionPolicy Bypass -File telegram-bot.ps1
# ============================================================

$TOKEN   = "8856678891:AAGZNIxkIoznOJwuwQpnsRr_H5bGnj7Wano"
$API     = "https://api.telegram.org/bot$TOKEN"
$HUMAN   = "+01158592808"

# ─── Per-chat session store ───────────────────────────────────
$sessions = @{}

function Get-Session($chatId) {
    if (-not $sessions.ContainsKey($chatId)) {
        $sessions[$chatId] = @{ failCount=0; escalated=$false; pendingIntent=$null }
    }
    return $sessions[$chatId]
}

# ─── Topic list ───────────────────────────────────────────────
$TOPICS = @(
    'preposition','noun','verb','adjective','adverb','tense','grammar',
    'sentence','paragraph','vocabulary','spelling','punctuation','clause',
    'pronoun','conjunction','article','determiner','passive','active',
    'reading','writing','listening','speaking','comprehension','essay',
    'idiom','phrasal verb','modal','conditional','reported speech',
    'direct speech','indirect speech','subject','predicate','object',
    'syntax','morphology','phonics','intonation','stress','syllable'
)

# ─── Explanations ─────────────────────────────────────────────
$EXPLANATIONS = @{
    preposition = @"
*Prepositions* tell us about relationships — position, time, direction.

Common ones: in, on, at, by, for, with, about, between, through

Quick rule:
• Place → "The book is *on* the table."
• Time  → "See you *at* 3 PM / *on* Monday / *in* June."
• Direction → "Walk *through* the door."

🔑 Gen Z tip: Think of prepositions as GPS tags — they locate things in space or time.
"@
    tense = @"
*Tenses* show when something happens.

• Simple present     → "She *studies* every day."
• Present continuous → "She *is studying* right now."
• Simple past        → "She *studied* yesterday."
• Present perfect    → "She *has studied* for two hours."
• Simple future      → "She *will study* tomorrow."

🔑 Tip: Focus on WHY you're choosing a tense, not just the form.
"@
    noun = @"
*Nouns* are naming words — people, places, things, or ideas.

• Concrete: cat, table, school
• Abstract: happiness, freedom, love
• Proper: London, Emma, Monday (always capitalised)
• Collective: a flock of birds, a team of players

🔑 Tip: If you can put "the" or "a" in front of a word, it's probably a noun.
"@
    verb = @"
*Verbs* are action or state words — the engine of every sentence.

• Action: run, write, laugh
• State/linking: be, seem, feel, become
• Auxiliary: have, do, will, can, should

🔑 Tip: Every complete sentence MUST have a verb. No verb = no sentence.
"@
    adjective = @"
*Adjectives* describe nouns.

• "She has a bright idea." (before noun)
• "The idea is brilliant." (after linking verb)
• Comparative: "This is easier than that."
• Superlative: "It's the easiest topic."

🔑 Gen Z tip: Adjectives = the vibe check of a sentence.
"@
    adverb = @"
*Adverbs* modify verbs, adjectives, or other adverbs.

• How:    She speaks clearly.
• When:   He called yesterday.
• Where:  Leave it here.
• Degree: That's really good.

🔑 Tip: Many adverbs end in -ly, but not all (fast, hard, well).
"@
    conditional = @"
*Conditionals* express "if" situations.

• Zero:   If + present, present  → General truth
• First:  If + present, will     → Real future possibility
• Second: If + past, would       → Unreal present/future
• Third:  If + past perfect, would have → Unreal past

🔑 Example: "If I study hard, I will pass." (First conditional)
"@
    passive = @"
*Passive voice* shifts focus from the doer to the action/receiver.

Active → Passive:
"The teacher corrects the papers."
→ "The papers are corrected by the teacher."

Formula: subject + be (correct tense) + past participle

🔑 Use passive when the doer is unknown, unimportant, or obvious.
"@
    essay = @"
*Essay writing* — a Gen Z-friendly breakdown:

1. Introduction — hook + background + thesis statement
2. Body paragraphs — Point → Evidence → Explanation → Link
3. Conclusion — restate thesis + summary + final thought

🔑 Remember PEEL for body paragraphs:
Point → Evidence → Explanation → Link
"@
    vocabulary = @"
*Building vocabulary* strategically:

• Learn words in context, not isolated lists
• Use the word in 3 different sentences to remember it
• Group by topic clusters (food, emotions, academic verbs)
• Review with spaced repetition (flashcards work!)

🔑 Gen Z hack: Make memes or short video flashcards — visual memory sticks.
"@
}

# ─── Practice questions ───────────────────────────────────────
$PRACTICE = @{
    preposition = @(
        "Fill in: 'She arrived ___ Monday ___ 9 o'clock ___ the morning.'",
        "Correct the error: 'I'm interested on grammar.'",
        "Write 3 sentences using in, on, at for time.",
        "Choose: 'The cat jumped ___ (over/above) the wall.'"
    )
    tense = @(
        "Put the verb into the correct tense: 'She (study) for three hours when I called.'",
        "Spot the error: 'I am knowing the answer.'",
        "Write a short paragraph using at least 3 different tenses.",
        "Translate to present perfect: 'She finished her essay an hour ago.'"
    )
    noun = @(
        "Identify nouns: 'The team celebrated their victory with great joy.'",
        "Is 'information' countable or uncountable? Why does it matter?",
        "Write 2 sentences: one with a collective noun, one with an abstract noun."
    )
    verb = @(
        "Identify the main verb and auxiliaries: 'She has been studying all day.'",
        "Write 3 sentences using modal verbs: should, might, must.",
        "Convert to negative and question form: 'They play football on Sundays.'"
    )
    conditional = @(
        "Complete: 'If I ______ (know) the answer, I ______ (tell) you.' (2nd conditional)",
        "What type of conditional? 'If you heat water to 100C, it boils.'",
        "Write your own example for each of the 4 conditional types."
    )
    essay = @(
        "Write a thesis statement for: 'Social media affects teenagers' mental health.'",
        "Expand using PEEL: 'Reading improves vocabulary.'",
        "Write an introduction (3-4 sentences) for: 'Should school uniforms be mandatory?'"
    )
    default = @(
        "Can you give me a definition of the key term in your own words?",
        "Write an example sentence using a concept from this topic.",
        "What is one thing about this topic you find confusing? Let's break it down!"
    )
}

# ─── Helper functions ─────────────────────────────────────────
function Detect-Topic($text) {
    $l = $text.ToLower()
    foreach ($t in $TOPICS) {
        if ($l.Contains($t)) { return $t }
    }
    return $null
}

function Is-Homework($text) {
    $l = $text.ToLower()
    $patterns = @(
        'do my homework','do this homework','do the homework',
        'do my assignment','do this assignment','write my essay',
        'answer this question','answer my exam','complete my assignment',
        'complete my homework','solve this exam','solve my exam',
        'give me the answers','just do it for me','just write it for me'
    )
    foreach ($p in $patterns) { if ($l.Contains($p)) { return $true } }
    return $false
}

function Is-NonAcademic($text) {
    $l = $text.ToLower()
    $keywords = @('depress','lonely','anxious','anxiety','stress','mental health',
                  'suicide','hurt myself','heartbreak','boyfriend','girlfriend',
                  'crush','love life','fight with my friend','i feel lost',
                  'i feel hopeless','i feel worthless','i feel empty')
    foreach ($k in $keywords) { if ($l.Contains($k)) { return $true } }
    return $false
}

function Is-Greeting($text) {
    $greetings = @('hi','hello','hey','yo','sup','hiya','good morning','good afternoon','good evening')
    $t = $text.Trim().ToLower().TrimEnd('!.,')
    return $greetings -contains $t
}

function Get-Explanation($topic) {
    foreach ($k in $EXPLANATIONS.Keys) {
        if ($topic -and $topic.ToLower().Contains($k)) { return $EXPLANATIONS[$k] }
    }
    return $null
}

function Get-Practice($topic) {
    foreach ($k in $PRACTICE.Keys) {
        if ($k -ne 'default' -and $topic -and $topic.ToLower().Contains($k)) {
            return $PRACTICE[$k]
        }
    }
    return $PRACTICE['default']
}

# ─── Main respond function ────────────────────────────────────
function Get-BotReply($text, $sess) {
    $input = $text.Trim()

    if ($sess.escalated) {
        return "🙋 You've already been connected to a human teacher/mentor at $HUMAN. They'll be with you shortly!"
    }

    if (Is-Greeting $input) {
        $sess.failCount = 0
        return "Hey! 👋 I'm *Preposition Pal*, your English tutor.`n`nI can help you with:`n• 📖 Explaining English grammar topics`n• 🔢 Step-by-step breakdowns`n• ✏️ Practice questions`n`nWhat topic do you need help with today?`n`n_Type /reset anytime to start over._"
    }

    if (Is-Homework $input) {
        $sess.failCount = 0
        return "I can't do that for you — completing homework yourself is how you actually learn! 📚`n`nBut I *can* help you understand the topic so you can do it yourself.`n`nFor extra guidance, contact your teacher:`n📞 $HUMAN`n`nWhat specifically are you stuck on?"
    }

    if (Is-NonAcademic $input) {
        $sess.escalated = $true
        return "That sounds like something outside my area — I'm here for academic English support only.`n`nMore importantly, what you're going through *matters*. 💙`n`nPlease reach out to your teacher/mentor right now:`n📞 *$HUMAN*`n`nThey're ready to support you. 🔗"
    }

    $wantsPractice = $input.ToLower() -match 'practice|exercise|question|quiz|drill|test me|give me.*question'
    $wantsExplain  = $input.ToLower() -match 'explain|what is|what are|how do|how does|break.*down|help.*understand|tell me about|teach me|simple'
    $topic = Detect-Topic $input

    if ($sess.pendingIntent -and -not $topic) {
        $sess.failCount++
        if ($sess.failCount -ge 2) {
            $sess.escalated = $true
            return "Sorry, I'm still having trouble understanding.`n`nLet me connect you to your teacher who can help better! 🔗`n📞 *$HUMAN*"
        }
        return "Sorry, I don't quite understand. Could you tell me what subject this is about, or try asking in a different way?"
    }

    if (($wantsPractice -or $wantsExplain) -and -not $topic) {
        $sess.pendingIntent = if ($wantsPractice) { 'practice' } else { 'explain' }
        $sess.failCount = 0
        return "Sure — what subject or topic do you need help with?"
    }

    if ($topic) {
        $sess.failCount = 0
        $intent = if ($sess.pendingIntent) { $sess.pendingIntent } `
                  elseif ($wantsPractice)  { 'practice' } `
                  elseif ($wantsExplain)   { 'explain' } `
                  else                     { $null }
        $sess.pendingIntent = $null

        if ($intent -eq 'practice') {
            $qs   = Get-Practice $topic
            $list = ($qs | ForEach-Object { $i = [Array]::IndexOf($qs, $_) + 1; "$i. $_" }) -join "`n"
            return "Here are some *practice questions* for *$topic*:`n`n$list`n`nTake your time — let me know if you want me to explain any of these! 💪"
        }

        $expl = Get-Explanation $topic
        if ($expl) {
            return "Here's a breakdown of *${topic}*:`n$expl`n`nWant some practice questions on this? Just ask! ✏️"
        }
        return "Got it — you need help with *$topic*!`n`nI don't have a pre-built explanation for that yet, but I can still help:`n`n1. Tell me specifically what you're confused about.`n2. I'll break it down step by step.`n`nWhat's the tricky part? 🤔"
    }

    $sess.failCount++
    if ($sess.failCount -ge 2) {
        $sess.escalated = $true
        return "Sorry, I'm having trouble understanding after a couple of tries.`n`nLet me connect you to your *teacher/mentor* who can help better! 🔗`n📞 *$HUMAN*"
    }
    return "Sorry, I don't quite understand. Could you tell me what subject this is about, or try asking in a different way?"
}

# ─── Telegram API helpers ─────────────────────────────────────
function Send-TgMessage($chatId, $text) {
    $body = @{
        chat_id    = $chatId
        text       = $text
        parse_mode = 'Markdown'
    } | ConvertTo-Json -Compress

    try {
        Invoke-RestMethod -Uri "$API/sendMessage" -Method Post `
            -ContentType 'application/json' -Body $body | Out-Null
    } catch {
        # retry without markdown if parse fails
        $plain = $text -replace '[*_`]',''
        $body2 = @{ chat_id=$chatId; text=$plain } | ConvertTo-Json -Compress
        try { Invoke-RestMethod -Uri "$API/sendMessage" -Method Post `
            -ContentType 'application/json' -Body $body2 | Out-Null } catch {}
    }
}

function Get-Updates($offset) {
    try {
        $r = Invoke-RestMethod -Uri "$API/getUpdates?offset=$offset&timeout=30" `
             -Method Get -TimeoutSec 35
        return $r.result
    } catch { return @() }
}

# ─── Verify token on startup ──────────────────────────────────
Write-Host ""
Write-Host "🔍 Verifying token..." -ForegroundColor Cyan
try {
    $me = Invoke-RestMethod -Uri "$API/getMe" -Method Get
    Write-Host "✅ Connected as: @$($me.result.username) ($($me.result.first_name))" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to connect. Check your token." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🤖 Preposition Pal is LIVE on Telegram!" -ForegroundColor Green
Write-Host "   Human fallback: $HUMAN" -ForegroundColor Yellow
Write-Host "   Press Ctrl+C to stop." -ForegroundColor Gray
Write-Host ""

# ─── Polling loop ─────────────────────────────────────────────
$offset = 0

while ($true) {
    $updates = Get-Updates $offset

    foreach ($update in $updates) {
        $offset = $update.update_id + 1

        if (-not $update.message) { continue }

        $chatId = $update.message.chat.id
        $text   = ($update.message.text -as [string]).Trim()
        $user   = $update.message.from.first_name

        if (-not $text) {
            Send-TgMessage $chatId "I can only read text messages! Type your question 📝"
            continue
        }

        Write-Host "[$chatId] $user: $text" -ForegroundColor DarkGray

        # /start resets session
        if ($text -eq '/start') {
            $sessions.Remove([string]$chatId)
            Send-TgMessage $chatId "Hey! 👋 I'm *Preposition Pal*, your English tutor.`n`nI can help you with:`n• 📖 Explaining English grammar topics`n• 🔢 Step-by-step breakdowns`n• ✏️ Practice questions`n`nWhat topic do you need help with today?"
            continue
        }

        # /reset
        if ($text -eq '/reset') {
            $sessions.Remove([string]$chatId)
            Send-TgMessage $chatId "Session reset! Let's start fresh. What topic would you like help with? 📚"
            continue
        }

        $sess  = Get-Session ([string]$chatId)
        $reply = Get-BotReply $text $sess

        Send-TgMessage $chatId $reply
        Write-Host "  → Bot: $($reply.Substring(0,[Math]::Min(80,$reply.Length)))..." -ForegroundColor Cyan
    }

    Start-Sleep -Milliseconds 200
}
