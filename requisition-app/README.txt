============================================================
  KAMA COMPANIES
  Requisition & Calendar System
============================================================

FOLDER CONTENTS
---------------
  index.html   → The full working app (open this in a browser)
  types.ts     → TypeScript type definitions (reference only)
  README.txt   → This file
  netlify.toml → Netlify static-site deployment settings
  _headers     → Security headers for static hosting


HOW TO OPEN
-----------
1. Double-click  index.html
2. It opens in Chrome / Edge / Firefox / Safari
3. Create an account with a username and a 3-digit password, or sign in to an existing account


FREE STATIC DEPLOYMENT (NETLIFY)
--------------------------------
1. Open https://app.netlify.com/drop and sign in or create a free account
2. Drag the contents of this folder onto the deployment page
3. Netlify publishes the app at a public HTTPS address ending in .netlify.app
4. To update it, open the site in Netlify and upload the updated folder from its Deploys page

The netlify.toml file configures the folder as the publish directory. The _headers
file adds browser security headers. No build command or package installation is needed.


DEPARTMENTS
-----------
  Sales | R and D | Executive | Engineering | Finance


REQUEST CATEGORIES (filtered by department)
-------------------------------------------
  Food expenses
  Human resources
  Sales and marketing
  Technology and hosting
  Fuel and transport
  Others

  Mapping rules (hard restrictions):
  • Sales      → Sales and marketing, Food expenses, Fuel and transport, Others
  • R and D    → Technology and hosting, Human resources, Fuel and transport, Others
  • Executive  → All categories
  • Engineering→ Technology and hosting, Fuel and transport, Human resources, Others
  • Finance    → All categories


FEATURES
--------
  • Submit requisitions (with Estimated Cost and Attachment notes)
  • Admin approve / reject with comments
  • Shared activity calendar
  • Filters by department, status, type
  • Printable approved request form (Kama Companies branded)


SHARING WITH THE TEAM
---------------------
  • Share the whole folder, or the zip file: requisition-app.zip
  • Each person opens index.html on their computer
  • Accounts, requests, and events are stored in that browser only (localStorage)
  • Passwords are stored as salted hashes, but account roles are not secured
  • Hosting creates a public demo link; it does not add shared storage or secure authentication
  • Anyone can create an Admin account, and passwords are only 3 digits
  • Do not use this hosted demo for real approvals or confidential information
  • A production system needs server-side authentication, role permissions, and shared storage


© Kama Companies – Internal use
