import { describe, it, expect, vi, beforeEach } from 'vitest'
import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import App from '../App.jsx'

const services = [
  { id: 1, name: 'Haircut', description: 'Standard cut' },
  { id: 2, name: 'Manicure', description: 'Nail care' }
]

const timeSlots = [
  { id: 10, service_id: 1, start_time: '2026-07-25T10:00:00Z', end_time: '2026-07-25T11:00:00Z', available: true },
  { id: 11, service_id: 1, start_time: '2026-07-25T14:00:00Z', end_time: '2026-07-25T15:00:00Z', available: true }
]

const createdBooking = {
  id: 42,
  customer_name: 'Jane',
  customer_email: 'jane@test.com',
  status: 'pending'
}

beforeEach(() => {
  vi.restoreAllMocks()
  vi.unstubAllGlobals()
})

function setupFetchSequence() {
  const fetchMock = vi.fn()
  fetchMock
    .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(services) })
    .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(timeSlots) })
    .mockResolvedValueOnce({ ok: true, status: 201, json: () => Promise.resolve(createdBooking) })
    .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(services) })
  vi.stubGlobal('fetch', fetchMock)
  return fetchMock
}

describe('App booking flow', () => {
  it('completes the full booking flow: services -> time slots -> form -> confirmation', async () => {
    setupFetchSequence()
    render(<App />)

    // Step 1: Wait for services to load
    await waitFor(() => {
      expect(screen.getByText('Haircut')).toBeInTheDocument()
    })

    // Step 2: Select a service -> time slots appear
    await userEvent.click(screen.getByText('Haircut'))
    await waitFor(() => {
      expect(screen.getByText(/Select a Time Slot/)).toBeInTheDocument()
    })

    // Step 3: Select a time slot -> booking form appears
    const slotButton = screen.getAllByRole('button').find((b) => b.textContent.includes('–'))
    await userEvent.click(slotButton)
    expect(screen.getByText(/Book Haircut/)).toBeInTheDocument()

    // Step 4: Fill and submit form -> confirmation appears
    await userEvent.type(screen.getByLabelText(/Name/), 'Jane')
    await userEvent.type(screen.getByLabelText(/Email/), 'jane@test.com')
    await userEvent.click(screen.getByRole('button', { name: /Confirm Booking/ }))

    await waitFor(() => {
      expect(screen.getByText('Booking Confirmed!')).toBeInTheDocument()
    })
    expect(screen.getByText('Jane')).toBeInTheDocument()
  })

  it('allows navigating back from time slots to services', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      json: () => Promise.resolve(services)
    }))

    render(<App />)

    await waitFor(() => {
      expect(screen.getByText('Haircut')).toBeInTheDocument()
    })

    await userEvent.click(screen.getByText('Haircut'))

    await waitFor(() => {
      expect(screen.getByRole('button', { name: /Back to services/ })).toBeInTheDocument()
    })

    await userEvent.click(screen.getByRole('button', { name: /Back to services/ }))
    expect(screen.getByText('Choose a Service')).toBeInTheDocument()
  })

  it('allows resetting the flow from confirmation', async () => {
    setupFetchSequence()
    render(<App />)

    // Go through full flow
    await waitFor(() => expect(screen.getByText('Haircut')).toBeInTheDocument())
    await userEvent.click(screen.getByText('Haircut'))
    await waitFor(() => {
      const slotButton = screen.getAllByRole('button').find((b) => b.textContent.includes('–'))
      return slotButton && userEvent.click(slotButton)
    })
    await userEvent.type(screen.getByLabelText(/Name/), 'Jane')
    await userEvent.type(screen.getByLabelText(/Email/), 'jane@test.com')
    await userEvent.click(screen.getByRole('button', { name: /Confirm Booking/ }))

    await waitFor(() => expect(screen.getByText('Booking Confirmed!')).toBeInTheDocument())

    // Reset
    await userEvent.click(screen.getByRole('button', { name: /Book Another/ }))
    expect(screen.getByText('Choose a Service')).toBeInTheDocument()
  })
})
