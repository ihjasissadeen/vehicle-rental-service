<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>DrivePoint Auto Rentals</title>
            <link
                href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=Outfit:wght@300;400;500;600&display=swap"
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
                    --border: rgba(255, 255, 255, 0.08);
                    --gold: #f0a500;
                    --text: #f4f0ea;
                    --muted: #a1a1aa;
                }

                body {
                    background: var(--bg);
                    color: var(--text);
                    font-family: 'Outfit', sans-serif;
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column;
                    line-height: 1.5;
                    -webkit-font-smoothing: antialiased;
                }

                nav {
                    position: sticky;
                    top: 0;
                    z-index: 50;
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    padding: 1.1rem 6%;
                    background: rgba(9, 9, 11, 0.8);
                    backdrop-filter: blur(12px);
                    border-bottom: 1px solid var(--border);
                }

                .logo {
                    font-family: 'Syne', sans-serif;
                    font-weight: 800;
                    font-size: 1.25rem;
                    letter-spacing: -0.02em;
                    color: var(--text);
                    text-decoration: none;
                    display: flex;
                    align-items: center;
                    gap: 0.6rem;
                }

                .logo-mark {
                    width: 30px;
                    height: 30px;
                    background: var(--gold);
                    border-radius: 7px;
                    display: grid;
                    place-items: center;
                }

                .nav-right {
                    display: flex;
                    align-items: center;
                    gap: 1.8rem;
                }

                .nav-right a {
                    text-decoration: none;
                    font-size: 0.9rem;
                    color: var(--muted);
                    font-weight: 400;
                    transition: all 0.2s;
                }

                .nav-right a:hover {
                    color: var(--gold);
                }

                .nav-cta {
                    background: var(--gold) !important;
                    color: #000 !important;
                    padding: 0.6rem 1.4rem;
                    border-radius: 8px;
                    font-weight: 600 !important;
                    transition: transform 0.2s, opacity 0.2s !important;
                }

                .nav-cta:hover {
                    opacity: 0.9 !important;
                    transform: translateY(-1px);
                }

                /* Hero Layout */
                main {
                    flex: 1;
                    display: flex;
                    align-items: center;
                    padding: 4rem 6%;
                    position: relative;
                    overflow: hidden;
                }

                main::before {
                    content: "";
                    position: absolute;
                    top: -10%;
                    left: 50%;
                    transform: translateX(-50%);
                    width: 1000px;
                    height: 600px;
                    background: radial-gradient(circle, rgba(240, 165, 0, 0.08) 0%, transparent 70%);
                    pointer-events: none;
                }

                .hero-container {
                    display: grid;
                    grid-template-columns: 1.1fr 0.9fr;
                    align-items: center;
                    width: 100%;
                    z-index: 2;
                    gap: 4rem;
                }

                .hero-inner {
                    text-align: left;
                }

                .eyebrow {
                    display: inline-flex;
                    align-items: center;
                    gap: 0.6rem;
                    border: 1px solid rgba(240, 165, 0, 0.25);
                    background: rgba(240, 165, 0, 0.05);
                    border-radius: 100px;
                    padding: 0.4rem 1.1rem;
                    font-size: 0.75rem;
                    font-weight: 500;
                    letter-spacing: 0.12em;
                    text-transform: uppercase;
                    color: var(--gold);
                    margin-bottom: 2.5rem;
                    animation: up 0.8s ease both;
                }

                h2 {
                    font-family: 'Syne', sans-serif;
                    font-weight: 800;
                    font-size: clamp(2.8rem, 6vw, 4.5rem);
                    line-height: 1.05;
                    letter-spacing: -0.04em;
                    margin-bottom: 1.5rem;
                    animation: up 0.8s 0.1s ease both;
                }

                h2 span {
                    background: linear-gradient(135deg, #f0a500 0%, #ffcc33 100%);
                    -webkit-background-clip: text;
                    -webkit-text-fill-color: transparent;
                }

                .hero-desc {
                    font-size: 1.15rem;
                    color: var(--muted);
                    font-weight: 300;
                    line-height: 1.6;
                    max-width: 500px;
                    margin-bottom: 3rem;
                    animation: up 0.8s 0.2s ease both;
                }

                .hero-buttons {
                    display: flex;
                    gap: 0.9rem;
                    flex-wrap: wrap;
                    animation: up 0.6s 0.24s ease both;
                }

                .btn-main {
                    background: var(--gold);
                    color: #000;
                    text-decoration: none;
                    padding: 0.85rem 2rem;
                    border-radius: 8px;
                    font-weight: 500;
                    font-size: 0.95rem;
                    transition: opacity 0.2s, transform 0.2s;
                    display: inline-flex;
                    align-items: center;
                    gap: 0.5rem;
                }

                .btn-main:hover {
                    opacity: 0.85;
                    transform: translateY(-2px);
                }

                .btn-outline {
                    background: transparent;
                    color: var(--text);
                    text-decoration: none;
                    padding: 0.85rem 2rem;
                    border-radius: 8px;
                    font-weight: 400;
                    font-size: 0.95rem;
                    border: 1px solid var(--border);
                    transition: border-color 0.2s, transform 0.2s;
                    display: inline-flex;
                    align-items: center;
                    gap: 0.5rem;
                }

                .btn-outline:hover {
                    border-color: rgba(255, 255, 255, 0.25);
                    transform: translateY(-2px);
                }

                /* New Right Showcase Container for the Car Graphic */
                .hero-image-showcase {
                    flex: 1;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    animation: up 0.8s 0.2s ease both;
                }

                .hero-image-showcase img {
                    max-width: 100%;
                    height: auto;
                    object-fit: contain;
                    filter: drop-shadow(0 25px 50px rgba(0, 0, 0, 0.7));
                }

                footer {
                    background: var(--surface);
                    border-top: 1px solid var(--border);
                    text-align: center;
                    padding: 1.4rem;
                    font-size: 0.82rem;
                    color: var(--muted);
                }

                @keyframes up {
                    from {
                        opacity: 0;
                        transform: translateY(20px);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }

                /* Responsive scaling */
                @media (max-width: 900px) {
                    .hero-container {
                        flex-direction: column;
                        text-align: center;
                    }

                    .hero-inner {
                        text-align: center;
                        margin: 0 auto;
                    }

                    .hero-buttons {
                        justify-content: center;
                    }
                }
            </style>
        </head>

        <body>
            <nav>
                <a href="#" class="logo">
                    <span class="logo-mark">
                        <svg viewBox="0 0 14 14" fill="none">
                            <path d="M4 2.5H7.5C10 2.5 11.5 4.5 11.5 7C11.5 9.5 10 11.5 7.5 11.5H4V2.5Z" stroke="#000"
                                stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                        </svg>
                    </span>
                    DrivePoint Auto Rentals
                </a>
                <div class="nav-right">
                    <% String userName=(String) session.getAttribute("userName"); String role=(String)
                        session.getAttribute("role"); if (userName !=null) { %>
                        <span style="font-size: 0.85rem; color: var(--gold);">Welcome, <strong>
                                <%= userName %>
                            </strong></span>
                        <a href="user?action=editProfile">My Profile</a>
                        <a href="user?action=logout" style="color: #ef4444;">Logout</a>
                                <% } else { %>
                                    <a href="login.html">Login</a>
                                    <a href="register.html" class="nav-cta">Sign Up</a>
                                    <% } %>
                </div>
            </nav>

            <main>
                <div class="hero-container">
                    <div class="hero-inner">
                        <div class="eyebrow">Premium Fleet &nbsp; &nbsp; Instant Booking</div>
                        <h2>Find Your <span>Perfect Drive</span></h2>
                        <p class="hero-desc">Discover the perfect ride for your journey, book instantly and drive away.
                        </p>
                        <div class="hero-buttons">
                            <a href="vehicle?action=list" class="btn-main">
                                Browse Vehicles
                                <svg width="15" height="15" viewBox="0 0 15 15" fill="none">
                                    <path d="M3 7.5h9M8.5 3.5l4 4-4 4" stroke="currentColor" stroke-width="1.5"
                                        stroke-linecap="round" stroke-linejoin="round" />
                                </svg>
                            </a>
                            <a href="booking?action=my" class="btn-outline">Manage My Bookings</a>
                        </div>
                    </div>

                    <div class="hero-image-showcase">
                        <img src="BMW.png" alt="Featured BMW Car">
                    </div>
                </div>
            </main>

            <footer>
                <p>&copy; 2026 DrivePoint Auto Rentals. All rights reserved.</p>
            </footer>
        </body>

        </html>