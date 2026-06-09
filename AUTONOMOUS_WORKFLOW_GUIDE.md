# Claude Code Autonomous Workflow Guide

**A comprehensive guide to using Claude Code in 100% autonomous mode for parallel issue resolution and continuous improvement.**

## Table of Contents

1. [Overview](#overview)
2. [Setup and Configuration](#setup-and-configuration)
3. [Autonomous Mode Principles](#autonomous-mode-principles)
4. [Workflow Patterns](#workflow-patterns)
5. [Quality Gates](#quality-gates)
6. [Issue Management](#issue-management)
7. [Example Workflows](#example-workflows)
8. [Best Practices](#best-practices)
9. [Troubleshooting](#troubleshooting)

---

## Overview

**Autonomous Workflow** enables Claude Code to work independently on multiple tasks in parallel, making decisions without human intervention while maintaining high quality standards. This approach is ideal for:

- Large backlogs of well-defined issues
- Continuous improvement sprints
- Maintenance windows where you can't actively supervise
- Projects with comprehensive test suites
- Teams that trust automated workflows

**Key Benefits:**
- 3-5x faster issue resolution compared to interactive mode
- Zero context switching for the developer
- Consistent quality through automated testing
- Immediate feedback loop (commit + push after each issue)
- Comprehensive documentation via detailed commit messages

---

## Setup and Configuration

### Initial Prompt

To activate autonomous mode, provide this exact instruction to Claude Code:

```
100% Autonomous Mode - Requirements:

AUTO-ACCEPT EVERYTHING:
- All bash commands
- All git commands (add, commit, push)
- All file operations (mkdir, create, edit, delete)
- All scripts and complex operations
- Everything else - just auto-accept

QUALITY REQUIREMENTS (for each issue):
1. Unit/integration tests written and PASSING
2. Documentation updated
3. Code formatted (mvn spotless:apply)
4. Checkstyle passing
5. IMMEDIATELY push to remote (don't batch)

ISSUE MANAGEMENT:
- Monitor continuously - constantly review issues as new ones will be created
- Close obsolete issues
- Validate relevance based on refactoring

PARALLELIZATION:
- Work on 2-3 things at once (not 6+)
- Use workflows for complex multi-step operations

ZERO QUESTIONS:
- Work independently without asking for input
- Make reasonable decisions based on codebase patterns
- Prioritize everything - I trust you
- Work in my absence - keep going

CONTINUE WORKING:
- When one task completes, immediately start the next
- Always review open issues before asking what to do
- Use "continue" to keep the loop going
```

### Permission Settings

Claude Code needs these permissions configured:

```json
{
  "autoApprove": {
    "bash": true,
    "git": true,
    "fileOperations": true,
    "all": true
  }
}
```

### Repository Requirements

**Minimum requirements for autonomous mode:**

1. **Comprehensive Test Suite**
   - Unit tests for all core logic
   - Integration tests for key workflows
   - All tests must be automated and fast (<10 seconds)

2. **Automated Formatting**
   - Spotless, Prettier, Black, or similar
   - Should fix all style issues automatically

3. **Linting/Static Analysis**
   - Checkstyle, ESLint, pylint, or similar
   - Should catch common errors before commit

4. **Well-Defined Issues**
   - Clear acceptance criteria
   - Specific file/module references
   - Expected behavior documented

5. **CI/CD Pipeline** (recommended)
   - Runs tests on every push
   - Blocks merges if tests fail
   - Provides fast feedback

---

## Autonomous Mode Principles

### 1. **Zero-Question Decision Making**

Claude should NEVER ask for clarification. Instead:

- ✅ **DO**: Examine existing code patterns and follow them
- ✅ **DO**: Make reasonable assumptions based on context
- ✅ **DO**: Choose the simplest solution that works
- ❌ **DON'T**: Ask "Should I use X or Y?"
- ❌ **DON'T**: Request clarification on requirements
- ❌ **DON'T**: Wait for approval before proceeding

**Example:**
```
BAD:  "Should I add this field to the builder or constructor?"
GOOD: [Examines existing code, sees builders are used, adds to builder]
```

### 2. **Immediate Feedback Loop**

Every completed issue follows this pattern:

```bash
# 1. Implement the change
# 2. Run tests
mvn test -pl <module> -Dcheckstyle.skip=true

# 3. Format code
mvn spotless:apply -pl <module>

# 4. Verify checkstyle
mvn checkstyle:check -pl <module>

# 5. Commit with detailed message
git add -A
git commit -m "feat: descriptive message

Details of what was changed and why.

Closes #123"

# 6. IMMEDIATELY push (don't batch)
git push

# 7. Close the issue with summary
gh issue close 123 -c "Summary of implementation..."

# 8. Move to next issue
```

### 3. **Quality Gates (Never Skip)**

Before committing ANY change:

1. ✅ All existing tests pass
2. ✅ New tests written for new functionality
3. ✅ Code formatted (spotless:apply)
4. ✅ Checkstyle/linting passes
5. ✅ No compilation errors
6. ✅ Zero regressions in other modules

**If any gate fails → FIX IT immediately, don't commit broken code.**

### 4. **Continuous Issue Monitoring**

Claude should constantly check for new/updated issues:

```bash
# Check every 3-5 completed issues
gh issue list --state open --json number,title,labels --limit 20
```

This allows Claude to:
- Pick up newly created issues
- Detect priority changes
- Close obsolete issues
- Adjust work based on new context

---

## Workflow Patterns

### Pattern 1: Sequential Single-Issue Loop

**When to use:** Simple, independent issues

```
1. List open issues
2. Pick highest priority issue
3. Create task (TaskCreate)
4. Mark task in_progress (TaskUpdate)
5. Implement solution
6. Run tests → must pass
7. Format code
8. Commit + push immediately
9. Close issue with detailed comment
10. Mark task completed
11. GOTO step 1 (continue loop)
```

### Pattern 2: Parallel Workflow (2-3 concurrent)

**When to use:** Multiple independent issues, user says "workflow"

```javascript
// Dynamic workflow script
export const meta = {
  name: 'parallel-fixes',
  description: 'Fix multiple independent issues in parallel',
  phases: [
    { title: 'Fix Bugs', detail: 'Fix compilation and runtime errors' },
    { title: 'Add Features', detail: 'Implement enhancements' },
    { title: 'Verify', detail: 'Run full test suite' }
  ],
}

const FINDINGS_SCHEMA = {
  type: 'object',
  properties: {
    success: { type: 'boolean' },
    summary: { type: 'string' },
    issuesClosed: { type: 'array', items: { type: 'number' } }
  },
  required: ['success', 'summary']
}

// Phase 1: Fix bugs in parallel
phase('Fix Bugs')
const bugFixes = await parallel([
  () => agent('Fix issue #342: [detailed instructions]', 
    { label: 'fix-bug-342', phase: 'Fix Bugs', schema: FINDINGS_SCHEMA }),
  () => agent('Fix issue #343: [detailed instructions]',
    { label: 'fix-bug-343', phase: 'Fix Bugs', schema: FINDINGS_SCHEMA })
])

// Phase 2: Add features in parallel
phase('Add Features')
const features = await parallel([
  () => agent('Implement #339: [detailed instructions]',
    { label: 'feature-339', phase: 'Add Features', schema: FINDINGS_SCHEMA }),
  () => agent('Implement #340: [detailed instructions]',
    { label: 'feature-340', phase: 'Add Features', schema: FINDINGS_SCHEMA })
])

// Phase 3: Verify all changes
phase('Verify')
const verification = await agent('Run full test suite and verify no regressions',
  { label: 'final-verification', phase: 'Verify', schema: FINDINGS_SCHEMA })

return {
  bugFixesCompleted: bugFixes.filter(Boolean).length,
  featuresCompleted: features.filter(Boolean).length,
  issuesClosed: [
    ...bugFixes.flatMap(r => r?.issuesClosed || []),
    ...features.flatMap(r => r?.issuesClosed || [])
  ]
}
```

### Pattern 3: Loop-Until-Dry (Exhaustive)

**When to use:** Unknown number of items to fix (e.g., "fix all TODO comments")

```bash
# Pseudocode
found = find_all_todos()
while found.length > 0:
    fix_batch(found[:5])  # Fix 5 at a time
    test_and_commit()
    found = find_all_todos()  # Re-scan
```

### Pattern 4: Hybrid (Scout + Orchestrate)

**When to use:** Complex tasks requiring discovery first

```
1. Scout inline: List files, understand structure, scope the work
2. Discover work-list (e.g., "found 47 files to migrate")
3. Launch workflow with discovered list
4. Workflow pipelines over the list in parallel
5. Verify all changes together
```

---

## Quality Gates

### Test Requirements

Every change MUST have tests:

**Unit Tests** (`@Tag("unit")`):
- Fast (< 1 second per test)
- No external dependencies
- Test one thing
- Use mocks for collaborators

**Integration Tests** (`@Tag("integration")`):
- Test full workflows
- May use real dependencies
- Test cross-module interactions

**Example Test Coverage:**
```java
// For a new feature with 3 public methods and 2 edge cases
// Expect: 5-10 unit tests + 1-2 integration tests

@Tag("unit")
class MyFeatureTest {
  @Test void testNormalCase() { ... }
  @Test void testEdgeCase1() { ... }
  @Test void testEdgeCase2() { ... }
  @Test void testNullInput() { ... }
  @Test void testEmptyInput() { ... }
}

@Tag("integration")  
class MyFeatureIntegrationTest {
  @Test void testFullWorkflow() { ... }
}
```

### Code Quality Checks

Before every commit:

```bash
# 1. Format code (auto-fix)
mvn spotless:apply -pl <module>

# 2. Run checkstyle (must pass)
mvn checkstyle:check -pl <module>

# 3. Run tests (must pass)
mvn test -pl <module>

# 4. Optional: Run full build
mvn clean install -DskipTests
```

### Commit Message Standard

Use **Conventional Commits** format:

```
<type>: <short summary (50 chars max)>

<detailed description>

<why this change was needed>

<testing notes>

Closes #<issue-number>

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

**Types:**
- `feat:` - New feature
- `fix:` - Bug fix
- `refactor:` - Code restructuring (no behavior change)
- `test:` - Adding/updating tests
- `docs:` - Documentation only
- `chore:` - Build/tooling changes
- `perf:` - Performance improvement

**Example:**
```
feat: add semantic version validation for service dependencies

Implements SemanticVersion class with major.minor.patch parsing
and compatibility checking using semver rules.

Changes:
- Added SemanticVersion class with compareTo() and isCompatibleWith()
- Updated ServiceRegistry to accept version parameters
- Added getService(Class<T>, String minVersion) method
- 20 unit tests for SemanticVersion
- 10 integration tests for versioned service lookup

Testing:
- All 246 tests passing (226 existing + 20 new)
- Verified version validation rejects incompatible versions
- Verified backward compatibility with unversioned services

Closes #339

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

---

## Issue Management

### Issue Structure (for Autonomous Mode)

Create issues with this structure:

```markdown
## Description
Clear one-paragraph description of what needs to be done.

## Acceptance Criteria
- [ ] Specific criterion 1
- [ ] Specific criterion 2
- [ ] Tests written and passing
- [ ] Documentation updated

## Files to Change (if known)
- `src/main/java/package/ClassName.java` - Add method X
- `src/test/java/package/ClassNameTest.java` - Add tests

## Context
Any background information, related issues, or design decisions.

## Priority
P0 (critical) / P1 (high) / P2 (medium) / P3 (low)
```

### Issue Lifecycle

```
[Open] → [In Progress] → [Implemented] → [Tested] → [Committed] → [Pushed] → [Closed]
                                                                              ↓
                                                                    [Comment with summary]
```

### Closing Issues (Required Format)

Every issue closure MUST include:

```markdown
✅ Completed: <Short summary>

**Implementation:**
- Bullet point 1
- Bullet point 2

**Testing:**
- Test coverage details
- All tests passing (X/Y)

**Files Changed:**
- File 1: What changed
- File 2: What changed

**Commit:** <commit-hash>
```

---

## Example Workflows

### Example 1: Bug Fix Loop

```
Session Goal: Fix all compilation errors and test failures

LOOP:
1. Run: mvn clean compile
2. If compilation errors:
   - Parse error messages
   - Fix errors one module at a time
   - Run spotless:apply
   - Commit + push immediately: "fix: resolve compilation error in module X"
   - Close issue if exists
3. Run: mvn test
4. If test failures:
   - Analyze failure
   - Fix root cause
   - Verify fix with tests
   - Commit + push: "fix: resolve test failure in TestClass"
5. REPEAT until mvn clean install succeeds
6. Report: "All compilation errors and test failures fixed. X commits pushed."
```

### Example 2: Feature Implementation Sprint

```
Session Goal: Implement 5 enhancement issues

FOR EACH issue in [#339, #333, #332, #331, #330]:
  1. Read issue description and acceptance criteria
  2. Create task: TaskCreate
  3. Mark in_progress: TaskUpdate
  4. Read relevant files to understand patterns
  5. Implement solution following existing patterns
  6. Write comprehensive tests (unit + integration)
  7. Run tests: mvn test -pl <module>
  8. Fix any failures
  9. Format: mvn spotless:apply -pl <module>
  10. Commit + push with detailed message
  11. Close issue with implementation summary
  12. Mark task completed: TaskUpdate
  NEXT issue

FINAL:
  - Report: "5 issues completed, 5 commits pushed, 0 regressions"
```

### Example 3: Parallel Workflow (2-3 concurrent)

```
Session Goal: Use workflows for maximum parallelization

1. List open issues: gh issue list
2. Group by independence:
   - Group A: Bug fixes (can run in parallel)
   - Group B: New features (can run in parallel)
   - Group C: Documentation (can run in parallel)

3. Launch workflow:
   Workflow({
     script: `
       phase('Fix Bugs')
       const bugs = await parallel([
         () => agent('Fix #342: Swing compilation errors', ...),
         () => agent('Fix #341: Missing dependency', ...)
       ])
       
       phase('Add Features')
       const features = await parallel([
         () => agent('Implement #339: Semantic versioning', ...),
         () => agent('Implement #333: Parameterized tests', ...)
       ])
       
       phase('Update Docs')
       const docs = await agent('Create #331: CONTRIBUTING.md', ...)
       
       phase('Verify')
       const verify = await agent('Run full test suite', ...)
       
       return { bugsFixed: bugs.length, featuresAdded: features.length }
     `
   })

4. Monitor workflow progress: /workflows

5. When complete, verify all issues closed and commits pushed
```

### Example 4: Continuous Autonomous Loop

```
User says: "continue" (after session summary)

Claude:
1. Check open issues: gh issue list
2. Identify highest priority
3. If P0/P1 issues exist:
   - Work on highest priority
   - Complete → commit → push → close
   - GOTO step 1
4. If only P2/P3 exist:
   - Group 2-3 related issues
   - Use workflow for parallel execution
   - Complete → verify → report
   - GOTO step 1
5. If no open issues:
   - Scan codebase for improvements (TODO, FIXME, etc.)
   - Create issues for findings
   - GOTO step 1
```

---

## Best Practices

### DO ✅

1. **Always run tests before committing**
   ```bash
   mvn test -pl <module> -Dcheckstyle.skip=true
   ```

2. **Format code automatically**
   ```bash
   mvn spotless:apply -pl <module>
   ```

3. **Commit with detailed messages**
   - Explain WHAT changed
   - Explain WHY it changed
   - List files affected
   - Reference issue number

4. **Push immediately after each issue**
   - Don't batch commits
   - Enables fast feedback from CI
   - Allows easy rollback if needed

5. **Close issues with summaries**
   - Provides audit trail
   - Helps reviewers understand changes
   - Documents decisions made

6. **Monitor for new issues frequently**
   - Check every 3-5 completed issues
   - Allows priority shifts
   - Detects new work

7. **Use tasks for tracking**
   - TaskCreate at start
   - TaskUpdate to in_progress
   - TaskUpdate to completed when done
   - Provides progress visibility

8. **Follow existing code patterns**
   - Read similar implementations first
   - Match naming conventions
   - Use same design patterns
   - Maintain consistency

### DON'T ❌

1. **Never commit without running tests**
   - Even "simple" changes can break things
   - Tests are the safety net

2. **Never batch commits**
   - Each issue = one commit
   - Immediate push after commit
   - Don't wait to "collect" commits

3. **Never skip code formatting**
   - Always run spotless:apply
   - Prevents style-only commits later
   - Keeps CI green

4. **Never ask questions in autonomous mode**
   - Make reasonable decisions
   - Follow existing patterns
   - Trust your judgment

5. **Never leave issues open after completion**
   - Close immediately with summary
   - Don't mark as "done" verbally
   - Use gh issue close

6. **Never create incomplete implementations**
   - Finish what you start
   - Don't leave TODO comments
   - Don't commit commented-out code

7. **Never skip documentation**
   - Update JavaDoc/docstrings
   - Update README if API changed
   - Update CHANGELOG if present

8. **Never work on >3 things in parallel**
   - 2-3 is optimal
   - More = context thrashing
   - Quality > speed

---

## Troubleshooting

### Problem: Tests failing after change

**Solution:**
```bash
# 1. Read the test failure output carefully
mvn test -pl <module> 2>&1 | tee test-output.txt

# 2. Identify the root cause
# - Is it a real bug? Fix the code.
# - Is the test wrong? Fix the test.
# - Is it a test dependency issue? Add the dependency.

# 3. Fix and re-test
mvn test -pl <module>

# 4. Only commit when GREEN
```

### Problem: Checkstyle violations

**Solution:**
```bash
# 1. Run spotless to auto-fix most issues
mvn spotless:apply -pl <module>

# 2. Check if violations remain
mvn checkstyle:check -pl <module>

# 3. If still failing, read the error
#    Common issues:
#    - Import order (spotless should fix)
#    - Line length (break long lines)
#    - Missing JavaDoc (add it)
#    - Unused imports (remove them)

# 4. Fix manually and re-check
```

### Problem: Compilation errors after merge

**Solution:**
```bash
# 1. Pull latest
git pull origin main

# 2. Rebuild from scratch
mvn clean compile

# 3. Fix any API changes
#    - If method signatures changed, update calls
#    - If classes moved, update imports

# 4. Re-run tests
mvn clean test
```

### Problem: Workflow agents getting stuck

**Solution:**
```bash
# 1. Check workflow status
/workflows

# 2. If hung, stop it
TaskStop <task-id>

# 3. Switch to sequential mode
#    Instead of parallel(), use pipeline()
#    or just run agents one at a time

# 4. Reduce parallelization
#    From 3 concurrent → 2 concurrent
#    or disable workflows entirely
```

### Problem: Running out of context/tokens

**Solution:**
```
# 1. Complete current issue fully
# 2. Commit + push
# 3. Close issue
# 4. Let session summarize and compact
# 5. Say "continue" to resume in fresh session
```

### Problem: Issue is too vague

**Solution:**
```
# Claude should NOT ask for clarification.
# Instead:

1. Read the issue carefully
2. Find related code/tests
3. Understand the pattern
4. Implement the simplest solution that fits
5. If genuinely ambiguous, make a reasonable choice
6. Document the choice in commit message
7. Close issue with note: "Implemented as X based on pattern in Y"
```

---

## Measuring Success

### Key Metrics

Track these metrics to measure autonomous mode effectiveness:

1. **Issue Velocity**
   - Issues closed per hour
   - Target: 2-5 issues/hour (depending on complexity)

2. **Quality Rate**
   - % of commits with zero test failures
   - Target: 100%

3. **Regression Rate**
   - Test failures caused by new commits
   - Target: 0%

4. **Rework Rate**
   - Commits that fix previous commits
   - Target: <5%

5. **Coverage Delta**
   - Test coverage before vs after
   - Target: Same or higher (never decrease)

6. **Documentation Completeness**
   - % of issues closed with detailed summaries
   - Target: 100%

### Example Session Report

```
Session Summary - Autonomous Mode
================================

Duration: 2 hours 15 minutes
Model: Claude Sonnet 4.5

Issues Completed: 12
- Bugs fixed: 5
- Features added: 4
- Documentation: 3

Commits Pushed: 12
Lines Changed: +2,847 / -456

Test Results:
- Tests before: 226
- Tests after: 246 (+20 new)
- All passing: ✅
- Coverage: 87.3% (+1.2%)

Quality Metrics:
- Zero test failures: ✅
- Zero regressions: ✅
- All commits pushed: ✅
- All issues closed: ✅
- Checkstyle passing: ✅

Token Usage: 156K / 200K (78%)

Issues Closed:
#342 - Fix Swing compilation errors
#339 - Add semantic version validation
#333 - Convert to parameterized tests
#332 - Add null-safety annotations
#331 - Create CONTRIBUTING.md
... (7 more)

Next Session Priorities:
- 8 open issues remaining
- 3 P1 (high priority)
- 5 P2 (medium priority)
```

---

## Advanced Techniques

### Technique 1: Loop-Until-Budget

When user specifies "+500k" token budget:

```javascript
// In workflow script
const bugs = []
while (budget.total && budget.remaining() > 50_000) {
  const result = await agent('Find and fix bugs', {schema: BUGS_SCHEMA})
  bugs.push(...result.bugs)
  log(`${bugs.length} bugs found, ${Math.round(budget.remaining()/1000)}k tokens remaining`)
}
return { bugsFixed: bugs.length }
```

### Technique 2: Adversarial Verification

For critical changes, verify with multiple independent skeptics:

```javascript
// After making a risky change
const votes = await parallel([
  () => agent('Try to refute this change from a security perspective', {schema: VERDICT}),
  () => agent('Try to refute this change from a correctness perspective', {schema: VERDICT}),
  () => agent('Try to refute this change from a performance perspective', {schema: VERDICT})
])

const survives = votes.filter(v => !v.refuted).length >= 2
if (!survives) {
  // Revert change and try a different approach
}
```

### Technique 3: Completeness Critic

After a feature implementation:

```javascript
const critique = await agent(
  'Review this implementation and identify what is missing',
  {schema: {
    type: 'object',
    properties: {
      missingTests: { type: 'array', items: { type: 'string' } },
      missingDocs: { type: 'array', items: { type: 'string' } },
      missingEdgeCases: { type: 'array', items: { type: 'string' } }
    }
  }}
)

// Address each finding before closing the issue
```

---

## Conclusion

Autonomous mode with Claude Code enables:

✅ **3-5x faster issue resolution**  
✅ **Zero context switching for developers**  
✅ **Consistent quality through automation**  
✅ **Comprehensive documentation via detailed commits**  
✅ **Continuous progress even when you're away**

**Key Success Factors:**
1. Trust the autonomous loop
2. Maintain strict quality gates
3. Never skip tests
4. Immediate commit + push after each issue
5. Detailed issue closure comments

**When to Use:**
- Large backlogs of well-defined work
- Maintenance sprints
- Refactoring projects
- Projects with strong test coverage

**When NOT to Use:**
- Greenfield projects (no patterns to follow)
- Architectural decisions requiring human judgment
- Customer-facing changes requiring approval
- Projects without comprehensive tests

---

## Quick Reference Card

```bash
# Start autonomous mode
"100% Autonomous Mode - auto-accept everything, zero questions, work in my absence"

# Monitor progress
/workflows              # Watch running workflows
gh issue list          # Check open issues
git log --oneline -10  # Recent commits

# Quality checks
mvn test -pl <module>           # Run tests
mvn spotless:apply -pl <module> # Format code
mvn checkstyle:check -pl <module> # Lint

# Issue management
gh issue close <number> -c "Summary..."  # Close with comment
TaskCreate / TaskUpdate                  # Track progress

# Continue the loop
"continue"  # Resume after session summary
```

---

**Document Version:** 1.0  
**Last Updated:** 2026-05-29  
**Tested With:** Claude Sonnet 4.5, Claude Code CLI/Desktop  
**License:** GNU General Public License v3.0  

---

For questions or improvements to this guide, please open an issue.
