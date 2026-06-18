'use strict';
/* ============================================================
   history.js — Session-only password history
   Stored entirely in memory (a plain JS array).
   Cleared automatically when the tab is closed or refreshed.
   Nothing is ever written to localStorage or sent anywhere.
   ============================================================ */

const History = (() => {

  const MAX_RECORDS = 50;
  let records = [];

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
  }

  /** Return a shallow copy of all records (newest first). */
  function getAll() { return [...records]; }

  /** Wipe the in-memory history. */
  function clear() { records = []; }

  /** Number of stored records. */
  function count() { return records.length; }

  return { add, getAll, clear, count };
})();
