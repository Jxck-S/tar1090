/**
 * tar1090 Development Server:
 * 1. Serves static files from the 'html' directory (allowing local frontend testing).
 * 2. Proxies API requests to globe.theairtraffic.com (fetching live data).
 * 3. Supports a '--no-proxy' flag to run without upstream data.
 * 4. Configures proxy headers to mimic a browser and avoid CORS issues.
 */
const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const path = require('path');
const cors = require('cors');

const app = express();
const PORT = 8080;
const PROXY_TARGET = 'https://globe.theairtraffic.com';
const NO_PROXY = process.argv.includes('--no-proxy');

// Enable CORS
app.use(cors());

// Serve static files from the 'html' directory
// This allows you to verify your local CSS/JS changes
app.use(express.static(path.join(__dirname, 'html')));

// Proxy Headers Configuration
// We mimic a browser to ensure the upstream server accepts the request
const proxyOptions = {
    target: PROXY_TARGET,
    changeOrigin: true, // Needed for virtual hosted sites
    secure: true,       // Verify SSL
    cookieDomainRewrite: 'localhost',
    onProxyReq: (proxyReq, req, res) => {
        proxyReq.setHeader('Referer', PROXY_TARGET + '/');
        proxyReq.setHeader('Origin', PROXY_TARGET);
        // Remove headers that might cause issues
        proxyReq.removeHeader('x-forwarded-for');
        proxyReq.removeHeader('x-forwarded-proto');
        proxyReq.removeHeader('x-forwarded-port');
    },
    onProxyRes: (proxyRes, req, res) => {
        // Allow our local origin to access the proxied resources
        proxyRes.headers['Access-Control-Allow-Origin'] = '*';
    },
    logLevel: 'debug'
};

// --- Proxy Routes ---
// All requests not handled by static files will be forwarded upstream
if (!NO_PROXY) {
    app.use('/', createProxyMiddleware(proxyOptions));
}

app.listen(PORT, () => {
    console.log(`\n=========================================================`);
    console.log(` Dev Server Running!`);
    if (NO_PROXY) {
        console.log(` Proxy: DISABLED`);
    } else {
        console.log(` Proxy Target: ${PROXY_TARGET}`);
    }
    console.log(` Serving Local Files from: ./html`);
    console.log(` Local Address: http://localhost:${PORT}`);
    console.log(`=========================================================\n`);
});
