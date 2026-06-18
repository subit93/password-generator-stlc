'use strict';
/* ============================================================
   generator.js — Core password & passphrase generation
   All generation is done client-side using crypto.getRandomValues()
   for cryptographically secure output. No network calls. No server.
   ============================================================ */

const Generator = (() => {

  // ── Character sets ──────────────────────────────────────────
  const SETS = {
    uppercase: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    lowercase: 'abcdefghijklmnopqrstuvwxyz',
    numbers:   '0123456789',
    symbols:   '!@#$%^&*()_+-=[]{}|;:,.<>?/'
  };

  // Characters that look alike and cause confusion
  const AMBIGUOUS = new Set(['O', '0', 'l', '1', 'I']);

  // Curated word list for passphrase mode
  const WORDS = [
    'abandon','ability','absence','academy','account','achieve','acquire','address',
    'advance','ancient','balance','barrier','blossom','bravery','captain','capture',
    'cascade','chapter','circuit','classic','climate','cluster','compass','courage',
    'crystal','culture','curious','current','declare','defense','diamond','digital',
    'distant','diverse','dynamic','element','elegant','embrace','endless','enhance',
    'essence','extreme','fantasy','feature','fighter','finance','foreign','forward',
    'freedom','gallery','gateway','general','glacier','glitter','gravity','harmony',
    'harvest','history','horizon','hundred','imagine','impulse','journey','justice',
    'kingdom','lantern','library','liberty','logical','loyalty','machine','mineral',
    'mission','monarch','morning','mystery','network','nuclear','observe','operate',
    'organic','passion','pattern','phantom','pioneer','popular','primary','private',
    'product','program','quantum','radical','railway','reality','recover','reflect',
    'resolve','respect','restore','revenue','science','section','serious','shelter',
    'silicon','silence','similar','soldier','special','success','surface','survive',
    'thunder','tourism','trigger','trouble','typical','uniform','unknown','upgrade',
    'venture','victory','village','virtual','warrior','website','western','whisper',
    'working','writing','younger','zealous','abstract','acoustic','adjacent','alliance',
    'ambient','angular','aquatic','archive','arsenal','artisan','ascribe','fortune',
    'blazing','coastal','destiny','endless','fertile','glowing','horizon','insight',
    'lasting','meadow','natural','origins','persist','quality','radiant','serene'
  ];

  // ── Crypto-secure random integer in [0, max) ────────────────
  // Uses rejection sampling to eliminate modulo bias.
  function secureRandom(max) {
    if (max <= 1) return 0;
    const limit = 4294967296 - (4294967296 % max); // largest multiple of max ≤ 2^32
    const buf = new Uint32Array(1);
    let val;
    do {
      crypto.getRandomValues(buf);
      val = buf[0];
    } while (val >= limit);
    return val % max;
  }

  // ── Build charset list from options ────────────────────────
  function buildSets(opts) {
    const result = [];
    ['uppercase', 'lowercase', 'numbers', 'symbols'].forEach(key => {
      if (!opts[`include_${key}`]) return;
      let chars = SETS[key];
      if (opts.excludeAmbiguous) {
        chars = chars.split('').filter(c => !AMBIGUOUS.has(c)).join('');
      }
      if (chars.length > 0) result.push({ key, chars });
    });
    return result;
  }

  // ── Generate a single password ──────────────────────────────
  function generatePassword(opts) {
    const sets = buildSets(opts);
    if (sets.length === 0) return '';

    const fullCharset = sets.map(s => s.chars).join('');
    const targetLen   = Math.max(opts.length, opts.requireEach ? sets.length : 1);
    const arr         = [];

    // Guarantee at least one char from each selected set
    if (opts.requireEach) {
      sets.forEach(s => arr.push(s.chars[secureRandom(s.chars.length)]));
    }

    // Fill remaining positions
    while (arr.length < targetLen) {
      arr.push(fullCharset[secureRandom(fullCharset.length)]);
    }

    // Fisher-Yates shuffle to randomise position of required chars
    for (let i = arr.length - 1; i > 0; i--) {
      const j = secureRandom(i + 1);
      [arr[i], arr[j]] = [arr[j], arr[i]];
    }

    return arr.join('');
  }

  // ── Generate a passphrase ───────────────────────────────────
  function generatePassphrase(wordCount) {
    const picked = [];
    for (let i = 0; i < wordCount; i++) {
      picked.push(WORDS[secureRandom(WORDS.length)]);
    }
    return picked.join('-');
  }

  // ── Generate multiple passwords ─────────────────────────────
  function generateBulk(count, opts) {
    return Array.from({ length: count }, () => generatePassword(opts));
  }

  // ── Estimate entropy in bits ────────────────────────────────
  // H = L × log₂(N)  where L = length, N = charset size
  function calculateEntropy(opts) {
    const sets = buildSets(opts);
    const charsetSize = sets.reduce((sum, s) => sum + s.chars.length, 0);
    if (charsetSize === 0 || opts.length === 0) return 0;
    return Math.round(opts.length * Math.log2(charsetSize));
  }

  // ── Public API ──────────────────────────────────────────────
  return { generatePassword, generatePassphrase, generateBulk, calculateEntropy };

})();
