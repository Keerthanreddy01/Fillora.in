# Security Guidelines for Fillora.in

## ⚠️ IMPORTANT SECURITY NOTICE

This repository contains a Flutter application that requires API keys and other sensitive information. Please follow these guidelines to maintain security.

## 🔑 API Keys and Secrets

### Never commit these files:
- `.env` files containing actual credentials
- `google-services.json`
- `GoogleService-Info.plist`
- `firebase_options.dart` with real keys
- Any file containing API keys, tokens, or passwords

### What to do instead:
1. Use `.env.example` as a template
2. Create your own `.env` file locally (ignored by git)
3. Use environment variables in production
4. Store secrets in secure services (Firebase Config, AWS Secrets Manager, etc.)

## 🔒 Current API Keys Used

### Google Gemini API
- **Purpose**: AI-powered form assistance and text extraction
- **Location**: Should be in `.env` file as `GEMINI_API_KEY`
- **How to get**: [Google AI Studio](https://makersuite.google.com/app/apikey)

### Setup Instructions

1. **Get your API key:**
   - Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Create a new API key
   - Copy the key

2. **Create .env file:**
   ```bash
   cp .env.example .env
   ```

3. **Add your key to .env:**
   ```
   GEMINI_API_KEY=your_actual_api_key_here
   ```

4. **Never commit .env:**
   - The `.env` file is already in `.gitignore`
   - Double-check before committing

## 🚫 What NOT to Commit

### Files to NEVER commit:
- Any file with actual API keys
- Production database URLs
- Private keys (.key, .pem files)
- Keystores (.keystore, .jks files)
- Service account JSON files
- Configuration files with secrets

### Before Every Commit:
1. Run `git status` to check what you're committing
2. Use `git diff --cached` to review changes
3. Search for potential secrets: `grep -r "api.*key\|secret\|password" .`
4. Use tools like `git-secrets` for automated scanning

## 🔍 How to Check for Leaked Secrets

### Manual Check:
```bash
# Search for potential API keys
grep -r "AIza\|sk-\|pk_" . --exclude-dir=.git

# Search for common secret patterns
grep -r "password\|secret\|token\|key.*=" . --exclude-dir=.git
```

### Automated Tools:
- [git-secrets](https://github.com/awslabs/git-secrets)
- [truffleHog](https://github.com/trufflesecurity/trufflehog)
- [detect-secrets](https://github.com/Yelp/detect-secrets)

## 🚨 If You Accidentally Commit Secrets

### Immediate Actions:
1. **Revoke the exposed credentials immediately**
2. **Remove from code and commit the fix**
3. **Rewrite git history if necessary:**
   ```bash
   git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch path/to/file' --prune-empty --tag-name-filter cat -- --all
   ```
4. **Force push (⚠️ dangerous - coordinate with team):**
   ```bash
   git push origin --force --all
   ```
5. **Generate new credentials**

## 📋 Security Checklist

Before each release:
- [ ] No hardcoded API keys in source code
- [ ] All secrets in environment variables or secure config
- [ ] `.env` files not committed
- [ ] `.gitignore` includes all sensitive file patterns
- [ ] Dependencies are up to date and secure
- [ ] No debug/development code in production
- [ ] API keys have appropriate restrictions/scopes

## 📞 Contact

If you discover a security vulnerability, please email: [your-security-email@domain.com]

---

**Remember: Security is everyone's responsibility!**