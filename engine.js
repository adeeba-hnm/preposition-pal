'use strict';

// ─── Topic keyword bank ───────────────────────────────────────────────────────
const ENGLISH_TOPICS = [
  'preposition', 'noun', 'verb', 'adjective', 'adverb', 'tense', 'grammar',
  'sentence', 'paragraph', 'vocabulary', 'spelling', 'punctuation', 'clause',
  'pronoun', 'conjunction', 'article', 'determiner', 'passive', 'active',
  'reading', 'writing', 'listening', 'speaking', 'comprehension', 'essay',
  'idiom', 'phrasal verb', 'modal', 'conditional', 'reported speech',
  'direct speech', 'indirect speech', 'subject', 'predicate', 'object',
  'syntax', 'morphology', 'phonics', 'intonation', 'stress', 'syllable',
];

// ─── Canned explanations (topic → content) ───────────────────────────────────
const EXPLANATIONS = {
  preposition: `
**Prepositions** tell us about relationships — position, time, direction, etc.

Common ones: *in, on, at, by, for, with, about, between, through*

Quick rule:
- **Place** → "The book is *on* the table."
- **Time** → "See you *at* 3 PM / *on* Monday / *in* June."
- **Direction** → "Walk *through* the door."

🔑 Gen Z tip: Think of prepositions as GPS tags — they locate things in space or time.`,

  tense: `
**Tenses** show *when* something happens.

| Tense | Example |
|---|---|
| Simple present | "She **studies** every day." |
| Present continuous | "She **is studying** right now." |
| Simple past | "She **studied** yesterday." |
| Present perfect | "She **has studied** for two hours." |
| Simple future | "She **will study** tomorrow." |

🔑 Tip: Focus on *why* you're choosing a tense, not just the form.`,

  noun: `
**Nouns** are naming words — people, places, things, or ideas.

- *Concrete*: cat, table, school
- *Abstract*: happiness, freedom, love
- *Proper*: London, Emma, Monday (always capitalised)
- *Collective*: a *flock* of birds, a *team* of players

🔑 Tip: If you can put "the" or "a" in front of a word, it's probably a noun.`,

  verb: `
**Verbs** are action or state words — the engine of every sentence.

- *Action*: run, write, laugh
- *State/linking*: be, seem, feel, become
- *Auxiliary*: have, do, will, can, should

🔑 Tip: Every complete sentence MUST have a verb. No verb = no sentence.`,

  adjective: `
**Adjectives** describe nouns.

- "She has a *bright* idea." (before noun)
- "The idea is *brilliant*." (after linking verb)
- Comparative: "This is *easier* than that."
- Superlative: "It's the *easiest* topic."

🔑 Gen Z tip: Adjectives = the vibe check of a sentence.`,

  adverb: `
**Adverbs** modify verbs, adjectives, or other adverbs.

- *How*: She speaks **clearly**.
- *When*: He called **yesterday**.
- *Where*: Leave it **here**.
- *Degree*: That's **really** good.

🔑 Tip: Many adverbs end in *-ly*, but not all (*fast*, *hard*, *well*).`,

  conditional: `
**Conditionals** express "if" situations.

| Type | Form | Meaning |
|---|---|---|
| Zero | If + present, present | General truth |
| First | If + present, will | Real future possibility |
| Second | If + past, would | Unreal present/future |
| Third | If + past perfect, would have | Unreal past |

🔑 Example: "If I **study** hard, I **will** pass." (First conditional)`,

  passive: `
**Passive voice** shifts focus from doer to the action/receiver.

Active → Passive:
"The teacher **corrects** the papers." → "The papers **are corrected** by the teacher."

Formula: **subject + be (correct tense) + past participle**

🔑 Use passive when the *doer* is unknown, unimportant, or obvious.`,

  essay: `
**Essay writing** — a Gen Z-friendly breakdown:

1. **Introduction** — hook + background + thesis statement
2. **Body paragraphs** — 1 idea each: Point → Evidence → Explanation → Link
3. **Conclusion** — restate thesis + summary + final thought

🔑 Remember PEEL for body paragraphs:
**P**oint → **E**vidence → **E**xplanation → **L**ink`,

  vocabulary: `
**Building vocabulary** strategically:

- Learn words in **context**, not isolated lists
- Use the word in **3 different sentences** to remember it
- Group by **topic clusters** (food, emotions, academic verbs)
- Review with **spaced repetition** (flashcards work!)

🔑 Gen Z hack: Make memes or TikTok-style flashcards with the word — visual memory sticks.`,
};

// ─── Practice question sets ───────────────────────────────────────────────────
const PRACTICE = {
  preposition: [
    "Fill in: 'She arrived ___ Monday ___ 9 o'clock ___ the morning.'",
    "Correct the error: 'I'm interested *on* grammar.'",
    "Write 3 sentences using *in, on, at* for time.",
    "Choose: 'The cat jumped ___ (over/above) the wall.'",
  ],
  tense: [
    "Put the verb in brackets into the correct tense: 'She (study) for three hours when I called.'",
    "Spot the error: 'I am knowing the answer.'",
    "Write a short paragraph (4 sentences) about your morning using at least 3 different tenses.",
    "Translate to present perfect: 'She finished her essay an hour ago.'",
  ],
  noun: [
    "Identify nouns: 'The team celebrated their victory with great joy.'",
    "Is 'information' countable or uncountable? Why does it matter?",
    "Write 2 sentences: one with a collective noun, one with an abstract noun.",
  ],
  verb: [
    "Identify the main verb and any auxiliaries: 'She has been studying all day.'",
    "Write 3 sentences using modal verbs: *should, might, must*.",
    "Convert to negative and question form: 'They play football on Sundays.'",
  ],
  conditional: [
    "Complete: 'If I ______ (know) the answer, I ______ (tell) you.' (2nd conditional)",
    "What type of conditional? 'If you heat water to 100°C, it boils.'",
    "Write your own example for each of the 4 conditional types.",
  ],
  essay: [
    "Write a thesis statement for: 'Social media affects teenagers' mental health.'",
    "Expand this point using PEEL: 'Reading improves vocabulary.'",
    "Write an introduction (3–4 sentences) for the topic: 'Should school uniforms be mandatory?'",
  ],
  default: [
    "Can you give me a definition of the key term in your own words?",
    "Write an example sentence using a concept from this topic.",
    "What is one thing about this topic you find confusing? Let's break it down!",
  ],
};

// ─── Helpers ──────────────────────────────────────────────────────────────────
function detectTopic(text) {
  const lower = text.toLowerCase();
  return ENGLISH_TOPICS.find(t => lower.includes(t)) || null;
}

function isHomeworkRequest(text) {
  const lower = text.toLowerCase();
  const patterns = [
    /do\s+(my|this|the)\s+(homework|assignment|exam|test|quiz)/,
    /write\s+(my|this|the)\s+(essay|assignment|report)/,
    /answer\s+(this|these|my)\s+(question|questions|exam)/,
    /complete\s+(my|this|the)\s+(assignment|homework|test)/,
    /solve\s+(this|my)\s+(exam|test|assignment)/,
    /give me the answers/,
    /just\s+(give|write|do)\s+it\s+for\s+me/,
  ];
  return patterns.some(p => p.test(lower));
}

function isNonAcademic(text) {
  const lower = text.toLowerCase();
  const patterns = [
    /\b(depress|sad|lonely|anxi|stress|mental health|suicid|hurt myself|cry|heartbreak)\b/,
    /\b(relationship|boyfriend|girlfriend|crush|love life)\b/,
    /\b(fight with|argument with)\b.*\b(friend|parent|family)\b/,
    /i feel (so )?(lost|hopeless|worthless|empty)/,
  ];
  return patterns.some(p => p.test(lower));
}

function isGreeting(text) {
  return /^(hi|hello|hey|yo|sup|hiya|good (morning|afternoon|evening))[!.,]?$/i.test(text.trim());
}

function getExplanation(topic) {
  for (const key of Object.keys(EXPLANATIONS)) {
    if (topic && topic.toLowerCase().includes(key)) return EXPLANATIONS[key];
  }
  return null;
}

function getPractice(topic) {
  for (const key of Object.keys(PRACTICE)) {
    if (key !== 'default' && topic && topic.toLowerCase().includes(key)) return PRACTICE[key];
  }
  return PRACTICE.default;
}

// ─── Session state factory ─────────────────────────────────────────────────────
function createSession() {
  return { failCount: 0, escalated: false, pendingIntent: null };
}

// ─── Main respond function ────────────────────────────────────────────────────
function respond(text, session) {
  const input = text.trim();

  if (session.escalated) {
    return '🙋 You\'ve been connected to a human teacher/mentor. They\'ll be with you shortly. I\'m stepping back for now!';
  }

  // Greeting
  if (isGreeting(input)) {
    session.failCount = 0;
    return `Hey! 👋 I'm **Preposition Pal**, your English tutor.\n\nI can help you with:\n- 📖 Explaining English grammar topics\n- 🔢 Step-by-step breakdowns\n- ✏️ Practice questions\n\nWhat topic do you need help with today?`;
  }

  // Homework / academic dishonesty guardrail
  if (isHomeworkRequest(input)) {
    session.failCount = 0;
    return `I can't do that for you — completing homework or assignments yourself is a big part of actually learning! 📚\n\nBut I *can* help you **understand** the topic so you can do it yourself.\n\n🔗 I'm also connecting you to a teacher/mentor who can give you more guidance.\n\nWhat specifically are you stuck on?`;
  }

  // Non-academic / personal guardrail
  if (isNonAcademic(input)) {
    session.escalated = true;
    return `That sounds like something outside my area — I'm here for academic English support only.\n\nMore importantly, what you're going through matters. 💙 I'm connecting you to a human teacher/mentor who can properly support you right now.\n\n🔗 **Escalating to a human now.**`;
  }

  // Detect intent: practice request
  const wantsPractice = /practice|exercise|question|quiz|drill|test me|give me (some )?(questions?|problems?)/.test(input.toLowerCase());
  // Detect intent: explanation request
  const wantsExplain = /explain|what is|what are|how (do|does|to)|break.*down|help.*understand|tell me about|teach me|simple/.test(input.toLowerCase());

  const topic = detectTopic(input);

  // If we have a pending intent waiting for a topic
  if (session.pendingIntent && !topic) {
    // second miss → escalate
    session.failCount += 1;
    if (session.failCount >= 2) {
      session.escalated = true;
      return `Sorry, I'm still having trouble understanding. Let me connect you to a human teacher who can help better! 🔗`;
    }
    return `Sorry, I don't quite understand. Could you tell me what subject this is about, or try asking in a different way?`;
  }

  // Slot filling: intent detected but no topic
  if ((wantsPractice || wantsExplain) && !topic) {
    session.pendingIntent = wantsPractice ? 'practice' : 'explain';
    session.failCount = 0;
    return `Sure — what subject or topic do you need help with?`;
  }

  // We have a topic (possibly also intent from pending)
  if (topic) {
    session.failCount = 0;
    const intent = session.pendingIntent || (wantsPractice ? 'practice' : wantsExplain ? 'explain' : null);
    session.pendingIntent = null;

    if (intent === 'practice') {
      const qs = getPractice(topic);
      const list = qs.map((q, i) => `${i + 1}. ${q}`).join('\n');
      return `Here are some **practice questions** for **${topic}**:\n\n${list}\n\nTake your time — let me know if you want me to explain any of these! 💪`;
    }

    // Default: explain
    const explanation = getExplanation(topic);
    if (explanation) {
      return `Here's a breakdown of **${topic}**:\n${explanation}\n\nWant some practice questions on this? Just ask! ✏️`;
    }

    return `Got it — you need help with **${topic}**!\n\nI don't have a pre-built explanation for that yet, but here's what I suggest:\n\n1. Tell me specifically what you're confused about.\n2. I'll break it down step by step.\n\nWhat's the tricky part? 🤔`;
  }

  // Fallback
  session.failCount += 1;
  if (session.failCount >= 2) {
    session.escalated = true;
    return `Sorry, I'm having trouble understanding after a couple of tries. Let me connect you to a **human teacher/mentor** who can help you better! 🔗`;
  }
  return `Sorry, I don't quite understand. Could you tell me what subject this is about, or try asking in a different way?`;
}

module.exports = { respond, createSession };
