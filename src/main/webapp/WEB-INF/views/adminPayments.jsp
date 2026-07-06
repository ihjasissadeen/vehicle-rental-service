<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.vehiclerental.model.Payment" %>
<%@ page import="com.vehiclerental.model.CardPayment" %>
<%@ page import="com.vehiclerental.model.CashPayment" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Ledger — DrivePoint Auto Rentals</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=Outfit:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --bg: #09090b;
            --surface: #111113;
            --surface2: #18181b;
            --border: rgba(255,255,255,0.08);
            --gold: #f0a500;
            --text: #f4f0ea;
            --muted: #7a7672;
            --danger: #f87171;
            --danger-dim: rgba(248,113,113,0.1);
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
            padding: 3rem 6%;
        }

        .header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 3rem;
            flex-wrap: wrap;
            gap: 1.5rem;
        }

        .title {
            font-family: 'Syne', sans-serif;
            font-size: 2.3rem;
            font-weight: 800;
            letter-spacing: -0.02em;
        }

        .title span { color: var(--gold); }

        .subtitle {
            color: var(--muted);
            font-size: 0.9rem;
            font-weight: 300;
            margin-top: 0.3rem;
        }

        .btn-back {
            background: var(--surface2);
            border: 1px solid var(--border);
            color: var(--text);
            text-decoration: none;
            padding: 0.6rem 1.2rem;
            border-radius: 7px;
            font-size: 0.85rem;
            font-weight: 500;
            transition: all 0.2s;
        }

        .btn-back:hover {
            border-color: var(--gold);
            color: var(--gold);
        }

        .table-container {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            overflow-x: auto;
            position: relative;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            font-size: 0.9rem;
        }

        th {
            background: var(--surface2);
            padding: 1rem 1.5rem;
            font-weight: 500;
            color: var(--gold);
            font-size: 0.78rem;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            border-bottom: 1px solid var(--border);
        }

        td {
            padding: 1.1rem 1.5rem;
            border-bottom: 1px solid var(--border);
            color: var(--text);
        }

        tr:last-of-type td {
            border-bottom: none;
        }

        .badge {
            font-size: 0.72rem;
            font-weight: 600;
            padding: 0.2rem 0.6rem;
            border-radius: 100px;
            display: inline-block;
        }

        .badge-completed { background: var(--green-dim); color: var(--green); border: 1px solid rgba(74,222,128,0.2); }
        .badge-pending { background: rgba(240,165,0,0.08); color: var(--gold); border: 1px solid rgba(240,165,0,0.2); }

        .type-tag {
            font-size: 0.75rem;
            color: var(--muted);
            text-transform: uppercase;
            font-weight: 600;
        }

        .receipt-snippet {
            font-family: monospace;
            font-size: 0.8rem;
            color: var(--muted);
            max-width: 320px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .actions {
            display: flex;
            gap: 0.6rem;
        }

        .btn-action {
            padding: 0.35rem 0.8rem;
            border-radius: 5px;
            font-size: 0.75rem;
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
            border: 1px solid transparent;
            transition: all 0.2s;
        }

        .btn-confirm {
            background: var(--green-dim);
            color: var(--green);
            border-color: rgba(74,222,128,0.2);
        }

        .btn-confirm:hover {
            background: var(--green);
            color: #000;
        }

        .btn-delete {
            background: var(--danger-dim);
            color: var(--danger);
            border-color: rgba(248,113,113,0.2);
        }

        .btn-delete:hover {
            background: var(--danger);
            color: #000;
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--muted);
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(14px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

    <div class="header">
        <div>
            <a href="user?action=dashboard" class="btn-back" style="display: inline-block; margin-bottom: 1rem;">&larr; Back to Dashboard</a>
            <h1 class="title">Payment <span>Ledger</span></h1>
            <p class="subtitle">Monitor active invoices, process counter collections, and track payments.</p>
        </div>
    </div>

    <%
        List<Payment> payments = (List<Payment>) request.getAttribute("payments");

        if (payments != null && !payments.isEmpty()) {
    %>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Booking ID</th>
                    <th>Amount</th>
                    <th>Type</th>
                    <th>Status</th>
                    <th>Transaction Details / Polymorphic Receipt</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (Payment p : payments) {
                        boolean isCompleted = "Completed".equalsIgnoreCase(p.getStatus());
                %>
                    <tr>
                        <td style="font-weight: 600; color: var(--gold);">#<%= p.getId() %></td>
                        <td>#<%= p.getBookingId() %></td>
                        <td style="font-weight: 500;">LKR <%= p.getAmount() %></td>
                        <td class="type-tag"><%= p.getType() %></td>
                        <td>
                            <span class="badge <%= isCompleted ? "badge-completed" : "badge-pending" %>">
                                <%= p.getStatus() %>
                            </span>
                        </td>
                        <td>
                            <div class="receipt-snippet" title="<%= p.generateReceipt() %>">
                                <%= p.generateReceipt() %>
                            </div>
                        </td>
                        <td class="actions">
                            <% if (!isCompleted && "cash".equalsIgnoreCase(p.getType())) { %>
                                <a href="payment?action=confirm&id=<%= p.getId() %>" class="btn-action btn-confirm">Confirm Cash</a>
                            <% } %>
                            <a href="payment?action=delete&id=<%= p.getId() %>" class="btn-action btn-delete" onclick="return confirm('Are you sure you want to void this payment record?');">Void</a>
                        </td>
                    </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>

    <%
        } else {
    %>
        <div class="table-container">
            <div class="empty-state">
                <p>No payments have been processed yet.</p>
            </div>
        </div>
    <%
        }
    %>

</body>
</html>
