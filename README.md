# MyProgress PWA

Minimal-cost fitness tracker PWA for iPhone and Android. It can be installed to the phone home screen and used like an app without App Store / Google Play.

## Included
- Lithuanian / English switch in the top bar and Settings; first launch detects browser language.
- Dashboard, weight, measurements, workouts, exercise library, progress charts, progress photos, nutrition and settings.
- Local demo mode works immediately.
- Optional Supabase cloud auth/database/storage integration.
- PWA manifest + service worker.

## Enable cloud storage
1. Create a free Supabase project.
2. Open SQL Editor and run `supabase.sql`.
3. Copy Project URL and anon/public key.
4. In `app.js`, replace `YOUR_SUPABASE_URL` and `YOUR_SUPABASE_ANON_KEY`.
5. Deploy the folder to Cloudflare Pages, GitHub Pages, Netlify, or another static host.

## Install on iPhone
Open the deployed URL in Safari -> Share -> Add to Home Screen -> Open as Web App.

## Important
The current UI is an MVP foundation. The local demo mode is intentionally independent of Supabase so it can be tested before creating a cloud project. For production, connect each CRUD action to Supabase tables and Storage; the SQL schema and RLS policies are included.
