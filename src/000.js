const express = require('express');
const { exec } = require('child_process');
const app = express();
const port = 3000;

// Utility function for safe shell execution
function runScript(scriptPath, args = '', res) {
  const command = args ? `${scriptPath} ${args}` : scriptPath;
  exec(command, (err, stdout, stderr) => {
    if (err) {
      console.error(`Error executing ${command}:`, stderr);
      return res.status(500).send(stderr || 'Script execution error');
    }
    res.send(stdout);
  });
}

app.get('/', (req, res) => {
  runScript('bin/001', '', res);
});

app.get('/aws', (req, res) => {
  runScript('bin/002', '', res);
});

app.get('/docker', (req, res) => {
  runScript('bin/003', '', res);
});

app.get('/loadbalanced', (req, res) => {
  runScript('bin/004', JSON.stringify(req.headers), res);
});

app.get('/tls', (req, res) => {
  runScript('bin/005', JSON.stringify(req.headers), res);
});

app.get('/secret_word', (req, res) => {
  runScript('bin/006', JSON.stringify(req.headers), res);
});

app.listen(port, () => console.log(`Rearc quest listening on port ${port}!`));
