const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = 3001;
const PUBLIC_DIR = __dirname;
const UPLOADS_DIR = path.join(PUBLIC_DIR, 'uploads');

if (!fs.existsSync(UPLOADS_DIR)) {
    fs.mkdirSync(UPLOADS_DIR, { recursive: true });
}

const MIME_TYPES = {
    '.html': 'text/html; charset=utf-8',
    '.css': 'text/css; charset=utf-8',
    '.js': 'application/javascript; charset=utf-8',
    '.json': 'application/json',
    '.png': 'image/png',
    '.jpg': 'image/jpeg',
    '.jpeg': 'image/jpeg',
    '.svg': 'image/svg+xml',
    '.pdf': 'application/pdf',
    '.docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    '.doc': 'application/msword',
    '.xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    '.xls': 'application/vnd.ms-excel',
    '.csv': 'text/csv; charset=utf-8',
    '.pptx': 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    '.ppt': 'application/vnd.ms-powerpoint',
    '.zip': 'application/zip',
    '.ipynb': 'application/x-ipynb+json',
    '.ico': 'image/x-icon'
};

const server = http.createServer((req, res) => {
    // 1. API: File Upload
    if (req.method === 'POST' && req.url === '/api/upload') {
        let body = '';
        req.on('data', chunk => { body += chunk; });
        req.on('end', () => {
            try {
                const { filename, base64 } = JSON.parse(body);
                if (!filename || !base64) {
                    res.writeHead(400, { 'Content-Type': 'application/json' });
                    return res.end(JSON.stringify({ error: 'Missing filename or base64 data' }));
                }

                // Sanitize filename
                const safeName = Date.now() + '_' + filename.replace(/[^a-zA-Z0-9._-]/g, '_');
                const filePath = path.join(UPLOADS_DIR, safeName);
                const buffer = Buffer.from(base64, 'base64');

                fs.writeFileSync(filePath, buffer);
                const fileUrl = '/uploads/' + safeName;

                res.writeHead(200, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ success: true, url: fileUrl, filename: safeName }));
            } catch (err) {
                res.writeHead(500, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ error: err.message }));
            }
        });
        return;
    }

    // 2. API: Save Academic Data to Disk
    if (req.method === 'POST' && req.url === '/api/save-data') {
        let body = '';
        req.on('data', chunk => { body += chunk; });
        req.on('end', () => {
            try {
                const dataPath = path.join(PUBLIC_DIR, 'curriculum_data.json');
                fs.writeFileSync(dataPath, body, 'utf-8');
                res.writeHead(200, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ success: true }));
            } catch (err) {
                res.writeHead(500, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ error: err.message }));
            }
        });
        return;
    }

    // 3. API: Get Academic Data
    if (req.method === 'GET' && req.url === '/api/get-data') {
        const dataPath = path.join(PUBLIC_DIR, 'curriculum_data.json');
        if (fs.existsSync(dataPath)) {
            const data = fs.readFileSync(dataPath, 'utf-8');
            res.writeHead(200, { 'Content-Type': 'application/json' });
            return res.end(data);
        } else {
            res.writeHead(404, { 'Content-Type': 'application/json' });
            return res.end(JSON.stringify({ error: 'No custom data file found' }));
        }
    }

    // Static File Serving
    let safeUrl = req.url.split('?')[0];
    if (safeUrl === '/' || safeUrl === '') {
        safeUrl = '/index.html';
    } else if (safeUrl === '/admin') {
        safeUrl = '/admin.html';
    }

    let filePath = path.join(PUBLIC_DIR, safeUrl);

    if (fs.existsSync(filePath) && fs.statSync(filePath).isDirectory()) {
        filePath = path.join(filePath, 'index.html');
    }

    fs.readFile(filePath, (err, content) => {
        if (err) {
            if (err.code === 'ENOENT') {
                const indexPath = path.join(PUBLIC_DIR, 'index.html');
                fs.readFile(indexPath, (idxErr, idxContent) => {
                    if (idxErr) {
                        res.writeHead(404, { 'Content-Type': 'text/plain' });
                        res.end('404 Not Found');
                    } else {
                        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
                        res.end(idxContent);
                    }
                });
            } else {
                res.writeHead(500, { 'Content-Type': 'text/plain' });
                res.end(`Server Error: ${err.code}`);
            }
        } else {
            const ext = path.extname(filePath).toLowerCase();
            const contentType = MIME_TYPES[ext] || 'application/octet-stream';
            res.writeHead(200, { 
                'Content-Type': contentType,
                'Content-Disposition': 'inline'
            });
            res.end(content);
        }
    });
});

server.listen(PORT, '0.0.0.0', () => {
    console.log(`🚀 Kepler Academic Server running at http://localhost:${PORT}/`);
    console.log(`📁 Serving directory: ${PUBLIC_DIR}`);
    console.log(`📂 Uploads folder: ${UPLOADS_DIR}`);
});
