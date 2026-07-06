<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.vehiclerental.model.Review" %>
<%@ page import="com.vehiclerental.model.Vehicle" %>
<%@ page import="com.vehiclerental.util.HtmlUtils" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Feedback — DrivePoint Auto Rentals</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=Outfit:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --bg: #09090b;
            --surface: #111113;
            --surface2: #18181b;
            --border: rgba(255, 255, 255, 0.08);
            --gold: #f0a500;
            --gold-dim: rgba(240, 165, 0, 0.1);
            --text: #f4f0ea;
            --muted: #7a7672;
            --emerald: #10b981;
            --emerald-dim: rgba(16, 185, 129, 0.1);
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
            max-width: 800px;
            width: 100%;
            margin: 0 auto;
            padding: 3rem 1.5rem;
            flex: 1;
            animation: fadeUp 0.5s ease both;
        }

        .header-section {
            text-align: center;
            margin-bottom: 3rem;
            position: relative;
        }

        .page-tag {
            font-size: 0.72rem;
            letter-spacing: 0.15em;
            text-transform: uppercase;
            color: var(--gold);
            margin-bottom: 0.6rem;
        }

        .page-title {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 2.2rem;
            letter-spacing: -0.02em;
            margin-bottom: 0.6rem;
        }

        .page-desc {
            font-size: 0.9rem;
            color: var(--muted);
            max-width: 500px;
            margin: 0 auto;
            line-height: 1.5;
        }

        .write-btn {
            display: inline-block;
            background: var(--gold);
            color: #000;
            padding: 0.65rem 1.3rem;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 500;
            text-decoration: none;
            margin-top: 1.2rem;
            transition: opacity 0.2s;
        }

        .write-btn:hover {
            opacity: 0.88;
        }

        .review-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 1.8rem;
            margin-bottom: 1.25rem;
            position: relative;
            transition: transform 0.2s, border-color 0.2s;
        }

        .review-card:hover {
            transform: translateY(-2px);
            border-color: rgba(255, 255, 255, 0.12);
        }

        .card-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1rem;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .avatar {
            width: 38px;
            height: 38px;
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 50%;
            display: grid;
            place-items: center;
            color: var(--gold);
            font-weight: bold;
            font-size: 0.85rem;
        }

        .user-name {
            font-weight: 500;
            font-size: 0.92rem;
        }

        .review-badge {
            font-size: 0.65rem;
            padding: 0.25rem 0.6rem;
            border-radius: 100px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-weight: 500;
        }

        .badge-verified {
            background: var(--emerald-dim);
            color: var(--emerald);
            border: 1px solid rgba(16, 185, 129, 0.2);
        }

        .badge-public {
            background: rgba(255, 255, 255, 0.03);
            color: var(--muted);
            border: 1px solid var(--border);
        }

        .stars {
            color: var(--gold);
            font-size: 0.85rem;
            display: flex;
            gap: 0.15rem;
        }

        .comment-text {
            font-size: 0.95rem;
            line-height: 1.5;
            color: #ece9e4;
            margin-bottom: 1.2rem;
        }

        .polymorphic-output {
            background: var(--surface2);
            border-left: 3px solid var(--gold);
            padding: 0.6rem 0.9rem;
            font-size: 0.8rem;
            color: var(--muted);
            border-radius: 0 6px 6px 0;
            font-family: monospace;
        }

        .empty-state {
            text-align: center;
            padding: 5rem 2rem;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            color: var(--muted);
        }

        footer {
            background: var(--surface);
            border-top: 1px solid var(--border);
            text-align: center;
            padding: 1.3rem;
            font-size: 0.78rem;
            color: var(--muted);
            margin-top: auto;
        }

        @keyframes fadeUp {
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
                    <path d="M4 2.5H7.5C10 2.5 11.5 4.5 11.5 7C11.5 9.5 10 11.5 7.5 11.5H4V2.5Z" stroke="#000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
            </span>
            DrivePoint Auto Rentals
        </a>
        <div class="nav-right">
            <a href="vehicle?action=list">Browse Catalog</a>
            <a href="index.jsp">Home</a>
        </div>
    </nav>

    <div class="container">
        <div class="header-section">
            <div class="page-tag">User Reviews</div>
            <%
                Vehicle vehicle = (Vehicle) request.getAttribute("vehicle");
                if (vehicle != null) {
            %>
                <h1 class="page-title">Reviews for <%= HtmlUtils.escape(vehicle.getBrand()) %></h1>
                <p class="page-desc">Classified as <%= HtmlUtils.escape(vehicle.getType()) %> | Price rate: <%= vehicle.getPricePerDay() %> LKR/day</p>
                <a href="review?action=addForm&vehicleId=<%= vehicle.getId() %>" class="write-btn">+ Write a Review</a>
            <%
                } else {
            %>
                <h1 class="page-title">All Customer Feedback</h1>
                <p class="page-desc">Authentic ratings from public users and verified renter transactions.</p>
            <%
                }
            %>
        </div>

        <%
            List<Review> list = (List<Review>) request.getAttribute("reviews");
            if (list == null || list.isEmpty()) {
        %>
            <div class="empty-state">
                <p>No reviews have been written for this vehicle yet. Be the first to share your rental experience!</p>
                <% if (vehicle != null) { %>
                    <a href="review?action=addForm&vehicleId=<%= vehicle.getId() %>" class="write-btn" style="margin-top: 1.5rem;">+ Write First Review</a>
                <% } %>
            </div>
        <%
            } else {
                for (Review r : list) {
                    boolean isVerified = "verified".equalsIgnoreCase(r.getType());
        %>
            <div class="review-card">
                <div class="card-top">
                    <div class="user-info">
                        <div class="avatar">
                            <%= HtmlUtils.escape(r.getUserName().substring(0, 1).toUpperCase()) %>
                        </div>
                        <div>
                            <div class="user-name"><%= HtmlUtils.escape(r.getUserName()) %></div>
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
                        </div>
                    </div>
                    <div>
                        <% if (isVerified) { %>
                            <span class="review-badge badge-verified">✓ Verified Renter</span>
                        <% } else { %>
                            <span class="review-badge badge-public">Public Review</span>
                        <% } %>
                    </div>
                </div>

                <div class="comment-text">
                    "<%= HtmlUtils.escape(r.getComment()) %>"
                </div>
            </div>
        <%
                }
            }
        %>
    </div>

    <footer>
        <p>&copy; 2026 DrivePoint Auto Rentals. All rights reserved.</p>
    </footer>

</body>
</html>