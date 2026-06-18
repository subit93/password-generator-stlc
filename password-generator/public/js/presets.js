'use strict';
/* ============================================================
   presets.js — Named preset configurations
   Each preset maps to a full set of generator options.
   ============================================================ */

const Presets = (() => {

  const configs = {
    social: {
      label:            'Social',
      length:           12,
      include_uppercase: true,
      include_lowercase: true,
      include_numbers:   true,
      include_symbols:   false,
      excludeAmbiguous:  false,
      requireEach:       true
    },
    banking: {
      label:            'Banking',
      length:           16,
      include_uppercase: true,
      include_lowercase: true,
      include_numbers:   true,
      include_symbols:   true,
      excludeAmbiguous:  true,   // avoid O/0/l/1 confusion on bank forms
      requireEach:       true
    },
    work: {
      label:            'Work',
      length:           16,
      include_uppercase: true,
      include_lowercase: true,
      include_numbers:   true,
      include_symbols:   false,  // some work systems reject special chars
      excludeAmbiguous:  true,
      requireEach:       true
    },
    superSecure: {
      label:            'Super Secure',
      length:           32,
      include_uppercase: true,
      include_lowercase: true,
      include_numbers:   true,
      include_symbols:   true,
      excludeAmbiguous:  true,
      requireEach:       true
    }
  };

  /** Return a preset config by name, or null if not found. */
  function get(name) { return configs[name] || null; }

  /** Return all preset configs. */
  function all() { return configs; }

  return { get, all };
})();
