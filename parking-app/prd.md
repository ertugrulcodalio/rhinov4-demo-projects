# Parking App — Product Requirements Document

## Overview

A multi-tenant parking management application built on Rhino V4 (Rails API + React frontend). Organizations manage parking lots, spots, vehicles, and reservations.

## Models

### ParkingLot
- `name` (string, required) — lot name, e.g. "Downtown Garage A"
- `address` (string, required)
- `total_spots` (integer, required)
- `organization_id` (foreign key)

### ParkingSpot
- `number` (string, required) — spot identifier, e.g. "A1", "B12"
- `spot_type` (string) — values: "standard", "compact", "handicapped", "ev_charging" (default: "standard")
- `is_available` (boolean, default: true)
- `parking_lot_id` (foreign key)

### Vehicle
- `license_plate` (string, required, unique per org)
- `make` (string) — e.g. "Toyota"
- `model` (string) — e.g. "Camry"
- `color` (string)
- `vehicle_type` (string) — "car", "motorcycle", "truck" (default: "car")
- `user_id` (foreign key — owner)
- `organization_id` (foreign key)

### Reservation
- `start_time` (datetime, required)
- `end_time` (datetime, required)
- `status` (string) — "pending", "active", "completed", "cancelled" (default: "pending")
- `total_cost` (decimal)
- `notes` (text)
- `vehicle_id` (foreign key)
- `parking_spot_id` (foreign key)
- `user_id` (foreign key — who made the reservation)

## Relationships
- Organization has many ParkingLots, Vehicles
- ParkingLot has many ParkingSpots
- ParkingSpot has many Reservations
- Vehicle has many Reservations
- User has many Vehicles, Reservations

## Roles & Permissions

### admin
- Full access to all models (CRUD)

### manager
- ParkingLot: index, show, update
- ParkingSpot: index, show, store, update
- Vehicle: index, show
- Reservation: index, show, store, update

### member
- Vehicle: index, show, store, update (own vehicles only)
- Reservation: index, show, store (own reservations only)
- ParkingLot: index, show
- ParkingSpot: index, show

## API Behavior
- All endpoints under tenant route group: `/api/:organization/...`
- ParkingSpot availability updates when a Reservation goes active/completed/cancelled
- Reservations filterable by status, start_time, vehicle_id, parking_spot_id

## Acceptance Criteria
- [ ] ParkingLot CRUD works for admin and manager
- [ ] ParkingSpot CRUD works; `is_available` reflects active reservations
- [ ] Vehicle CRUD works; members can only manage their own vehicles
- [ ] Reservation lifecycle: pending → active → completed or cancelled
- [ ] All endpoints return correct 403 for unauthorized roles
- [ ] RSpec request specs cover happy path + 403 + 404 per model
- [ ] React frontend: list and detail views for ParkingLots, ParkingSpots, Vehicles, Reservations
- [ ] Frontend connects to Rails API via Vite proxy at `/api`
- [ ] Login flow works; organization slug routing works
