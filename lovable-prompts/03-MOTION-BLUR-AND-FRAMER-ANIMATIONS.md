# LOVABLE MASTER PROMPT 3: MOTION SYSTEM & DIRECTIONAL MOTION BLUR

Copy-paste this prompt into Lovable to configure Framer Motion and smooth motion blur animations.

---

```markdown
Act as a senior creative technologist and animation specialist.

Implement sophisticated, editorial-grade animations for the Kepler-inspired academic portfolio using Framer Motion and modern CSS transforms.

### 1. MOTION PRINCIPLES
- Avoid bouncy, game-like springs or cartoonish ease-in-out effects.
- Use sharp, editorial cubic-bezier easing: `cubic-bezier(0.16, 1, 0.3, 1)` (expo out).
- Transitions should feel weighted, tactile, and restrained.

### 2. DIRECTIONAL MOTION BLUR SYSTEM
- Implement a temporary directional motion blur that triggers only while elements are in rapid transit:
  ```css
  .editorial-motion {
    transition: transform 0.45s cubic-bezier(0.16, 1, 0.3, 1), 
                opacity 0.45s cubic-bezier(0.16, 1, 0.3, 1),
                filter 0.35s ease;
    will-change: transform, filter, opacity;
  }
  .is-scrolling-fast, .is-moving {
    filter: blur(2px);
  }
  ```
- Track scroll velocity via a lightweight requestAnimationFrame hook. When velocity exceeds the threshold (>40px/frame), apply `filter: blur(1.5px)` to fast-moving cards; clear the blur immediately upon deceleration to restore crisp text readability.

### 3. SPECIFIC ANIMATION REQUIREMENTS
- Scroll-Triggered Reveals: Elements fade up smoothly (`translateY(24px)` to `translateY(0)` with opacity from `0` to `1`).
- Staggered Card Animations: When entering a course tab, stagger lecture and assignment cards with 60ms increments.
- Image Zoom Transitions: Hovering over project cards smoothly scales the image by 1.04x over 700ms with no layout shift.
- Tab Transitions: Switching courses triggers an elegant page transition with directional slide and momentary blur fade.
- Parallax: Subtle 10-15px depth offset between the hero headline and background grid.

### 4. ACCESSIBILITY COMPLIANCE
Strictly respect `prefers-reduced-motion: reduce`:
- Disable all blur filters, scale transforms, and loop timers when reduced motion is detected.
- Fall back to clean instantaneous state changes.
```

