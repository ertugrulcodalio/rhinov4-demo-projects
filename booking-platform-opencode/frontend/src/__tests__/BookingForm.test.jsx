import { describe, it, expect, vi, beforeEach } from 'vitest'
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import BookingForm from '../components/BookingForm.jsx'

const service = { id: 1, name: 'Haircut' }
const timeSlot = { id: 10, start_time: '2026-07-25T10:00:00Z', end_time: '2026-07-25T11:00:00Z' }

beforeEach(() => {
  vi.restoreAllMocks()
})

describe('BookingForm', () => {
  it('renders the form with service and time slot info', () => {
    render(
      <BookingForm
        orgSlug="test-org"
        service={service}
        timeSlot={timeSlot}
        onBooked={() => {}}
        onBack={() => {}}
      />
    )
    expect(screen.getByText(/Book Haircut/)).toBeInTheDocument()
    expect(screen.getByLabelText(/Name/)).toBeInTheDocument()
    expect(screen.getByLabelText(/Email/)).toBeInTheDocument()
    expect(screen.getByLabelText(/Phone/)).toBeInTheDocument()
    expect(screen.getByLabelText(/Notes/)).toBeInTheDocument()
    expect(screen.getByRole('button', { name: /Confirm Booking/ })).toBeInTheDocument()
  })

  it('calls onBack when back button is clicked', async () => {
    const onBack = vi.fn()
    render(
      <BookingForm
        orgSlug="test-org"
        service={service}
        timeSlot={timeSlot}
        onBooked={() => {}}
        onBack={onBack}
      />
    )

    await userEvent.click(screen.getByRole('button', { name: /Back to time slots/ }))
    expect(onBack).toHaveBeenCalled()
  })

  it('submits the form and calls onBooked with created booking', async () => {
    const onBooked = vi.fn()
    const createdBooking = { id: 42, customer_name: 'Jane Doe', customer_email: 'jane@test.com', status: 'pending' }

    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      status: 201,
      json: () => Promise.resolve(createdBooking)
    }))

    render(
      <BookingForm
        orgSlug="test-org"
        service={service}
        timeSlot={timeSlot}
        onBooked={onBooked}
        onBack={() => {}}
      />
    )

    await userEvent.type(screen.getByLabelText(/Name/), 'Jane Doe')
    await userEvent.type(screen.getByLabelText(/Email/), 'jane@test.com')
    await userEvent.click(screen.getByRole('button', { name: /Confirm Booking/ }))

    expect(onBooked).toHaveBeenCalledWith(createdBooking)
  })

  it('shows validation errors from API', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: false,
      status: 422,
      json: () => Promise.resolve({ errors: ["Customer name can't be blank"] })
    }))

    render(
      <BookingForm
        orgSlug="test-org"
        service={service}
        timeSlot={timeSlot}
        onBooked={() => {}}
        onBack={() => {}}
      />
    )

    await userEvent.type(screen.getByLabelText(/Name/), 'Jane')
    await userEvent.type(screen.getByLabelText(/Email/), 'jane@test.com')
    await userEvent.click(screen.getByRole('button', { name: /Confirm Booking/ }))

    expect(await screen.findByRole('alert')).toHaveTextContent("Customer name can't be blank")
  })

  it('disables submit button while submitting', async () => {
    vi.stubGlobal('fetch', vi.fn().mockReturnValue(new Promise(() => {})))

    render(
      <BookingForm
        orgSlug="test-org"
        service={service}
        timeSlot={timeSlot}
        onBooked={() => {}}
        onBack={() => {}}
      />
    )

    await userEvent.type(screen.getByLabelText(/Name/), 'Jane')
    await userEvent.type(screen.getByLabelText(/Email/), 'jane@test.com')
    await userEvent.click(screen.getByRole('button', { name: /Confirm Booking/ }))

    expect(screen.getByRole('button', { name: /Booking.../ })).toBeDisabled()
  })

  it('sends optional phone and notes fields', async () => {
    const onBooked = vi.fn()
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      status: 201,
      json: () => Promise.resolve({ id: 1 })
    }))

    render(
      <BookingForm
        orgSlug="test-org"
        service={service}
        timeSlot={timeSlot}
        onBooked={onBooked}
        onBack={() => {}}
      />
    )

    await userEvent.type(screen.getByLabelText(/Name/), 'Jane')
    await userEvent.type(screen.getByLabelText(/Email/), 'jane@test.com')
    await userEvent.type(screen.getByLabelText(/Phone/), '555-1234')
    await userEvent.type(screen.getByLabelText(/Notes/), 'Please be gentle')
    await userEvent.click(screen.getByRole('button', { name: /Confirm Booking/ }))

    const body = JSON.parse(vi.mocked(fetch).mock.calls[0][1].body)
    expect(body.booking.customer_phone).toBe('555-1234')
    expect(body.booking.notes).toBe('Please be gentle')
  })
})
