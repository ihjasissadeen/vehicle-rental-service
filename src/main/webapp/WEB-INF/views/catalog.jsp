<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.vehiclerental.model.Vehicle" %>
<%@ page import="com.vehiclerental.model.VehicleDetails" %>
<%@ page import="com.vehiclerental.model.Category" %>
<%@ page import="com.vehiclerental.util.HtmlUtils" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Explore our Fleet — DrivePoint Auto Rentals</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=Outfit:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --bg: #09090b; --surface: #111113; --surface2: #18181b;
            --border: rgba(255,255,255,0.08); --gold: #f0a500;
            --text: #f4f0ea; --muted: #7a7672;
        }
        body { background: var(--bg); color: var(--text); font-family: 'Outfit', sans-serif; min-height: 100vh; }

        nav { display: flex; align-items: center; justify-content: space-between; padding: 1.1rem 6%; border-bottom: 1px solid var(--border); position: sticky; top: 0; background: rgba(9,9,11,0.8); backdrop-filter: blur(15px); z-index: 100; }
        .logo { font-family: 'Syne', sans-serif; font-weight: 800; font-size: 1.1rem; color: var(--text); text-decoration: none; display: flex; align-items: center; gap: 0.5rem; }
        .logo-mark { width: 26px; height: 26px; background: var(--gold); border-radius: 5px; display: grid; place-items: center; }
        .nav-right { display: flex; gap: 1.5rem; align-items: center; }
        .nav-right a { font-size: 0.85rem; color: var(--muted); text-decoration: none; transition: color 0.2s; }
        .nav-right a:hover { color: var(--text); }

        .container { padding: 4rem 6%; }
        .header { margin-bottom: 3.5rem; }
        .page-tag { font-size: 0.75rem; letter-spacing: 0.15em; text-transform: uppercase; color: var(--gold); margin-bottom: 0.5rem; }
        h1 {
            font-family: 'Syne', sans-serif;
            font-size: clamp(2.2rem, 5vw, 3rem);
            letter-spacing: -0.03em;
            line-height: 1.1;
            font-weight: 800;
        }
        h1 span { color: var(--gold); }

        .catalog-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 2rem; }
        .vehicle-card { background: var(--surface); border: 1px solid var(--border); border-radius: 16px; overflow: hidden; transition: transform 0.3s, border-color 0.3s; position: relative; }
        .vehicle-card:hover { transform: translateY(-8px); border-color: rgba(240,165,0,0.25); }

        .card-img { width: 100%; height: 200px; background: #1a1a1c; position: relative; display: flex; align-items: center; justify-content: center; overflow: hidden; }
        .card-img:hover .specs-overlay { opacity: 1; transform: translateY(0); }
        .specs-overlay {
            position: absolute;
            inset: 0;
            background: rgba(17,17,19,0.95);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            gap: 0.7rem;
            opacity: 0;
            transform: translateY(10px);
            transition: all 0.3s ease;
            padding: 1.5rem;
        }
        .spec-item { font-size: 0.8rem; color: var(--text); display: flex; align-items: center; gap: 0.5rem; font-weight: 300; }
        .card-img img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.3s; }
        .card-img:hover img { transform: scale(1.1); filter: blur(2px); }
        .type-badge { position: absolute; top: 1rem; right: 1rem; background: rgba(255,255,255,0.05); backdrop-filter: blur(5px); padding: 0.3rem 0.8rem; border-radius: 100px; font-size: 0.65rem; text-transform: uppercase; letter-spacing: 0.05em; color: var(--muted); border: 1px solid var(--border); }

        .card-content { padding: 1.5rem; }
        .card-brand { font-family: 'Syne', sans-serif; font-size: 1.25rem; margin-bottom: 0.25rem; }
        .card-specs { display: flex; gap: 0.75rem; margin-bottom: 1.25rem; }
        .spec { font-size: 0.7rem; color: var(--muted); display: flex; align-items: center; gap: 0.3rem; }

        .card-footer { display: flex; align-items: center; justify-content: space-between; padding-top: 1.25rem; border-top: 1px solid var(--border); }
        .price { font-size: 1.15rem; font-weight: 600; color: var(--gold); }
        .price span { font-size: 0.75rem; color: var(--muted); font-weight: 400; }

        .btn-rent { background: var(--gold); color: #000; text-decoration: none; padding: 0.6rem 1.2rem; border-radius: 8px; font-size: 0.85rem; font-weight: 600; transition: opacity 0.2s; }
        .btn-rent:hover { opacity: 0.85; }
        .btn-disabled { background: var(--surface2); color: var(--muted); cursor: not-allowed; }

        footer { text-align: center; padding: 3rem; border-top: 1px solid var(--border); margin-top: 4rem; color: var(--muted); font-size: 0.8rem; }
    </style>
</head>
<body>

<nav>
    <a href="index.jsp" class="logo">
        <div class="logo-mark">
            <svg viewBox="0 0 14 14" fill="none">
                    <path d="M4 2.5H7.5C10 2.5 11.5 4.5 11.5 7C11.5 9.5 10 11.5 7.5 11.5H4V2.5Z" stroke="#000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
        </div>
        DrivePoint Auto Rentals
    </a>
    <div class="nav-right">
        <a href="index.jsp">Home</a>
        <a href="booking?action=my">My Bookings</a>
        <a href="user?action=logout" style="color: #f87171;">Logout</a>
    </div>
</nav>

<div class="container">
    <div class="header">
        <div class="page-tag">Premium Fleet</div>
        <h1>Our <span>Vehicle Collection</span></h1>
    </div>

    <!-- Beautiful Filter Bar -->
    <div style="display: flex; gap: 0.8rem; margin-bottom: 3rem; flex-wrap: wrap;">
        <a href="vehicle?action=list" style="text-decoration: none; padding: 0.55rem 1.3rem; border-radius: 100px; font-size: 0.8rem; border: 1px solid var(--border); background: <%= request.getParameter("category") == null ? "var(--gold)" : "transparent" %>; color: <%= request.getParameter("category") == null ? "#000" : "var(--muted)" %>; font-weight: 600; transition: all 0.2s;">
            All Collection
        </a>
        <%
            List<Category> categories = (List<Category>) request.getAttribute("categories");
            if (categories != null) {
                for (Category c : categories) {
                    boolean isActive = c.getName().equalsIgnoreCase(request.getParameter("category"));
        %>
            <a href="vehicle?action=list&category=<%= java.net.URLEncoder.encode(c.getName(), "UTF-8") %>" style="text-decoration: none; padding: 0.55rem 1.3rem; border-radius: 100px; font-size: 0.8rem; border: 1px solid var(--border); background: <%= isActive ? "var(--gold)" : "transparent" %>; color: <%= isActive ? "#000" : "var(--muted)" %>; font-weight: 600; transition: all 0.2s;">
                <%= HtmlUtils.escape(c.getName()) %>
            </a>
        <%
                }
            }
        %>
    </div>

    <!-- Live Premium Fleet Search Bar -->
    <div style="margin-bottom: 2.5rem; max-width: 480px; position: relative; animation: fadeUp 0.5s ease both;">
        <input type="text" id="vehicleSearch" onkeyup="filterFleet()" placeholder="Search by brand or type (e.g. Honda, Toyota, Bike)..."
               style="width: 100%; padding: 0.85rem 1.25rem 0.85rem 2.8rem; background: var(--surface); border: 1px solid var(--border); border-radius: 10px; font-family: 'Outfit', sans-serif; font-size: 0.9rem; color: var(--text); outline: none; transition: all 0.2s;">
        <span style="position: absolute; left: 1.1rem; top: 50%; transform: translateY(-50%); font-size: 0.95rem; pointer-events: none; opacity: 0.65;">🔍</span>
    </div>

    <style>
        input#vehicleSearch:focus {
            border-color: rgba(240, 165, 0, 0.5) !important;
            box-shadow: 0 0 0 4px rgba(240, 165, 0, 0.08);
            background: var(--surface2) !important;
        }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>

    <div class="catalog-grid">
        <%
            List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("vehicles");
            if (vehicles != null) {
                for (Vehicle v : vehicles) {
                    // Logic to pick a default image based on type
                    String imgPath = "https://img.icons8.com/ios-filled/100/f0a500/car.png";
                    if ("Bike".equalsIgnoreCase(v.getType())) imgPath = "https://img.icons8.com/ios-filled/100/f0a500/motorcycle.png";
                    if ("Van".equalsIgnoreCase(v.getType())) imgPath = "https://img.icons8.com/ios-filled/100/f0a500/van.png";
        %>
            <div class="vehicle-card">
                <div class="card-img">
                    <span class="type-badge"><%= HtmlUtils.escape(v.getType()) %></span>
                    <img src="assets/vehicles/<%= v.getId() %>.jpg" onerror="this.src='<%= imgPath %>'" alt="<%= HtmlUtils.escape(v.getBrand()) %>">

                    <div class="specs-overlay">
                        <% VehicleDetails d = v.getDetails(); if(d != null) { %>
                            <div class="spec-item">⛽ <%= d.getFuelType() %></div>
                            <div class="spec-item">🪑 <%= d.getSeatingCapacity() %> Seats</div>
                            <div class="spec-item">❄️ <%= d.isHasAc() ? "Air Conditioned" : "No AC" %></div>
                            <div class="spec-item">⚙️ <%= d.isHasGear() ? "Manual/Auto" : "Standard" %></div>
                        <% } else { %>
                            <div class="spec-item">Detailed specs coming soon</div>
                        <% } %>
                    </div>
                </div>
                <div class="card-content">
                    <h3 class="card-brand"><%= HtmlUtils.escape(v.getBrand()) %></h3>
                    <div class="card-specs">
                        <span class="spec">&bull; ID: <%= v.getId() %></span>
                        <span class="spec">&bull; <%= v.isAvailable() ? "In Stock" : "Reserved" %></span>
                    </div>
                    <div class="card-footer">
                        <div class="price">LKR <%= v.getPricePerDay() %> <span>/ day</span></div>
                        <a href="booking.jsp?vehicleId=<%= v.getId() %>" class="btn-rent">Rent Now</a>
                    </div>
                    <div style="margin-top: 1rem; border-top: 1px solid var(--border); padding-top: 0.8rem; display: flex; justify-content: space-between; align-items: center;">
                        <a href="review?action=list&vehicleId=<%= v.getId() %>" style="color: var(--gold); text-decoration: none; font-size: 0.82rem; font-weight: 500;">★ View Reviews</a>
                        <a href="review?action=addForm&vehicleId=<%= v.getId() %>" style="color: var(--muted); text-decoration: none; font-size: 0.82rem;">+ Write Review</a>
                    </div>
                </div>
            </div>
        <%
                }
            }
        %>
    </div>
</div>

<footer>
    <p>&copy; 2026 DrivePoint Auto Rentals. All rights reserved.</p>
</footer>

<script>
    function filterFleet() {
        const query = document.getElementById('vehicleSearch').value.toLowerCase().trim();
        const cards = document.querySelectorAll('.vehicle-card');

        cards.forEach(card => {
            const brand = card.querySelector('.card-brand').innerText.toLowerCase();
            const type = card.querySelector('.type-badge').innerText.toLowerCase();

            if (brand.includes(query) || type.includes(query)) {
                card.style.display = 'block';
            } else {
                card.style.display = 'none';
            }
        });
    }
</script>
</body>
</html>
