import { describe, it, expect, vi, beforeEach } from 'vitest'
import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import TimeSlotPicker from '../components/TimeSlotPicker.jsx'

const service = { id: 1, name: 'Haircut' }

const mockSlots = [
  { id: 10, service_id: 1, start_time: '2026-07-25T10:00:00Z', end_time: '2026-07-25T11:00:00Z', available: true },
  { id: 11, service_id: 1, start_time: '2026-07-25T12:00:00Z', end_time: '2026-07-25T13:00:00Z', available: false },
  { id: 12, service_id: 2, start_time: '2026-07-25T10:00:00Z', end_time: '2026-07-25T11:00:00Z', available: true }
]

beforeEach(() => {
  vi.restoreAllMocks()
  vi.unstubAllGlobals()
})

describe('TimeSlotPicker', () => {
  it('shows loading state initially', () => {
    vi.stubGlobal('fetch', vi.fn().mockReturnValue(new Promise(() => {})))
    render(<TimeSlotPicker orgSlug="test-org" service={service} onSelect={() => {}} onBack={() => {}} />)
    expect(screen.getByRole('status')).toHaveTextContent('Loading time slots')
  })

  it('filters slots by service_id and available', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      json: () => Promise.resolve(mockSlots)
    }))

    render(<TimeSlotPicker orgSlug="test-org" service={service} onSelect={() => {}} onBack={() => {}} />)

    await waitFor(() => {
      expect(screen.getByText(/Select a Time Slot for Haircut/)).toBeInTheDocument()
    })
    const buttons = screen.getAllByRole('button')
    const slotButtons = buttons.filter((b) => b.textContent.includes('–'))
    expect(slotButtons).toHaveLength(1)
  })

  it('calls onSelect with the clicked slot', async () => {
    const onSelect = vi.fn()
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      json: () => Promise.resolve(mockSlots)
    }))

    render(<TimeSlotPicker orgSlug="test-org" service={service} onSelect={onSelect} onBack={() => {}} />)

    await waitFor(() => {
      expect(screen.getByText(/Haircut/)).toBeInTheDocument()
    })

    const slotButton = screen.getAllByRole('button').find((b) => b.textContent.includes('–'))
    await userEvent.click(slotButton)
    expect(onSelect).toHaveBeenCalledWith(mockSlots[0])
  })

  it('shows empty message when no available slots', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      json: () => Promise.resolve([{ id: 99, service_id: 1, available: false, start_time: '2026-07-25T10:00:00Z', end_time: '2026-07-25T11:00:00Z' }])
    }))

    render(<TimeSlotPicker orgSlug="test-org" service={service} onSelect={() => {}} onBack={() => {}} />)

    await waitFor(() => {
      expect(screen.getByText('No available time slots for this service.')).toBeInTheDocument()
    })
  })

  it('calls onBack when back button is clicked', async () => {
    const onBack = vi.fn()
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      json: () => Promise.resolve([])
    }))

    render(<TimeSlotPicker orgSlug="test-org" service={service} onSelect={() => {}} onBack={onBack} />)

    await waitFor(() => {
      expect(screen.getByRole('button', { name: /Back to services/ })).toBeInTheDocument()
    })

    await userEvent.click(screen.getByRole('button', { name: /Back to services/ }))
    expect(onBack).toHaveBeenCalled()
  })

  it('shows error on fetch failure', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: false,
      status: 500,
      json: () => Promise.resolve({ errors: ['Server error'] })
    }))

    render(<TimeSlotPicker orgSlug="test-org" service={service} onSelect={() => {}} onBack={() => {}} />)

    await waitFor(() => {
      expect(screen.getByRole('alert')).toHaveTextContent('Error: Server error')
    })
  })
})
