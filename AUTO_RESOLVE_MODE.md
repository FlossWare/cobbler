# Auto-Resolve Mode - Quick Start

**Automatically resolve GitHub issues with Claude Code in 5 minutes.**

## What is Auto-Resolve Mode?

**Auto-Resolve** is a Claude Code workflow pattern where Claude automatically:
- ✅ Reviews open GitHub issues
- ✅ Picks highest priority items
- ✅ Implements complete solutions with tests
- ✅ Commits + pushes immediately after each fix
- ✅ Closes issues with detailed summaries
- ✅ Continues to next issue automatically
- ✅ Works even when you're not watching

**Result:** 3-5x faster issue resolution with zero human intervention.

**Official Name:** Auto-Resolve Mode (formerly called "Autonomous Loop Mode")

---

## Prerequisites

Your project MUST have:
- ✅ Comprehensive test suite (unit + integration)
- ✅ Automated code formatting (Spotless, Prettier, Black, etc.)
- ✅ Linting/static analysis (Checkstyle, ESLint, pylint)
- ✅ Well-defined GitHub issues with clear acceptance criteria
- ✅ CI/CD pipeline that runs tests on every push (recommended)

---

## Step 1: Initial Activation (Copy-Paste)

Open Claude Code and paste this EXACT prompt:

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
3. Code formatted (run formatter automatically)
4. Linting passing
5. IMMEDIATELY push to remote (don't batch)

ISSUE MANAGEMENT:
- Monitor continuously - constantly review issues
- Close obsolete issues
- Validate relevance based on refactoring
- Create new issues if you discover problems

PARALLELIZATION:
- Work on 2-3 things at once (not more)
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

---

## Step 2: Configure Auto-Accept (Optional)

If Claude Code prompts for permissions, configure settings to auto-approve:

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

Or just approve prompts as they appear (they'll be cached).

---

## Step 3: Let It Run

Claude will now:
1. Check your open GitHub issues
2. Pick the highest priority issue
3. Read relevant code to understand patterns
4. Implement a complete solution with tests
5. Run tests → format code → verify linting
6. Commit with detailed message
7. Push immediately to remote
8. Close the issue with a summary
9. **Automatically move to the next issue**

You'll see output like:
```
Checking open issues...
Found 12 open issues. Prioritizing by labels and age.

Starting work on #342: Fix Swing compilation errors
Reading platform-swing-ui module...
Found AWT API mismatches in 3 files...
Fixing SwingPanel.java...
Running tests... ✅ All passing
Formatting code... ✅ Done
Committing: "fix: resolve AWT/Swing API mismatches"
Pushing to remote... ✅ Pushed
Closing issue #342... ✅ Closed

Moving to next issue: #339: Add semantic version validation
...
```

---

## Step 4: Continue the Loop

When a session ends (context limit reached), Claude will summarize:

```
Session Summary:
- Issues completed: 8
- Commits pushed: 8
- Tests: 246 passing (226 → 246, +20 new)
- Zero regressions
- Token usage: 156K/200K (78%)
```

To continue in a new session, just say:

```
continue
```

Claude will:
- Resume from where it left off
- Check for new/updated issues
- Pick up the next highest priority item
- Keep the loop going

---

## What Makes This "Auto-Resolve Mode"?

It's a **pattern**, not a built-in skill. The key elements:

### 1. The Loop
```
LOOP:
  1. List open issues (gh issue list)
  2. Pick highest priority
  3. Implement solution
  4. Test → Format → Lint
  5. Commit → Push immediately
  6. Close issue with summary
  GOTO step 1
```

### 2. Zero Questions
- Claude makes ALL decisions
- Follows existing code patterns
- Never asks for clarification
- Trusts its judgment

### 3. Immediate Feedback
- Each issue = 1 commit
- Push immediately after each commit
- Never batch commits
- Fast CI feedback loop

### 4. Quality Gates
```bash
# Before every commit:
1. Run tests (must pass)
2. Format code (auto-fix style)
3. Verify linting (must pass)
4. Verify no regressions
```

### 5. Continuous Monitoring
```bash
# Every 3-5 completed issues:
gh issue list --state open --limit 20
# Pick up new issues, detect priority changes
```

---

## Example Session

```
User: [Pastes auto-resolve mode prompt]

Claude:
Auto-resolve mode activated. Checking open issues...

Found 12 open issues:
- #342 (P1): Fix Swing compilation errors
- #339 (P1): Add semantic version validation
- #333 (P2): Convert to parameterized tests
- #332 (P2): Add null-safety annotations
- ... (8 more)

Starting with highest priority: #342

[30 seconds later]
✅ Issue #342 completed and pushed
   - Fixed 3 AWT API mismatches
   - All tests passing
   - Commit: a1b2c3d

Moving to #339: Add semantic version validation

[2 minutes later]
✅ Issue #339 completed and pushed
   - Implemented SemanticVersion class
   - Added 20 new tests
   - Updated ServiceRegistry interface
   - All 246 tests passing
   - Commit: d4e5f6g

Moving to #333: Convert to parameterized tests

[continues automatically until context limit or no issues remain]

Session complete:
- Issues closed: 8
- Commits pushed: 8
- Time: 45 minutes
- Quality: Zero regressions, all tests passing
```

---

## Common Questions

### Q: Will it work while I'm away?
**A:** Yes! That's the point. Start it before lunch, come back to 5+ issues resolved.

### Q: What if it makes a mistake?
**A:** Every commit is tested before pushing. If tests fail, Claude fixes the issue. You can always review commits and revert if needed.

### Q: Will it ask me questions?
**A:** No. Zero questions. It makes reasonable decisions based on existing code patterns.

### Q: Can it work on multiple issues in parallel?
**A:** Yes, but limited to 2-3 concurrent tasks to maintain quality. Use workflows for parallelization:

```
# In Claude Code chat
"Use workflow mode to work on these 3 issues in parallel:
- #342: Fix Swing errors
- #339: Add versioning
- #333: Parameterized tests"
```

### Q: How do I stop it?
**A:** Just interrupt Claude Code (Ctrl+C in CLI) or close the session. It's safe to stop at any point.

### Q: What if I run out of context?
**A:** Claude will summarize and compact. Just say "continue" to resume in a fresh session.

---

## Advanced: Workflow Mode

For complex multi-step work, use **workflows**:

```
User: "workflow"  # Include this keyword
      "Fix these 3 issues in parallel:
       - #342: Swing compilation errors
       - #339: Semantic versioning
       - #333: Parameterized tests"

Claude: [Launches dynamic workflow with 3 parallel agents]
        [Each agent works independently]
        [All agents commit + push when done]
        [Issues auto-closed]
```

Workflows are faster but use more tokens. Best for:
- 3-5 independent issues
- Complex multi-step operations
- When you want maximum speed

---

## Tips for Success

### DO ✅
1. **Start with clear, well-defined issues**
   - Good: "Fix AWT API mismatch in SwingPanel.java line 42"
   - Bad: "Make the UI better"

2. **Ensure comprehensive tests exist**
   - Claude validates changes against tests
   - No tests = no safety net

3. **Let it run uninterrupted**
   - Best results when it can work through 5-10 issues continuously

4. **Review commits periodically**
   - Claude documents changes well in commit messages
   - Quick review every 5-10 commits

5. **Use "continue" between sessions**
   - Maintains context across conversation resets

### DON'T ❌
1. **Don't interrupt mid-issue**
   - Let it finish current issue before stopping

2. **Don't work on the same files simultaneously**
   - Let Claude work, you review later

3. **Don't skip the initial prompt**
   - The exact wording matters for autonomous behavior

4. **Don't batch too many issues**
   - If you have 50+ issues, work in batches of 10-20

5. **Don't disable tests**
   - Tests are the safety net

---

## Troubleshooting

### Problem: Claude is asking questions
**Fix:** Re-paste the auto-resolve mode prompt to reinforce "zero questions" requirement

### Problem: Commits failing tests
**Fix:** Ensure your test suite is comprehensive and fast (<10 seconds)

### Problem: Running out of tokens quickly
**Fix:** 
- Reduce parallelization (from 3 → 2)
- Work on smaller issues first
- Use "continue" more frequently

### Problem: Issues not being closed
**Fix:** Ensure Claude has GitHub CLI access (`gh auth login`)

---

## Summary

**To start auto-resolve mode:**
1. Paste the activation prompt (Step 1 above)
2. Say "continue" to keep it going
3. Review commits periodically
4. Enjoy 3-5x faster issue resolution

**What you get:**
- ✅ Autonomous issue resolution
- ✅ Comprehensive tests for every change
- ✅ Immediate commits + pushes
- ✅ Detailed commit messages
- ✅ Zero regressions (test-gated)
- ✅ Work continues even when you're away

**To activate Auto-Resolve Mode:**
```
"100% Autonomous Mode - auto-accept everything, zero questions"
```

Then just say `continue` to keep the auto-resolve loop running!

---

## Full Guides

For more details, see:
- **[AUTONOMOUS_WORKFLOW_GUIDE.md](AUTONOMOUS_WORKFLOW_GUIDE.md)** - Complete auto-resolve mode documentation
- **[CONTINUOUS_REVIEW_GUIDE.md](CONTINUOUS_REVIEW_GUIDE.md)** - Automated code review patterns

---

**Document Version:** 1.0  
**Last Updated:** 2026-05-29  
**Tested With:** Claude Sonnet 4.5, Claude Code CLI/Desktop  
**License:** GNU General Public License v3.0
