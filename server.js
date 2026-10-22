'use strict';

require('dotenv').config();
const express = require('express');
const path    = require('path');
const TelegramBot = require('node-telegram-bot-api');
const { respond, createSession } = require('./engine');

const app  = express();
const PORT = process.env.PORT || 3000;
const TELEGRAM_TOKEN = process.env.TELEGRAM_TOKEN;

// ─── In-memory session store ──────────────────────────────────────────────────
// Key: string session id  →  Value: session object
const sessions = new Map();

function getSession(id) {
  if (!sessions.has(id)) sessions.set(id, createSession());
  return sessions.get(id);
}

// ─── Express setup ────────────────────────────────────────────────────────────
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

/**
 * POST /chat
 * Body: { message: string, sessionId?: string }
 * Response: { reply: string, showQuickReplies: boolean }
 */
app.post('/chat', (req, res) => {
  const { message, sessionId } = req.body;
  if (!message || typeof message !== 'string') {
    return res.status(400).json({ error: 'message is required' });
  }

  // Use provided sessionId (browser stores in sessionStorage) or fall back to IP
  const sid  = sessionId || req.ip;
  const sess = getSession(sid);
  const reply = respond(message, sess);

  // Show quick replies on greeting or after bot escalates (fresh conversation hints)
  const showQuickReplies = /Hey! 👋/.test(reply) || reply.length < 120;

  res.json({ reply, showQuickReplies });
});

// ─── Telegram bot ─────────────────────────────────────────────────────────────
if (TELEGRAM_TOKEN) {
  const bot = new TelegramBot(TELEGRAM_TOKEN, { polling: true });

  // Format reply for Telegram (strip HTML-ish markdown, keep readable)
  function tgFormat(text) {
    // Convert our markdown to Telegram MarkdownV2 compatible plain text
    return text
      .replace(/\*\*(.+?)\*\*/g, '*$1*')   // bold → Telegram bold
      .replace(/\*(.+?)\*/g, '_$1_')        // italic → Telegram italic
      .replace(/`(.+?)`/g, '`$1`')          // code stays
      .replace(/^#+ /gm, '')                // strip headings markup
      .replace(/^[-•] /gm, '• ')            // unify bullets
      .replace(/^\d+\. /gm, match => match); // keep numbered lists
  }

  bot.on('message', async (msg) => {
    const chatId = msg.chat.id;
    const text   = (msg.text || '').trim();

    // Ignore non-text messages gracefully
    if (!text) {
      bot.sendMessage(chatId, "I can only read text messages for now! Type your question 📝");
      return;
    }

    // /start command
    if (text === '/start') {
      sessions.delete(String(chatId)); // reset session
      bot.sendMessage(
        chatId,
        "Hey! 👋 I'm *Preposition Pal*, your English tutor\\.\n\nI can help you with:\n• 📖 Explaining grammar topics\n• 🔢 Step\\-by\\-step breakdowns\n• ✏️ Practice questions\n\nWhat topic do you need help with today?",
        { parse_mode: 'MarkdownV2' }
      );
      return;
    }

    // /reset command
    if (text === '/reset') {
      sessions.delete(String(chatId));
      bot.sendMessage(chatId, "Session reset! Let's start fresh. What topic would you like help with?");
      return;
    }

    const sess  = getSession(String(chatId));
    const reply = respond(text, sess);

    try {
      // Try sending with Markdown formatting
      await bot.sendMessage(chatId, tgFormat(reply), { parse_mode: 'Markdown' });
    } catch {
      // Fall back to plain text if Markdown parsing fails
      await bot.sendMessage(chatId, reply.replace(/[*_`]/g, ''));
    }
  });

  bot.on('polling_error', (err) => {
    console.error('[Telegram polling error]', err.message);
  });

  console.log('🤖 Telegram bot started (polling)');
} else {
  console.warn('⚠️  TELEGRAM_TOKEN not set — Telegram bot is disabled. Add it to .env to enable.');
}

// ─── Start server ─────────────────────────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`✅ Preposition Pal running at http://localhost:${PORT}`);
});
