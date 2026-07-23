import { describe, it, expect, vi, beforeEach } from 'vitest'
import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import BookingsManager from '../components/BookingsManager.jsx'

beforeEach(() => {
  vi.restoreAllMocks()
  vi.unstubAllGlobals()
})

const mockBookings = [
  { id: 1, service_id: 1, time_slot_id: 10, staff_member_id: '', customer_name: 'John Doe', customer_email: 'john@test.com', customer_phone: '', notes: '', status: 'confirmed' },
  { id: 2, service_id: 2, time_slot_id: 11, staff_member_id: '2', customer_name: 'Jane Smith', customer_email: 'jane@test.com', customer_phone: '555-1234', notes: 'Special request', status: 'pending' }
]

describe('BookingsManager', () => {
  it('shows loading state initially', () => {
    vi.stubGlobal('fetch', vi.fn().mockReturnValue(new Promise(() => {})))
    render(<BookingsManager />)
    expect(screen.getByRole('status')).toHaveTextContent('Loading bookings...')
  })

  it('renders list of bookings after loading', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      json: () => Promise.resolve(mockBookings)
    }))

    render(<BookingsManager />)

    await waitFor(() => {
      expect(screen.getByText((content) => content.includes('John Doe'))).toBeInTheDocument()
    })
    expect(screen.getByText((content) => content.includes('Jane Smith'))).toBeInTheDocument()
  })

  it('shows create form when "Create Booking" is clicked', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      json: () => Promise.resolve([])
    }))

    render(<BookingsManager />)

    await waitFor(() => {
      expect(screen.getByText('Create Booking')).toBeInTheDocument()
    })

    await userEvent.click(screen.getByText('Create Booking'))
    expect(screen.getByText('New Booking')).toBeInTheDocument()
  })

  it('calls create API and updates list', async () => {
    const createdBooking = { id: 3, service_id: 1, time_slot_id: 10, staff_member_id: '', customer_name: 'New Customer', customer_email: 'new@test.com', customer_phone: '', notes: '', status: 'pending' }

    vi.stubGlobal('fetch', vi.fn()
      .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(mockBookings) })
      .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(createdBooking) })
    )

    render(<BookingsManager />)

    await waitFor(() => {
      expect(screen.getByText('Create Booking')).toBeInTheDocument()
    })

    await userEvent.click(screen.getByText('Create Booking'))

    await userEvent.type(screen.getByPlaceholderText('Customer Name'), 'New Customer')
    await userEvent.type(screen.getByPlaceholderText('Customer Email'), 'new@test.com')
    await userEvent.click(screen.getByRole('button', { name: /^Create$/ }))

    await waitFor(() => {
      expect(screen.getByText((content) => content.includes('New Customer'))).toBeInTheDocument()
    })
  })

  it('calls update API and updates list', async () => {
    const updatedBooking = { id: 1, service_id: 1, time_slot_id: 10, staff_member_id: '', customer_name: 'Updated Customer', customer_email: 'updated@test.com', customer_phone: '', notes: '', status: 'completed' }

    vi.stubGlobal('fetch', vi.fn()
      .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(mockBookings) })
      .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(updatedBooking) })
    )

    render(<BookingsManager />)

    await waitFor(() => {
      expect(screen.getByText((content) => content.includes('John Doe'))).toBeInTheDocument()
    })

    await userEvent.click(screen.getAllByRole('button', { name: /Edit/ })[0])

    await userEvent.clear(screen.getByPlaceholderText('Customer Name'))
    await userEvent.type(screen.getByPlaceholderText('Customer Name'), 'Updated Customer')
    await userEvent.click(screen.getByRole('button', { name: /Update/ }))

    await waitFor(() => {
      expect(screen.getByText((content) => content.includes('Updated Customer'))).toBeInTheDocument()
    })
  })

  it('calls delete API and removes from list', async () => {
    vi.stubGlobal('fetch', vi.fn()
      .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(mockBookings) })
      .mockResolvedValueOnce({ ok: true, status: 204 })
    )

    render(<BookingsManager />)

    await waitFor(() => {
      expect(screen.getByText((content) => content.includes('John Doe'))).toBeInTheDocument()
    })

    await userEvent.click(screen.getAllByRole('button', { name: /Delete/ })[0])

    await waitFor(() => {
      expect(screen.queryByText((content) => content.includes('John Doe'))).not.toBeInTheDocument()
    })
  })
})
