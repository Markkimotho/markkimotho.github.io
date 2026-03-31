---
published: true
layout: page
title: Make-An-Order
description: Point of sale system for managing orders, inventory, and customers
img: assets/img/project_makeorder.jpg
importance: 17
category: projects
---

## Overview

Make-An-Order is a point of sale system built with Flask and MySQL. Staff can manage orders and inventory. Customers can browse and place orders. Orders trigger SMS notifications.

The system handles three types of users: superuser (godmode), admin (run the business), and operators (use the register). Separate from that, there's a customer system for buyers. This separation keeps staff accounts out of customer analytics and order data clean.

## Core Features

**Orders**

- Admins place orders on behalf of customers
- Customers place orders through a web interface with code/email lookup
- Orders tracked with status: pending, confirmed, completed, cancelled, refunded
- SMS notification sent to customer phone when order placed
- Each order gets a receipt

**Inventory**

- Add products with name, SKU, category, price, quantity
- Stock decreases automatically when orders placed
- Can restock items manually
- Cancelled or refunded orders restore stock
- Every stock change is logged (what, why, who, when)

**Customers**

- Admin creates customer records with name, phone, unique code
- Customers lookup by code or email to place orders
- Complete order history per customer
- Phone number used for SMS notifications

**Staff Management**

- Google OAuth login for staff
- Three roles: superuser, admin, operator
- Superuser: create/delete users, manage roles
- Admin: manage customers, inventory, orders, see analytics
- Operator: place orders, view history

**Reports & Analytics**

- Revenue over time
- Top selling products
- Payment method breakdown
- Order status distribution
- Filter by date range
- Download reports as CSV

## Technology

| Component | Tech                            |
| --------- | ------------------------------- |
| Backend   | Flask 3.0                       |
| Database  | MySQL 5.7+                      |
| ORM       | SQLAlchemy 2.0                  |
| Auth      | Google OAuth 2.0                |
| SMS       | Africa's Talking API            |
| Frontend  | Bootstrap 5.3, Jinja2, Chart.js |
| Hosting   | Render, Heroku                  |

## Setup

**Prerequisites**

- Python 3.8+
- MySQL running locally or on a server
- Google OAuth credentials
- Africa's Talking account (optional)

**Install**

```bash
git clone https://github.com/Markkimotho/make-an-order.git
cd make-an-order
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

**Configure .env**

```
APP_URL=http://localhost:5001
APP_SECRET_KEY=your-secret-key

GOOGLE_CLIENT_ID=your-id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your-secret

MYSQL_HOST=127.0.0.1
MYSQL_USER=root
MYSQL_PASSWORD=your-password
MYSQL_DB=customers_orders

AT_USERNAME=sandbox
AT_API_KEY=your-key
AT_SENDER_ID=your-sender-id
```

**Important:** Add `http://localhost:5001/auth/authorize` to Google Console OAuth Authorized redirect URIs.

**Run**

```bash
python3 app.py
```

Visit `http://localhost:5001`

## API Endpoints

### Auth (`/auth`)

- `GET /auth/login` — Start Google OAuth
- `GET /auth/authorize` — OAuth callback
- `POST /auth/login/local` — Email/password
- `POST /auth/customer-login` — Customer lookup
- `GET /auth/logout` — End session

### Inventory (`/inventory`)

- `GET /api/inventory` — Get all products
- `POST /api/inventory` — Create product (admin+)
- `PUT /api/inventory/<id>` — Edit product (admin+)
- `DELETE /api/inventory/<id>` — Delete product (superuser+)
- `GET /api/inventory/search?q=term` — Search
- `POST /api/inventory/restock` — Add stock (admin+)
- `GET /api/inventory/audit-trail` — Stock history

### Orders (`/orders`)

- `POST /api/orders/place_order` — Create order
- `GET /api/orders/view_orders` — Get all (admin+)
- `GET /api/orders/<id>` — Get order
- `PUT /api/orders/<id>` — Update status (admin+)
- `DELETE /api/orders/<id>` — Delete (admin+)
- `GET /api/orders/<id>/receipt` — Generate receipt
- `GET /api/orders/export/csv` — Download CSV

### Customers (`/customers`)

- `POST /api/customers/register` — Create (admin+)
- `GET /api/customers` — Get all (admin+)
- `GET /api/customers/<id>` — Get customer
- `PUT /api/customers/<id>` — Edit (admin+)
- `DELETE /api/customers/<id>` — Delete (superuser+)

### Users (`/users`)

- `GET /api/users` — Get all (superuser+)
- `PUT /api/users/<id>/role` — Change role (superuser+)
- `PUT /api/users/<id>/customer` — Link to customer (superuser+)
- `DELETE /api/users/<id>` — Delete (superuser+)

### Reports (`/reports`)

- `GET /api/reports/revenue` — Revenue by date
- `GET /api/reports/top-products` — Top sellers
- `GET /api/reports/payment-breakdown` — By payment type
- `GET /api/reports/order-status` — Status distribution

## Database Schema

**users** — Staff accounts

- id, email, name, picture_url, role, customer_id, created_at

**customers** — Buyer records

- id, code, name, phone_number, email, created_at

**inventory** — Products

- id, name, sku, category, description, price, quantity, reorder_level

**orders** — Transactions

- id, customer_id, total_amount, status, payment_method, payment_reference, created_at

**order_items** — Line items

- id, order_id, inventory_id, quantity, unit_price, subtotal

**stock_movements** — Audit trail

- id, inventory_id, movement_type, quantity_changed, reason, created_by, created_at

## Deployments

### Render

1. Push to GitHub
2. Create Web Service from repo
3. Set environment variables (same as .env)
4. Add database URL to environment
5. Deploy

Add to Google Console OAuth: `https://your-render-url.com/auth/authorize`

### Heroku

1. `heroku addons:create jawsdb:kitefin`
2. `git push heroku main`
3. `heroku config:set APP_URL=https://your-app.herokuapp.com ...`

Add to Google Console OAuth: `https://your-app.herokuapp.com/auth/authorize`

## Project Structure

```
make-an-order/
├── api/
│   ├── customers.py
│   ├── inventory.py
│   ├── orders.py
│   ├── reports.py
│   └── users.py
├── auth/
│   └── auth_routes.py
├── services/
│   ├── seed_service.py
│   └── sms_service.py
├── templates/
│   ├── landing.html
│   ├── role_select.html
│   ├── index.html
│   ├── base.html
│   ├── inventory.html
│   ├── customers.html
│   ├── orders.html
│   ├── reports.html
│   └── receipts.html
├── static/
│   └── style.css
├── models.py
├── config.py
├── app.py
└── requirements.txt
```

## Architecture Notes

**Users vs Customers**

Staff login with Google OAuth and get a User account with a role. Customers are separate records with a phone number and unique code. This keeps staff out of customer lists and prevents confusion about who actually bought something.

**Role-Based UI**

The inventory page (checkout interface) looks different for admins, operators, and customers. Admins see a customer selector dropdown. Operators see just a place order button. Everything is validated at the API level too.

**Stock Audit Trail**

Every inventory change gets logged with timestamp, operator ID, quantity change, and reason. This means you can trace any discrepancy back to who changed it and why.

**OAuth Configuration**

The app takes APP_URL as an environment variable. It builds the redirect URI from that and registers it with Google. This prevents redirect_uri_mismatch errors when deploying to different environments.

**SMS Handling**

Africa's Talking integration is wrapped in try/catch. If SMS fails, the order still goes through. SMS is optional.

## Testing

```bash
pytest tests/
pytest tests/test_orders.py -v
pytest --cov=api tests/
```

## Limitations

- SMS only via Africa's Talking
- No built-in payment processing (external reference supported)
- No inventory forecasting yet
- No multi-location support yet

## Contributing

Issues and PRs welcome on [GitHub](https://github.com/Markkimotho/make-an-order).

---

**Updated:** March 31, 2026
