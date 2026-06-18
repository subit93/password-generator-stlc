'use strict';
/* ============================================================
   history.js — Persistent password history via localStorage
   Records are stored under the key 'pwg_history' so they
   survive page reloads.  Nothing is sent to any server.
   ============================================================ */

const History = (() => {

  const MAX_RECORDS = 50;
  const STORAGE_KEY = 'pwg_history';

  // Initialise from localStorage if data exists
  let records = [];
  try {
    const stored = localStorage.getItem(STORAGE_KEY);
    if (stored) records = JSON.parse(stored);
  } catch (e) { records = []; }

  /** Persist the current records array to localStorage. */
  function _save() {
    try { localStorage.setItem(STORAGE_KEY, JSON.stringify(records)); } catch (e) { /* quota/private mode */ }
  }

  /**
   * Add a new record to the top of the history.
   * @param {string} password  The generated password or passphrase.
   * @param {'password'|'passphrase'|'bulk'} type
   */
  function add(password, type = 'password') {
    records.unshift({
      password,
      type,
      time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' })
    });
    // Cap the list to avoid unbounded growth
    if (records.length > MAX_RECORDS) records.length = MAX_RECORDS;
    _save();
  }

  /** Return a shallow copy of all records (newest first). */
  function getAll() { return [...records]; }

  /** Wipe the in-memory history and remove from localStorage. */
  function clear() {
    records = [];
    try { localStorage.removeItem(STORAGE_KEY); } catch (e) { /* ignore */ }
  }

  /** Number of stored records. */
  function count() { return records.length; }

  return { add, getAll, clear, count };
})();
