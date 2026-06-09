# Claude Code Guides for This Project

**Comprehensive guides for using Claude Code's advanced features on this and other projects.**

---

## Quick Start

### 🚀 [Auto-Resolve Mode](AUTO_RESOLVE_MODE.md) - **START HERE**

**Automatically resolve GitHub issues in 5 minutes.**

Get Claude Code to:
- Automatically pick and resolve issues
- Write complete solutions with tests
- Commit and push after each fix
- Close issues with detailed summaries
- Continue to next issue automatically

**One-line activation:**
```
"100% Autonomous Mode - auto-accept everything, zero questions"
```

Then say `continue` to keep it running!

**Perfect for:**
- Large issue backlogs
- Maintenance sprints
- Working while you're away
- 3-5x faster development

---

## Advanced Guides

### 📋 [Auto-Resolve Workflow Guide](AUTONOMOUS_WORKFLOW_GUIDE.md)

**Complete documentation for auto-resolve mode.**

Deep dive into:
- Setup and configuration
- Workflow patterns (sequential, parallel, hybrid)
- Quality gates and testing requirements
- Issue management best practices
- Parallelization with workflows
- Success metrics and reporting
- Advanced techniques (adversarial verification, completeness critics)

**Read this if you want:**
- Full understanding of auto-resolve mode
- Custom workflow scripts
- Integration with your CI/CD
- To adapt the pattern to your project

---

### 🔍 [Continuous Review Guide](CONTINUOUS_REVIEW_GUIDE.md)

**Automated code review and quality monitoring.**

Learn how to:
- Run automated security scans (OWASP Top 10)
- Detect code quality issues (complexity, duplication)
- Find test coverage gaps
- Audit documentation completeness
- Check for outdated dependencies
- Schedule regular reviews (daily/weekly)
- Integrate with CI/CD pipelines

**Review dimensions:**
1. Security (SQL injection, XSS, etc.)
2. Quality (complexity, code smells)
3. Testing (coverage gaps, missing tests)
4. Documentation (missing JavaDoc, TODOs)
5. Dependencies (CVEs, outdated libs)

**Perfect for:**
- Pre-release quality checks
- Continuous security monitoring
- Technical debt reduction
- Onboarding validation

---

## Which Guide Should I Read?

### I want Claude to automatically fix my issues
→ **[Auto-Resolve Mode](AUTO_RESOLVE_MODE.md)** (Quick Start)

### I want to understand how auto-resolve works in depth
→ **[Auto-Resolve Workflow Guide](AUTONOMOUS_WORKFLOW_GUIDE.md)**

### I want Claude to review my code regularly
→ **[Continuous Review Guide](CONTINUOUS_REVIEW_GUIDE.md)**

### I want to adapt these patterns to my project
→ Read all three guides:
1. Start with [Auto-Resolve Mode](AUTO_RESOLVE_MODE.md) for basics
2. Read [Auto-Resolve Workflow Guide](AUTONOMOUS_WORKFLOW_GUIDE.md) for depth
3. Add [Continuous Review Guide](CONTINUOUS_REVIEW_GUIDE.md) for quality monitoring

---

## Quick Reference

### Auto-Resolve Mode Activation
```
100% Autonomous Mode - Requirements:

AUTO-ACCEPT EVERYTHING:
- All bash commands, git commands, file operations

QUALITY REQUIREMENTS:
1. Tests written and PASSING
2. Documentation updated  
3. Code formatted
4. Linting passing
5. IMMEDIATELY push to remote

ZERO QUESTIONS:
- Work independently without asking
- Make reasonable decisions
- Work in my absence
```

### Continue Auto-Resolve Loop
```
continue
```

### Launch Parallel Workflow
```
workflow

[Task description - Claude will orchestrate multiple agents in parallel]
```

### Request Code Review
```
Review the codebase for:
- Security vulnerabilities
- Code quality issues
- Test coverage gaps
```

---

## Success Stories from This Project

**Auto-Resolve Mode Results:**
- **12 issues** resolved in 45 minutes
- **8 commits** pushed with zero regressions
- **20 new tests** added
- **246 total tests** passing (100%)
- **Zero manual intervention** required

**Continuous Review Results:**
- **2 P0 security issues** found and auto-fixed
- **5 P1 quality issues** identified and documented
- **Test coverage** improved from 80% → 82%
- **Code complexity** reduced by 8%

---

## Contributing Improvements

Found a way to improve these patterns? Submit a PR!

These guides are living documents, refined through real-world usage.

---

## License

All guides are licensed under GNU General Public License v3.0, same as this project.

Feel free to copy, adapt, and use these patterns in your own projects!

---

**Document Version:** 1.0  
**Last Updated:** 2026-05-29  
**Maintained By:** FlossWare Platform Team
