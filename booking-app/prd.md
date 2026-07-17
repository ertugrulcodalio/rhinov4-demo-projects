# Product Requirement Document (PRD) - BookEase

## 1. Overview
**BookEase** is a hybrid booking platform built on the Rhino V4 Rails API framework. Service businesses (barbershops, clinics, etc.) manage their services, staff, and availability through an organization-scoped multi-tenant API, while customers browse active services and available time slots and create bookings through a single-tenant public route. The key architectural choice is a hybrid tenancy model: one route group for organization staff and one for public customers, ensuring strict data isolation and role-based visibility.

## 2. Problem Statement
Service businesses need to manage their offerings privately (drafts, inactive services) without exposing incomplete or unavailable options to customers. Customers need a clean, scoped view of only what is bookable. BookEase enforces role-based visibility at the API layer: draft and inactive services are invisible to customers, and every booking is scoped exclusively to its owner.

## 3. Target Users & Roles

| Role | Description |
|------|-------------|
| `owner` | Full access to everything including billing and user management |
| `admin` | Operational admin. Full CRUD on all resources |
| `staff` | Can manage availability and update booking status, cannot delete services |
| `customer` | Can browse active services and time slots, create and manage own bookings |

## 4. Tenancy Classification

**Classification:** `hybrid`

**Rationale:** Organizations are shared workspaces where multiple staff members manage the same services and availability (multi-tenant), while customers act exclusively on their own bookings and see only public catalog data (single-tenant).

**Route groups:**
- `/api/:organization/...` — multi-tenant organization route for staff management
- `/api/customer/...` — single-tenant customer route scoped to current user

**Middleware:** `ResolveOrganizationFromRoute` applies on the organization route group only.

**Record scoping:**
- `services`, `staff_members`, `time_slots` — scoped by `organization_id`
- `bookings` — scoped by `organization_id` on staff route; scoped to `current_user` on customer route

## 5. Key Features

1. **Hybrid Tenancy** — Two co-existing Rhino route groups: multi-tenant for staff (`/api/:organization/`) and single-tenant for customers (`/api/customer/`)
2. **Service Management** — Staff create and manage services with a `status` field (`active` / `draft` / `inactive`). Only active services are visible to customers.
3. **Staff Members** — Organizations manage their staff roster. Staff members are org-scoped and not visible on the customer route.
4. **Time Slot Management** — Staff create available time slots linked to a service and optionally a staff member. Slots have a `available` boolean. Only available slots are visible to customers.
5. **Customer Booking** — Customers browse active services and available time slots, then create bookings referencing a time slot. A booking marks the slot as unavailable.
6. **Booking Lifecycle** — Bookings progress through states (`pending → confirmed → completed → cancelled`). Staff can update any booking status. Customers can only cancel their own `pending` bookings.
7. **Cross-Tenant Isolation** — The organization route enforces `organization_id` scoping on all owned models. The customer route enforces `current_user` scoping on bookings. Neither side can access the other's private data.
8. **Draft/Inactive Hiding** — A `ServiceScope` filters services to `status: active` on the customer route. A `TimeSlotScope` filters to `available: true` on the customer route. Staff see everything.

## 6. Data Model

> Validation placement note: presence requirements are enforced in policies; model validations are format/type only with `allow_nil: true` (Rhino V4 convention).

### Model: `services`
A bookable service offered by the organization (e.g. "Haircut", "Consultation").

| Column | Type | Notes |
|--------|------|-------|
| `id` | integer | primary key |
| `organization_id` | integer | FK to organizations, non-nullable |
| `name` | string | non-nullable, max 255 chars |
| `description` | text | nullable |
| `duration_minutes` | integer | nullable |
| `price` | decimal(10,2) | nullable |
| `status` | string | default: `draft`, values: active/draft/inactive |
| `created_at` | datetime | |
| `updated_at` | datetime | |

Relationships: `belongs_to :organization`, `has_many :time_slots`

### Model: `staff_members`
A staff member belonging to an organization.

| Column | Type | Notes |
|--------|------|-------|
| `id` | integer | primary key |
| `organization_id` | integer | FK to organizations, non-nullable |
| `name` | string | non-nullable, max 255 chars |
| `email` | string | nullable |
| `role_title` | string | nullable |
| `created_at` | datetime | |
| `updated_at` | datetime | |

Relationships: `belongs_to :organization`, `has_many :time_slots`

### Model: `time_slots`
An available time slot for a service, optionally assigned to a staff member.

| Column | Type | Notes |
|--------|------|-------|
| `id` | integer | primary key |
| `service_id` | integer | FK to services, non-nullable |
| `staff_member_id` | integer | FK to staff_members, nullable |
| `starts_at` | datetime | non-nullable |
| `ends_at` | datetime | non-nullable |
| `available` | boolean | default: true |
| `created_at` | datetime | |
| `updated_at` | datetime | |

Relationships: `belongs_to :service`, `belongs_to :staff_member (optional)`, `has_one :booking`

### Model: `bookings`
A customer's booking for a time slot.

| Column | Type | Notes |
|--------|------|-------|
| `id` | integer | primary key |
| `organization_id` | integer | FK to organizations, non-nullable |
| `user_id` | integer | FK to users, non-nullable |
| `time_slot_id` | integer | FK to time_slots, non-nullable |
| `status` | string | default: `pending`, values: pending/confirmed/completed/cancelled |
| `notes` | text | nullable |
| `created_at` | datetime | |
| `updated_at` | datetime | |

Relationships: `belongs_to :organization`, `belongs_to :user`, `belongs_to :time_slot`

## 7. Permissions Matrix

### Services
| Role | index | show | create | update | destroy |
|------|-------|------|--------|--------|---------|
| admin | ✅ all | ✅ all fields | ✅ | ✅ all fields | ✅ |
| staff | ✅ all | ✅ all fields | ✅ | ✅ (no status) | ❌ |
| customer (customer route) | ✅ active only | ✅ public fields | ❌ | ❌ | ❌ |

### Staff Members
| Role | index | show | create | update | destroy |
|------|-------|------|--------|--------|---------|
| admin | ✅ | ✅ | ✅ | ✅ | ✅ |
| staff | ✅ | ✅ | ❌ | ❌ | ❌ |
| customer | ❌ not exposed | — | — | — | — |

### Time Slots
| Role | index | show | create | update | destroy |
|------|-------|------|--------|--------|---------|
| admin | ✅ all | ✅ | ✅ | ✅ | ✅ |
| staff | ✅ all | ✅ | ✅ | ✅ | ❌ |
| customer (customer route) | ✅ available only | ✅ public fields | ❌ | ❌ | ❌ |

### Bookings
| Role | index | show | create | update | destroy |
|------|-------|------|--------|--------|---------|
| admin | ✅ all org bookings | ✅ | ❌ | ✅ (status) | ✅ |
| staff | ✅ all org bookings | ✅ | ❌ | ✅ (status) | ❌ |
| customer (customer route) | ✅ own only | ✅ own only | ✅ | ✅ (cancel own pending) | ✅ own |

## 8. Auto-Scopes Required

| Scope Class | Tenant Route | Customer Route |
|-------------|-------------|----------------|
| `Scopes::ServiceScope` | pass through (org filter by BelongsToOrganization) | filter to `status: active` from customer's org |
| `Scopes::TimeSlotScope` | pass through | filter to `available: true` from customer's org (via service → org chain) |
| `Scopes::BookingScope` | pass through | filter to `user_id: current_user.id` |

## 9. Test Requirements

Tests must be exhaustive and cover:

1. **Cross-tenant isolation** — org A staff cannot see, update, or delete org B's services, time slots, staff members, or bookings (404 not 403)
2. **Cross-user isolation** — customer A cannot see, update, or delete customer B's bookings (404)
3. **Draft/inactive hiding** — customers never see draft or inactive services; customers never see unavailable time slots
4. **Active-only customer catalog** — customers see only active services and available slots from their org
5. **Booking ownership** — customers can only cancel their own pending bookings
6. **Staff write protection** — customers cannot create/update/delete services, staff members, or time slots
7. **Index exclusion** — cross-org index returns 200 with empty or filtered list, never 404
8. **Unauthenticated access** — all routes return 401 without a valid token

## 10. Seed Data

| Email | Password | Org | Role |
|-------|----------|-----|------|
| admin@clipmaster.com | password | ClipMaster | admin |
| staff@clipmaster.com | password | ClipMaster | staff |
| admin@healwell.com | password | HealWell Clinic | admin |
| alice@customer.com | password | ClipMaster | customer |
| bob@customer.com | password | ClipMaster | customer |
