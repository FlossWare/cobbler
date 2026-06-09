# Claude Code Continuous Review Guide

**A comprehensive guide to using Claude Code for continuous codebase review, quality improvement, and proactive issue detection.**

## Table of Contents

1. [Overview](#overview)
2. [Review Modes](#review-modes)
3. [Setup and Configuration](#setup-and-configuration)
4. [Review Dimensions](#review-dimensions)
5. [Workflow Patterns](#workflow-patterns)
6. [Quality Patterns](#quality-patterns)
7. [Example Review Scripts](#example-review-scripts)
8. [Integration with CI/CD](#integration-with-cicd)
9. [Best Practices](#best-practices)
10. [Measuring Effectiveness](#measuring-effectiveness)

---

## Overview

**Continuous Review** is a proactive approach where Claude Code regularly scans your codebase for quality issues, security vulnerabilities, technical debt, and improvement opportunities — without waiting for specific requests.

**Key Benefits:**
- **Catch issues early** before they reach production
- **Prevent technical debt** accumulation through constant monitoring
- **Improve code quality** with consistent, automated reviews
- **Security scanning** for vulnerabilities and best practice violations
- **Knowledge sharing** via detailed findings and explanations

**When to Use:**
- Daily/weekly automated quality checks
- Pre-release verification
- Continuous improvement sprints
- Onboarding validation for new code
- Regression prevention

---

## Review Modes

### Mode 1: On-Demand Review

**Trigger:** User explicitly requests a review

```bash
# In Claude Code chat
"Review the codebase for security vulnerabilities"
"Find all TODO and FIXME comments and prioritize them"
"Check test coverage and identify untested code"
```

**Best for:**
- Specific concerns
- Pre-commit validation
- Focused audits

### Mode 2: Scheduled Review (Cron-based)

**Trigger:** Automated schedule

```bash
# Schedule daily review at 2am
"Set up a cron job to review the codebase daily at 2am for:
- New TODO/FIXME comments
- Security vulnerabilities
- Test coverage gaps
- Code duplication
- Outdated dependencies"
```

**Best for:**
- Daily quality monitoring
- Weekly comprehensive audits
- Monthly deep-dives

### Mode 3: Continuous Review (Event-driven)

**Trigger:** Git hooks (pre-commit, post-merge)

```bash
# .git/hooks/post-merge
#!/bin/bash
claude-code run review-changes-since-last-merge.js
```

**Best for:**
- Real-time quality gates
- PR validation
- Branch protection

### Mode 4: Autonomous Review Loop

**Trigger:** Claude continuously monitors and creates issues

```bash
# In autonomous mode
"Continuously scan the codebase for issues. When you find problems:
1. Create a GitHub issue with details
2. Assess severity (P0-P3)
3. If P0/P1 and fixable, fix it immediately
4. If P2/P3, just create the issue for later
5. Continue scanning for more issues"
```

**Best for:**
- Maintenance windows
- Technical debt reduction sprints
- Quality improvement campaigns

---

## Setup and Configuration

### Initial Prompt for Continuous Review

```
Continuous Review Mode - Requirements:

REVIEW SCOPE:
- All production code (src/main)
- All test code (src/test)
- Build files (pom.xml, build.gradle, package.json)
- Configuration files
- Documentation

REVIEW DIMENSIONS:
1. Security vulnerabilities (OWASP Top 10)
2. Code quality issues (complexity, duplication, smells)
3. Test coverage gaps
4. Missing documentation
5. TODO/FIXME comments
6. Outdated dependencies
7. Performance anti-patterns
8. Thread-safety issues
9. Resource leaks
10. Error handling gaps

OUTPUT FORMAT:
For each finding:
- Severity: P0 (critical) / P1 (high) / P2 (medium) / P3 (low)
- File and line number
- Description of issue
- Why it's a problem
- Suggested fix
- Estimated effort

ACTION BASED ON SEVERITY:
- P0 (critical security/data loss): CREATE ISSUE + FIX IMMEDIATELY
- P1 (high impact): CREATE ISSUE + FIX IF TIME PERMITS
- P2 (medium): CREATE ISSUE ONLY
- P3 (low/nice-to-have): LOG FINDING (don't create issue)

QUALITY GATES:
- All findings must be verified (no false positives)
- All fixes must include tests
- All changes must pass existing tests
- Create one issue per distinct problem
```

### Directory Structure for Review Results

```
.claude/
  reviews/
    2026-05-29-security-scan.md       # Security review results
    2026-05-29-test-coverage.md       # Coverage gaps
    2026-05-29-code-quality.md        # Quality issues
    2026-05-29-todo-audit.md          # TODO/FIXME inventory
    findings/                          # Detailed findings
      CVE-2024-1234-sql-injection.md
      test-gap-user-service.md
      cyclomatic-complexity-parser.md
```

### Configuration File (.claude/review-config.json)

```json
{
  "review": {
    "schedule": "0 2 * * *",
    "dimensions": [
      "security",
      "quality",
      "testing",
      "documentation",
      "dependencies"
    ],
    "severity_thresholds": {
      "auto_fix": ["P0"],
      "create_issue": ["P0", "P1", "P2"],
      "log_only": ["P3"]
    },
    "exclude_patterns": [
      "**/target/**",
      "**/node_modules/**",
      "**/*.min.js",
      "**/generated/**"
    ],
    "quality_gates": {
      "max_cyclomatic_complexity": 15,
      "min_test_coverage": 80,
      "max_method_length": 100,
      "max_class_length": 500
    }
  }
}
```

---

## Review Dimensions

### 1. Security Review

**What to look for:**

- **SQL Injection**: Unparameterized queries
- **XSS**: Unsanitized user input in HTML
- **Path Traversal**: Unchecked file paths
- **Deserialization**: Unsafe object deserialization
- **Hardcoded Secrets**: API keys, passwords in code
- **Weak Crypto**: MD5, SHA1, DES usage
- **CSRF**: Missing CSRF protection
- **Open Redirects**: Unvalidated redirect URLs
- **XXE**: XML external entity attacks
- **Insecure Dependencies**: Known CVEs

**Example prompts:**

```bash
# Comprehensive security scan
"Scan the codebase for OWASP Top 10 vulnerabilities:
1. Search for SQL queries without parameterization
2. Find user input used in HTML without escaping
3. Detect file operations with user-controlled paths
4. Identify ObjectInputStream usage (deserialization)
5. Find hardcoded credentials/API keys
6. Check for weak crypto algorithms
7. Verify CSRF protection on state-changing endpoints
8. Detect open redirect vulnerabilities
9. Check XML parsing for XXE vulnerabilities
10. Audit dependencies for known CVEs

For each finding:
- Provide file:line reference
- Explain the vulnerability
- Show proof-of-concept exploit (if applicable)
- Suggest secure alternative
- Assess severity (P0-P3)"
```

**Automated security scan (scheduled):**

```javascript
// .claude/workflows/security-scan.js
export const meta = {
  name: 'security-scan',
  description: 'OWASP Top 10 security vulnerability scan',
  phases: [
    { title: 'Scan', detail: 'Multi-dimensional security scan' },
    { title: 'Verify', detail: 'Adversarial verification' },
    { title: 'Report', detail: 'Create issues for findings' }
  ],
}

const VULN_SCHEMA = {
  type: 'object',
  properties: {
    vulnerabilities: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          type: { type: 'string' },
          severity: { enum: ['P0', 'P1', 'P2', 'P3'] },
          file: { type: 'string' },
          line: { type: 'number' },
          description: { type: 'string' },
          exploit: { type: 'string' },
          fix: { type: 'string' }
        },
        required: ['type', 'severity', 'file', 'description', 'fix']
      }
    }
  }
}

phase('Scan')
const dimensions = [
  'SQL Injection',
  'XSS',
  'Path Traversal',
  'Deserialization',
  'Hardcoded Secrets',
  'Weak Crypto'
]

const findings = await parallel(
  dimensions.map(dim => () => 
    agent(`Scan for ${dim} vulnerabilities in src/`, {
      label: `scan-${dim}`,
      phase: 'Scan',
      schema: VULN_SCHEMA
    })
  )
)

phase('Verify')
const allVulns = findings.filter(Boolean).flatMap(f => f.vulnerabilities)

// Adversarial verification: each vuln verified by 3 independent agents
const verified = await parallel(
  allVulns.map(vuln => () =>
    parallel([
      () => agent(`Try to refute this security finding: ${vuln.description}`, {schema: VERDICT}),
      () => agent(`Verify exploitability: ${vuln.description}`, {schema: VERDICT}),
      () => agent(`Assess severity: ${vuln.description}`, {schema: VERDICT})
    ]).then(votes => ({
      ...vuln,
      confirmed: votes.filter(v => !v.refuted).length >= 2
    }))
  )
)

const confirmedVulns = verified.filter(v => v.confirmed)

phase('Report')
// Create issues for P0/P1, log P2/P3
for (const vuln of confirmedVulns) {
  if (vuln.severity === 'P0' || vuln.severity === 'P1') {
    await agent(`Create GitHub issue for security vulnerability`, {
      label: `issue-${vuln.type}`,
      phase: 'Report'
    })
  }
}

return {
  scanned: dimensions.length,
  found: allVulns.length,
  confirmed: confirmedVulns.length,
  critical: confirmedVulns.filter(v => v.severity === 'P0').length
}
```

### 2. Code Quality Review

**What to look for:**

- **High Complexity**: Cyclomatic complexity > 15
- **Long Methods**: Methods > 100 lines
- **Large Classes**: Classes > 500 lines
- **Code Duplication**: Repeated logic blocks
- **God Objects**: Classes with too many responsibilities
- **Dead Code**: Unused methods, fields, classes
- **Magic Numbers**: Unexplained numeric literals
- **Deep Nesting**: Nesting > 4 levels
- **Missing Error Handling**: No try-catch where needed
- **Poor Naming**: Non-descriptive variable names

**Example prompts:**

```bash
# Code quality scan
"Review code quality across the codebase:

1. Find methods with cyclomatic complexity > 15
2. Find methods longer than 100 lines
3. Find classes larger than 500 lines
4. Detect duplicated code blocks (>10 lines similar)
5. Identify classes with >10 methods (god objects)
6. Find unused private methods
7. Detect magic numbers (explain each)
8. Find deeply nested code (>4 levels)
9. Check error handling coverage
10. Identify poorly named variables (single letters, abbreviations)

For each issue:
- File:line reference
- Metric value (e.g., complexity=23)
- Why it's a problem
- Refactoring suggestion"
```

**Automated quality scan:**

```javascript
// .claude/workflows/quality-scan.js
export const meta = {
  name: 'quality-scan',
  description: 'Code quality and maintainability review',
  phases: [
    { title: 'Metrics', detail: 'Calculate complexity and size metrics' },
    { title: 'Smells', detail: 'Detect code smells' },
    { title: 'Prioritize', detail: 'Rank by impact' }
  ],
}

phase('Metrics')
const metrics = await agent('Calculate complexity metrics for all classes', {
  schema: {
    type: 'object',
    properties: {
      methods: {
        type: 'array',
        items: {
          type: 'object',
          properties: {
            file: { type: 'string' },
            method: { type: 'string' },
            complexity: { type: 'number' },
            lines: { type: 'number' }
          }
        }
      }
    }
  }
})

const highComplexity = metrics.methods.filter(m => m.complexity > 15)
const longMethods = metrics.methods.filter(m => m.lines > 100)

phase('Smells')
const smells = await parallel([
  () => agent('Find code duplication (>10 lines)', {schema: DUPLICATION_SCHEMA}),
  () => agent('Find god objects (>10 methods)', {schema: GOD_OBJECT_SCHEMA}),
  () => agent('Find dead code (unused private methods)', {schema: DEAD_CODE_SCHEMA}),
  () => agent('Find magic numbers', {schema: MAGIC_NUMBER_SCHEMA})
])

phase('Prioritize')
// Rank issues by: (severity * occurrences * churn_rate)
const prioritized = await agent('Prioritize quality issues by impact', {
  schema: PRIORITY_SCHEMA
})

return {
  highComplexity: highComplexity.length,
  longMethods: longMethods.length,
  totalSmells: smells.filter(Boolean).reduce((sum, s) => sum + s.count, 0),
  topIssues: prioritized.top10
}
```

### 3. Test Coverage Review

**What to look for:**

- **Untested Public Methods**: No test coverage
- **Missing Edge Cases**: Only happy path tested
- **Integration Gaps**: No end-to-end tests
- **Mock Overuse**: Tests too coupled to implementation
- **Flaky Tests**: Tests that fail intermittently
- **Slow Tests**: Tests taking >5 seconds
- **Disabled Tests**: @Disabled or @Ignore annotations
- **Test Duplication**: Similar test logic repeated
- **Missing Assertions**: Tests with no assertions
- **Coverage < 80%**: Below quality threshold

**Example prompts:**

```bash
# Test coverage audit
"Audit test coverage and identify gaps:

1. List all public methods without test coverage
2. Find classes with <80% line coverage
3. Identify edge cases not tested (null, empty, boundary)
4. Check for integration test gaps
5. Find disabled/ignored tests (@Disabled, @Ignore)
6. Detect flaky tests (review CI history if available)
7. Find slow tests (>5 seconds)
8. Identify tests without assertions
9. Find test duplication (similar test logic)
10. Verify exception handling is tested

For each gap:
- File:line reference
- What's missing
- Why it's important
- Test case suggestion"
```

**Automated coverage scan:**

```javascript
// .claude/workflows/coverage-scan.js
export const meta = {
  name: 'coverage-scan',
  description: 'Test coverage gap analysis',
  phases: [
    { title: 'Discover', detail: 'Find untested code' },
    { title: 'Analyze', detail: 'Assess risk of gaps' },
    { title: 'Generate', detail: 'Create test skeletons' }
  ],
}

phase('Discover')
const gaps = await parallel([
  () => agent('Find public methods without tests', {schema: UNTESTED_SCHEMA}),
  () => agent('Find classes with <80% coverage', {schema: LOW_COVERAGE_SCHEMA}),
  () => agent('Find disabled tests', {schema: DISABLED_TESTS_SCHEMA}),
  () => agent('Find edge cases not tested', {schema: EDGE_CASE_SCHEMA})
])

phase('Analyze')
// Assess risk: critical paths should have higher coverage
const risk = await agent('Assess risk of coverage gaps', {
  schema: {
    type: 'object',
    properties: {
      criticalUntested: {
        type: 'array',
        items: {
          type: 'object',
          properties: {
            method: { type: 'string' },
            file: { type: 'string' },
            reason: { type: 'string' },
            riskLevel: { enum: ['high', 'medium', 'low'] }
          }
        }
      }
    }
  }
})

phase('Generate')
// For high-risk gaps, generate test skeletons
const testSkeletons = await parallel(
  risk.criticalUntested
    .filter(u => u.riskLevel === 'high')
    .map(u => () => 
      agent(`Generate test skeleton for ${u.method}`, {schema: TEST_SKELETON_SCHEMA})
    )
)

return {
  totalGaps: gaps.filter(Boolean).reduce((sum, g) => sum + g.count, 0),
  highRisk: risk.criticalUntested.filter(u => u.riskLevel === 'high').length,
  testSkeletonsGenerated: testSkeletons.length
}
```

### 4. Documentation Review

**What to look for:**

- **Missing JavaDoc**: Public APIs without documentation
- **Outdated Comments**: Comments contradicting code
- **TODO/FIXME**: Unresolved action items
- **Insufficient README**: Missing setup/usage instructions
- **Broken Links**: Dead URLs in documentation
- **Missing Examples**: No usage examples for complex APIs
- **Unclear Naming**: Methods/classes with unclear purpose
- **Missing Architecture Docs**: No high-level design docs
- **Changelog Gaps**: Changes not documented
- **API Breaking Changes**: Undocumented backward incompatibilities

**Example prompts:**

```bash
# Documentation audit
"Review documentation quality:

1. Find public methods/classes without JavaDoc
2. Find TODO/FIXME comments and classify by priority
3. Check for outdated comments (comment vs code mismatch)
4. Verify README has setup/build/usage instructions
5. Test all URLs in markdown files
6. Find complex methods without usage examples
7. Check for architecture documentation
8. Verify CHANGELOG.md is up-to-date
9. Detect API breaking changes without deprecation notices
10. Find unclear method/class names

For each issue:
- File:line reference
- What's missing/wrong
- Suggested improvement"
```

### 5. Dependency Review

**What to look for:**

- **Outdated Dependencies**: Newer versions available
- **Known Vulnerabilities**: CVEs in dependencies
- **Unused Dependencies**: Declared but not used
- **Duplicate Dependencies**: Same lib, different versions
- **License Conflicts**: Incompatible licenses
- **Deprecated APIs**: Using deprecated library features
- **Transitive Vulnerability**: Vulnerable indirect deps
- **Version Conflicts**: Dependency hell
- **Missing Security Patches**: Critical updates available
- **EOL Dependencies**: Unmaintained libraries

**Example prompts:**

```bash
# Dependency audit
"Audit project dependencies:

1. List all dependencies with available updates
2. Check for known CVEs (use Maven dependency-check or npm audit)
3. Find unused dependencies
4. Detect duplicate dependencies (same lib, different versions)
5. Verify license compatibility
6. Find usage of deprecated APIs
7. Check transitive dependencies for vulnerabilities
8. Identify version conflicts
9. Find dependencies without updates for >2 years (EOL risk)
10. Assess security patch urgency

For each finding:
- Dependency name and current version
- Recommended action
- Breaking change risk"
```

---

## Workflow Patterns

### Pattern 1: Multi-Dimensional Review

**Use case:** Comprehensive periodic review

```javascript
export const meta = {
  name: 'comprehensive-review',
  description: 'Multi-dimensional codebase review',
  phases: [
    { title: 'Security', detail: 'OWASP Top 10 scan' },
    { title: 'Quality', detail: 'Code quality metrics' },
    { title: 'Testing', detail: 'Coverage gaps' },
    { title: 'Docs', detail: 'Documentation audit' },
    { title: 'Dependencies', detail: 'Dependency check' },
    { title: 'Synthesize', detail: 'Prioritize findings' }
  ],
}

const FINDING_SCHEMA = {
  type: 'object',
  properties: {
    dimension: { type: 'string' },
    severity: { enum: ['P0', 'P1', 'P2', 'P3'] },
    findings: { type: 'array', items: { type: 'object' } }
  }
}

// Run all dimensions in parallel
phase('Security')
const security = await agent('Security scan (OWASP Top 10)', {
  label: 'security-scan',
  phase: 'Security',
  schema: FINDING_SCHEMA
})

phase('Quality')
const quality = await agent('Code quality scan', {
  label: 'quality-scan',
  phase: 'Quality',
  schema: FINDING_SCHEMA
})

phase('Testing')
const testing = await agent('Test coverage audit', {
  label: 'testing-scan',
  phase: 'Testing',
  schema: FINDING_SCHEMA
})

phase('Docs')
const docs = await agent('Documentation review', {
  label: 'docs-scan',
  phase: 'Docs',
  schema: FINDING_SCHEMA
})

phase('Dependencies')
const deps = await agent('Dependency audit', {
  label: 'deps-scan',
  phase: 'Dependencies',
  schema: FINDING_SCHEMA
})

// Synthesize and prioritize
phase('Synthesize')
const allFindings = [security, quality, testing, docs, deps]
  .filter(Boolean)
  .flatMap(r => r.findings)

const prioritized = allFindings.sort((a, b) => {
  const severityOrder = { P0: 0, P1: 1, P2: 2, P3: 3 }
  return severityOrder[a.severity] - severityOrder[b.severity]
})

// Create issues for P0/P1
for (const finding of prioritized.filter(f => f.severity === 'P0' || f.severity === 'P1')) {
  await agent(`Create issue for: ${finding.description}`, {
    label: `issue-${finding.dimension}`
  })
}

return {
  totalFindings: allFindings.length,
  bySeverity: {
    P0: allFindings.filter(f => f.severity === 'P0').length,
    P1: allFindings.filter(f => f.severity === 'P1').length,
    P2: allFindings.filter(f => f.severity === 'P2').length,
    P3: allFindings.filter(f => f.severity === 'P3').length
  },
  issuesCreated: prioritized.filter(f => f.severity === 'P0' || f.severity === 'P1').length
}
```

### Pattern 2: Incremental Review (Changed Files Only)

**Use case:** Pre-commit validation, PR reviews

```bash
# Review only files changed since main
git diff --name-only main...HEAD > changed_files.txt

# Pass to Claude
"Review only these files for quality issues:
$(cat changed_files.txt)

Focus on:
1. Security vulnerabilities
2. Test coverage for new code
3. Code quality (complexity, duplication)
4. Documentation for new public APIs

Only report issues in the changed files."
```

### Pattern 3: Loop-Until-Dry (Exhaustive)

**Use case:** Find ALL instances of a specific issue

```javascript
// Find and fix all TODO comments
let todos = []
let iteration = 0
const maxIterations = 10

while (iteration < maxIterations) {
  phase(`Iteration ${iteration + 1}`)
  
  const result = await agent('Find all TODO/FIXME comments', {
    schema: {
      type: 'object',
      properties: {
        todos: {
          type: 'array',
          items: {
            type: 'object',
            properties: {
              file: { type: 'string' },
              line: { type: 'number' },
              comment: { type: 'string' },
              priority: { enum: ['high', 'medium', 'low'] }
            }
          }
        }
      }
    }
  })
  
  if (!result.todos.length) break
  
  todos.push(...result.todos)
  
  // Fix high-priority TODOs immediately
  const highPriority = result.todos.filter(t => t.priority === 'high')
  if (highPriority.length > 0) {
    await agent(`Fix these high-priority TODOs: ${JSON.stringify(highPriority)}`)
  }
  
  iteration++
}

return { totalTodos: todos.length, fixed: todos.filter(t => t.priority === 'high').length }
```

### Pattern 4: Adversarial Review

**Use case:** Critical code paths, security-sensitive areas

```javascript
// For each finding, verify with multiple independent reviewers
const finding = {
  type: 'SQL Injection',
  file: 'UserService.java',
  line: 42,
  code: 'String query = "SELECT * FROM users WHERE id=" + userId'
}

// Three independent agents try to refute the finding
const votes = await parallel([
  () => agent('Review from security perspective: is this really exploitable?', {
    schema: VERDICT_SCHEMA
  }),
  () => agent('Review from correctness perspective: could this be a false positive?', {
    schema: VERDICT_SCHEMA
  }),
  () => agent('Review from context perspective: are there mitigations elsewhere?', {
    schema: VERDICT_SCHEMA
  })
])

const confirmed = votes.filter(v => v.isRealIssue).length >= 2

if (confirmed) {
  // Create issue and optionally fix
}
```

---

## Quality Patterns

### Pattern 1: Review → Verify → Fix

```javascript
phase('Review')
const findings = await agent('Find security vulnerabilities', {schema: VULN_SCHEMA})

phase('Verify')
const verified = await parallel(
  findings.vulnerabilities.map(v => () =>
    agent(`Adversarially verify: ${v.description}`, {schema: VERDICT_SCHEMA})
  )
)

const confirmed = verified.filter(v => v.isRealIssue)

phase('Fix')
const fixes = await parallel(
  confirmed.map(v => () =>
    agent(`Fix vulnerability: ${v.description}`, {label: `fix-${v.type}`})
  )
)

return { found: findings.length, confirmed: confirmed.length, fixed: fixes.length }
```

### Pattern 2: Diff-Based Review

**Only review what changed**

```bash
# Get changed files
CHANGED_FILES=$(git diff --name-only main...HEAD)

# Review only changed code
"Review these files:
$CHANGED_FILES

For each file, check:
1. New security vulnerabilities
2. Test coverage for new code
3. Breaking API changes
4. Documentation for new public APIs

Output format:
- File: <filename>
- Line: <line-number>
- Issue: <description>
- Severity: P0/P1/P2/P3
- Fix: <suggested-fix>
"
```

### Pattern 3: Continuous Monitoring

**Background loop that constantly watches for issues**

```bash
# Autonomous continuous review
"Start a continuous review loop:

LOOP FOREVER:
  1. Check for new commits (git log -1)
  2. If new commits:
     - Get changed files
     - Review changed files only
     - Create issues for P0/P1 findings
     - Fix P0 findings immediately
  3. Every 24 hours:
     - Run comprehensive review (all dimensions)
     - Generate review report
     - Email summary to team
  4. Sleep 1 hour
  REPEAT

Keep this running in the background."
```

---

## Example Review Scripts

### Example 1: Security-Only Review

```javascript
// .claude/workflows/security-review.js
export const meta = {
  name: 'security-review',
  description: 'Comprehensive security vulnerability scan',
  phases: [
    { title: 'OWASP Scan', detail: 'Top 10 vulnerabilities' },
    { title: 'Dependency Check', detail: 'Known CVEs' },
    { title: 'Secrets Scan', detail: 'Hardcoded credentials' },
    { title: 'Verify', detail: 'Adversarial verification' }
  ],
}

const VULN_SCHEMA = { /* ... */ }

phase('OWASP Scan')
const owasp = await parallel([
  () => agent('Scan for SQL injection', {schema: VULN_SCHEMA}),
  () => agent('Scan for XSS', {schema: VULN_SCHEMA}),
  () => agent('Scan for path traversal', {schema: VULN_SCHEMA}),
  () => agent('Scan for insecure deserialization', {schema: VULN_SCHEMA}),
  () => agent('Scan for weak crypto', {schema: VULN_SCHEMA})
])

phase('Dependency Check')
const deps = await agent('Check dependencies for CVEs', {schema: CVE_SCHEMA})

phase('Secrets Scan')
const secrets = await agent('Find hardcoded secrets', {schema: SECRETS_SCHEMA})

phase('Verify')
const allFindings = [
  ...owasp.filter(Boolean).flatMap(r => r.vulnerabilities),
  ...deps.cves,
  ...secrets.findings
]

const verified = await parallel(
  allFindings.map(f => () =>
    agent(`Verify security finding: ${f.description}`, {schema: VERDICT_SCHEMA})
  )
)

const confirmed = verified.filter(v => v.isRealIssue)

// Auto-create issues for P0/P1
for (const finding of confirmed.filter(f => f.severity === 'P0' || f.severity === 'P1')) {
  await agent(`Create security issue: ${finding.description}`)
}

return {
  scanned: 8,
  found: allFindings.length,
  confirmed: confirmed.length,
  critical: confirmed.filter(f => f.severity === 'P0').length
}
```

### Example 2: Test Coverage Review

```javascript
// .claude/workflows/coverage-review.js
export const meta = {
  name: 'coverage-review',
  description: 'Test coverage gap analysis and improvement',
  phases: [
    { title: 'Discover Gaps', detail: 'Find untested code' },
    { title: 'Assess Risk', detail: 'Prioritize by criticality' },
    { title: 'Generate Tests', detail: 'Create test skeletons' },
    { title: 'Verify Coverage', detail: 'Re-run coverage analysis' }
  ],
}

phase('Discover Gaps')
const gaps = await parallel([
  () => agent('Find public methods without tests'),
  () => agent('Find classes with <80% coverage'),
  () => agent('Find edge cases not tested')
])

phase('Assess Risk')
const risk = await agent('Prioritize coverage gaps by risk', {
  schema: {
    type: 'object',
    properties: {
      highRisk: { type: 'array' },
      mediumRisk: { type: 'array' },
      lowRisk: { type: 'array' }
    }
  }
})

phase('Generate Tests')
// For high-risk gaps, generate and write tests
const tests = await parallel(
  risk.highRisk.map(gap => () =>
    agent(`Generate test for ${gap.method}`, {schema: TEST_SCHEMA})
  )
)

// Write test files
for (const test of tests.filter(Boolean)) {
  await agent(`Write test file: ${test.filename}`)
}

phase('Verify Coverage')
const newCoverage = await agent('Run coverage analysis and report')

return {
  gapsFound: gaps.filter(Boolean).reduce((sum, g) => sum + g.count, 0),
  testsGenerated: tests.length,
  coverageImprovement: newCoverage.percentageIncrease
}
```

### Example 3: Code Quality Review

```javascript
// .claude/workflows/quality-review.js
export const meta = {
  name: 'quality-review',
  description: 'Code quality and maintainability analysis',
  phases: [
    { title: 'Complexity', detail: 'High complexity detection' },
    { title: 'Duplication', detail: 'Code duplication analysis' },
    { title: 'Smells', detail: 'Code smell detection' },
    { title: 'Refactor', detail: 'Automated refactoring' }
  ],
}

phase('Complexity')
const complex = await agent('Find methods with complexity > 15', {
  schema: {
    type: 'object',
    properties: {
      methods: {
        type: 'array',
        items: {
          type: 'object',
          properties: {
            file: { type: 'string' },
            method: { type: 'string' },
            complexity: { type: 'number' },
            suggestion: { type: 'string' }
          }
        }
      }
    }
  }
})

phase('Duplication')
const duplication = await agent('Find duplicated code (>10 lines)', {schema: DUP_SCHEMA})

phase('Smells')
const smells = await parallel([
  () => agent('Find god objects (>10 methods)'),
  () => agent('Find long methods (>100 lines)'),
  () => agent('Find magic numbers'),
  () => agent('Find deeply nested code (>4 levels)')
])

phase('Refactor')
// Auto-refactor simple cases
const refactored = await parallel(
  [
    ...complex.methods.filter(m => m.complexity < 20), // Only moderate complexity
    ...duplication.duplicates.filter(d => d.occurrences === 2) // Only 2 occurrences
  ].map(issue => () =>
    agent(`Refactor: ${issue.description}`)
  )
)

return {
  complexMethodsFound: complex.methods.length,
  duplicationFound: duplication.duplicates.length,
  smellsFound: smells.filter(Boolean).reduce((sum, s) => sum + s.count, 0),
  autoRefactored: refactored.length
}
```

---

## Integration with CI/CD

### GitHub Actions Integration

```yaml
# .github/workflows/claude-review.yml
name: Claude Code Review

on:
  pull_request:
    types: [opened, synchronize]
  schedule:
    - cron: '0 2 * * *'  # Daily at 2am

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Install Claude Code
        run: |
          curl -fsSL https://claude.ai/install.sh | sh
          
      - name: Run Security Review
        run: |
          claude-code workflow run .claude/workflows/security-review.js
          
      - name: Run Quality Review
        run: |
          claude-code workflow run .claude/workflows/quality-review.js
          
      - name: Upload Review Results
        uses: actions/upload-artifact@v3
        with:
          name: review-results
          path: .claude/reviews/
          
      - name: Comment on PR
        if: github.event_name == 'pull_request'
        uses: actions/github-script@v6
        with:
          script: |
            const fs = require('fs');
            const report = fs.readFileSync('.claude/reviews/summary.md', 'utf8');
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: report
            });
```

### Pre-commit Hook

```bash
# .git/hooks/pre-commit
#!/bin/bash

echo "Running Claude Code review on staged files..."

# Get staged files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.java$')

if [ -n "$STAGED_FILES" ]; then
  # Review only staged files
  claude-code run review-staged-files.js
  
  # Check exit code
  if [ $? -ne 0 ]; then
    echo "❌ Review found P0/P1 issues. Fix them before committing."
    exit 1
  fi
fi

echo "✅ Review passed"
exit 0
```

### Post-merge Hook

```bash
# .git/hooks/post-merge
#!/bin/bash

echo "Running post-merge review..."

# Review files changed in this merge
MERGED_FILES=$(git diff --name-only HEAD@{1} HEAD)

if [ -n "$MERGED_FILES" ]; then
  claude-code run review-merged-files.js
fi
```

---

## Best Practices

### DO ✅

1. **Review regularly**
   - Daily security scans
   - Weekly comprehensive reviews
   - Pre-release audits

2. **Prioritize findings**
   - P0: Fix immediately
   - P1: Create issue + plan fix
   - P2: Create issue for later
   - P3: Log only (don't create issue)

3. **Verify findings**
   - Use adversarial verification for P0/P1
   - Reduce false positives with multi-agent voting

4. **Automate issue creation**
   - Auto-create issues for P0/P1
   - Include detailed context in issue description

5. **Track trends over time**
   - Log review results
   - Compare month-over-month metrics
   - Celebrate improvements

6. **Focus on actionable findings**
   - Provide fix suggestions
   - Link to documentation/examples
   - Estimate effort to fix

7. **Review incrementally**
   - Changed files only for quick checks
   - Full codebase for comprehensive audits

8. **Document review process**
   - Save review results to .claude/reviews/
   - Generate summary reports
   - Share with team

### DON'T ❌

1. **Don't review generated code**
   - Exclude target/, node_modules/, etc.
   - Focus on human-written code

2. **Don't create issues for every finding**
   - P3 findings should be logged, not issued
   - Reduces issue fatigue

3. **Don't blindly trust findings**
   - Always verify before creating issues
   - Use adversarial verification

4. **Don't review in isolation**
   - Share review results with team
   - Discuss controversial findings
   - Build consensus on priorities

5. **Don't ignore trends**
   - If same issue appears repeatedly, fix root cause
   - Don't just treat symptoms

6. **Don't review without context**
   - Understand project priorities
   - Consider deadlines and resources
   - Balance perfection vs pragmatism

7. **Don't overwhelm with findings**
   - Batch and prioritize
   - Fix high-impact issues first
   - Don't create 100 issues at once

8. **Don't forget to follow up**
   - Re-scan after fixes
   - Verify issues are resolved
   - Close completed issues

---

## Measuring Effectiveness

### Key Metrics

Track these metrics to measure continuous review effectiveness:

```markdown
## Review Metrics Dashboard

### Finding Detection Rate
- Total findings per review: X
- P0 (critical): Y
- P1 (high): Z
- False positive rate: <5%

### Issue Resolution
- Average time to fix P0: <24 hours
- Average time to fix P1: <7 days
- P2/P3 backlog: X issues

### Code Quality Trends
- Average cyclomatic complexity: X (target: <10)
- Code duplication: X% (target: <3%)
- Test coverage: X% (target: >80%)

### Security Posture
- Known vulnerabilities: 0 (target)
- Dependency CVEs: 0 (target)
- Days since last security review: X (target: <7)

### Review Coverage
- % of codebase reviewed in last 30 days: X%
- Lines of code reviewed: X
- Files reviewed: X
```

### Example Report Template

```markdown
# Code Review Report - 2026-05-29

## Executive Summary
- **Files Reviewed:** 247
- **Lines Reviewed:** 15,432
- **Findings:** 23 total (2 P0, 5 P1, 10 P2, 6 P3)
- **Auto-Fixed:** 2 P0 findings
- **Issues Created:** 7 (P0 + P1)

## Critical Findings (P0)

### 1. SQL Injection in UserService.java:42
**Severity:** P0 (Critical)  
**File:** `src/main/java/com/example/UserService.java:42`  
**Issue:** Unparameterized SQL query with user input  
**Code:**
```java
String query = "SELECT * FROM users WHERE id=" + userId;
```
**Fix:** Use PreparedStatement  
**Status:** ✅ Auto-fixed and committed  
**Commit:** `a1b2c3d`

## High Priority Findings (P1)

### 1. Missing Test Coverage for PaymentProcessor
**Severity:** P1 (High)  
**File:** `src/main/java/com/example/PaymentProcessor.java`  
**Issue:** 0% test coverage on critical payment logic  
**Impact:** High risk of payment bugs in production  
**Recommendation:** Write integration tests for happy path + refund scenarios  
**Issue:** #456

... (continue for all P1 findings)

## Metrics Comparison

| Metric | This Week | Last Week | Trend |
|--------|-----------|-----------|-------|
| Security Vulnerabilities | 2 | 5 | ↓ 60% |
| Test Coverage | 82% | 80% | ↑ 2% |
| Code Duplication | 4.2% | 4.8% | ↓ 0.6% |
| Avg Complexity | 9.3 | 10.1 | ↓ 8% |

## Recommendations

1. **Security:** Enable automated dependency scanning in CI
2. **Testing:** Focus test efforts on payment and auth modules
3. **Quality:** Refactor top 5 most complex methods
4. **Documentation:** Add JavaDoc to all public APIs in auth module

## Next Review

**Scheduled:** 2026-06-05 (weekly)  
**Focus Areas:** Payment module, newly merged feature branches
```

---

## Conclusion

Continuous review with Claude Code enables:

✅ **Proactive quality improvement** instead of reactive bug fixing  
✅ **Security vulnerabilities caught** before production  
✅ **Technical debt prevention** through constant monitoring  
✅ **Automated enforcement** of coding standards  
✅ **Knowledge sharing** via detailed findings  

**Key Success Factors:**
1. Schedule regular reviews (daily security, weekly comprehensive)
2. Prioritize findings (P0 → fix immediately, P1 → create issue)
3. Verify findings before creating issues (reduce false positives)
4. Track trends over time (celebrate improvements)
5. Integrate with CI/CD (automate everything)

**When to Use:**
- Daily security scans (OWASP Top 10)
- Weekly quality reviews (complexity, duplication, coverage)
- Pre-release comprehensive audits (all dimensions)
- Post-merge validation (changed files only)
- Continuous monitoring (autonomous background loop)

---

## Quick Reference

```bash
# On-demand security scan
"Scan the codebase for security vulnerabilities (OWASP Top 10)"

# Weekly quality review
"Run a comprehensive code quality review: complexity, duplication, smells"

# Test coverage audit
"Find all code with <80% test coverage and create improvement plan"

# Changed files review (pre-commit)
git diff --cached --name-only | xargs claude-code review

# Comprehensive review (all dimensions)
claude-code workflow run .claude/workflows/comprehensive-review.js

# Continuous monitoring (autonomous)
"Start continuous review loop: scan every hour, create issues for P0/P1, fix P0 immediately"
```

---

**Document Version:** 1.0  
**Last Updated:** 2026-05-29  
**Tested With:** Claude Sonnet 4.5, Claude Code CLI/Desktop  
**License:** GNU General Public License v3.0  

---

For questions or improvements to this guide, please open an issue.
