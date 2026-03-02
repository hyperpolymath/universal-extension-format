<!-- SPDX-License-Identifier: PMPL-1.0-or-later -->
# Security Policy

We take security seriously. We appreciate your efforts to responsibly disclose vulnerabilities and will make every effort to acknowledge your contributions.

## Table of Contents

- [Reporting a Vulnerability](#reporting-a-vulnerability)
- [What to Include](#what-to-include)
- [Response Timeline](#response-timeline)
- [Disclosure Policy](#disclosure-policy)
- [Scope](#scope)
- [Safe Harbour](#safe-harbour)
- [Recognition](#recognition)
- [Security Updates](#security-updates)
- [Security Best Practices](#security-best-practices)

---

## Reporting a Vulnerability

### Preferred Method: GitHub Security Advisories

The preferred method for reporting security vulnerabilities is through GitHub's Security Advisory feature:

1. Navigate to [Report a Vulnerability](https://github.com/hyperpolymath/universal-extension-format/security/advisories/new)
2. Click **"Report a vulnerability"**
3. Complete the form with as much detail as possible
4. Submit -- we'll receive a private notification

This method ensures:

- End-to-end encryption of your report
- Private discussion space for collaboration
- Coordinated disclosure tooling
- Automatic credit when the advisory is published

### Alternative: Encrypted Email

If you cannot use GitHub Security Advisories, you may email us directly:

| | |
|---|---|
| **Email** | j.d.a.jewell@open.ac.uk |

> **Important:** Do not report security vulnerabilities through public GitHub issues, pull requests, discussions, or social media.

---

## What to Include

A good vulnerability report helps us understand and reproduce the issue quickly.

### Required Information

- **Description**: Clear explanation of the vulnerability
- **Impact**: What an attacker could achieve (confidentiality, integrity, availability)
- **Affected versions**: Which versions/commits are affected
- **Reproduction steps**: Detailed steps to reproduce the issue

### Helpful Additional Information

- **Proof of concept**: Code, scripts, or screenshots demonstrating the vulnerability
- **Attack scenario**: Realistic attack scenario showing exploitability
- **CVSS score**: Your assessment of severity (use [CVSS 3.1 Calculator](https://www.first.org/cvss/calculator/3.1))
- **CWE ID**: Common Weakness Enumeration identifier if known
- **Suggested fix**: If you have ideas for remediation
- **References**: Links to related vulnerabilities, research, or advisories

---

## Response Timeline

We commit to the following response times:

| Stage | Timeframe | Description |
|-------|-----------|-------------|
| **Initial Response** | 48 hours | We acknowledge receipt and confirm we're investigating |
| **Triage** | 7 days | We assess severity, confirm the vulnerability, and estimate timeline |
| **Status Update** | Every 7 days | Regular updates on remediation progress |
| **Resolution** | 90 days | Target for fix development and release (complex issues may take longer) |
| **Disclosure** | 90 days | Public disclosure after fix is available (coordinated with you) |

> **Note:** These are targets, not guarantees. Complex vulnerabilities may require more time. We'll communicate openly about any delays.

---

## Disclosure Policy

We follow **coordinated disclosure** (also known as responsible disclosure):

1. **You report** the vulnerability privately
2. **We acknowledge** and begin investigation
3. **We develop** a fix and prepare a release
4. **We coordinate** disclosure timing with you
5. **We publish** security advisory and fix simultaneously
6. **You may publish** your research after disclosure

---

## Scope

### In Scope

The following are within scope for security research:

- This repository (`hyperpolymath/universal-extension-format`) and all its code
- Official releases and packages published from this repository
- Documentation that could lead to security issues
- Build and deployment configurations in this repository
- Dependencies (report here, we'll coordinate with upstream)

### Out of Scope

The following are **not** in scope:

- Third-party services we integrate with (report directly to them)
- Social engineering attacks against maintainers
- Physical security
- Denial of service attacks against production infrastructure
- Spam, phishing, or other non-technical attacks
- Issues already reported or publicly known
- Theoretical vulnerabilities without proof of concept

---

## Safe Harbour

We support security research conducted in good faith.

If you conduct security research in accordance with this policy:

- We will not initiate legal action against you
- We will not report your activity to law enforcement
- We will work with you in good faith to resolve issues
- We consider your research authorised under the Computer Fraud and Abuse Act (CFAA), UK Computer Misuse Act, and similar laws
- We waive any potential claim against you for circumvention of security controls

---

## Recognition

Researchers who report valid vulnerabilities will be acknowledged in our Security Acknowledgments (unless they prefer anonymity).

---

## Security Updates

### Receiving Updates

To stay informed about security updates:

- **Watch this repository**: Click "Watch" -> "Custom" -> Select "Security alerts"
- **GitHub Security Advisories**: Published at [Security Advisories](https://github.com/hyperpolymath/universal-extension-format/security/advisories)
- **Release notes**: Security fixes noted in [CHANGELOG](CHANGELOG.md)

### Supported Versions

| Version | Supported | Notes |
|---------|-----------|-------|
| `main` branch | Yes | Latest development |
| Latest release | Yes | Current stable |
| Previous minor release | Yes | Security fixes backported |
| Older versions | No | Please upgrade |

---

## Security Best Practices

When using Universal Extension Format, we recommend:

### General

- Keep dependencies up to date
- Use the latest stable release
- Subscribe to security notifications
- Review configuration against security documentation
- Follow principle of least privilege

### For Contributors

- Never commit secrets, credentials, or API keys
- Use signed commits (`git config commit.gpgsign true`)
- Review dependencies before adding them
- Run security linters locally before pushing
- Report any concerns about existing code

---

## Contact

| Purpose | Contact |
|---------|---------|
| **Security issues** | [Report via GitHub](https://github.com/hyperpolymath/universal-extension-format/security/advisories/new) or j.d.a.jewell@open.ac.uk |
| **General questions** | [GitHub Discussions](https://github.com/hyperpolymath/universal-extension-format/discussions) |
| **Other enquiries** | See [README](README.adoc) for contact information |

---

*Thank you for helping keep Universal Extension Format and its users safe.*

---

<sub>Last updated: 2026 - Policy version: 1.0.0</sub>
