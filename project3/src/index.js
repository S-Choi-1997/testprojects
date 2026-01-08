const express = require('express');
const app = express();
const port = 3000;

app.use(express.json());

app.get('/api/express', (req, res) => {
  res.json({ message: 'Hello from Express!' });
});

app.get('/api/express/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Server running at http://0.0.0.0:${port}`);
});
