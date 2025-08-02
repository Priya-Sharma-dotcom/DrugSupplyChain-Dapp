const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 8080;

// Serve files from current folder (like index.html, ABI.json, script.js)
app.use(express.static(__dirname));

// Start server
app.listen(PORT, () => {
  console.log(` App running at http://localhost:${PORT}`);
});
