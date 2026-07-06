<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.vehiclerental.model.Review" %>
<%@ page import="com.vehiclerental.util.HtmlUtils" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Reviews — DrivePoint Auto Rentals</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=Outfit:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --bg: #09090b;
            --surface: #111113;
            --surface2: #18181b;
            --border: rgba(255, 255, 255, 0.08);
            --gold: #f0a500;
            --text: #f4f0ea;
            --muted: #7a7672;
            --danger: #f87171;
            --danger-dim: rgba(248, 113, 113, 0.15);
            --emerald: #10b981;
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
            position: sticky;
            top: 0;
            z-index: 50;
            background: rgba(9, 9, 11, 0.9);
            backdrop-filter: blur(16px);
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
            width: 26px;
            height: 26px;
            background: var(--gold);
            border-radius: 5px;
            display: grid;
            place-items: center;
        }

        .logo-mark svg {
            width: 13px;
            height: 13px;
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 1.25rem;
        }

        .nav-right a {
            font-size: 0.82rem;
            color: var(--muted);
            text-decoration: none;
            transition: color 0.2s;
        }

        .nav-right a:hover {
            color: var(--text);
        }

        .container {
            padding: 2.5rem 5%;
            flex: 1;
            animation: fadeUp 0.5s ease both;
        }

        .page-header {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            margin-bottom: 2rem;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .page-tag {
            font-size: 0.7rem;
            letter-spacing: 0.14em;
            text-transform: uppercase;
            color: var(--gold);
            margin-bottom: 0.4rem;
        }

        .page-title {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 2.5rem;
            letter-spacing: -0.03em;
            line-height: 1.1;
        }

        .table-wrap {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            overflow: hidden;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background: var(--surface2);
            border-bottom: 1px solid var(--border);
        }

        th {
            text-align: left;
            padding: 0.95rem 1.2rem;
            font-size: 0.7rem;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--muted);
            font-weight: 400;
        }

        tbody tr {
            border-bottom: 1px solid var(--border);
            transition: background 0.15s;
        }

        tbody tr:last-child {
            border-bottom: none;
        }

        tbody tr:hover {
            background: rgba(255, 255, 255, 0.02);
        }

        td {
            padding: 1.1rem 1.2rem;
            font-size: 0.9rem;
            vertical-align: middle;
        }

        .td-id {
            color: var(--muted);
            font-size: 0.8rem;
            font-family: monospace;
        }

        .td-tag {
            font-size: 0.75rem;
            font-weight: 500;
        }

        .tag-verified {
            color: var(--emerald);
        }

        .tag-public {
            color: var(--muted);
        }

        .stars {
            color: var(--gold);
            font-size: 0.82rem;
        }

        .btn-del {
            background: var(--danger-dim);
            border: 1px solid rgba(248, 113, 113, 0.2);
            color: var(--danger);
            padding: 0.35rem 0.85rem;
            border-radius: 5px;
            font-family: 'Outfit', sans-serif;
            font-size: 0.78rem;
            cursor: pointer;
            transition: background 0.2s;
        }

        .btn-del:hover {
            background: rgba(248, 113, 113, 0.25);
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--muted);
            font-size: 0.9rem;
        }

        footer {
            background: var(--surface);
            border-top: 1px solid var(--border);
            text-align: center;
            padding: 1.2rem;
            font-size: 0.78rem;
            color: var(--muted);
            margin-top: auto;
        }

        @keyframes fadeUp {
            from {
                opacity: 0;
                transform: translateY(14px);
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
        <a href="admin?action=dashboard" class="logo">
            <span class="logo-mark">
                <svg viewBox="0 0 14 14" fill="none">
                    <path d="M4 2.5H7.5C10 2.5 11.5 4.5 11.5 7C11.5 9.5 10 11.5 7.5 11.5H4V2.5Z" stroke="#000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
            </span>
            DrivePoint Auto Rentals
        </a>
        <div class="nav-right">
            <a href="admin?action=dashboard">Dashboard</a>
            <a href="user?action=logout" style="color: var(--danger);">Logout</a>
        </div>
    </nav>

    <div class="container">
        <div class="page-header">
            <div>
                <div class="page-tag">Platform Moderation</div>
                <h1 class="page-title">Manage Customer Reviews</h1>
            </div>
        </div>

        <div class="table-wrap">
            <%
                List<Review> list = (List<Review>) request.getAttribute("reviews");
                if (list == null || list.isEmpty()) {
            %>
                <div class="empty-state">
                    <p>No customer reviews have been written yet. System reviews are stored in reviews.txt.</p>
                </div>
            <%
                } else {
            %>
                <table>
                    <thead>
                        <tr>
                            <th style="width: 8%;">ID</th>
                            <th style="width: 12%;">User ID</th>
                            <th style="width: 12%;">Vehicle ID</th>
                            <th style="width: 15%;">Rating</th>
                            <th style="width: 38%;">Comment</th>
                            <th style="width: 15%;">Type</th>
                            <th style="width: 10%; text-align: right;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (Review r : list) {
                                boolean isVerified = "verified".equalsIgnoreCase(r.getType());
                        %>
                            <tr>
                                <td class="td-id">#<%= r.getId() %></td>
                                <td><%= HtmlUtils.escape(r.getUserName()) %> (ID: <%= r.getUserId() %>)</td>
                                <td>Vehicle #<%= r.getVehicleId() %></td>
                                <td>
                                    <div class="stars">
                                        <%
                                            for (int i = 1; i <= 5; i++) {
                                                if (i <= r.getRating()) {
                                        %>
                                            ★
                                        <%      } else { %>
                                            ☆
                                        <%
                                                }
                                            }
                                        %>
                                    </div>
                                </td>
                                <td>"<%= HtmlUtils.escape(r.getComment()) %>"</td>
                                <td class="td-tag <%= isVerified ? "tag-verified" : "tag-public" %>">
                                    <%= isVerified ? "✓ Verified" : "Public" %>
                                </td>
                                <td style="text-align: right;">
                                    <form action="review" method="post" onsubmit="return confirm('Are you sure you want to moderate/delete review #<%= r.getId() %>? This action is permanent.');" style="display: inline;">
                                        <input type="hidden" name="action" value="delete" />
                                        <input type="hidden" name="id" value="<%= r.getId() %>" />
                                        <button type="submit" class="btn-del">Delete</button>
                                    </form>
                                </td>
                            </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            <%
                }
            %>
        </div>
    </div>

    <footer>
        <p>&copy; 2026 DrivePoint Auto Rentals. All rights reserved.</p>
    </footer>

</body>
</html>