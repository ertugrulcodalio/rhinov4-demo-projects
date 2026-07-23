import { describe, it, expect, vi, beforeEach } from 'vitest'
import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import TimeSlotsManager from '../components/TimeSlotsManager.jsx'

beforeEach(() => {
  vi.restoreAllMocks()
  vi.unstubAllGlobals()
})

const mockServices = [
  { id: 1, name: 'Haircut', description: 'Standard cut', active: true, draft: false },
  { id: 2, name: 'Manicure', description: null, active: true, draft: false }
]

const mockSlots = [
  { id: 1, service_id: 1, staff_member_id: '', start_time: '2025-07-25T10:00', end_time: '2025-07-25T11:00', available: true, notes: '', staff_memo: '' },
  { id: 2, service_id: 2, staff_member_id: '2', start_time: '2025-07-25T14:00', end_time: '2025-07-25T15:00', available: false, notes: 'Lunch break', staff_memo: '' }
]

describe('TimeSlotsManager', () => {
  it('shows loading state initially', () => {
    vi.stubGlobal('fetch', vi.fn().mockReturnValue(new Promise(() => {})))
    render(<TimeSlotsManager />)
    expect(screen.getByRole('status')).toHaveTextContent('Loading time slots...')
  })

  it('renders list of time slots after loading', async () => {
    vi.stubGlobal('fetch', vi.fn()
      .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(mockSlots) })
      .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(mockServices) })
    )

    render(<TimeSlotsManager />)

    await waitFor(() => {
      expect(screen.getByText((content) => content.includes('2025-07-25T10:00'))).toBeInTheDocument()
    })
    expect(screen.getByText((content) => content.includes('2025-07-25T14:00'))).toBeInTheDocument()
  })

  it('shows create form when "Create Time Slot" is clicked', async () => {
    vi.stubGlobal('fetch', vi.fn()
      .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve([]) })
      .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(mockServices) })
    )

    render(<TimeSlotsManager />)

    await waitFor(() => {
      expect(screen.getByText('Create Time Slot')).toBeInTheDocument()
    })

    await userEvent.click(screen.getByText('Create Time Slot'))
    expect(screen.getByText('New Time Slot')).toBeInTheDocument()
  })

  it('calls create API and updates list', async () => {
    const createdSlot = { id: 3, service_id: 1, staff_member_id: '', start_time: '2025-07-26T09:00', end_time: '2025-07-26T10:00', available: true, notes: '', staff_memo: '' }

    vi.stubGlobal('fetch', vi.fn()
      .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(mockSlots) })
      .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(mockServices) })
      .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(createdSlot) })
    )

    render(<TimeSlotsManager />)

    await waitFor(() => {
      expect(screen.getByText('Create Time Slot')).toBeInTheDocument()
    })

    await userEvent.click(screen.getByText('Create Time Slot'))

    await userEvent.type(screen.getAllByRole('textbox')[0], '2025-07-26T09:00')
    await userEvent.type(screen.getAllByRole('textbox')[1], '2025-07-26T10:00')
    await userEvent.click(screen.getByRole('button', { name: /^Create$/ }))

    await waitFor(() => {
      expect(screen.getByText((content) => content.includes('2025-07-26T09:00'))).toBeInTheDocument()
    })
  })

  it('calls update API and updates list', async () => {
    const updatedSlot = { id: 1, service_id: 1, staff_member_id: '2', start_time: '2025-07-25T12:00', end_time: '2025-07-25T13:00', available: false, notes: '', staff_memo: '' }

    vi.stubGlobal('fetch', vi.fn()
      .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(mockSlots) })
      .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(mockServices) })
      .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(updatedSlot) })
    )

    render(<TimeSlotsManager />)

    await waitFor(() => {
      expect(screen.getAllByRole('button', { name: /Edit/ }).length).toBeGreaterThan(0)
    })

    await userEvent.click(screen.getAllByRole('button', { name: /Edit/ })[0])
    await userEvent.click(screen.getByRole('button', { name: /Update/ }))

    await waitFor(() => {
      expect(screen.getByText((content) => content.includes('2025-07-25T12:00'))).toBeInTheDocument()
    })
  })

  it('calls delete API and removes from list', async () => {
    vi.stubGlobal('fetch', vi.fn()
      .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(mockSlots) })
      .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(mockServices) })
      .mockResolvedValueOnce({ ok: true, status: 204 })
    )

    render(<TimeSlotsManager />)

    await waitFor(() => {
      expect(screen.getByText((content) => content.includes('2025-07-25T14:00'))).toBeInTheDocument()
    })

    await userEvent.click(screen.getAllByRole('button', { name: /Delete/ })[1])

    await waitFor(() => {
      expect(screen.queryByText((content) => content.includes('2025-07-25T14:00'))).not.toBeInTheDocument()
    })
  })
})
