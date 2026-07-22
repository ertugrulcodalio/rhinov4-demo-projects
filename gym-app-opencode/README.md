# Gym Management Application

A multi-tenant gym management platform built with Rhino-on-Rails, supporting:

- **Organizations (Gyms)**: Each organization represents a gym
- **Plans**: Membership plans that can be draft, active, or inactive
- **Classes**: Gym classes that can be draft, active, or inactive
- **Trainers**: Trainers associated with gyms
- **Bookings**: Member bookings for classes

## Features

### Customer Route (Members)
- View only active plans and available classes
- Create bookings for classes
- View their own bookings

### Organization Route (Staff)
- Manage plans, classes, trainers
- View and manage all member bookings
- Full CRUD operations

## Multi-Tenant Isolation

The application uses Rhino's organization-based multi-tenancy:
- All data is scoped to organizations
- Users are isolated within their organization
- Tenant-specific routes ensure proper access control

## Roles

- **Owner**: Full access to everything
- **Admin**: Operational admin with full CRUD
- **Trainer**: Can manage their own classes
- **Member**: Can view active content and manage bookings

## Setup

1. Clone the repository
2. Run `bundle install`
3. Run `rails db:create db:migrate`
4. Run `rails rhino:blueprint` to generate models from blueprints
5. Run `rails server`

## Testing

Run the test suite with:
```bash
bundle exec rspec
```

## API Endpoints

### Customer Routes
- `GET /customer/plans` - List active plans
- `GET /customer/classes` - List active classes
- `GET /customer/bookings` - List user's bookings
- `POST /customer/bookings` - Create a booking

### Organization Routes
- `GET /organization/plans` - List all plans
- `POST /organization/plans` - Create a plan
- `GET /organization/classes` - List all classes
- `POST /organization/classes` - Create a class
- `GET /organization/trainers` - List all trainers
- `POST /organization/trainers` - Create a trainer
- `GET /organization/bookings` - List all bookings