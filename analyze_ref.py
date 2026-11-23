import re
import json

with open('C:/Users/aakar/.gemini/antigravity/scratch/kepler-academic-portfolio/ref_bundle.js', 'r', encoding='utf-8') as f:
    code = f.read()

# Find navigation, section names, course titles, data objects
print("=== ROUTES / PATHS ===")
for m in re.finditer(r'path:\s*["\']([^"\']+)["\']', code):
    print(m.group(1))

print("\n=== NAVIGATION / SECTIONS ===")
navs = re.findall(r'href:\s*["\'](#[^"\']+)["\'],\s*label:\s*["\']([^"\']+)["\']', code)
for h, l in navs:
    print(f"{h} -> {l}")

print("\n=== SAMPLE STRINGS / SECTIONS ===")
for s in re.findall(r'["\']([A-Z][a-zA-Z\s]{4,40})["\']', code)[:80]:
    if any(w in s.lower() for w in ['overview', 'course', 'assign', 'project', 'cert', 'learn', 'work', 'os', 'operating', 'table', 'hero', 'system']):
        print(s)

print("\n=== SEARCHING FOR SPECIFIC TEXT ===")
keywords = ["Operating System", "Copyright", "Assignment", "Classroom", "Learning", "Certificate", "Author", "Student"]
for kw in keywords:
    pos = code.find(kw)
    if pos != -1:
        snippet = code[max(0, pos-100):min(len(code), pos+200)]
        print(f"[{kw} snippet]:", snippet.replace('\n', ' '))

