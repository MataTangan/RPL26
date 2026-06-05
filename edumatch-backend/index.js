const express = require('express');
const cors = require('cors');
const crypto = require('crypto');

const app = express();
app.use(cors());
app.use(express.json());

// ─── In-memory "database" ─────────────────────────────────────────────────────
const siswaDb = [];   // { id, name, email, passwordHash }
const tutorDb = [];   // { id, name, email, passwordHash, phone }
const sessions = [];  // booking sessions

const tutors = [
  { id: 1, name: 'Aisha Rahman',   subjects: ['Matematika', 'Fisika'],  ratePerHour: 75000, city: 'Jakarta', bio: 'Lulusan UI, 5 tahun pengalaman mengajar.', rating: 4.9, reviewCount: 128, avatarEmoji: '👩‍🏫', availableSlots: ['Senin 09:00', 'Rabu 14:00', 'Jumat 10:00'] },
  { id: 2, name: 'Budi Santoso',   subjects: ['Kimia', 'Biologi'],      ratePerHour: 60000, city: 'Bandung', bio: 'Dosen aktif ITB bidang sains.', rating: 4.7, reviewCount: 84, avatarEmoji: '👨‍🔬', availableSlots: ['Selasa 11:00', 'Kamis 16:00'] },
  { id: 3, name: 'Citra Dewi',     subjects: ['Bahasa Inggris'],        ratePerHour: 55000, city: 'Surabaya', bio: 'Native-like English, IELTS 8.5.', rating: 4.8, reviewCount: 201, avatarEmoji: '🌟', availableSlots: ['Senin 13:00', 'Jumat 15:00'] },
  { id: 4, name: 'Dian Permata',   subjects: ['Pemrograman', 'Data Science'], ratePerHour: 100000, city: 'Yogyakarta', bio: 'Software engineer 8 tahun di industri.', rating: 4.9, reviewCount: 67, avatarEmoji: '💻', availableSlots: ['Sabtu 10:00', 'Minggu 09:00'] },
];

// ─── Helpers ──────────────────────────────────────────────────────────────────
function hashPassword(password) {
  return crypto.createHash('sha256').update(password + 'edumatch_salt').digest('hex');
}

function generateToken(payload) {
  // Simple base64 "token" (not production-grade – use jsonwebtoken in real projects)
  const header  = Buffer.from(JSON.stringify({ alg: 'HS256', typ: 'JWT' })).toString('base64url');
  const body    = Buffer.from(JSON.stringify({ ...payload, iat: Date.now(), exp: Date.now() + 7 * 24 * 3600 * 1000 })).toString('base64url');
  const sig     = crypto.createHmac('sha256', 'edumatch_secret').update(`${header}.${body}`).digest('base64url');
  return `${header}.${body}.${sig}`;
}

function verifyToken(token) {
  try {
    const [header, body, sig] = token.split('.');
    const expectedSig = crypto.createHmac('sha256', 'edumatch_secret').update(`${header}.${body}`).digest('base64url');
    if (sig !== expectedSig) return null;
    const payload = JSON.parse(Buffer.from(body, 'base64url').toString());
    if (payload.exp < Date.now()) return null;
    return payload;
  } catch {
    return null;
  }
}

function authMiddleware(req, res, next) {
  const auth = req.headers['authorization'] || '';
  const token = auth.startsWith('Bearer ') ? auth.slice(7) : null;
  if (!token) return res.status(401).json({ message: 'Unauthorized: no token provided' });
  const payload = verifyToken(token);
  if (!payload) return res.status(401).json({ message: 'Unauthorized: invalid or expired token' });
  req.user = payload;
  next();
}

// ─── Siswa Auth ───────────────────────────────────────────────────────────────
app.post('/siswa/auth/register', (req, res) => {
  const { name, email, password } = req.body;
  if (!name || !email || !password)
    return res.status(400).json({ message: 'Nama, email, dan password wajib diisi.' });
  if (siswaDb.find(s => s.email === email))
    return res.status(400).json({ message: 'Email sudah terdaftar.' });

  const siswa = { id: siswaDb.length + 1, name, email, passwordHash: hashPassword(password) };
  siswaDb.push(siswa);

  const token = generateToken({ id: siswa.id, role: 'siswa', name: siswa.name, email: siswa.email });
  res.status(201).json({ token, user: { id: siswa.id, name: siswa.name, email: siswa.email, role: 'siswa' } });
});

app.post('/siswa/auth/login', (req, res) => {
  const { email, password } = req.body;
  if (!email || !password)
    return res.status(400).json({ message: 'Email dan password wajib diisi.' });

  const siswa = siswaDb.find(s => s.email === email);
  if (!siswa || siswa.passwordHash !== hashPassword(password))
    return res.status(401).json({ message: 'Email atau password salah.' });

  const token = generateToken({ id: siswa.id, role: 'siswa', name: siswa.name, email: siswa.email });
  res.json({ token, user: { id: siswa.id, name: siswa.name, email: siswa.email, role: 'siswa' } });
});

// ─── Tutor Auth ───────────────────────────────────────────────────────────────
app.post('/tutor/auth/register', (req, res) => {
  const { name, email, password, phone } = req.body;
  if (!name || !email || !password)
    return res.status(400).json({ message: 'Nama, email, dan password wajib diisi.' });
  if (tutorDb.find(t => t.email === email))
    return res.status(400).json({ message: 'Email sudah terdaftar.' });

  const tutor = { id: tutorDb.length + 1, name, email, passwordHash: hashPassword(password), phone: phone || '' };
  tutorDb.push(tutor);

  const token = generateToken({ id: tutor.id, role: 'tutor', name: tutor.name, email: tutor.email });
  res.status(201).json({ token, user: { id: tutor.id, name: tutor.name, email: tutor.email, phone: tutor.phone, role: 'tutor' } });
});

app.post('/tutor/auth/login', (req, res) => {
  const { email, password } = req.body;
  if (!email || !password)
    return res.status(400).json({ message: 'Email dan password wajib diisi.' });

  const tutor = tutorDb.find(t => t.email === email);
  if (!tutor || tutor.passwordHash !== hashPassword(password))
    return res.status(401).json({ message: 'Email atau password salah.' });

  const token = generateToken({ id: tutor.id, role: 'tutor', name: tutor.name, email: tutor.email });
  res.json({ token, user: { id: tutor.id, name: tutor.name, email: tutor.email, phone: tutor.phone, role: 'tutor' } });
});

// ─── Tutors ───────────────────────────────────────────────────────────────────
app.get('/api/tutors', (req, res) => res.json({ data: tutors }));

app.get('/api/tutors/:id', (req, res) => {
  const tutor = tutors.find(t => t.id === Number(req.params.id));
  if (!tutor) return res.status(404).json({ message: 'Tutor tidak ditemukan.' });
  res.json({ data: tutor });
});

// ─── Sessions (protected) ─────────────────────────────────────────────────────
app.get('/api/sessions', authMiddleware, (req, res) => {
  const userSessions = sessions.filter(s =>
    req.user.role === 'siswa' ? s.siswaId === req.user.id : s.tutorId === req.user.id
  );
  res.json({ data: userSessions });
});

app.post('/api/bookings', authMiddleware, (req, res) => {
  const { tutorId, slot, subject } = req.body;
  if (!tutorId || !slot || !subject)
    return res.status(400).json({ message: 'tutorId, slot, dan subject wajib diisi.' });
  const tutor = tutors.find(t => t.id === tutorId);
  if (!tutor) return res.status(404).json({ message: 'Tutor tidak ditemukan.' });

  const session = {
    id: sessions.length + 1,
    siswaId: req.user.id,
    tutorId,
    tutorName: tutor.name,
    subject,
    slot,
    status: 'pending',
    createdAt: new Date().toISOString(),
  };
  sessions.push(session);
  res.status(201).json({ data: session });
});

app.patch('/api/bookings/:id/accept', authMiddleware, (req, res) => {
  const session = sessions.find(s => s.id === Number(req.params.id));
  if (!session) return res.status(404).json({ message: 'Sesi tidak ditemukan.' });
  session.status = 'accepted';
  res.json({ data: session });
});

app.patch('/api/bookings/:id/decline', authMiddleware, (req, res) => {
  const session = sessions.find(s => s.id === Number(req.params.id));
  if (!session) return res.status(404).json({ message: 'Sesi tidak ditemukan.' });
  session.status = 'declined';
  res.json({ data: session });
});

// ─── Health check ─────────────────────────────────────────────────────────────
app.get('/health', (req, res) => res.json({ status: 'ok', timestamp: new Date().toISOString() }));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`✅  EduMatch backend running on http://localhost:${PORT}`));
