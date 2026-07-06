<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.vehiclerental.model.Category" %>
<%@ page import="com.vehiclerental.util.HtmlUtils" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vehicle Categories — DrivePoint Auto Rentals</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=Outfit:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --bg: #09090b;
            --surface: #111113;
            --surface2: #18181b;
            --border: rgba(255,255,255,0.08);
            --gold: #f0a500;
            --gold-dim: rgba(240,165,0,0.1);
            --text: #f4f0ea;
            --muted: #7a7672;
            --danger: #f87171;
            --danger-dim: rgba(248,113,113,0.15);
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
            font-size: clamp(2.2rem, 5vw, 3rem);
            line-height: 1.1;
            letter-spacing: -0.03em;
        }

        .btn-add {
            background: var(--gold);
            color: #000;
            text-decoration: none;
            padding: 0.6rem 1.4rem;
            border-radius: 7px;
            font-weight: 500;
            font-size: 0.875rem;
            transition: opacity 0.2s;
            white-space: nowrap;
        }

        .btn-add:hover { opacity: 0.85; }

        .alert-error {
            background: var(--danger-dim);
            border: 1px solid rgba(248,113,113,0.3);
            color: #fca5a5;
            padding: 1rem 1.2rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            font-size: 0.88rem;
            display: flex;
            align-items: center;
            gap: 0.6rem;
            line-height: 1.4;
        }

        .alert-error svg {
            width: 18px; height: 18px;
            flex-shrink: 0;
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
            padding: 0.85rem 1.2rem;
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

        tbody tr:last-child { border-bottom: none; }
        tbody tr:hover { background: rgba(255,255,255,0.02); }

        td {
            padding: 1rem 1.2rem;
            font-size: 0.9rem;
            vertical-align: middle;
        }

        .td-id { color: var(--muted); font-size: 0.8rem; font-family: monospace; }
        .td-name { font-weight: 500; }
        .td-desc { color: var(--muted); font-size: 0.85rem; }

        .action-btns { display: flex; gap: 0.5rem; }

        .btn-edit {
            background: transparent;
            border: 1px solid var(--border);
            color: var(--text);
            padding: 0.35rem 0.8rem;
            border-radius: 5px;
            font-family: 'Outfit', sans-serif;
            font-size: 0.78rem;
            cursor: pointer;
            text-decoration: none;
            transition: border-color 0.2s;
        }

        .btn-edit:hover { border-color: rgba(255,255,255,0.25); }

        .btn-del {
            background: var(--danger-dim);
            border: 1px solid rgba(248,113,113,0.2);
            color: var(--danger);
            padding: 0.35rem 0.8rem;
            border-radius: 5px;
            font-family: 'Outfit', sans-serif;
            font-size: 0.78rem;
            cursor: pointer;
            text-decoration: none;
            transition: background 0.2s;
        }

        .btn-del:hover { background: rgba(248,113,113,0.18); }

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
            from { opacity: 0; transform: translateY(14px); }
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
        <a href="admin?action=dashboard">Dashboard</a>
        <a href="user?action=logout" style="color: var(--danger);">Logout</a>
    </div>
</nav>

<div class="container">
    <div class="page-header">
        <div>
            <div class="page-tag">System Parameters</div>
            <h1 class="page-title">Vehicle Categories</h1>
        </div>
        <a href="category?action=addForm" class="btn-add">+ Add New Category</a>
    </div>

    <% 
        String errorMsg = (String) request.getAttribute("error");
        if (errorMsg != null) {
    %>
        <div class="alert-error">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="12" r="10"></circle>
                <line x1="12" y1="8" x2="12" y2="12"></line>
                <line x1="12" y1="16" x2="12.01" y2="16"></line>
            </svg>
            <%= HtmlUtils.escape(errorMsg) %>
        </div>
    <% 
        }
    %>

    <div class="table-wrap">
        <% 
            List<Category> list = (List<Category>) request.getAttribute("categories");
            if (list == null || list.isEmpty()) {
        %>
            <div class="empty-state">
                <p>No vehicle categories found. Add your first classification to organize the fleet!</p>
            </div>
        <% 
            } else {
        %>
            <table>
                <thead>
                    <tr>
                        <th style="width: 10%;">ID</th>
                        <th style="width: 25%;">Category Name</th>
                        <th style="width: 45%;">Description</th>
                        <th style="width: 20%; text-align: right;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        for (Category c : list) {
                    %>
                        <tr>
                            <td class="td-id">#<%= c.getId() %></td>
                            <td class="td-name"><%= HtmlUtils.escape(c.getName()) %></td>
                            <td class="td-desc"><%= HtmlUtils.escape(c.getDescription()) %></td>
                            <td>
                                <div class="action-btns" style="justify-content: flex-end;">
                                    <a href="category?action=editForm&id=<%= c.getId() %>" class="btn-edit">Edit</a>
                                    <a href="category?action=delete&id=<%= c.getId() %>" class="btn-del" onclick="return confirm('Are you sure you want to delete the category \'<%= HtmlUtils.escape(c.getName()).replace("'", "\\'") %>\'? Vehicles of this classification will lose their grouping.');">Delete</a>
                                </div>
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
