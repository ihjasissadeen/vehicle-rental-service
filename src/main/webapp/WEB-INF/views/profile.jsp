<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.vehiclerental.model.User" %>
<%@ page import="com.vehiclerental.util.HtmlUtils" %>
<%
    // Ensure the customer is logged in. If not, redirect immediately.
    String sessionRole = (String) session.getAttribute("role");
    if (sessionRole == null) {
        response.sendRedirect("login.html");
        return;
    }
    User customer = (User) request.getAttribute("user");
    if (customer == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile — DrivePoint Auto Rentals</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=Outfit:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        :root {
            --bg: #09090b;
            --surface: #111113;
            --border: rgba(255, 255, 255, 0.08);
            --gold: #f0a500;
            --text: #f4f0ea;
            --muted: #a1a1aa;
            --success: #10b981;
            --error: #ef4444;
        }

        body {
            background: var(--bg);
            color: var(--text);
            font-family: 'Outfit', sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            line-height: 1.5;
            -webkit-font-smoothing: antialiased;
        }

        nav {
            position: sticky;
            top: 0;
            z-index: 50;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1.1rem 6%;
            background: rgba(9, 9, 11, 0.8);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--border);
        }

        .logo {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 1.25rem;
            letter-spacing: -0.02em;
            color: var(--text);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.6rem;
        }

        .logo-mark {
            width: 30px;
            height: 30px;
            background: var(--gold);
            border-radius: 7px;
            display: grid;
            place-items: center;
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 1.8rem;
        }

        .nav-right a {
            text-decoration: none;
            font-size: 0.9rem;
            color: var(--muted);
            font-weight: 400;
            transition: all 0.2s;
        }

        .nav-right a:hover {
            color: var(--gold);
        }

        main {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 3rem 6%;
            position: relative;
            overflow: hidden;
        }

        main::before {
            content: "";
            position: absolute;
            top: -10%;
            left: 50%;
            transform: translateX(-50%);
            width: 1000px;
            height: 600px;
            background: radial-gradient(circle, rgba(240, 165, 0, 0.05) 0%, transparent 70%);
            pointer-events: none;
            z-index: 1;
        }

        .profile-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 2.5rem;
            width: 100%;
            max-width: 500px;
            z-index: 2;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.5);
            animation: up 0.6s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        .card-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .card-header h2 {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 2rem;
            letter-spacing: -0.03em;
            margin-bottom: 0.4rem;
        }

        .card-header h2 span {
            background: linear-gradient(135deg, #f0a500 0%, #ffcc33 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .card-header p {
            color: var(--muted);
            font-size: 0.9rem;
            font-weight: 300;
        }

        .alert-banner {
            background: rgba(16, 185, 129, 0.08);
            border: 1px solid rgba(16, 185, 129, 0.25);
            border-radius: 8px;
            padding: 0.8rem 1rem;
            color: var(--success);
            font-size: 0.85rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.6rem;
            animation: up 0.4s ease both;
        }

        .form-group {
            margin-bottom: 1.25rem;
            display: flex;
            flex-direction: column;
            gap: 0.4rem;
        }

        .form-group label {
            font-size: 0.82rem;
            font-weight: 500;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .form-control {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--border);
            color: var(--text);
            font-family: 'Outfit', sans-serif;
            font-size: 0.95rem;
            padding: 0.75rem 1rem;
            border-radius: 8px;
            outline: none;
            transition: all 0.25s ease;
        }

        .form-control:focus {
            border-color: var(--gold);
            background: rgba(240, 165, 0, 0.02);
            box-shadow: 0 0 0 3px rgba(240, 165, 0, 0.15);
        }

        .btn-submit {
            background: var(--gold);
            color: #000;
            border: none;
            font-family: 'Outfit', sans-serif;
            font-size: 0.95rem;
            font-weight: 600;
            padding: 0.85rem;
            border-radius: 8px;
            cursor: pointer;
            width: 100%;
            transition: all 0.2s ease;
            margin-top: 1.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .btn-submit:hover {
            opacity: 0.9;
            transform: translateY(-1px);
        }

        .btn-submit:active {
            transform: translateY(0);
        }

        .back-link {
            text-align: center;
            margin-top: 1.5rem;
        }

        .back-link a {
            text-decoration: none;
            font-size: 0.88rem;
            color: var(--muted);
            transition: color 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
        }

        .back-link a:hover {
            color: var(--gold);
        }

        footer {
            background: var(--surface);
            border-top: 1px solid var(--border);
            text-align: center;
            padding: 1.4rem;
            font-size: 0.82rem;
            color: var(--muted);
        }

        @keyframes up {
            from {
                opacity: 0;
                transform: translateY(15px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <nav>
        <a href="index.jsp" class="logo">
            <span class="logo-mark">
                <svg viewBox="0 0 14 14" fill="none">
                    <path d="M4 2.5H7.5C10 2.5 11.5 4.5 11.5 7C11.5 9.5 10 11.5 7.5 11.5H4V2.5Z" stroke="#000"
                        stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
            </span>
            DrivePoint Auto Rentals
        </a>
        <div class="nav-right">
            <a href="index.jsp">Home</a>
            <a href="vehicle?action=list">Browse Fleet</a>
            <a href="booking?action=my">My Bookings</a>
            <a href="user?action=logout" style="color: #ef4444;">Logout</a>
        </div>
    </nav>

    <main>
        <div class="profile-card">
            <div class="card-header">
                <h2>My <span>Profile</span></h2>
                <p>Manage your account credentials and personal details below</p>
            </div>

            <% if ("true".equals(request.getParameter("success"))) { %>
                <div class="alert-banner">
                    <svg width="18" height="18" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                    </svg>
                    <span>Profile settings updated successfully!</span>
                </div>
            <% } %>

            <form action="user" method="POST">
                <input type="hidden" name="action" value="updateProfile" />
                <input type="hidden" name="id" value="<%= customer.getId() %>" />

                <div class="form-group">
                    <label for="name">Full Name</label>
                    <input type="text" id="name" name="name" class="form-control" value="<%= HtmlUtils.escape(customer.getName()) %>" required placeholder="Enter your full name" />
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" class="form-control" value="<%= HtmlUtils.escape(customer.getEmail()) %>" required placeholder="name@email.com" />
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="Leave blank to keep current password" />
                </div>

                <button type="submit" class="btn-submit">
                    Save Changes
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="20 6 9 17 4 12"></polyline>
                    </svg>
                </button>
            </form>

            <div class="back-link">
                <a href="index.jsp">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="19" y1="12" x2="5" y2="12"></line>
                        <polyline points="12 19 5 12 12 5"></polyline>
                    </svg>
                    Back to Home page
                </a>
            </div>
        </div>
    </main>

    <footer>
        <p>&copy; 2026 DrivePoint Auto Rentals. All rights reserved.</p>
    </footer>
</body>
</html>
