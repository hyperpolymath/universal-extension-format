# How to Get Mozilla Add-ons API Credentials

## The Problem
The API key page doesn't show up in search results and isn't linked prominently. You MUST be logged in to see it.

## Step-by-Step Instructions

### Option 1: Direct URL (After Login)
1. **Login first**: Go to https://addons.mozilla.org and sign in
2. **Then navigate to**: https://addons.mozilla.org/en-US/developers/addon/api/key/
   - Note: This URL only works AFTER you're logged in

### Option 2: Manual Navigation
1. Go to https://addons.mozilla.org
2. Click **"Sign In"** (top right)
3. Sign in with your Firefox Account
4. Click your **username** (top right) → **"Manage My Submissions"**
5. In the left sidebar, click **"API Credentials"**
6. Or navigate to: **Tools** → **"Manage API Keys"**

### Option 3: Developer Hub Path
1. Go to https://addons.mozilla.org/developers/
2. Sign in if not already
3. Click **"Tools"** in the top navigation
4. Select **"Manage API Keys"**

## Creating API Credentials

Once you're on the API key page:

1. Click **"Generate new credentials"** or **"Create new API credentials"**
2. You'll see:
   - **JWT issuer** (this is your `--api-key`)
   - **JWT secret** (this is your `--api-secret`)
3. **CRITICAL**: Copy both immediately - the secret is only shown ONCE
4. Store them securely (password manager or environment variables)

## Example Usage

```bash
# Store in environment (secure)
export AMO_API_KEY="user:12345678:987"
export AMO_API_SECRET="abc123def456..."

# Use with web-ext
cd /var/mnt/eclipse/repos/fireflag/extension

npx web-ext sign \
  --channel=listed \
  --api-key="$AMO_API_KEY" \
  --api-secret="$AMO_API_SECRET" \
  --amo-metadata=../MOZILLA-LISTING.json
```

## Security Best Practices

```bash
# Add to ~/.bashrc or ~/.zshrc (DO NOT commit to git)
export AMO_API_KEY="your-jwt-issuer"
export AMO_API_SECRET="your-jwt-secret"

# Or use a .env file (add to .gitignore!)
echo "AMO_API_KEY=your-jwt-issuer" >> .env
echo "AMO_API_SECRET=your-jwt-secret" >> .env
echo ".env" >> .gitignore
```

## Troubleshooting

### "Page Not Found" or 404
→ You're not logged in. Sign in first, then try the direct URL.

### "Permission Denied"
→ Your account might not have developer access yet.
→ Go to https://addons.mozilla.org/developers/ and accept the developer agreement.

### Can't Find "API Credentials" Link
→ Try the direct URL: https://addons.mozilla.org/en-US/developers/addon/api/key/
→ Make sure you're using `/en-US/` in the URL (or your locale)

### Link Structure Changed
Mozilla sometimes reorganizes the developer hub. If the above doesn't work:
1. Go to https://addons.mozilla.org/developers/
2. Look for "Profile" or "Account Settings"
3. Search for "API" or "Credentials"
4. Check under "Tools" or "Advanced"

## Why Mozilla Hides This

The API key page is intentionally hidden from:
- Search engines (robots.txt)
- Logged-out users
- Site navigation (deep link only)

This is a security measure to prevent:
- Automated scraping
- Credential harvesting
- Unauthorized API access

## Alternative: Manual Submission

If you still can't find the API page, you can submit manually:

1. Go to: https://addons.mozilla.org/developers/addon/submit/upload-listed
2. Upload `fireflag-0.1.0.zip`
3. Fill out the form manually
4. Skip the command-line submission

The manual web interface is often easier for first-time submissions anyway!
