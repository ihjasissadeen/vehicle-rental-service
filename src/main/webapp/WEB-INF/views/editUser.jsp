<%@ page import="com.vehiclerental.model.User" %>
<%@ page import="com.vehiclerental.util.HtmlUtils" %>
<%
    User user = (User) request.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit User Account — Admin Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=Outfit:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --bg: #09090b;
            --surface: #111113;
            --surface2: #18181b;
            --border: rgba(255,255,255,0.08);
            --border-focus: rgba(240,165,0,0.5);
            --gold: #f0a500;
            --text: #f4f0ea;
            --muted: #a1a1aa;
        }

        body {
            background: var(--bg);
            color: var(--text);
            font-family: 'Outfit', sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        nav {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1.1rem 6%;
            border-bottom: 1px solid var(--border);
        }

        .logo {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 1.1rem;
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

        .nav-link {
            font-size: 0.85rem;
            color: var(--muted);
            text-decoration: none;
            transition: color 0.2s;
        }

        .nav-link:hover { color: var(--text); }

        main {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 3rem 1.5rem;
            position: relative;
            overflow: hidden;
        }

        main::before {
            content: '';
            position: absolute;
            top: 0; left: 50%;
            transform: translateX(-50%);
            width: 600px; height: 300px;
            background: radial-gradient(ellipse, rgba(240,165,0,0.07) 0%, transparent 70%);
            pointer-events: none;
        }

        .card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 2.5rem;
            width: 100%;
            max-width: 440px;
            position: relative;
            z-index: 2;
            animation: fadeUp 0.5s ease both;
        }

        .card-header { margin-bottom: 2rem; }

        .card-tag {
            font-size: 0.7rem;
            letter-spacing: 0.14em;
            text-transform: uppercase;
            color: var(--gold);
            margin-bottom: 0.6rem;
        }

        .card-title {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 1.8rem;
            letter-spacing: -0.02em;
            line-height: 1.1;
        }

        .card-sub {
            font-size: 0.85rem;
            color: var(--muted);
            margin-top: 0.5rem;
            font-weight: 300;
        }

        .form-group { margin-bottom: 1.1rem; }

        label {
            display: block;
            font-size: 0.78rem;
            letter-spacing: 0.06em;
            color: var(--muted);
            text-transform: uppercase;
            margin-bottom: 0.45rem;
        }

        input, select {
            width: 100%;
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 7px;
            padding: 0.72rem 0.9rem;
            font-family: 'Outfit', sans-serif;
            font-size: 0.95rem;
            color: var(--text);
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        input:focus, select:focus {
            border-color: var(--border-focus);
            box-shadow: 0 0 0 3px rgba(240,165,0,0.08);
        }


        .btn-submit {
            width: 100%;
            background: var(--gold);
            color: #000;
            border: none;
            border-radius: 7px;
            padding: 0.85rem;
            font-family: 'Outfit', sans-serif;
            font-size: 0.95rem;
            font-weight: 500;
            cursor: pointer;
            margin-top: 0.5rem;
            transition: opacity 0.2s, transform 0.15s;
            letter-spacing: 0.01em;
        }

        .btn-submit:hover { opacity: 0.86; transform: translateY(-1px); }
        .btn-submit:active { transform: translateY(0); }

        .back-link {
            text-align: center;
            margin-top: 1.25rem;
            font-size: 0.85rem;
            color: var(--muted);
        }

        .back-link a {
            color: var(--gold);
            text-decoration: none;
            font-weight: 500;
        }

        .back-link a:hover { text-decoration: underline; }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(16px); }
            to { opacity: 1; transform: translateY(0); }
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
    <a href="user?action=listUsers" class="nav-link">&larr; Back to Directory</a>
</nav>

<main>
    <div class="card">
        <div class="card-header">
            <div class="card-tag">Account Modification</div>
            <h1 class="card-title">Edit User</h1>
            <p class="card-sub">Modify account attributes for User #<%= user.getId() %> below.</p>
        </div>

        <form action="user" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="<%= user.getId() %>">

            <div class="form-group">
                <label for="name">Name</label>
                <input type="text" id="name" name="name" value="<%= HtmlUtils.escape(user.getName()) %>" required>
            </div>

            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" value="<%= HtmlUtils.escape(user.getEmail()) %>" required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="text" id="password" name="password" placeholder="Leave blank to keep the current password">
            </div>

            <div class="form-group">
                <label for="role">System Role</label>
                <select id="role" name="role" required>
                    <option value="customer" <%= "customer".equalsIgnoreCase(user.getRole()) ? "selected" : "" %>>Customer</option>
                    <option value="admin" <%= "admin".equalsIgnoreCase(user.getRole()) ? "selected" : "" %>>Administrator</option>
                </select>
            </div>

            <button type="submit" class="btn-submit">Save Changes</button>

        </form>

        <div class="back-link">
            Need to discard? <a href="user?action=listUsers">Return to directory</a>
        </div>
    </div>
</main>

</body>
</html>