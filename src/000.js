const express = require('express');
const { exec } = require('child_process');
const fs = require('fs');
const https = require('https');
const path = require('path');

const app = express();
const httpPort = 3000;
const httpsPort = 3443;

// === ROUTES ===
app.get('/', (req, res) => {
  exec('bin/001', (err, stdout, stderr) => {
    if (err) return res.status(500).send(stderr);
    res.send(stdout);
  });
});

app.get('/aws', (req, res) => {
  exec('bin/002', (err, stdout, stderr) => {
    res.send(stdout || stderr);
  });
});

app.get('/docker', (req, res) => {
  exec('bin/003', (err, stdout, stderr) => {
    res.send(stdout || stderr);
  });
});

app.get('/loadbalanced', (req, res) => {
  exec(`bin/004 '${JSON.stringify(req.headers)}'`, (err, stdout, stderr) => {
    res.send(stdout || stderr);
  });
});

app.get('/tls', (req, res) => {
  exec(`bin/005 '${JSON.stringify(req.headers)}'`, (err, stdout, stderr) => {
    res.send(stdout || stderr);
  });
});

app.get('/secret_word', (req, res) => {
  exec(`bin/006 '${JSON.stringify(req.headers)}'`, (err, stdout, stderr) => {
    res.send(stdout || stderr);
  });
});

// === START HTTP SERVER ===
app.listen(httpPort, '0.0.0.0', () => {
  console.log(`HTTP server running on port ${httpPort}`);
});

// === START HTTPS SERVER ===
const certPath = path.join(__dirname, 'cert');

try {
  const key = fs.readFileSync(path.join(certPath, 'key.pem'));
  const cert = fs.readFileSync(path.join(certPath, 'cert.pem'));

  const httpsOptions = { key, cert };

  https.createServer(httpsOptions, app).listen(httpsPort, '0.0.0.0', () => {
    console.log(`HTTPS server running on port ${httpsPort}`);
  });
} catch (err) {
  console.error('Failed to start HTTPS server. Certificate files may be missing or invalid.');
  console.error(err.message);
}

# The above code is been used I just used the https cert certificate but again this way is also not that secured
# The below code also works but for http
// const express = require('express');
// const { exec } = require('child_process');
// const app = express();
// const port = 3000;

// // Utility function for safe shell execution
// function runScript(scriptPath, args = '', res) {
//   const command = args ? `${scriptPath} ${args}` : scriptPath;
//   exec(command, (err, stdout, stderr) => {
//     if (err) {
//       console.error(`Error executing ${command}:`, stderr);
//       return res.status(500).send(stderr || 'Script execution error');
//     }
//     res.send(stdout);
//   });
// }

// app.get('/', (req, res) => {
//   runScript('bin/001', '', res);
// });

// app.get('/aws', (req, res) => {
//   runScript('bin/002', '', res);
// });

// app.get('/docker', (req, res) => {
//   runScript('bin/003', '', res);
// });

// app.get('/loadbalanced', (req, res) => {
//   runScript('bin/004', JSON.stringify(req.headers), res);
// });

// app.get('/tls', (req, res) => {
//   runScript('bin/005', JSON.stringify(req.headers), res);
// });

// app.get('/secret_word', (req, res) => {
//   runScript('bin/006', JSON.stringify(req.headers), res);
// });

// //app.listen(port, () => console.log(`Rearc quest listening on port ${port}!`));
// app.listen(port, '0.0.0.0', () => console.log(`Rearc quest listening on port ${port}!`));
