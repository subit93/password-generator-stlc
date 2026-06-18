'use strict';
/* ============================================================
   app.js — UI controller: event wiring, state, DOM updates
   Depends on: generator.js, strength.js, presets.js, history.js
   ============================================================ */

(function () {

  // ── DOM helper ─────────────────────────────────────────────
  const $ = id => document.getElementById(id);

  // ── Generator tab elements ──────────────────────────────────
  const lengthSlider   = $('length-slider');
  const lengthDisplay  = $('length-display');
  const shortWarning   = $('short-warning');
  const incUppercase   = $('inc-uppercase');
  const incLowercase   = $('inc-lowercase');
  const incNumbers     = $('inc-numbers');
  const incSymbols     = $('inc-symbols');
  const exclAmbiguous  = $('excl-ambiguous');
  const reqEach        = $('req-each');
  const strengthFill   = $('strength-fill');
  const strengthLabel  = $('strength-label');
  const entropyLabel   = $('entropy-label');
  const outputBox      = $('output-box');
  const passwordText   = $('password-text');
  const showHideBtn    = $('show-hide-btn');
  const eyeIcon        = $('eye-icon');
  const clearCountdown = $('clear-countdown');
  const generateBtn    = $('generate-btn');
  const copyBtn        = $('copy-btn');
  const regenBtn       = $('regen-btn');

  // ── Bulk tab elements ───────────────────────────────────────
  const bulkCount        = $('bulk-count');
  const bulkCountDisplay = $('bulk-count-display');
  const bulkGenerateBtn  = $('bulk-generate-btn');
  const bulkExportBtn    = $('bulk-export-btn');
  const bulkClearBtn     = $('bulk-clear-btn');
  const bulkList         = $('bulk-list');

  // ── Passphrase tab elements ─────────────────────────────────
  const phraseCount       = $('phrase-count');
  const phraseCountDisp   = $('phrase-count-display');
  const phraseGenerateBtn = $('phrase-generate-btn');
  const phraseCopyBtn     = $('phrase-copy-btn');
  const phraseOutputBox   = $('phrase-output-box');
  const phraseText        = $('phrase-text');

  // ── History tab elements ────────────────────────────────────
  const clearHistoryBtn = $('clear-history-btn');
  const historyList     = $('history-list');

  // ── Toast ───────────────────────────────────────────────────
  const toastEl = $('toast');

  // ── State ───────────────────────────────────────────────────
  let currentPassword  = '';
  let currentPhrase    = '';
  let bulkPasswords    = [];
  let isHidden         = false;
  let activePreset     = null;
  let countdownTimer   = null;
  let countdownSeconds = 0;
  let toastTimer       = null;

  const AUTO_CLEAR_SECS = 60; // seconds before password auto-clears

  // ══════════════════════════════════════════════════════════════
  //  OPTIONS
  // ══════════════════════════════════════════════════════════════
  function getOptions() {
    return {
      length:            parseInt(lengthSlider.value, 10),
      include_uppercase: incUppercase.checked,
      include_lowercase: incLowercase.checked,
      include_numbers:   incNumbers.checked,
      include_symbols:   incSymbols.checked,
      excludeAmbiguous:  exclAmbiguous.checked,
      requireEach:       reqEach.checked
    };
  }

  // ══════════════════════════════════════════════════════════════
  //  PRESETS
  // ══════════════════════════════════════════════════════════════
  function applyPreset(name) {
    const cfg = Presets.get(name);
    if (!cfg) return;
    activePreset = name;

    lengthSlider.value    = cfg.length;
    lengthDisplay.textContent = cfg.length;
    incUppercase.checked  = cfg.include_uppercase;
    incLowercase.checked  = cfg.include_lowercase;
    incNumbers.checked    = cfg.include_numbers;
    incSymbols.checked    = cfg.include_symbols;
    exclAmbiguous.checked = cfg.excludeAmbiguous;
    reqEach.checked       = cfg.requireEach;

    syncToggleCards();
    updateStrengthBar();
    updateShortWarning();
    highlightPreset(name);
  }

  function highlightPreset(name) {
    document.querySelectorAll('.preset-btn').forEach(btn => {
      btn.classList.toggle('active', btn.dataset.preset === name);
    });
  }

  function clearPresetHighlight() {
    document.querySelectorAll('.preset-btn').forEach(btn => btn.classList.remove('active'));
    activePreset = null;
  }

  // ══════════════════════════════════════════════════════════════
  //  TOGGLE CARD VISUALS
  // ══════════════════════════════════════════════════════════════
  function syncToggleCards() {
    [
      ['card-uppercase', incUppercase],
      ['card-lowercase', incLowercase],
      ['card-numbers',   incNumbers],
      ['card-symbols',   incSymbols]
    ].forEach(([cardId, input]) => {
      const card = $(cardId);
      card.style.borderColor = input.checked ? 'var(--accent)' : '';
    });
  }

  // ══════════════════════════════════════════════════════════════
  //  STRENGTH BAR (live, updates as user tweaks options)
  // ══════════════════════════════════════════════════════════════
  function updateStrengthBar() {
    const opts    = getOptions();
    const entropy = Generator.calculateEntropy(opts);
    const result  = Strength.calculate(entropy);

    strengthFill.className = 'strength-bar-fill ' + result.cssClass;
    strengthFill.style.width = result.percent + '%';

    strengthLabel.textContent = result.label;
    strengthLabel.style.color = result.color;

    entropyLabel.textContent = entropy > 0 ? `~${entropy} bits` : '—';
  }

  // ══════════════════════════════════════════════════════════════
  //  SHORT PASSWORD WARNING
  // ══════════════════════════════════════════════════════════════
  function updateShortWarning() {
    const len = parseInt(lengthSlider.value, 10);
    shortWarning.classList.toggle('visible', len < 12);
  }

  // ══════════════════════════════════════════════════════════════
  //  GENERATE PASSWORD
  // ══════════════════════════════════════════════════════════════
  function doGenerate() {
    const opts = getOptions();
    const noSets = !opts.include_uppercase && !opts.include_lowercase
                 && !opts.include_numbers  && !opts.include_symbols;
    if (noSets) {
      showToast('⚠️ Select at least one character set.', 'warn');
      return;
    }

    currentPassword = Generator.generatePassword(opts);
    isHidden = false;

    renderPassword();
    copyBtn.disabled  = false;
    regenBtn.disabled = false;

    History.add(currentPassword, 'password');
    startAutoClear();
    updateStrengthBar();
  }

  // ══════════════════════════════════════════════════════════════
  //  RENDER PASSWORD OUTPUT
  // ══════════════════════════════════════════════════════════════
  function renderPassword() {
    // textContent is XSS-safe — no innerHTML used here
    passwordText.textContent = currentPassword;
    passwordText.classList.remove('placeholder', 'blurred');
    if (isHidden) passwordText.classList.add('blurred');
    eyeIcon.textContent = isHidden ? '🙈' : '👁';
  }

  // ══════════════════════════════════════════════════════════════
  //  AUTO-CLEAR TIMER (security: clear after 60s)
  // ══════════════════════════════════════════════════════════════
  function startAutoClear() {
    stopAutoClear();
    countdownSeconds = AUTO_CLEAR_SECS;
    tickCountdown();
    countdownTimer = setInterval(tickCountdown, 1000);
  }

  function tickCountdown() {
    if (countdownSeconds <= 0) {
      clearPassword();
      return;
    }
    clearCountdown.textContent = `🔒 Auto-clears in ${countdownSeconds}s`;
    countdownSeconds--;
  }

  function stopAutoClear() {
    if (countdownTimer) { clearInterval(countdownTimer); countdownTimer = null; }
    clearCountdown.textContent = '';
  }

  function clearPassword() {
    stopAutoClear();
    currentPassword = '';
    isHidden = false;

    passwordText.textContent = 'Password cleared for security.';
    passwordText.className   = 'output-text placeholder';
    eyeIcon.textContent      = '👁';

    copyBtn.disabled  = true;
    regenBtn.disabled = true;

    showToast('🔒 Password cleared after 60s for security.', 'warn');
  }

  // ══════════════════════════════════════════════════════════════
  //  CLIPBOARD
  // ══════════════════════════════════════════════════════════════
  async function copyToClipboard(text, label) {
    if (!text) return;
    try {
      await navigator.clipboard.writeText(text);
      showToast(`✅ ${label} copied to clipboard!`, 'success');
    } catch {
      showToast('❌ Copy failed — please select the text and copy manually.', 'error');
    }
  }

  // ══════════════════════════════════════════════════════════════
  //  TOAST
  // ══════════════════════════════════════════════════════════════
  function showToast(message, type = '') {
    toastEl.textContent = message;
    toastEl.className   = `toast ${type} show`;
    if (toastTimer) clearTimeout(toastTimer);
    toastTimer = setTimeout(() => toastEl.classList.remove('show'), 2800);
  }

  // ══════════════════════════════════════════════════════════════
  //  TABS
  // ══════════════════════════════════════════════════════════════
  function initTabs() {
    document.querySelectorAll('.tab').forEach(tab => {
      tab.addEventListener('click', () => {
        document.querySelectorAll('.tab').forEach(t => {
          t.classList.remove('active');
          t.setAttribute('aria-selected', 'false');
        });
        document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));

        tab.classList.add('active');
        tab.setAttribute('aria-selected', 'true');
        document.getElementById('tab-' + tab.dataset.tab).classList.add('active');

        if (tab.dataset.tab === 'history') renderHistory();
      });
    });
  }

  // ══════════════════════════════════════════════════════════════
  //  HISTORY TAB
  // ══════════════════════════════════════════════════════════════
  function renderHistory() {
    const records = History.getAll();
    if (records.length === 0) {
      historyList.innerHTML = '<p class="empty-msg">No passwords generated yet.</p>';
      return;
    }

    // Build HTML — passwords are escaped via escapeHtml, never via innerHTML with raw data
    historyList.innerHTML = records.map((r, i) =>
      `<div class="history-item">
        <span class="history-text">${escapeHtml(r.password)}</span>
        <span class="history-type">${escapeHtml(r.type)}</span>
        <span class="history-time">${escapeHtml(r.time)}</span>
        <button class="history-copy" data-idx="${i}" title="Copy to clipboard">📋</button>
      </div>`
    ).join('');

    // Wire copy buttons using index lookup (avoids storing raw passwords in attributes)
    historyList.querySelectorAll('.history-copy').forEach(btn => {
      btn.addEventListener('click', () => {
        const idx = parseInt(btn.dataset.idx, 10);
        const record = History.getAll()[idx];
        if (record) copyToClipboard(record.password, 'Password');
      });
    });
  }

  // ══════════════════════════════════════════════════════════════
  //  BULK TAB
  // ══════════════════════════════════════════════════════════════
  function renderBulkList() {
    if (bulkPasswords.length === 0) { bulkList.innerHTML = ''; return; }

    bulkList.innerHTML = bulkPasswords.map((pw, i) =>
      `<div class="bulk-item">
        <span class="bulk-item-num">${i + 1}.</span>
        <span class="bulk-item-text">${escapeHtml(pw)}</span>
        <button class="bulk-item-copy" data-idx="${i}" title="Copy">📋</button>
      </div>`
    ).join('');

    bulkList.querySelectorAll('.bulk-item-copy').forEach(btn => {
      btn.addEventListener('click', () => {
        const idx = parseInt(btn.dataset.idx, 10);
        copyToClipboard(bulkPasswords[idx], 'Password');
      });
    });
  }

  function exportBulkAsTxt() {
    const content = bulkPasswords.join('\n');
    const blob    = new Blob([content], { type: 'text/plain;charset=utf-8' });
    const url     = URL.createObjectURL(blob);
    const a       = Object.assign(document.createElement('a'), {
      href:     url,
      download: `passwords-${Date.now()}.txt`
    });
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
    showToast(`⬇ ${bulkPasswords.length} passwords exported!`, 'success');
  }

  // ══════════════════════════════════════════════════════════════
  //  XSS-SAFE HTML ESCAPE
  // ══════════════════════════════════════════════════════════════
  function escapeHtml(str) {
    return String(str)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

  // ══════════════════════════════════════════════════════════════
  //  INIT — wire all events
  // ══════════════════════════════════════════════════════════════
  function init() {

    // Tabs
    initTabs();

    // ── Length slider ─────────────────────────────────────────
    lengthSlider.addEventListener('input', () => {
      lengthDisplay.textContent = lengthSlider.value;
      updateShortWarning();
      updateStrengthBar();
      clearPresetHighlight();
    });

    // ── Character set checkboxes ──────────────────────────────
    [incUppercase, incLowercase, incNumbers, incSymbols].forEach(cb => {
      cb.addEventListener('change', () => {
        syncToggleCards();
        updateStrengthBar();
        clearPresetHighlight();
      });
    });

    // ── Options checkboxes ────────────────────────────────────
    [exclAmbiguous, reqEach].forEach(cb => {
      cb.addEventListener('change', () => {
        updateStrengthBar();
        clearPresetHighlight();
      });
    });

    // ── Preset buttons ────────────────────────────────────────
    document.querySelectorAll('.preset-btn').forEach(btn => {
      btn.addEventListener('click', () => applyPreset(btn.dataset.preset));
    });

    // ── Generator actions ─────────────────────────────────────
    generateBtn.addEventListener('click', doGenerate);
    regenBtn.addEventListener('click', doGenerate);

    copyBtn.addEventListener('click', () => copyToClipboard(currentPassword, 'Password'));

    // Clicking the output box also copies (but not the show/hide button)
    outputBox.addEventListener('click', e => {
      if (e.target === showHideBtn || showHideBtn.contains(e.target)) return;
      copyToClipboard(currentPassword, 'Password');
    });

    // ── Show / hide toggle ────────────────────────────────────
    showHideBtn.addEventListener('click', e => {
      e.stopPropagation();
      if (!currentPassword) return;
      isHidden = !isHidden;
      renderPassword();
    });

    // ── Bulk tab ──────────────────────────────────────────────
    bulkCount.addEventListener('input', () => {
      bulkCountDisplay.textContent = bulkCount.value;
    });

    bulkGenerateBtn.addEventListener('click', () => {
      const opts = getOptions();
      const noSets = !opts.include_uppercase && !opts.include_lowercase
                   && !opts.include_numbers  && !opts.include_symbols;
      if (noSets) { showToast('⚠️ Select at least one character set.', 'warn'); return; }

      const n = parseInt(bulkCount.value, 10);
      bulkPasswords = Generator.generateBulk(n, opts);
      bulkPasswords.forEach(pw => History.add(pw, 'bulk'));

      renderBulkList();
      bulkExportBtn.disabled = false;
      bulkClearBtn.disabled  = false;
      showToast(`✅ ${n} passwords generated!`, 'success');
    });

    bulkExportBtn.addEventListener('click', exportBulkAsTxt);

    bulkClearBtn.addEventListener('click', () => {
      bulkPasswords = [];
      bulkList.innerHTML      = '';
      bulkExportBtn.disabled  = true;
      bulkClearBtn.disabled   = true;
    });

    // ── Passphrase tab ────────────────────────────────────────
    phraseCount.addEventListener('input', () => {
      phraseCountDisp.textContent = phraseCount.value;
    });

    phraseGenerateBtn.addEventListener('click', () => {
      const wordCount   = parseInt(phraseCount.value, 10);
      currentPhrase     = Generator.generatePassphrase(wordCount);
      phraseText.textContent = currentPhrase;
      phraseText.classList.remove('placeholder');
      phraseCopyBtn.disabled = false;
      History.add(currentPhrase, 'passphrase');
    });

    phraseCopyBtn.addEventListener('click', () => copyToClipboard(currentPhrase, 'Passphrase'));

    // Click on phrase output box also copies
    phraseOutputBox.addEventListener('click', () => copyToClipboard(currentPhrase, 'Passphrase'));

    // ── History tab ───────────────────────────────────────────
    clearHistoryBtn.addEventListener('click', () => {
      History.clear();
      renderHistory();
      showToast('🗑 History cleared.', '');
    });

    // ── Initial UI state ──────────────────────────────────────
    syncToggleCards();
    updateStrengthBar();
    updateShortWarning();
    applyPreset('superSecure'); // sensible default
  }

  // Kick everything off once the DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

})();
