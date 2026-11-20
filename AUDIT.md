# Repository audit — first pass

## Findings
- Static customer storefront and seller dashboard, with Supabase integration and browser-storage fallback.
- Do not expose seller operations publicly until Supabase Auth and restrictive Row Level Security policies are in place; README itself flags demo policies.
- Never accept or store raw payment-card details in this frontend. Use a compliant hosted checkout/payment provider and server-side verification.
- Validate menu/order schema, realtime behavior, input validation, and mobile accessibility. Netlify is already referenced; Vercel can also host the static frontend.

## Verification
README and root structure inspected; Supabase policies and browser flows require a separate functional test.