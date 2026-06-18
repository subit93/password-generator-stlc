'use strict';
/* ============================================================
   strength.js — Password strength scoring based on entropy
   ============================================================ */

const Strength = (() => {

  /**
   * Score a password based on its entropy (bits).
   *
   * Thresholds (industry guidelines):
   *   < 40 bits  → Weak
   *   40–79 bits → Medium
   *   80–119 bits→ Strong
   *   120+ bits  → Very Strong
   *
   * @param {number} entropy  Entropy in bits (from Generator.calculateEntropy)
   * @returns {{ label: string, cssClass: string, percent: number, color: string }}
   */
  function calculate(entropy) {
    if (entropy < 40) {
      return {
        label:    'Weak',
        cssClass: 'str-weak',
        percent:  Math.max(5, Math.round((entropy / 40) * 25)),
        color:    'var(--danger)'
      };
    }
    if (entropy < 80) {
      return {
        label:    'Medium',
        cssClass: 'str-medium',
        percent:  25 + Math.round(((entropy - 40) / 40) * 25),
        color:    'var(--warn)'
      };
    }
    if (entropy < 120) {
      return {
        label:    'Strong',
        cssClass: 'str-strong',
        percent:  50 + Math.round(((entropy - 80) / 40) * 30),
        color:    'var(--accent)'
      };
    }
    return {
      label:    'Very Strong',
      cssClass: 'str-very-strong',
      percent:  100,
      color:    'var(--cyan)'
    };
  }

  return { calculate };
})();
