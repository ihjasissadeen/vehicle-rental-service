<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vehiclerental.model.Vehicle" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit a Review — DrivePoint Auto Rentals</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=Outfit:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --bg: #09090b;
            --surface: #111113;
            --surface2: #18181b;
            --border: rgba(255, 255, 255, 0.08);
            --border-focus: rgba(240, 165, 0, 0.5);
            --gold: #f0a500;
            --text: #f4f0ea;
            --muted: #7a7672;
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
            top: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 600px;
            height: 300px;
            background: radial-gradient(ellipse, rgba(240, 165, 0, 0.07) 0%, transparent 70%);
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

        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 10%;
            right: 10%;
            height: 1px;
            background: linear-gradient(90deg, transparent, var(--gold), transparent);
            border-radius: 100px;
        }

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
            margin-bottom: 0.4rem;
        }

        .card-sub {
            font-size: 0.84rem;
            color: var(--muted);
            font-weight: 300;
            margin-bottom: 2rem;
        }

        .form-group {
            margin-bottom: 1.1rem;
        }

        label {
            display: block;
            font-size: 0.78rem;
            letter-spacing: 0.06em;
            color: var(--muted);
            text-transform: uppercase;
            margin-bottom: 0.45rem;
        }

        input[type="text"] {
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

        input[type="text"]::placeholder {
            color: #3a3835;
        }

        input:focus {
            border-color: var(--border-focus);
            box-shadow: 0 0 0 3px rgba(240, 165, 0, 0.08);
        }

        .rating-stars {
            display: flex;
            align-items: center;
            gap: 0.4rem;
            margin-top: 0.25rem;
        }

        .rating-stars input[type="radio"] {
            display: none;
        }

        .rating-stars label {
            font-size: 1.7rem;
            color: #27272a;
            cursor: pointer;
            transition: color 0.15s;
            margin: 0;
        }

        .rating-stars input[type="radio"]:checked ~ label {
            color: #27272a;
        }

        /* Pure CSS Golden Stars on Hover and Selection */
        .rating-stars {
            flex-direction: row-reverse;
            justify-content: flex-end;
        }

        .rating-stars label:hover,
        .rating-stars label:hover ~ label,
        .rating-stars input[type="radio"]:checked ~ label {
            color: var(--gold);
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
        }

        .btn-submit:hover {
            opacity: 0.86;
            transform: translateY(-1px);
        }

        .btn-submit:active {
            transform: translateY(0);
        }

        .view-link {
            display: block;
            text-align: center;
            margin-top: 1.5rem;
            font-size: 0.83rem;
            color: var(--muted);
            text-decoration: none;
            transition: color 0.2s;
        }

        .view-link:hover {
            color: var(--gold);
        }

        footer {
            background: var(--surface);
            border-top: 1px solid var(--border);
            text-align: center;
            padding: 1.3rem;
            font-size: 0.78rem;
            color: var(--muted);
        }

        @keyframes fadeUp {
            from {
                opacity: 0;
                transform: translateY(16px);
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

    <main>
        <%
            Vehicle vehicle = (Vehicle) request.getAttribute("vehicle");
        %>
        <div class="card">
            <div class="card-tag">Customer Experience</div>
            <h1 class="card-title">Submit a Review</h1>
            <p class="card-sub">Share your honest thoughts for the <%= vehicle != null ? vehicle.getBrand() : "selected vehicle" %>.</p>

            <form action="review" method="post">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="vehicleId" value="<%= vehicle != null ? vehicle.getId() : request.getParameter("vehicleId") %>">

                <!-- Dynamic Session User Presentation -->
                <div style="background: var(--surface2); border: 1px solid var(--border); padding: 0.9rem 1.1rem; border-radius: 8px; margin-bottom: 1.25rem;">
                    <p style="font-size: 0.7rem; color: var(--muted); text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.25rem;">Reviewing As</p>
                    <p style="font-weight: 500; font-size: 0.95rem; color: var(--gold);"><%= session.getAttribute("userName") %> (User #<%= session.getAttribute("userId") %>)</p>
                </div>

                <div class="form-group">
                    <label>Rating</label>
                    <div class="rating-stars">
                        <input type="radio" id="star5" name="rating" value="5" required />
                        <label for="star5">★</label>
                        <input type="radio" id="star4" name="rating" value="4" />
                        <label for="star4">★</label>
                        <input type="radio" id="star3" name="rating" value="3" />
                        <label for="star3">★</label>
                        <input type="radio" id="star2" name="rating" value="2" />
                        <label for="star2">★</label>
                        <input type="radio" id="star1" name="rating" value="1" />
                        <label for="star1">★</label>
                    </div>
                </div>

                <div class="form-group">
                    <label for="comment">Your Comment</label>
                    <input type="text" id="comment" name="comment" placeholder="What did you like or dislike about the ride?" required />
                </div>

                <button type="submit" class="btn-submit">Submit Review</button>
            </form>

            <a href="review?action=list<%= vehicle != null ? "&vehicleId=" + vehicle.getId() : "" %>" class="view-link">← View Existing Reviews</a>
        </div>
    </main>

    <footer>
        <p>&copy; 2026 DrivePoint Auto Rentals. All rights reserved.</p>
    </footer>

</body>
</html>
