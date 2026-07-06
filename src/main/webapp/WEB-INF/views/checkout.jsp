<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vehiclerental.model.Booking" %>
<%@ page import="com.vehiclerental.model.Vehicle" %>
<%@ page import="com.vehiclerental.util.HtmlUtils" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secured Checkout — DrivePoint Auto Rentals</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=Outfit:wght@300;400;500;600&display=swap" rel="stylesheet">
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
            --green: #4ade80;
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

        .container {
            max-width: 900px;
            margin: 3rem auto;
            padding: 0 1.5rem;
            width: 100%;
            flex: 1;
            display: grid;
            grid-template-columns: 1fr 1.2fr;
            gap: 2rem;
            animation: fadeUp 0.5s ease both;
        }

        .summary-panel {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 2rem;
            height: fit-content;
        }

        .checkout-panel {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 2.5rem;
            position: relative;
        }

        .checkout-panel::before {
            content: '';
            position: absolute;
            top: 0;
            left: 10%;
            right: 10%;
            height: 1px;
            background: linear-gradient(90deg, transparent, var(--gold), transparent);
        }

        .panel-tag {
            font-size: 0.7rem;
            letter-spacing: 0.14em;
            text-transform: uppercase;
            color: var(--gold);
            margin-bottom: 0.5rem;
        }

        .panel-title {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 1.7rem;
            letter-spacing: -0.02em;
            margin-bottom: 1.5rem;
        }

        .summary-item {
            display: flex;
            justify-content: space-between;
            padding: 0.8rem 0;
            border-bottom: 1px solid var(--border);
            font-size: 0.88rem;
        }

        .summary-item:last-of-type {
            border-bottom: none;
        }

        .summary-item label {
            color: var(--muted);
        }

        .summary-item span {
            font-weight: 500;
        }

        .total-box {
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 1.2rem;
            margin-top: 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .total-box label {
            font-size: 0.8rem;
            color: var(--gold);
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .total-box span {
            font-family: 'Syne', sans-serif;
            font-size: 1.4rem;
            font-weight: 800;
            color: var(--text);
        }

        .type-selector {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .selector-btn {
            flex: 1;
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 1rem;
            cursor: pointer;
            text-align: center;
            transition: all 0.2s;
        }

        .selector-btn.active {
            border-color: var(--gold);
            background: rgba(240, 165, 0, 0.05);
        }

        .selector-btn svg {
            width: 24px;
            height: 24px;
            margin-bottom: 0.4rem;
            fill: var(--muted);
        }

        .selector-btn.active svg {
            fill: var(--gold);
        }

        .selector-btn span {
            display: block;
            font-size: 0.82rem;
            font-weight: 500;
            color: var(--muted);
        }

        .selector-btn.active span {
            color: var(--gold);
        }

        .form-group {
            margin-bottom: 1.25rem;
        }

        .form-group label {
            display: block;
            font-size: 0.76rem;
            letter-spacing: 0.06em;
            color: var(--muted);
            text-transform: uppercase;
            margin-bottom: 0.45rem;
        }

        input {
            width: 100%;
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 7px;
            padding: 0.75rem 0.9rem;
            font-family: 'Outfit', sans-serif;
            font-size: 0.95rem;
            color: var(--text);
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        input:focus {
            border-color: var(--border-focus);
            box-shadow: 0 0 0 3px rgba(240, 165, 0, 0.08);
        }

        select {
            width: 100%;
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 7px;
            padding: 0.75rem 0.9rem;
            font-family: 'Outfit', sans-serif;
            font-size: 0.95rem;
            color: var(--text);
            outline: none;
            appearance: none;
        }

        .btn-pay {
            width: 100%;
            background: var(--gold);
            color: #000;
            border: none;
            border-radius: 7px;
            padding: 0.9rem;
            font-family: 'Outfit', sans-serif;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            margin-top: 1rem;
            transition: opacity 0.2s, transform 0.15s;
        }

        .btn-pay:hover {
            opacity: 0.9;
            transform: translateY(-1px);
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
            from { opacity: 0; transform: translateY(16px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .payment-section {
            display: none;
        }

        .payment-section.active {
            display: block;
            animation: fadeUp 0.3s ease both;
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
    </nav>

    <%
        Booking booking = (Booking) request.getAttribute("booking");
        Vehicle vehicle = (Vehicle) request.getAttribute("vehicle");

        // Calculate dynamic rental days & total price
        java.time.LocalDate d1 = java.time.LocalDate.parse(booking.getStartDate());
        java.time.LocalDate d2 = java.time.LocalDate.parse(booking.getEndDate());
        long days = java.time.temporal.ChronoUnit.DAYS.between(d1, d2);
        if (days <= 0) days = 1;
        double total = days * vehicle.getPricePerDay();
    %>

    <main class="container">
        
        <!-- Summary Panel -->
        <div class="summary-panel">
            <div class="panel-tag">Rental Summary</div>
            <h2 class="panel-title" style="font-size: 1.4rem; margin-bottom: 1.2rem;"><%= HtmlUtils.escape(vehicle.getBrand()) %> <span><%= HtmlUtils.escape(vehicle.getType()) %></span></h2>
            
            <div class="summary-item">
                <label>Daily Rate</label>
                <span>LKR <%= vehicle.getPricePerDay() %></span>
            </div>
            <div class="summary-item">
                <label>Rental Duration</label>
                <span><%= days %> <%= days == 1 ? "Day" : "Days" %></span>
            </div>
            <div class="summary-item">
                <label>Start Date</label>
                <span><%= booking.getStartDate() %></span>
            </div>
            <div class="summary-item">
                <label>End Date</label>
                <span><%= booking.getEndDate() %></span>
            </div>

            <div class="total-box">
                <label>Total Amount</label>
                <span>LKR <%= total %></span>
            </div>
        </div>

        <!-- Checkout Form Panel -->
        <div class="checkout-panel">
            <div class="panel-tag">Secure Checkout</div>
            <h1 class="panel-title">Choose Payment Method</h1>

            <!-- Method Selector -->
            <div class="type-selector">
                <div class="selector-btn active" id="btn-card" onclick="selectMethod('card')">
                    <svg viewBox="0 0 24 24"><path d="M20 4H4c-1.11 0-1.99.89-1.99 2L2 18c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V6c0-1.11-.89-2-2-2zm0 14H4v-6h16v6zm0-10H4V6h16v2z"/></svg>
                    <span>Card Payment</span>
                </div>
                <div class="selector-btn" id="btn-cash" onclick="selectMethod('cash')">
                    <svg viewBox="0 0 24 24"><path d="M11.8 10.9c-2.27-.59-3-1.2-3-2.15 0-1.09 1.01-1.85 2.7-1.85 1.78 0 2.44.85 2.5 2.1h2.21c-.07-1.72-1.12-3.3-3.21-3.81V3h-3v2.16c-1.94.42-3.5 1.68-3.5 3.61 0 2.31 1.91 3.46 4.7 4.13 2.5.6 3 1.48 3 2.41 0 .69-.49 1.79-2.7 1.79-2.06 0-2.87-.92-2.98-2.1h-2.2c.12 2.19 1.76 3.42 3.68 3.83V21h3v-2.15c1.95-.37 3.5-1.5 3.5-3.55 0-2.84-2.43-3.81-4.7-4.4z"/></svg>
                    <span>Cash on Pickup</span>
                </div>
            </div>

            <!-- Form -->
            <form action="payment" method="post" id="paymentForm">
                <input type="hidden" name="action" value="process">
                <input type="hidden" name="bookingId" value="<%= booking.getId() %>">
                <input type="hidden" name="amount" value="<%= total %>">
                <input type="hidden" name="paymentType" id="paymentTypeInput" value="card">

                <!-- Card Section -->
                <div class="payment-section active" id="section-card">
                    <div class="form-group">
                        <label for="cardHolder">Cardholder Name</label>
                        <input type="text" id="cardHolder" name="cardHolder" placeholder="e.g. John Doe" required>
                    </div>
                    <div class="form-group">
                        <label for="cardNumber">Card Number</label>
                        <input type="text" id="cardNumber" name="cardNumber" placeholder="1111-2222-3333-4444" pattern="[0-9\- ]{13,19}" required>
                    </div>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                        <div class="form-group">
                            <label>Expiry Date</label>
                            <input type="text" placeholder="MM/YY" pattern="[0-9]{2}/[0-9]{2}">
                        </div>
                        <div class="form-group">
                            <label>CVV</label>
                            <input type="text" placeholder="123" pattern="[0-9]{3}">
                        </div>
                    </div>
                </div>

                <!-- Cash Section -->
                <div class="payment-section" id="section-cash">
                    <div class="form-group">
                        <label for="branchLocation">Select Pickup Branch</label>
                        <select id="branchLocation" name="branchLocation" style="background: var(--surface2); border: 1px solid var(--border); border-radius: 7px; padding: 0.75rem 0.9rem; color: var(--text); width: 100%;">
                            <option value="Colombo Head Office">Colombo Head Office</option>
                            <option value="Kandy City Counter">Kandy City Counter</option>
                            <option value="Galle Coastal Hub">Galle Coastal Hub</option>
                            <option value="Negombo Airport Terminal">Negombo Airport Terminal</option>
                        </select>
                    </div>
                    <div style="background: rgba(240, 165, 0, 0.04); border: 1px dashed rgba(240, 165, 0, 0.2); border-radius: 8px; padding: 1rem; font-size: 0.82rem; color: var(--muted); line-height: 1.4;">
                        📌 <b>Cash on Pickup Selected:</b> Your booking is fully secured. Please make payment to the counter executive at your selected branch during pickup.
                    </div>
                </div>

                <button type="submit" class="btn-pay" id="btn-submit-text">Confirm & Pay LKR <%= total %></button>
            </form>
        </div>

    </main>

    <footer>
        <p>&copy; 2026 DrivePoint Auto Rentals. All rights reserved.</p>
    </footer>

    <script>
        function selectMethod(method) {
            // Update input val
            document.getElementById('paymentTypeInput').value = method;

            // Reset buttons
            document.getElementById('btn-card').classList.remove('active');
            document.getElementById('btn-cash').classList.remove('active');

            // Reset sections
            document.getElementById('section-card').classList.remove('active');
            document.getElementById('section-cash').classList.remove('active');

            // Set active
            if (method === 'card') {
                document.getElementById('btn-card').classList.add('active');
                document.getElementById('section-card').classList.add('active');
                document.getElementById('btn-submit-text').innerText = "Confirm & Pay LKR <%= total %>";
                
                // Set card fields to required
                document.getElementById('cardHolder').setAttribute('required', 'true');
                document.getElementById('cardNumber').setAttribute('required', 'true');
            } else {
                document.getElementById('btn-cash').classList.add('active');
                document.getElementById('section-cash').classList.add('active');
                document.getElementById('btn-submit-text').innerText = "Secure Booking (Cash on Pickup)";
                
                // Remove card required
                document.getElementById('cardHolder').removeAttribute('required');
                document.getElementById('cardNumber').removeAttribute('required');
            }
        }
    </script>
</body>
</html>
