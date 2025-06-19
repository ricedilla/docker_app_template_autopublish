const http = require('http');
const PORT = 3000;
http.createServer((req, res) => {
  res.writeHead(200, {'Content-Type': 'text/plain; charset=utf-8'});
  const timestamp = new Date().toISOString();
  res.end(`Hello, www! 🚀\nDeployed: ${timestamp}\nPlatform: ${process.platform}/${process.arch}\n`);
}).listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}/`);
  console.log(`Platform: ${process.platform}/${process.arch}`);
});
