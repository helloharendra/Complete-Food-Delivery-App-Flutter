const express = require('express');
const multer = require('multer');
const cors = require('cors');
const path = require('path');
const fs = require('fs');
const os = require('os');

const app = express();
const PORT = Number(process.env.PORT || 8091);
const publicBaseUrl = process.env.DIERB_PUBLIC_UPLOAD_URL || `http://169.58.246.131:${PORT}`;
const root = process.env.DIERB_UPLOAD_ROOT || path.join(os.homedir(), 'Desktop', 'Dierb-Images');
const allowedTypes = new Set(['products', 'stores', 'categories', 'profiles']);
const rateBuckets = new Map();

for (const dir of allowedTypes) fs.mkdirSync(path.join(root, dir), { recursive: true });

app.disable('x-powered-by');
app.use(cors({ methods: ['GET', 'POST', 'OPTIONS'], allowedHeaders: ['Content-Type', 'Authorization'] }));
app.use('/uploads', express.static(root, {
  fallthrough: false,
  immutable: true,
  maxAge: '30d',
  setHeaders: (res) => {
    res.setHeader('X-Content-Type-Options', 'nosniff');
    res.setHeader('Cross-Origin-Resource-Policy', 'cross-origin');
  },
}));

function uploadRateLimit(req, res, next) {
  const key = req.ip || req.socket.remoteAddress || 'unknown';
  const now = Date.now();
  const windowMs = 15 * 60 * 1000;
  const existing = rateBuckets.get(key);
  const bucket = !existing || now - existing.startedAt > windowMs ? { startedAt: now, count: 0 } : existing;
  bucket.count += 1;
  rateBuckets.set(key, bucket);
  if (bucket.count > 30) return res.status(429).json({ success: false, error: 'Too many uploads. Try again later.' });
  next();
}

setInterval(() => {
  const cutoff = Date.now() - 30 * 60 * 1000;
  for (const [key, value] of rateBuckets) if (value.startedAt < cutoff) rateBuckets.delete(key);
}, 15 * 60 * 1000).unref();

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const requestedType = String(req.body?.type || req.query?.type || 'products').toLowerCase();
    const type = allowedTypes.has(requestedType) ? requestedType : 'products';
    req.dierbUploadType = type;
    cb(null, path.join(root, type));
  },
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname).toLowerCase();
    const safeExt = ['.jpg', '.jpeg', '.png', '.webp'].includes(ext) ? ext : '.jpg';
    cb(null, `${Date.now()}-${require('crypto').randomBytes(12).toString('hex')}${safeExt}`);
  },
});

const upload = multer({
  storage,
  limits: { fileSize: 8 * 1024 * 1024, files: 1, fields: 4 },
  fileFilter: (req, file, cb) => {
    const ok = ['image/jpeg', 'image/png', 'image/webp'].includes(file.mimetype);
    cb(ok ? null : new Error('Only JPG, PNG and WEBP images are allowed'), ok);
  },
});

function hasValidImageSignature(filePath) {
  const bytes = Buffer.alloc(12);
  const fd = fs.openSync(filePath, 'r');
  try { fs.readSync(fd, bytes, 0, bytes.length, 0); } finally { fs.closeSync(fd); }
  const jpeg = bytes[0] === 0xff && bytes[1] === 0xd8 && bytes[2] === 0xff;
  const png = bytes.subarray(0, 8).equals(Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]));
  const webp = bytes.subarray(0, 4).toString() === 'RIFF' && bytes.subarray(8, 12).toString() === 'WEBP';
  return jpeg || png || webp;
}

app.get('/health', (req, res) => res.json({ ok: true, service: 'Dierb VPS Uploads' }));

app.post('/upload', uploadRateLimit, upload.single('file'), (req, res) => {
  if (!req.file) return res.status(400).json({ success: false, error: 'No image uploaded' });
  if (!hasValidImageSignature(req.file.path)) {
    fs.rmSync(req.file.path, { force: true });
    return res.status(415).json({ success: false, error: 'Invalid image content' });
  }
  const type = req.dierbUploadType || 'products';
  res.status(200).json({
    success: true,
    fileName: req.file.filename,
    type,
    url: `${publicBaseUrl}/uploads/${type}/${req.file.filename}`,
  });
});

app.use((err, req, res, next) => {
  if (req.file?.path) fs.rm(req.file.path, { force: true }, () => {});
  const status = err instanceof multer.MulterError && err.code === 'LIMIT_FILE_SIZE' ? 413 : 400;
  console.error(`[upload] ${err.message || 'failed'}`);
  res.status(status).json({ success: false, error: err.message || 'Upload failed' });
});

app.listen(PORT, '0.0.0.0', () => console.log(`Dierb upload server ready on port ${PORT}`));
