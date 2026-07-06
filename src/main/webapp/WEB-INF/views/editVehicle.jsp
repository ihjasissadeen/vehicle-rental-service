<%@ page import="com.vehiclerental.model.Vehicle" %>
    <%@ page import="java.util.List" %>
        <%@ page import="com.vehiclerental.model.Category" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Edit Vehicle — DrivePoint Auto Rentals</title>
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
                        --border-focus: rgba(240, 165, 0, 0.5);
                        --gold: #f0a500;
                        --text: #f4f0ea;
                        --muted: #7a7672;
                        --danger: #f87171;
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

                    main {
                        flex: 1;
                        display: flex;
                        align-items: flex-start;
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

                    main::after {
                        content: '';
                        position: absolute;
                        inset: 0;
                        background-image:
                            linear-gradient(var(--border) 1px, transparent 1px),
                            linear-gradient(90deg, var(--border) 1px, transparent 1px);
                        background-size: 55px 55px;
                        mask-image: radial-gradient(ellipse 70% 60% at 50% 50%, black 20%, transparent 100%);
                        pointer-events: none;
                    }

                    .card {
                        background: var(--surface);
                        border: 1px solid var(--border);
                        border-radius: 14px;
                        padding: 2.5rem;
                        width: 100%;
                        max-width: 460px;
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

                    .breadcrumb {
                        font-size: 0.78rem;
                        color: var(--muted);
                        margin-bottom: 1.75rem;
                        display: flex;
                        align-items: center;
                        gap: 0.4rem;
                    }

                    .breadcrumb a {
                        color: var(--muted);
                        text-decoration: none;
                        transition: color 0.2s;
                    }

                    .breadcrumb a:hover {
                        color: var(--gold);
                    }

                    .breadcrumb span {
                        opacity: 0.4;
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
                        font-size: 1.75rem;
                        letter-spacing: -0.02em;
                        margin-bottom: 0.4rem;
                    }

                    .card-sub {
                        font-size: 0.83rem;
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

                    input[type="text"],
                    input[type="number"],
                    select {
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
                        appearance: none;
                    }

                    input:focus,
                    select:focus {
                        border-color: var(--border-focus);
                        box-shadow: 0 0 0 3px rgba(240, 165, 0, 0.08);
                    }

                    select {
                        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath d='M2 4l4 4 4-4' stroke='%237a7672' stroke-width='1.5' fill='none' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E");
                        background-repeat: no-repeat;
                        background-position: right 0.9rem center;
                        cursor: pointer;
                    }

                    select option {
                        background: #18181b;
                    }

                    .form-actions {
                        display: flex;
                        gap: 0.75rem;
                        margin-top: 1.75rem;
                    }

                    .btn-save {
                        flex: 1;
                        background: var(--gold);
                        color: #000;
                        border: none;
                        border-radius: 7px;
                        padding: 0.82rem;
                        font-family: 'Outfit', sans-serif;
                        font-size: 0.95rem;
                        font-weight: 500;
                        cursor: pointer;
                        transition: opacity 0.2s, transform 0.15s;
                    }

                    .btn-save:hover {
                        opacity: 0.86;
                        transform: translateY(-1px);
                    }

                    .btn-save:active {
                        transform: translateY(0);
                    }

                    .btn-cancel {
                        background: transparent;
                        color: var(--text);
                        border: 1px solid var(--border);
                        border-radius: 7px;
                        padding: 0.82rem 1.4rem;
                        font-family: 'Outfit', sans-serif;
                        font-size: 0.9rem;
                        cursor: pointer;
                        text-decoration: none;
                        transition: border-color 0.2s;
                        display: inline-flex;
                        align-items: center;
                    }

                    .btn-cancel:hover {
                        border-color: rgba(255, 255, 255, 0.25);
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

                <% Vehicle vehicle=(Vehicle) request.getAttribute("vehicle"); %>

                    <nav>
                        <a href="index.html" class="logo">
                            <span class="logo-mark">
                                <svg viewBox="0 0 14 14" fill="none">
                                    <path d="M4 2.5H7.5C10 2.5 11.5 4.5 11.5 7C11.5 9.5 10 11.5 7.5 11.5H4V2.5Z"
                                        stroke="#000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                                </svg>
                            </span>
                            DrivePoint Auto Rentals
                        </a>
                        <div class="nav-right">
                            <a href="vehicle?action=list">← Vehicle List</a>
                            <a href="adminDashboard.jsp">Dashboard</a>
                        </div>
                    </nav>

                    <main>
                        <div class="card">

                            <div class="breadcrumb">
                                <a href="adminDashboard.jsp">Dashboard</a>
                                <span>/</span>
                                <a href="vehicle?action=list">Vehicles</a>
                                <span>/</span>
                                Edit
                            </div>

                            <div class="card-tag">Fleet Management</div>
                            <h1 class="card-title">Edit Vehicle</h1>
                            <p class="card-sub">Changes will be saved to vehicles.txt.</p>

                            <form action="vehicle" method="post" enctype="multipart/form-data">

                                <!-- Action tells servlet this is an UPDATE request -->
                                <input type="hidden" name="action" value="update">

                                <!-- Vehicle ID to identify which record to update -->
                                <input type="hidden" name="id" value="<%= vehicle.getId() %>">

                                <div class="form-group">
                                    <label for="brand">Brand</label>
                                    <input type="text" id="brand" name="brand" value="<%= vehicle.getBrand() %>"
                                        required />
                                </div>

                                <div class="form-group">
                                    <label for="type">Type (Category)</label>
                                    <select id="type" name="type" required>
                                        <% List<Category> categoriesList = (List<Category>)
                                                request.getAttribute("categories");
                                                if (categoriesList != null && !categoriesList.isEmpty()) {
                                                for (Category c : categoriesList) {
                                                boolean isSel = c.getName().equalsIgnoreCase(vehicle.getType());
                                                %>
                                                <option value="<%= c.getName() %>" <%=isSel ? "selected" : "" %>><%=
                                                        c.getName() %>
                                                </option>
                                                <% } } else { %>
                                                    <option value="Car" <%=vehicle.getType().equals("Car") ? "selected"
                                                        : "" %>>Car</option>
                                                    <option value="Bike" <%=vehicle.getType().equals("Bike")
                                                        ? "selected" : "" %>>Bike</option>
                                                    <option value="Van" <%=vehicle.getType().equals("Van") ? "selected"
                                                        : "" %>>Van</option>
                                                    <% } %>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="pricePerDay">Price Per Day (LKR)</label>
                                    <input type="number" id="pricePerDay" name="pricePerDay" step="0.01" min="0"
                                        value="<%= vehicle.getPricePerDay() %>" required />
                                </div>

                                <hr style="border-color: rgba(255,255,255,0.08); margin: 1.5rem 0;" />
                                <p
                                    style="font-size: 0.8rem; color: var(--gold); margin-bottom: 1rem; text-transform: uppercase; letter-spacing: 0.1em;">
                                    Extra Specifications</p>

                                <div class="form-group">
                                    <label for="fuelType">Fuel Type</label>
                                    <input type="text" id="fuelType" name="fuelType"
                                        value="<%= vehicle.getDetails() != null && vehicle.getDetails().getFuelType() != null ? vehicle.getDetails().getFuelType() : "" %>" />
                                </div>

                                <div class="form-group">
                                    <label for="seatingCapacity">Seating Capacity</label>
                                    <input type="number" id="seatingCapacity" name="seatingCapacity"
                                        value="<%= vehicle.getDetails() != null ? vehicle.getDetails().getSeatingCapacity() : "" %>" />
                                </div>

                                <div class="form-group">
                                    <label for="hasAc">Air Conditioning</label>
                                    <select id="hasAc" name="hasAc">
                                        <option value="true" <%=vehicle.getDetails() !=null &&
                                            vehicle.getDetails().isHasAc() ? "selected" : "" %>>Yes (AC)</option>
                                        <option value="false" <%=vehicle.getDetails() !=null &&
                                            !vehicle.getDetails().isHasAc() ? "selected" : "" %>>No (Non-AC)</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="hasGear">Transmission</label>
                                    <select id="hasGear" name="hasGear">
                                        <option value="true" <%=vehicle.getDetails() !=null &&
                                            vehicle.getDetails().isHasGear() ? "selected" : "" %>>Manual (Gears)
                                        </option>
                                        <option value="false" <%=vehicle.getDetails() !=null &&
                                            !vehicle.getDetails().isHasGear() ? "selected" : "" %>>Auto (No Gears)
                                        </option>
                                    </select>
                                </div>

                                <hr style="border-color: rgba(255,255,255,0.08); margin: 1.5rem 0;" />

                                <div class="form-group">
                                    <label for="available">Availability</label>
                                    <select id="available" name="available">
                                        <option value="true" <%=vehicle.isAvailable() ? "selected" : "" %>>Available
                                        </option>
                                        <option value="false" <%=!vehicle.isAvailable() ? "selected" : "" %>>Not
                                            Available</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="imageFile">Update Vehicle Image (File Upload)</label>
                                    <input type="file" id="imageFile" name="imageFile" accept="image/*"
                                        style="border: 1px solid var(--border); background: var(--surface2); padding: 0.72rem 0.9rem; border-radius: 7px; color: var(--text); width: 100%;" />
                                    <p style="font-size: 0.72rem; color: var(--muted); margin-top: 0.25rem;">Optional:
                                        Upload a new JPG/PNG to replace the current vehicle image.</p>
                                </div>

                                <div class="form-actions">
                                    <button type="submit" class="btn-save">Update Vehicle</button>
                                    <a href="../vehicle?action=list" class="btn-cancel">Cancel</a>
                                </div>

                            </form>
                        </div>
                    </main>

                    <footer>
                        <p>&copy; 2026 DrivePoint Auto Rentals. All rights reserved.</p>
                    </footer>

            </body>

            </html>