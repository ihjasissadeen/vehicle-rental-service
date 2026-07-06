<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vehiclerental.model.Payment" %>
<%@ page import="com.vehiclerental.model.Booking" %>
<%@ page import="com.vehiclerental.model.Vehicle" %>
<%@ page import="com.vehiclerental.util.HtmlUtils" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoice Receipt — DrivePoint Auto Rentals</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=Outfit:wght@300;400;500;600&display=swap" rel="stylesheet">
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
            --green: #4ade80;
            --green-dim: rgba(74,222,128,0.1);
        }

        body {
            background: var(--bg);
            color: var(--text);
            font-family: 'Outfit', sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 2rem 1.5rem;
        }

        .receipt-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 3rem;
            width: 100%;
            max-width: 520px;
            position: relative;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
            animation: fadeUp 0.5s ease both;
        }

        .receipt-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 12%;
            right: 12%;
            height: 1px;
            background: linear-gradient(90deg, transparent, var(--gold), transparent);
        }

        .logo-block {
            text-align: center;
            margin-bottom: 2rem;
        }

        .logo-mark {
            width: 32px;
            height: 32px;
            background: var(--gold);
            border-radius: 6px;
            display: inline-grid;
            place-items: center;
            margin-bottom: 0.5rem;
        }

        .logo-mark svg {
            width: 16px;
            height: 16px;
        }

        .company-name {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 1.15rem;
            letter-spacing: -0.01em;
        }

        .receipt-header {
            text-align: center;
            margin-bottom: 2.5rem;
            border-bottom: 1px dashed var(--border);
            padding-bottom: 1.5rem;
        }

        .receipt-title {
            font-family: 'Syne', sans-serif;
            font-size: 1.6rem;
            font-weight: 800;
            letter-spacing: -0.02em;
            margin-bottom: 0.25rem;
        }

        .receipt-status {
            display: inline-block;
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            font-weight: 600;
            padding: 0.2rem 0.7rem;
            border-radius: 100px;
            background: var(--green-dim);
            color: var(--green);
            border: 1px solid rgba(74, 222, 128, 0.2);
            margin-top: 0.5rem;
        }

        .status-pending {
            background: rgba(240, 165, 0, 0.08);
            color: var(--gold);
            border: 1px solid rgba(240, 165, 0, 0.2);
        }

        .receipt-row {
            display: flex;
            justify-content: space-between;
            padding: 0.7rem 0;
            border-bottom: 1px solid var(--border);
            font-size: 0.88rem;
        }

        .receipt-row:last-of-type {
            border-bottom: none;
        }

        .receipt-row label {
            color: var(--muted);
        }

        .receipt-row span {
            font-weight: 500;
        }

        .polymorphic-output {
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 1.1rem;
            margin-top: 2rem;
            border-left: 3px solid var(--gold);
            font-size: 0.83rem;
            line-height: 1.55;
            color: var(--text);
        }

        .polymorphic-header {
            font-size: 0.65rem;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--gold);
            margin-bottom: 0.35rem;
            font-weight: 600;
        }

        .action-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-top: 2.5rem;
        }

        .btn {
            background: var(--surface2);
            border: 1px solid var(--border);
            color: var(--text);
            border-radius: 7px;
            padding: 0.75rem;
            font-family: 'Outfit', sans-serif;
            font-size: 0.85rem;
            font-weight: 500;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
            transition: all 0.2s;
        }

        .btn:hover {
            border-color: var(--gold);
            color: var(--gold);
        }

        .btn-primary {
            background: var(--gold);
            color: #000;
            border: none;
        }

        .btn-primary:hover {
            opacity: 0.9;
            color: #000;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(16px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

    <%
        Payment payment = (Payment) request.getAttribute("payment");
        Booking booking = (Booking) request.getAttribute("booking");
        Vehicle vehicle = (Vehicle) request.getAttribute("vehicle");
        boolean isPending = "Pending".equalsIgnoreCase(payment.getStatus());
    %>

    <div class="receipt-card">
        
        <!-- Logo Block -->
        <div class="logo-block">
            <span class="logo-mark">
                <svg viewBox="0 0 14 14" fill="none">
                    <path d="M4 2.5H7.5C10 2.5 11.5 4.5 11.5 7C11.5 9.5 10 11.5 7.5 11.5H4V2.5Z" stroke="#000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
            </span>
            <div class="company-name">DrivePoint Auto Rentals</div>
        </div>

        <!-- Receipt Header -->
        <div class="receipt-header">
            <div class="receipt-title">Payment Receipt</div>
            <span class="receipt-status <%= isPending ? "status-pending" : "" %>">
                <%= payment.getStatus() %>
            </span>
        </div>

        <!-- Details -->
        <div class="receipt-row">
            <label>Payment ID</label>
            <span>#<%= payment.getId() %></span>
        </div>
        <div class="receipt-row">
            <label>Booking ID</label>
            <span>#<%= booking.getId() %></span>
        </div>
        <div class="receipt-row">
            <label>Vehicle Brand</label>
            <span><%= HtmlUtils.escape(vehicle.getBrand()) %></span>
        </div>
        <div class="receipt-row">
            <label>Date Processed</label>
            <span><%= payment.getDate() %></span>
        </div>
        <div class="receipt-row" style="border-top: 1px solid var(--border); padding-top: 1rem; margin-top: 0.5rem;">
            <label style="font-weight: 500; color: var(--gold);">Amount Paid</label>
            <span style="font-family: 'Syne', sans-serif; font-size: 1.15rem; font-weight: 800; color: var(--text);">LKR <%= payment.getAmount() %></span>
        </div>

        <!-- Polymorphic Output Showcase Box (Viva highlight!) -->
        <div class="polymorphic-output">
            <div class="polymorphic-header">Polymorphic generateReceipt() Output</div>
            <%= payment.generateReceipt() %>
        </div>

        <!-- Actions -->
        <div class="action-row">
            <a href="booking?action=my" class="btn btn-primary">My Bookings</a>
            <button onclick="window.print()" class="btn">Print Invoice</button>
        </div>

    </div>

</body>
</html>
