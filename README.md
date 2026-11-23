# Kepler-Inspired Academic Portfolio // Six-Course Management System

> **Master Engineering & Editorial Specification**  
> Inspired by the aesthetic of **Kepler Interactive** (`kepler-interactive.com`) and engineered for university academic evaluation.

---

## 1. Project Overview & Visual Direction

This repository contains a full-stack, editorial-style academic portfolio and university management platform built for six academic courses. It eliminates cookie-cutter SaaS "dashboard card" fatigue in favor of a Swiss-inspired editorial layout alternating between deep charcoal, cinematic black, pure white, and tactile off-white with signature electric orange accents (`#FF8900`).

### Color Palette Reference
| Token | Hex Value | Role & Usage |
|---|---|---|
| **Kepler Orange** | `#FF8900` | Buttons, active navigation pills, hover states, badges, highlight lines |
| **Charcoal** | `#242424` | Dominant surface for lecture timelines and Bloom's taxonomy outcomes |
| **Cinematic Black** | `#171717` | Full-bleed hero canvas, project galleries, footers, code blocks |
| **Pure White** | `#FFFFFF` | Editorial broadsheet overview, syllabus metrics, knowledge repositories |
| **Off-White** | `#F7F7F5` | Tactile paper surface for assignment cards and evaluation tables |
| **Light Grey** | `#E8ECEC` | Crisp 1px hairline rules and dividing borders on light sections |
| **Muted Grey** | `#929292` | Monospaced metadata labels, captions, and secondary body text |

---

## 2. Comprehensive Code & Architectural Review (Section 7)

Before developing and deploying this architecture, a deep inspection was performed against common Lovable templates and academic portfolios (such as `os-portfolio-chronicles`):

### 1. Complete Architecture Inspection
- **Previous Bottleneck:** Standard Lovable projects often bundle everything into a single overloaded client component with tightly coupled mock state. When refreshed or expanded to 6 courses, state collisions and memory leaks occur.
- **Engineered Fix:** Clean separation of concerns with a decoupled data layer (`DEFAULT_ACADEMIC_DATA`), dynamic course renderer, standalone administrative control panel (`admin.html`), and independent Supabase SQL schema (`supabase-schema.sql`).

### 2. Component Identification & Pacing
- **Previous Bottleneck:** "Dashboard-Card Syndrome" — every section looks like the same rounded card with identical padding, losing visual hierarchy.
- **Engineered Fix:** Dynamic editorial pacing. Alternating backgrounds (Black `#171717` → White `#FFFFFF` → Charcoal `#242424` → Off-White `#F7F7F5` → Black `#171717` → White `#FFFFFF`) create a rich, magazine-style rhythm.

### 3. Routing Structure
- **Architecture:** 
  - Public Editorial Showcase: `index.html` (accessible to recruiters, professors, and peers).
  - Private Administrative Console: `admin.html` (gated behind authentication).
  - Lovable React Router equivalents provided in `lovable-prompts/`.

### 4. Database Schema Review
- **Previous Bottleneck:** Relational mismatch where assignments and lectures were loosely stored in unindexed JSON arrays, preventing granular queries.
- **Engineered Fix:** PostgreSQL relational schema in `supabase-schema.sql` with foreign keys (`course_id` referencing `courses(id)`), custom ENUMs (`assignment_status`), and UUID primary keys.

### 5. Supabase Integration & RLS
- **Security Check:** Row Level Security (RLS) policies implemented on all 6 tables. Public visitors have `SELECT` permissions; only authenticated faculty/admin users can perform `INSERT`, `UPDATE`, or `DELETE`.
- **Storage:** Configured `academic-files` and `project-media` buckets with public CDN distribution and authenticated write rules.

### 6. Full CRUD Verification
- **Assignments:** Add, Edit, Delete, View, Upload Question PDF, Upload Solution code, Set dynamic deadlines, and update status (`Pending`, `In Progress`, `Submitted`, `Graded`).
- **Projects:** Add, Edit, Delete, Upload cover images, Add markdown documentation, Add GitHub links, and Add live deployment URLs.
- **Classroom Learnings:** Add lecture number, date, topic, comprehensive notes, key takeaways, and upload PPT/PDF slides.
- **Resources:** Organize by category, track file types and sizes, preview contents in modals, and initiate downloads.

### 7. Animation & Directional Motion Blur Review
- **Previous Problem:** Heavy, unoptimized Framer Motion springs or flashing CSS transitions that cause frame drops on laptops.
- **Engineered Fix:** Custom velocity-aware motion blur. The system monitors scroll velocity; when scrolling rapidly (>45px/frame), a subtle `filter: blur(1.5px)` is applied to moving cards and removed immediately upon stopping to preserve text legibility. Respects `prefers-reduced-motion`.

### 8. Responsiveness & Viewports
- Verified across mobile (375px), tablet (768px), laptop (1024px), and ultra-wide screens (1440px+). The 6-course tab strip supports smooth horizontal overflow with hidden scrollbars for touch devices.

### 9. Performance & Persistence
- Zero build lag. Instant preview without compiling. Works 100% offline via resilient `localStorage` caching while maintaining seamless cloud sync with Supabase when credentials are provided.

---

## 3. The Six Courses Structure

Each course contains six independent pedagogical sections:
1. **Data Science (`DS-401`):** Statistical modeling, Bayesian likelihoods, PySpark distributed pipelines, and manifold learning.
2. **Artificial Intelligence (`AI-402`):** Informed heuristic search, A* admissibility, minimax game engines, and Markov decision processes.
3. **Advanced Artificial Intelligence (`AAI-501`):** Scaled dot-product attention, transformer architectures from scratch, diffusion models, and DPO alignment.
4. **Fundamentals of Cloud Computing (`CC-303`):** Cgroups/namespaces, multi-zone Kubernetes clusters, Terraform, and Istio service mesh.
5. **Entrepreneurship (`ENT-305`):** Customer discovery field studies, B2B SaaS unit economics (CAC/LTV), financial modeling, and venture pitch decks.
6. **Internship Evaluation 1 (`INT-490`):** Corporate sprint logs, production incident postmortems, enterprise microservice migrations, and thesis defense.

---

## 4. How to Run Locally

### Option A: Instant Browser Preview (Zero Setup)
1. Navigate to:
   ```
   C:\Users\aakar\.gemini\antigravity\scratch\kepler-academic-portfolio\
   ```
2. Double-click `index.html` to open the public editorial portfolio.
3. Double-click `admin.html` to open the administrative management panel.
   - **Default Admin Passcode:** `kepler2026`

### Option B: Local HTTP Server (Recommended)
Open PowerShell in the project directory:
```powershell
cd "C:\Users\aakar\.gemini\antigravity\scratch\kepler-academic-portfolio"
python -m http.server 8080
```
Then open `http://localhost:8080` in your web browser.

---

## 5. Connecting to Supabase

1. Create a free project at [supabase.com](https://supabase.com).
2. Open the **SQL Editor** in your Supabase dashboard.
3. Copy and run the entire contents of `supabase-schema.sql`.
4. Open the **Admin Panel** (`admin.html`), click **"Supabase Config"**, and paste your **Project URL** and **Anon Key**.
5. All updates will now synchronize directly with your PostgreSQL database!

---

## 6. Lovable Integration Guides

To reproduce or expand this platform inside **Lovable** (`lovable.dev`):
1. **Visual System:** Use `lovable-prompts/01-DESIGN-SYSTEM-AND-EDITORIAL-SPEC.md`
2. **Database & Courses:** Use `lovable-prompts/02-SIX-COURSES-AND-SUPABASE-CRUD.md`
3. **Animations & Blur:** Use `lovable-prompts/03-MOTION-BLUR-AND-FRAMER-ANIMATIONS.md`
4. **Admin Console:** Use `lovable-prompts/04-ADMIN-PANEL-RLS-STORAGE.md`

