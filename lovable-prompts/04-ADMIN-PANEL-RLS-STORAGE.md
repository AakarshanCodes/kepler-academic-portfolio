# LOVABLE MASTER PROMPT 4: ADMIN PANEL, RLS POLICIES & STORAGE

Copy-paste this prompt into Lovable to set up the private administrative management console.

---

```markdown
Act as a security engineer and full-stack developer.

Build a secure private admin interface for managing the six academic courses without modifying any source code.

### 1. AUTHENTICATION & ACCESS CONTROL
- Private route: `/admin`
- Support two authentication methods:
  1. Supabase Auth (Faculty / Admin Email and Password with JWT tokens).
  2. Master faculty passcode gateway for emergency / demo evaluation (`kepler2026`).
- Unauthenticated visitors attempting to access `/admin` or invoke mutating API endpoints must be redirected to the public portfolio.

### 2. ROW LEVEL SECURITY (RLS) POLICIES
Enforce database-level policies on PostgreSQL:
- Public Read: Anyone can SELECT from `courses`, `classroom_learnings`, `assignments`, `projects`, `resources`, and `learning_outcomes`.
- Restricted Write: Only authenticated users with role `authenticated` or admin claim can INSERT, UPDATE, or DELETE records.

### 3. SUPABASE STORAGE BUCKETS
Configure two dedicated public buckets:
1. `academic-files`: Stores assignment prompt PDFs, student solution notebooks, lecture slides (.pptx), and textbook PDFs.
2. `project-media`: Stores capstone project banner screenshots, diagrams, and architecture RFCs.

Ensure file upload components display real-time upload progress, generate deterministic sanitized filenames, and store the resulting public URL into the corresponding table column.

### 4. PERSISTENCE & DATA REFRESH
- All CRUD modifications must immediately reflect in the state and persist across browser reloads.
- Provide a "Database Connection & Sync" modal in the admin header allowing faculty to input or modify `SUPABASE_URL` and `SUPABASE_ANON_KEY`.
- Include a "One-Click JSON Export" to download complete curriculum backups.
```

