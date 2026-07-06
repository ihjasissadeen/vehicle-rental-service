<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard — DrivePoint Auto Rentals</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@800&family=Outfit:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root { --bg: #09090b; --surface: #111113; --gold: #f0a500; --text: #f4f0ea; --muted: #7a7672; --border: rgba(255,255,255,0.08); }
        body { background: var(--bg); color: var(--text); font-family: 'Outfit', sans-serif; padding: 4rem 6%; }
        .container { max-width: 1000px; margin: 0 auto; }
        .header { margin-bottom: 3rem; }
        .title { font-family: 'Syne', sans-serif; font-size: 2.5rem; letter-spacing: -0.02em; margin-bottom: 0.5rem; }
        .subtitle { color: var(--muted); font-weight: 300; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 1.5rem; margin-top: 2rem; }
        .card { background: var(--surface); border: 1px solid var(--border); border-radius: 12px; padding: 2rem; transition: transform 0.2s; text-decoration: none; color: inherit; }
        .card:hover { transform: translateY(-5px); border-color: var(--gold); }
        .card-tag { font-size: 0.7rem; color: var(--gold); text-transform: uppercase; letter-spacing: 0.1em; margin-bottom: 0.8rem; display: block; }
        .card-name { font-size: 1.25rem; font-weight: 600; margin-bottom: 0.5rem; display: block; }
        .card-desc { font-size: 0.85rem; color: var(--muted); line-height: 1.5; }
        .logout { margin-top: 4rem; display: block; color: var(--muted); text-decoration: none; font-size: 0.85rem; }
        .logout:hover { color: var(--gold); }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1 class="title">Control <span>Center</span></h1>
            <p class="subtitle">Welcome back, Admin. Manage your fleet and users below.</p>
        </div>

        <div class="grid">
            <a href="user?action=listUsers" class="card">
                <span class="card-tag">Management</span>
                <span class="card-name">User Accounts</span>
                <p class="card-desc">View, edit, and manage all customer accounts and permissions.</p>
            </a>

            <a href="vehicle?action=list" class="card">
                <span class="card-tag">Fleet</span>
                <span class="card-name">Vehicle Inventory</span>
                <p class="card-desc">Add new vehicles, update specifications, and check availability.</p>
            </a>

            <a href="booking?action=all" class="card">
                <span class="card-tag">Operations</span>
                <span class="card-name">Bookings & Rentals</span>
                <p class="card-desc">Monitor active reservations and rental history across the fleet.</p>
            </a>

            <a href="category?action=list" class="card">
                <span class="card-tag">Classification</span>
                <span class="card-name">Vehicle Categories</span>
                <p class="card-desc">Define dynamic categories and filter options for browsing the catalog.</p>
            </a>

            <a href="review?action=adminList" class="card">
                <span class="card-tag">Feedback</span>
                <span class="card-name">Customer Reviews</span>
                <p class="card-desc">Monitor customer reviews, moderate comments, and track ratings.</p>
            </a>

            <a href="payment?action=adminList" class="card">
                <span class="card-tag">Financials</span>
                <span class="card-name">Payment Ledger</span>
                <p class="card-desc">Track active transactions, audit counter collections, and manage cash invoices.</p>
            </a>
        </div>

        <a href="user?action=logout" class="logout">← Logout and return to site</a>
    </div>
</body>
</html>