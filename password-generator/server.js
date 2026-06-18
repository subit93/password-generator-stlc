'use strict';
const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Serve all static files from /public
app.use(express.static(path.join(__dirname, 'public')));

// Fallback — return index.html for any unmatched route
app.get('*', (_req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(PORT, () => {
  console.log(`\n🔐  Password Generator is running!\n`);
  console.log(`    Open in your browser: http://localhost:${PORT}\n`);
});
