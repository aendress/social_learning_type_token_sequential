---
name: project-combined-population-status
description: Current implementation status of the combined-population analysis plan (plan_combined_population.md)
metadata:
  type: project
---

All steps in `plan_combined_population.md` are complete except Step 3 (creating `code/separate_results.Rmd` as a standalone copy).

**Why:** Step 3 is just a `cp` — deferred, not forgotten.

**What was done:**
- Step 1: `add-combined-population` chunk inserted at line ~693 (before `# Results`)
- Step 2: All edits to separate-results display chunks done (set_names/discard_at, population != "combined" filters throughout)
- Step 4: Combined display file created as `code/addon_combined.Rmd` (not `combined_results.Rmd` as named in plan); included as child at end of main file under `# Combined Sample` heading

**Remaining work:**
1. Run `cp code/social_learning_type_token_sequential_results.Rmd code/separate_results.Rmd` (Step 3)
2. Compile the PDF to get actual combined-sample numbers
3. Edit prose in `addon_combined.Rmd` — two issues:
   - Verify quantitative claims ("roughly twice as large", "two to three times greater", "six to eight times greater") against compiled combined tables
   - Rewrite passages that reference individual samples by name ("in the testable sample", "in the student sample") — these were copied from separate-results prose and are conceptually wrong in a combined-sample section

**How to apply:** When the user returns to this project, remind them the only structural work left is the `cp` for Step 3; the main remaining effort is prose editing in `addon_combined.Rmd` after compiling.
