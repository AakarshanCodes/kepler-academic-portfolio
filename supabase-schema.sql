-- ==============================================================================
-- KEPLER ACADEMIC PORTFOLIO - SUPABASE DATABASE SCHEMA & POLICIES
-- Architecture: 6-Course Academic Management System
-- Compatible with Lovable & Supabase
-- ==============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ------------------------------------------------------------------------------
-- 1. COURSES TABLE
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.courses (
    id TEXT PRIMARY KEY, -- e.g. 'data-science', 'artificial-intelligence'
    code TEXT NOT NULL,
    title TEXT NOT NULL,
    department TEXT NOT NULL,
    instructor TEXT NOT NULL,
    credits INTEGER DEFAULT 4,
    semester TEXT NOT NULL,
    hero_quote TEXT,
    description TEXT NOT NULL,
    syllabus_url TEXT,
    order_index INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ------------------------------------------------------------------------------
-- 2. CLASSROOM LEARNINGS TABLE (Lectures, Dates, Topics, Explanations, Slides)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.classroom_learnings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    course_id TEXT NOT NULL REFERENCES public.courses(id) ON DELETE CASCADE,
    lecture_number INTEGER NOT NULL,
    lecture_date DATE NOT NULL,
    topic TEXT NOT NULL,
    explanation TEXT NOT NULL,
    key_takeaways TEXT[] DEFAULT '{}',
    notes_url TEXT,
    ppt_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ------------------------------------------------------------------------------
-- 3. ASSIGNMENTS TABLE (CRUD: Add, Edit, Delete, Files, Deadlines, Status)
-- ------------------------------------------------------------------------------
CREATE TYPE assignment_status AS ENUM ('Pending', 'In Progress', 'Submitted', 'Graded');

CREATE TABLE IF NOT EXISTS public.assignments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    course_id TEXT NOT NULL REFERENCES public.courses(id) ON DELETE CASCADE,
    assignment_number INTEGER NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    deadline TIMESTAMP WITH TIME ZONE NOT NULL,
    status assignment_status DEFAULT 'Pending',
    score NUMERIC(5,2),
    max_score NUMERIC(5,2) DEFAULT 100.0,
    weightage_percent INTEGER,
    question_file_url TEXT,
    solution_file_url TEXT,
    submission_notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ------------------------------------------------------------------------------
-- 4. PROJECTS TABLE (CRUD: Add, Edit, Delete, Images, Docs, GitHub, Live URL)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.projects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    course_id TEXT NOT NULL REFERENCES public.courses(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    subtitle TEXT,
    description TEXT NOT NULL,
    documentation TEXT,
    tech_stack TEXT[] DEFAULT '{}',
    image_url TEXT,
    gallery_urls TEXT[] DEFAULT '{}',
    github_url TEXT,
    live_url TEXT,
    featured BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ------------------------------------------------------------------------------
-- 5. RESOURCES TABLE (Organize, Preview, Download Files)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.resources (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    course_id TEXT NOT NULL REFERENCES public.courses(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    category TEXT NOT NULL, -- e.g. 'Textbook', 'Research Paper', 'Cheat Sheet', 'Dataset', 'Code Repository'
    file_type TEXT NOT NULL, -- e.g. 'PDF', 'ZIP', 'JUPYTER', 'DOCX'
    file_size TEXT,          -- e.g. '4.2 MB'
    file_url TEXT NOT NULL,
    description TEXT,
    is_external_link BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ------------------------------------------------------------------------------
-- 6. LEARNING OUTCOMES TABLE
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.learning_outcomes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    course_id TEXT NOT NULL REFERENCES public.courses(id) ON DELETE CASCADE,
    outcome_code TEXT NOT NULL, -- e.g. 'CO-1', 'CO-2'
    bloom_level TEXT NOT NULL,  -- e.g. 'Analyze', 'Evaluate', 'Create'
    description TEXT NOT NULL,
    industry_relevance TEXT,
    order_index INTEGER DEFAULT 0
);

-- ------------------------------------------------------------------------------
-- ROW LEVEL SECURITY (RLS) POLICIES
-- Requirement: Admin access restricted, public read-only for portfolio showcase
-- ------------------------------------------------------------------------------

-- Enable RLS on all tables
ALTER TABLE public.courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.classroom_learnings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.resources ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.learning_outcomes ENABLE ROW LEVEL SECURITY;

-- 1. Public Read Policies (Allow anyone to view academic portfolio content)
CREATE POLICY "Public courses are viewable by everyone" ON public.courses FOR SELECT USING (true);
CREATE POLICY "Public learnings are viewable by everyone" ON public.classroom_learnings FOR SELECT USING (true);
CREATE POLICY "Public assignments are viewable by everyone" ON public.assignments FOR SELECT USING (true);
CREATE POLICY "Public projects are viewable by everyone" ON public.projects FOR SELECT USING (true);
CREATE POLICY "Public resources are viewable by everyone" ON public.resources FOR SELECT USING (true);
CREATE POLICY "Public outcomes are viewable by everyone" ON public.learning_outcomes FOR SELECT USING (true);

-- 2. Authenticated Admin CRUD Policies (Only authenticated admin can modify)
CREATE POLICY "Admin can modify courses" ON public.courses FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Admin can modify classroom learnings" ON public.classroom_learnings FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Admin can modify assignments" ON public.assignments FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Admin can modify projects" ON public.projects FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Admin can modify resources" ON public.resources FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Admin can modify learning outcomes" ON public.learning_outcomes FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ------------------------------------------------------------------------------
-- STORAGE BUCKETS CONFIGURATION (Supabase Storage)
-- ------------------------------------------------------------------------------
INSERT INTO storage.buckets (id, name, public) 
VALUES ('academic-files', 'academic-files', true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.buckets (id, name, public) 
VALUES ('project-media', 'project-media', true)
ON CONFLICT (id) DO NOTHING;

-- Storage RLS: Public read, Authenticated upload/delete
CREATE POLICY "Public Access to Academic Files" ON storage.objects FOR SELECT USING (bucket_id = 'academic-files');
CREATE POLICY "Admin Upload Academic Files" ON storage.objects FOR INSERT TO authenticated WITH CHECK (bucket_id = 'academic-files');
CREATE POLICY "Admin Update Academic Files" ON storage.objects FOR UPDATE TO authenticated USING (bucket_id = 'academic-files');
CREATE POLICY "Admin Delete Academic Files" ON storage.objects FOR DELETE TO authenticated USING (bucket_id = 'academic-files');

CREATE POLICY "Public Access to Project Media" ON storage.objects FOR SELECT USING (bucket_id = 'project-media');
CREATE POLICY "Admin Upload Project Media" ON storage.objects FOR INSERT TO authenticated WITH CHECK (bucket_id = 'project-media');
CREATE POLICY "Admin Delete Project Media" ON storage.objects FOR DELETE TO authenticated USING (bucket_id = 'project-media');

-- ------------------------------------------------------------------------------
-- SEED DATA: 6 ACADEMIC COURSES
-- ------------------------------------------------------------------------------
INSERT INTO public.courses (id, code, title, department, instructor, credits, semester, hero_quote, description, order_index)
VALUES
(
    'data-science',
    'BCS5403Y26',
    'Data Science Foundation',
    'Computer Science & Engineering',
    'Prof. Rushikesh Pawar',
    4,
    'Fall Semester 2026',
    'Extracting actionable intelligence from stochastic complexity.',
    'Advanced mathematical foundations, statistical modeling, end-to-end data pipelines, exploratory analysis, hypothesis validation, and distributed data processing methodologies.',
    1
),
(
    'artificial-intelligence',
    'BCS5402Y26',
    'Artificial Intelligence',
    'Computer Science & Engineering',
    'Prof. Kamlesh Ahuja',
    4,
    'Fall Semester 2026',
    'Formulating heuristics and rational agency in probabilistic state spaces.',
    'Foundations of deterministic and stochastic state search, constraint satisfaction, adversarial algorithms, Bayesian networks, reinforcement agents, and logic programming.',
    2
),
(
    'cloud-computing',
    'BCS5401Y26',
    'Fundamentals of Cloud',
    'Information Technology',
    'Prof. Sneha Talwalkar',
    4,
    'Fall Semester 2026',
    'Elastic distributed architectures engineered for planetary resilience.',
    'Virtualization layers, container orchestration with Kubernetes, microservice topologies, serverless primitives, distributed consensus, object storage, and cloud-native security.',
    3
),
(
    'entrepreneurship',
    'ENT-305',
    'Entrepreneurship',
    'School of Business & Innovation',
    'Faculty Coordinator',
    3,
    'Fall Semester 2026',
    'Transforming frontier engineering into scalable technological enterprises.',
    'Venture capital mechanics, unit economics, product-market fit verification, customer discovery, intellectual property strategy, financial modeling, and pitch execution.',
    4
),
(
    'internship-eval-1',
    'BCS5601Y26',
    'Internship -1',
    'Academic Affairs & Industry Liaison',
    'Prof. Neha Mangal',
    6,
    'Fall Semester 2026',
    'Rigorous industrial practicum bridging theoretical rigour and production scale.',
    'Comprehensive evaluation of real-world industry practicum, architectural contributions, corporate sprint cadences, production software deliverables, and professional engineering leadership.',
    5
),
(
    'advanced-ai',
    'BCS5551Y26',
    'Advanced Artificial Intelligence (E-1)',
    'Graduate Studies & Research',
    'Prof. Jitendra Choudhary',
    4,
    'Fall Semester 2026',
    'Deep generative architectures, attention dynamics, and foundational models.',
    'Deep representation learning, multi-head transformer architectures, latent diffusion, graph neural networks, alignment protocols, and continuous-state reinforcement learning.',
    6
)
ON CONFLICT (id) DO NOTHING;

