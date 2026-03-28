---
published: true
layout: page
title: Make-An-Order - Order Management Service
description: A RESTful service for managing customers and orders with Google OAuth and SMS notifications
img: assets/img/project_makeorder.jpg
importance: 17
category: fun
---

## Overview

**Make-An-Order** is a simple yet functional RESTful service for managing customers and orders implemented in Python. It provides a web interface and comprehensive API endpoints for order management, integrated with Google OAuth 2.0 authentication and Africa's Talking API for SMS notifications.

## Key Features

### User Authentication

- **Google OAuth 2.0** - Secure login with Google accounts
- Session management with Flask
- Protected routes and endpoints

### Customer Management

- **Register customers** - Add new customer records
- **View all customers** - Retrieve complete customer list
- **View specific customer** - Get detailed customer information
- **Update customer details** - Modify existing customer records
- **Delete customers** - Remove customer records

### Order Management

- **Place orders** - Create new orders with customer reference
- **View all orders** - Retrieve complete order history
- **View customer orders** - Get orders specific to a customer
- **Update order details** - Modify existing orders
- **Delete orders** - Remove order records

### SMS Notifications

- **Automatic SMS alerts** - Customers receive SMS when orders are placed
- **Africa's Talking API integration** - Real-time notification delivery
- Customizable sender ID

### Database Integration

- **MySQL database** - Persistent data storage
- **JawsDB on Heroku** - Cloud database for production
- **SQLAlchemy ORM** - Object-relational mapping

## Technology Stack

| Component             | Technology               |
| --------------------- | ------------------------ |
| **Backend Framework** | Flask                    |
| **ORM**               | SQLAlchemy               |
| **Database**          | MySQL (JawsDB on Heroku) |
| **Authentication**    | Google OAuth 2.0         |
| **SMS Gateway**       | Africa's Talking API     |
| **Testing**           | Pytest                   |
| **CI/CD**             | GitHub Actions           |
| **Deployment**        | Heroku                   |
| **Frontend**          | HTML, CSS                |

## API Endpoints

### Authentication

| Method | Endpoint  | Description                 |
| ------ | --------- | --------------------------- |
| GET    | `/login`  | Redirects to Google login   |
| GET    | `/logout` | Logs out authenticated user |

### Customers

| Method | Endpoint                           | Description            |
| ------ | ---------------------------------- | ---------------------- |
| POST   | `/customers/register`              | Create new customer    |
| GET    | `/customers/view_customers`        | Retrieve all customers |
| GET    | `/customers/view_customers/<id>`   | Get specific customer  |
| PUT    | `/customers/update_customers/<id>` | Update customer        |
| DELETE | `/customers/delete_customers/<id>` | Delete customer        |

### Orders

| Method | Endpoint                     | Description           |
| ------ | ---------------------------- | --------------------- |
| POST   | `/orders/place_order`        | Create new order      |
| GET    | `/orders/view_orders`        | Retrieve all orders   |
| GET    | `/orders/view_orders/<id>`   | Get customer's orders |
| PUT    | `/orders/update_orders/<id>` | Update order          |
| DELETE | `/orders/delete_orders/<id>` | Delete order          |

## Getting Started

### Prerequisites

- Python 3.8 or higher
- MySQL database
- Google OAuth 2.0 credentials
- Africa's Talking account

### Installation

```bash
# Clone the repository
git clone https://github.com/Markkimotho/make-an-order.git
cd make-an-order

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Create .env file with configuration
cp .env.example .env
# Edit .env with your credentials
```

### Environment Variables

```env
# Google OAuth
GOOGLE_CLIENT_ID=your_client_id
GOOGLE_CLIENT_SECRET=your_client_secret

# Flask
APP_SECRET_KEY=your_secret_key

# MySQL Database
MYSQL_HOST=localhost
MYSQL_USER=root
MYSQL_PASSWORD=password
MYSQL_DB=customers_orders

# Africa's Talking
AT_USERNAME=your_username
AT_API_KEY=your_api_key
AT_SENDER_ID=your_sender_id
```

### Run Locally

```bash
# Initialize database
flask db upgrade

# Start the application
python app.py
```

Access the app at `http://localhost:5001`

## Testing

The project includes comprehensive test coverage using Pytest:

```bash
# Run all tests
pytest tests/

# Run specific test file
pytest tests/test_customers.py
```

### Test Coverage

- **test_auth.py** - Authentication endpoints
- **test_customers.py** - Customer CRUD operations
- **test_orders.py** - Order CRUD operations
- **test_models.py** - Database models

## Deployment

### Deploy to Heroku

```bash
# Create Heroku app
heroku create your-app-name

# Add JawsDB MySQL add-on
heroku addons:create jawsdb:kitefin

# Set environment variables
heroku config:set GOOGLE_CLIENT_ID=your_id
heroku config:set GOOGLE_CLIENT_SECRET=your_secret
# ... set other variables

# Deploy
git push heroku main
```

### CI/CD with GitHub Actions

Automated testing and deployment on every push to main branch. The workflow:

1. Checks out code
2. Sets up Python environment
3. Installs dependencies
4. Runs test suite
5. Deploys to Heroku on success

**Setup:**

- Add GitHub secrets for all environment variables
- Workflow file: `.github/workflows/deploy.yml`

## Project Structure

```
make-an-order/
├── api/
│   ├── customers.py       # Customer endpoints
│   └── orders.py          # Order endpoints
├── auth/
│   ├── auth_routes.py     # Login/logout routes
│   └── auth_middleware.py # Auth checks
├── services/
│   ├── database_service.py  # DB operations
│   └── sms_service.py       # SMS via Africa's Talking
├── tests/
│   ├── test_auth.py
│   ├── test_customers.py
│   ├── test_orders.py
│   └── test_models.py
├── models.py              # Customer, Order models
├── config.py              # Configuration
├── app.py                 # Main entry point
└── requirements.txt       # Dependencies
```

## Example Usage

### Create a Customer

```bash
curl -X POST http://localhost:5001/customers/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Mike",
    "phone_number": "+254748995315",
    "code": "CUST001"
  }'
```

### Place an Order

```bash
curl -X POST http://localhost:5001/orders/place_order \
  -H "Content-Type: application/json" \
  -d '{
    "customer_id": 1,
    "item": "Laptop",
    "amount": 1200.50
  }'
```

## Features Highlights

- Secure Google OAuth authentication
- RESTful API design for easy integration
- Real-time SMS notifications
- Comprehensive error handling
- Automated testing with Pytest
- CI/CD pipeline with GitHub Actions
- Production-ready Heroku deployment
- Database migrations with Flask-Migrate

## Testing API

[View Postman Collection](https://www.postman.com/) - Import the collection to test all endpoints

## Repository

[View on GitHub](https://github.com/Markkimotho/make-an-order)

---

This project demonstrates full-stack development with authentication, database integration, external API usage, automated testing, and CI/CD practices.
