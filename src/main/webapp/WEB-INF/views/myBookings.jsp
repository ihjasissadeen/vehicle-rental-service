<%@ page import="java.util.List" %>
    <%@ page import="com.vehiclerental.model.Booking" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>My Bookings — DrivePoint Auto Rentals</title>
            <link
                href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=Outfit:wght@300;400;500&display=swap"
                rel="stylesheet">
            <style>
                *,
                *::before,
                *::after {
                    box-sizing: border-box;
                    margin: 0;
                    padding: 0;
                }

                :root {
                    --bg: #09090b;
                    --surface: #111113;
                    --surface2: #18181b;
                    --border: rgba(255, 255, 255, 0.08);
                    --gold: #f0a500;
                    --text: #f4f0ea;
                    --muted: #7a7672;
                    --danger: #f87171;
                    --danger-dim: rgba(248, 113, 113, 0.1);
                    --green: #4ade80;
                    --green-dim: rgba(74, 222, 128, 0.1);
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
                    background: rgba(9, 9, 11, 0.9);
                    position: sticky;
                    top: 0;
                    z-index: 50;
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
                    font-size: 0.75rem;
                    letter-spacing: 0.15em;
                    text-transform: uppercase;
                    color: var(--gold);
                    margin-bottom: 0.5rem;
                }

                h2 {
                    font-family: 'Syne', sans-serif;
                    font-weight: 800;
                    font-size: clamp(2.2rem, 5vw, 3rem);
                    line-height: 1.1;
                    letter-spacing: -0.03em;
                }

                h2 span {
                    color: var(--gold);
                }

                .btn-new {
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

                .btn-new:hover {
                    opacity: 0.85;
                }

                .cards-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                    gap: 1.25rem;
                }

                /* .card matches original class name */
                .card {
                    background: #111113;
                    border: 1px solid rgba(255, 255, 255, 0.08);
                    padding: 1.5rem;
                    border-radius: 8px;
                    transition: border-color 0.2s;
                }

                .card:hover {
                    border-color: rgba(240, 165, 0, 0.2);
                }

                .card-top {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    margin-bottom: 1.1rem;
                    padding-bottom: 0.9rem;
                    border-bottom: 1px solid var(--border);
                }

                .card-id {
                    font-size: 0.75rem;
                    color: var(--muted);
                    font-family: monospace;
                }

                /* span matches original — gold colour */
                span.status {
                    font-size: 0.7rem;
                    letter-spacing: 0.06em;
                    font-weight: 500;
                    padding: 0.2rem 0.65rem;
                    border-radius: 100px;
                }

                .status-active {
                    background: var(--green-dim);
                    color: var(--green);
                    border: 1px solid rgba(74, 222, 128, 0.2);
                }

                .status-cancelled {
                    background: var(--danger-dim);
                    color: var(--danger);
                    border: 1px solid rgba(248, 113, 113, 0.2);
                }

                .status-default {
                    background: rgba(240, 165, 0, 0.1);
                    color: var(--gold);
                    border: 1px solid rgba(240, 165, 0, 0.2);
                }

                .card p {
                    font-size: 0.88rem;
                    padding: 0.45rem 0;
                    border-bottom: 1px solid var(--border);
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .card p:last-of-type {
                    border-bottom: none;
                }

                .card p b {
                    font-size: 0.72rem;
                    letter-spacing: 0.08em;
                    text-transform: uppercase;
                    color: var(--muted);
                    font-weight: 400;
                }

                .empty-state {
                    text-align: center;
                    padding: 5rem 2rem;
                    color: var(--muted);
                }

                .empty-state p {
                    margin-bottom: 1.5rem;
                    font-size: 0.95rem;
                }

                footer {
                    background: var(--surface);
                    border-top: 1px solid var(--border);
                    text-align: center;
                    padding: 1.2rem;
                    font-size: 0.78rem;
                    color: var(--muted);
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
                    <a href="vehicle?action=list">Browse Fleet</a>
                    <a href="user?action=logout" style="color: var(--danger);">Logout</a>
                </div>
            </nav>

            <div class="container">
                <div class="page-header">
                    <div>
                        <div class="page-tag">Customer Portal</div>
                        <h2>My <span>Bookings</span></h2>
                    </div>
                    <a href="booking.jsp" class="btn-new">+ New Booking</a>
                </div>

                <% List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");

                        if (bookings != null && !bookings.isEmpty()) {
                        %>

                        <div class="cards-grid">
                            <% for (Booking b : bookings) { String status=b.getStatus(); String
                                statusClass="status-default" ; if ("active".equals(status)) statusClass="status-active"
                                ; if ("cancelled".equals(status)) statusClass="status-cancelled" ; %>
                                <div class="card">
                                    <div class="card-top">
                                        <span class="card-id">#<%= b.getId() %></span>
                                        <span class="status <%= statusClass %>">
                                            <%= b.getStatus() %>
                                        </span>
                                    </div>
                                    <p><b>Booking ID:</b>
                                        <%= b.getId() %>
                                    </p>
                                    <% com.vehiclerental.model.Vehicle v=null; try { v=new
                                        com.vehiclerental.service.VehicleService().getVehicleById(b.getVehicleId()); }
                                        catch(Exception e) {} String vehicleName=(v !=null) ? v.getBrand() + " " +
                                        v.getType() : "Vehicle #" + b.getVehicleId(); %>
                                        <p><b>Vehicle Name:</b>
                                            <%= vehicleName %>
                                        </p>
                                        <p><b>Start Date:</b>
                                            <%= b.getStartDate() %>
                                        </p>
                                        <p><b>End Date:</b>
                                            <%= b.getEndDate() %>
                                        </p>
                                        <% com.vehiclerental.model.Payment paymentObj=null; try { paymentObj=new
                                            com.vehiclerental.service.PaymentService().getPaymentByBookingId(b.getId());
                                            } catch(Exception e) {} String payStatusText="Unpaid" ; String
                                            payStatusClass="status-cancelled" ; if (paymentObj !=null) { if
                                            ("Completed".equalsIgnoreCase(paymentObj.getStatus())) {
                                            payStatusText="Paid (Completed)" ; payStatusClass="status-active" ; } else {
                                            payStatusText="Pending Cash Pickup" ; payStatusClass="status-default" ; } }
                                            %>
                                            <p><b>Payment Status:</b> <span class="status <%= payStatusClass %>"
                                                    style="font-size: 0.68rem; padding: 0.15rem 0.55rem; border-radius: 4px; display: inline-block; letter-spacing: normal; text-transform: none;">
                                                    <%= payStatusText %>
                                                </span></p>

                                            <% if ("pending".equals(b.getStatus()) || "active" .equals(b.getStatus())) {
                                                %>
                                                <a href="payment?action=checkout&bookingId=<%= b.getId() %>"
                                                    style="display: block; text-align: center; margin-top: 1rem; padding: 0.6rem; background: var(--gold); color: #000; text-decoration: none; border-radius: 5px; font-size: 0.85rem; font-weight: 600; transition: opacity 0.2s;"
                                                    onmouseover="this.style.opacity='0.85'"
                                                    onmouseout="this.style.opacity='1'">
                                                    <%= "active" .equals(b.getStatus()) ? "View Invoice / Receipt"
                                                        : "Pay / View Invoice" %>
                                                </a>

                                                <a href="booking?action=delete&id=<%= b.getId() %>"
                                                    style="display: block; text-align: center; margin-top: 0.5rem; padding: 0.6rem; border: 1px solid rgba(248,113,113,0.3); color: #f87171; text-decoration: none; border-radius: 5px; font-size: 0.85rem; transition: background 0.2s;"
                                                    onmouseover="this.style.background='rgba(248,113,113,0.1)'"
                                                    onmouseout="this.style.background='transparent'"
                                                    onclick="return confirm('Are you sure you want to cancel this booking?');">
                                                    Cancel Reservation
                                                </a>
                                                <% } %>

                                </div>
                                <% } %>
                        </div>

                        <% } else { %>
                            <div class="empty-state">
                                <p>You have no bookings yet.</p>
                                <a href="booking.jsp" class="btn-new">Book a Vehicle</a>
                            </div>
                            <% } %>
            </div>

            <footer>
                <p>&copy; 2026 DrivePoint Auto Rentals. All rights reserved.</p>
            </footer>

        </body>

        </html>