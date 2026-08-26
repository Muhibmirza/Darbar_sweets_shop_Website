# Darbar Sweets E-Commerce

A premium PHP and MySQL storefront for Darbar Sweets, built around original Darbar product photography, database-managed content, AJAX cart interactions, responsive layouts, and a private administration panel.

## Highlights

- Responsive storefront with a hands-free automatic promotional slider
- Consistent category and product grids across desktop, tablet, and mobile
- Original Darbar product photography throughout the live catalog
- Search, product detail, cart, checkout, account, tracking, about, and contact pages
- Session-based customer authentication and isolated admin authentication
- Admin CRUD for products, categories, banners, coupons, orders, customers, and branding
- Live MySQL dashboard totals for revenue, orders, customers, inventory, and payments
- CSRF protection, prepared PDO statements, escaped output, and validated image uploads
- GSAP/ScrollTrigger visual sequences with reduced-motion fallbacks

## Local setup

1. Place the project in `C:\xampp\htdocs\darbarsweets` (or the equivalent WAMP/Laragon web root).
2. Start Apache and MySQL.
3. Import `database/database.sql` in phpMyAdmin.
4. Confirm the connection values in `includes/db.php`.
5. Open `http://localhost/darbarsweets/`.
6. Open `http://localhost/darbarsweets/admin/` for administration.

### Seed administrator

- Email: `admin@darbarsweets.pk`
- Password: `admin123`

Change the seed password before any public deployment.

## Content management

Admin changes are written to the same `darbar_sweets` database read by the storefront. Product/category uploads are stored under `uploads/`, while their relative paths are saved in MySQL. Homepage banners are read from the `banners` table and automatically become part of the slider according to publish status and sort order.

## Main folders

- `admin/` — private administration interface
- `assets/` — shared CSS, JavaScript, and supporting assets
- `includes/` — database, configuration, bootstrap, and security helpers
- `uploads/products/darbar-originals/` — approved Darbar product photography
- `uploads/banners/` — homepage promotional artwork
- `views/` — reusable storefront views
- `database/database.sql` — complete importable schema and seed data

## Payments

Gateway placeholders live in `includes/payment-config.php`. Keep providers in sandbox mode until merchant credentials, callback URLs, and signature verification have been tested. Never commit live secrets or collect raw card details directly; use the provider's PCI-compliant hosted checkout.

## Production checklist

- Enable HTTPS-only secure cookies and a strict Content Security Policy.
- Move database and payment secrets to environment variables.
- Replace all seed credentials.
- Restrict write access to upload directories and keep PHP execution blocked there.
- Configure verified payment callbacks, transactional email, backups, and server logging.
