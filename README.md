# Pizza Ordering System

Welcome to the Pizza Ordering System, a fully-fledged platform built with Ruby on Rails that allows customers to place pizza orders, customize their pizzas with toppings, choose sides, and manage their orders efficiently.

## Features

- **Order Creation**: Vendor can create orders with pizzas, sides, and toppings.
- **Restocking**: You can restock pizzas, toppings, and sides to ensure availability.
- **Price Management**: Base prices for pizza sizes (small, medium, large) are configurable.
- **Order Details**: View order status, pizza details, and the total amount.
- **API Endpoints**: RESTful API to interact with the system (Order, Pizza, Topping, Side).
  
The system stores all data in-memory (arrays) for simplicity and ease of testing.

## Technologies Used

- **Ruby on Rails**: Framework for building the API.
- **RSpec**: For unit and controller testing.
- **In-memory storage**: No database is used, data is stored in arrays for simplicity.

## Setup and Installation

### Prerequisites

Ensure that you have the following installed:
- Ruby (version 3.x or higher)
- Rails (version 6.x or higher)
- Bundler

### Installation Steps

1. Clone the repository:

  ```bash
  git clone https://github.com/your-username/pizza-ordering-system.git
  cd pizza-ordering-system
  bundle install
  rails server

Orders
  Create Order: POST /orders
    Request body:
    {
      "order": {
        "pizzas": [
          {
            "id": 1,
            "size": "large",
            "crust": "cheese_burst",
            "base_price": 325,
            "topping_ids": [1, 2]
          }
        ],
        "sides": [
          {
            "id": 1,
            "quantity": 2
          }
        ]
      }
    }

    Response
    {
      "id": 1,
      "status": "pending",
      "pizzas": [
        {
          "id": 1,
          "size": "large",
          "crust": "cheese_burst",
          "base_price": 325,
          "toppings": [
            {
              "id": 1,
              "name": "Cheese"
            },
            {
              "id": 2,
              "name": "Pepperoni"
            }
          ]
        }
      ],
      "sides": [
        {
          "id": 1,
          "name": "Fries",
          "quantity": 2
        }
      ],
      "total_amount": ""
    }

  Show Order: GET /orders/:id
Pizzas
  Create Pizza: POST /pizzas
  Show Pizza: GET /pizzas/:id
  Restock Pizza: POST /pizzas/:id/restock
Toppings
  Create Topping: POST /toppings
  Show Topping: GET /toppings/:id
  Restock Topping: POST /toppings/:id/restock
Sides
  Create Side: POST /sides
  Show Side: GET /sides/:id
  Restock Side: POST /sides/:id/restock