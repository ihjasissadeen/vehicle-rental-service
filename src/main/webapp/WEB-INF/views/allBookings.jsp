<%@ page import="java.util.List" %>
<%@ page import="com.vehiclerental.model.Booking" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>All Reservations — Admin Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@800&family=Outfit:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root { --bg: #09090b; --surface: #111113; --gold: #f0a500; --text: #f4f0ea; --muted: #7a7672; --border: rgba(255,255,255,0.08); }
        body { background: var(--bg); color: var(--text); font-family: 'Outfit', sans-serif; padding: 4rem 6%; }
        .container { max-width: 1000px; margin: 0 auto; }
        .header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 3rem; }
        .title { font-family: 'Syne', sans-serif; font-size: 2.2rem; letter-spacing: -0.02em; }
        .title span { color: var(--gold); }
        .btn-back { color: var(--muted); text-decoration: none; font-size: 0.85rem; transition: color 0.2s; }
        .btn-back:hover { color: var(--gold); }
        
        table { width: 100%; border-collapse: collapse; background: var(--surface); border-radius: 12px; overflow: hidden; border: 1px solid var(--border); }
        th { background: rgba(255,255,255,0.02); color: var(--gold); text-transform: uppercase; font-size: 0.7rem; letter-spacing: 0.1em; padding: 1.2rem 1.5rem; text-align: left; }
        td { padding: 1.2rem 1.5rem; border-bottom: 1px solid var(--border); font-size: 0.9rem; }
        tr:last-child td { border-bottom: none; }
        .status-badge { background: rgba(240,165,0,0.1); color: var(--gold); padding: 0.25rem 0.75rem; border-radius: 100px; font-size: 0.75rem; font-weight: 500; border: 1px solid rgba(240,165,0,0.2); }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1 class="title">All <span>Reservations</span></h1>
            <a href="admin?action=dashboard" class="btn-back">&larr; Back to Dashboard</a>
        </div>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Customer ID</th>
                    <th>Vehicle ID</th>
                    <th>Start Date</th>
                    <th>End Date</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
                    if (bookings != null) {
                        for (Booking b : bookings) {
                %>
                <tr>
                    <td style="color: var(--muted); font-family: monospace;">#<%= b.getId() %></td>
                    <td><%= b.getUserId() %></td>
                    <td><%= b.getVehicleId() %></td>
                    <td><%= b.getStartDate() %></td>
                    <td><%= b.getEndDate() %></td>
                    <td><span class="status-badge"><%= b.getStatus() %></span></td>
                </tr>
                <%
                        }
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>