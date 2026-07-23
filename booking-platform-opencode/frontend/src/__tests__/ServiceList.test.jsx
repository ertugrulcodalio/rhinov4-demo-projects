import { describe, it, expect, vi, beforeEach } from 'vitest'
import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import ServiceList from '../components/ServiceList.jsx'

const mockServices = [
  { id: 1, name: 'Haircut', description: 'Standard haircut' },
  { id: 2, name: 'Manicure', description: null }
]

beforeEach(() => {
  vi.restoreAllMocks()
})

describe('ServiceList', () => {
  it('shows loading state initially', () => {
    vi.stubGlobal('fetch', vi.fn().mockReturnValue(new Promise(() => {})))
    render(<ServiceList orgSlug="test-org" onSelect={() => {}} />)
    expect(screen.getByRole('status')).toHaveTextContent('Loading services')
  })

  it('renders list of services after loading', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      json: () => Promise.resolve(mockServices)
    }))

    render(<ServiceList orgSlug="test-org" onSelect={() => {}} />)

    await waitFor(() => {
      expect(screen.getByText('Haircut')).toBeInTheDocument()
    })
    expect(screen.getByText('Manicure')).toBeInTheDocument()
  })

  it('shows description when present', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      json: () => Promise.resolve(mockServices)
    }))

    render(<ServiceList orgSlug="test-org" onSelect={() => {}} />)

    await waitFor(() => {
      expect(screen.getByText('Standard haircut')).toBeInTheDocument()
    })
  })

  it('calls onSelect with the clicked service', async () => {
    const onSelect = vi.fn()
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      json: () => Promise.resolve(mockServices)
    }))

    render(<ServiceList orgSlug="test-org" onSelect={onSelect} />)

    await waitFor(() => {
      expect(screen.getByText('Haircut')).toBeInTheDocument()
    })

    await userEvent.click(screen.getByText('Haircut'))
    expect(onSelect).toHaveBeenCalledWith(mockServices[0])
  })

  it('shows error state on fetch failure', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: false,
      status: 500,
      json: () => Promise.resolve({ errors: ['Server error'] })
    }))

    render(<ServiceList orgSlug="test-org" onSelect={() => {}} />)

    await waitFor(() => {
      expect(screen.getByRole('alert')).toHaveTextContent('Error: Server error')
    })
  })

  it('shows empty state when no services exist', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      json: () => Promise.resolve([])
    }))

    render(<ServiceList orgSlug="test-org" onSelect={() => {}} />)

    await waitFor(() => {
      expect(screen.getByText('No services available.')).toBeInTheDocument()
    })
  })
})
