# 📚 Preposition Pal

> An interactive English grammar tutor chatbot for Gen Z students — runs in the browser **and** on Telegram. No LLM API required.

---

## ✨ Features

- 🌐 **Web chat** — open `preposition-pal.html` directly in any browser (zero install)
- 🤖 **Telegram bot** — connects via `@pepopepohdhd_bot`
- 🧠 **Rule-based engine** — slot filling, fallback handling, escalation logic
- 📞 **Human fallback** — escalates to teacher at `+01158592808` on 2× failures or personal issues
- 🚫 **Academic integrity guard** — refuses to do homework/assignments
- ✏️ **10 topic explanations** — prepositions, tenses, nouns, verbs, adjectives, adverbs, conditionals, passive voice, essays, vocabulary
- 🎯 **Practice question sets** — per-topic drills

---

## 🚀 Quick Start

### Web (standalone — no install needed)
Just open the file in your browser:
```
preposition-pal/preposition-pal.html
```
Double-click it. Done.

---

### Telegram Bot (PowerShell — no Node/Python needed)
```powershell
powershell -ExecutionPolicy Bypass -File telegram-bot.ps1
```
Then open Telegram → search **@pepopepohdhd_bot** → `/start`

---

### Full Server (Web + Telegram via Node.js)
```bash
npm install
cp .env.example .env   # add your TELEGRAM_TOKEN
node server.js
```
Open `http://localhost:3000`

---

## 🗂 Project Structure

```
preposition-pal/
├── preposition-pal.html   ← Standalone web UI (self-contained, no server)
├── engine.js              ← Rule-based chatbot brain (Node.js module)
├── server.js              ← Express server + Telegram (Node.js)
├── telegram-bot.ps1       ← Telegram bot in pure PowerShell (no Node needed)
├── .env.example           ← Environment variable template
├── package.json
└── public/
    └── index.html         ← Web UI served by Express
```

---

## 🤖 Bot Logic

| Student Input | Bot Response |
|---|---|
| Greeting | Welcome + quick reply buttons |
| "explain tenses" | Full explanation with examples |
| "practice questions" | Slot-fills topic, then sends drills |
| No topic given | Asks: *"Sure — what topic?"* |
| 2× unclear input | Escalates to human teacher |
| Homework request | Declines + offers to explain instead |
| Personal/emotional | Escalates immediately to human |

---

## 📋 Role Definition

- **Bot name:** Preposition Pal  
- **Purpose:** Academic English support for Gen Z students  
- **Scope:** Grammar explanations, step-by-step breakdowns, practice questions  
- **Not in scope:** Completing homework, personal/emotional support  
- **Human escalation:** `+01158592808`

---

## 🛠 Tech Stack

| Layer | Tech |
|---|---|
| Web UI | Vanilla HTML / CSS / JS |
| Telegram (no Node) | PowerShell + `Invoke-RestMethod` |
| Telegram (with Node) | `node-telegram-bot-api` |
| Server | Node.js + Express |
| Bot engine | Pure JavaScript rule-based logic |

---

*Made with ❤️ for English learners.*
