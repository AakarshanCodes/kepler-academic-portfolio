# LOVABLE MASTER PROMPT 2: SIX COURSES ARCHITECTURE & SUPABASE CRUD

Copy-paste this prompt into Lovable to configure database tables, state management, and the six courses.

---

```markdown
Act as a full-stack engineer and Supabase architect.

Connect the portfolio to Supabase and establish the six independent academic courses with full CRUD management.

### 1. THE SIX COURSES
1. Data Science (id: 'data-science', code: 'DS-401')
2. Artificial Intelligence (id: 'artificial-intelligence', code: 'AI-402')
3. Advanced Artificial Intelligence (id: 'advanced-ai', code: 'AAI-501')
4. Fundamentals of Cloud Computing (id: 'cloud-computing', code: 'CC-303')
5. Entrepreneurship (id: 'entrepreneurship', code: 'ENT-305')
6. Internship Evaluation 1 (id: 'internship-eval-1', code: 'INT-490')

Every course must independently render six dedicated tabs/sections:
- Overview (Instructor bio, credits, department, theoretical pillars, syllabus download)
- Classroom Learnings (Lecture number, date, topic, in-depth explanation, key takeaways, notes PDF & PPT slides)
- Assignments (Title, description, deadline, status badge ['Pending', 'In Progress', 'Submitted', 'Graded'], score, question file, solution file)
- Projects (Title, subtitle, description, tech stack tags, live deployment URL, GitHub repository, cover image, architectural RFC documentation)
- Resources (Category, file type ['PDF', 'ZIP', 'JUPYTER'], file size, direct preview modal, download link)
- Learning Outcomes (Bloom's Taxonomy Level 4-6, competency descriptions, practical industry relevance)

### 2. DATABASE SCHEMA & TYPES
Run the database migration provided in `supabase-schema.sql` on the connected Supabase instance:
- `courses`
- `classroom_learnings` (Foreign key to `courses.id`)
- `assignments` (Foreign key to `courses.id`)
- `projects` (Foreign key to `courses.id`)
- `resources` (Foreign key to `courses.id`)
- `learning_outcomes` (Foreign key to `courses.id`)

### 3. COMPLETE CRUD CAPABILITIES
Implement full React Query / Supabase mutations for:
- Assignments: createAssignment, updateAssignment, deleteAssignment, uploadAssignmentFiles.
- Projects: createProject, updateProject, deleteProject, uploadProjectCover.
- Classroom Learnings: createLecture, updateLecture, deleteLecture, uploadSlides.
- Resources: createResource, updateResource, deleteResource, uploadResourceFile.

Ensure optimistic UI updates and local fallback persistence if offline or disconnected.
```

