<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Category — DrivePoint Auto Rentals</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=Outfit:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --bg: #09090b;
            --surface: #111113;
            --surface2: #18181b;
            --border: rgba(255,255,255,0.08);
            --gold: #f0a500;
            --text: #f4f0ea;
            --muted: #7a7672;
            --danger: #f87171;
        }

        body {
            background: var(--bg);
            color: var(--text);
            font-family: 'Outfit', sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        nav {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1rem 5%;
            border-bottom: 1px solid var(--border);
            background: rgba(9,9,11,0.9);
            position: sticky; top: 0; z-index: 50;
            backdrop-filter: blur(16px);
        }

        .logo {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 1.05rem;
            color: var(--text);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .logo-mark {
            width: 26px; height: 26px;
            background: var(--gold);
            border-radius: 5px;
            display: grid;
            place-items: center;
        }

        .logo-mark svg { width: 13px; height: 13px; }

        .nav-right { display: flex; align-items: center; gap: 1.25rem; }

        .nav-right a {
            font-size: 0.82rem;
            color: var(--muted);
            text-decoration: none;
            transition: color 0.2s;
        }

        .nav-right a:hover { color: var(--text); }

        .container {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 3rem 1.5rem;
            animation: fadeIn 0.4s ease both;
        }

        .card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 16px;
            width: 100%;
            max-width: 500px;
            padding: 2.5rem;
            box-shadow: 0 20px 40px rgba(0,0,0,0.4);
        }

        .card-header {
            margin-bottom: 2rem;
        }

        .card-tag {
            font-size: 0.7rem;
            letter-spacing: 0.14em;
            text-transform: uppercase;
            color: var(--gold);
            margin-bottom: 0.4rem;
            display: block;
        }

        .card-title {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 1.75rem;
            letter-spacing: -0.02em;
        }

        .form-group {
            margin-bottom: 1.5rem;
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        label {
            font-size: 0.8rem;
            font-weight: 500;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        input[type="text"], textarea {
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 0.8rem 1rem;
            color: var(--text);
            font-family: 'Outfit', sans-serif;
            font-size: 0.92rem;
            transition: border-color 0.2s, box-shadow 0.2s;
            width: 100%;
        }

        input[type="text"]:focus, textarea:focus {
            outline: none;
            border-color: var(--gold);
            box-shadow: 0 0 0 3px rgba(240,165,0,0.15);
        }

        textarea {
            resize: vertical;
            min-height: 110px;
        }

        .action-btns {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }

        .btn-submit {
            flex: 2;
            background: var(--gold);
            color: #000;
            border: none;
            border-radius: 8px;
            padding: 0.8rem;
            font-family: 'Outfit', sans-serif;
            font-weight: 600;
            font-size: 0.9rem;
            cursor: pointer;
            transition: opacity 0.2s;
        }

        .btn-submit:hover { opacity: 0.85; }

        .btn-cancel {
            flex: 1;
            background: transparent;
            border: 1px solid var(--border);
            color: var(--text);
            border-radius: 8px;
            padding: 0.8rem;
            font-family: 'Outfit', sans-serif;
            font-size: 0.9rem;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
            transition: border-color 0.2s;
        }

        .btn-cancel:hover { border-color: rgba(255,255,255,0.2); }

        footer {
            background: var(--surface);
            border-top: 1px solid var(--border);
            text-align: center;
            padding: 1.2rem;
            font-size: 0.78rem;
            color: var(--muted);
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(12px); }
            to   { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

<nav>
    <a href="admin?action=dashboard" class="logo">
        <span class="logo-mark">
            <svg viewBox="0 0 14 14" fill="none">
                    <path d="M4 2.5H7.5C10 2.5 11.5 4.5 11.5 7C11.5 9.5 10 11.5 7.5 11.5H4V2.5Z" stroke="#000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
        </span>
        DrivePoint Auto Rentals
    </a>
    <div class="nav-right">
        <a href="category?action=list">Back to List</a>
    </div>
</nav>

<div class="container">
    <div class="card">
        <div class="card-header">
            <span class="card-tag">Add Configuration</span>
            <h2 class="card-title">New Category</h2>
        </div>

        <form action="category?action=add" method="POST">
            <div class="form-group">
                <label for="name">Category Name</label>
                <input type="text" id="name" name="name" required placeholder="e.g., Luxury Sedan, SUV, Bike">
            </div>

            <div class="form-group">
                <label for="desc">Description</label>
                <textarea id="desc" name="desc" required placeholder="Describe what vehicles fall under this category..."></textarea>
            </div>

            <div class="action-btns">
                <button type="submit" class="btn-submit">Save Category</button>
                <a href="category?action=list" class="btn-cancel">Cancel</a>
            </div>
        </form>
    </div>
</div>

<footer>
    <p>&copy; 2026 DrivePoint Auto Rentals. All rights reserved.</p>
</footer>

</body>
</html>
