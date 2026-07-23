import { describe, it, expect, vi, beforeEach } from 'vitest'
import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import ServicesManager from '../components/ServicesManager.jsx'

beforeEach(() => {
  vi.restoreAllMocks()
  vi.unstubAllGlobals()
})

const mockServices = [
  { id: 1, name: 'Haircut', description: 'Standard cut', active: true, draft: false },
  { id: 2, name: 'Manicure', description: null, active: true, draft: false }
]

describe('ServicesManager', () => {
  it('shows loading state initially', () => {
    vi.stubGlobal('fetch', vi.fn().mockReturnValue(new Promise(() => {})))
    render(<ServicesManager />)
    expect(screen.getByRole('status')).toHaveTextContent('Loading services...')
  })

  it('renders list of services after loading', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      json: () => Promise.resolve(mockServices)
    }))

    render(<ServicesManager />)

    await waitFor(() => {
      expect(screen.getByText('Haircut')).toBeInTheDocument()
    })
    expect(screen.getByText('Manicure')).toBeInTheDocument()
  })

  it('shows create form when "Create Service" is clicked', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      json: () => Promise.resolve([])
    }))

    render(<ServicesManager />)

    await waitFor(() => {
      expect(screen.getByText('Create Service')).toBeInTheDocument()
    })

    await userEvent.click(screen.getByText('Create Service'))
    expect(screen.getByText('New Service')).toBeInTheDocument()
  })

  it('calls create API and updates list', async () => {
    const createdService = { id: 3, name: 'New Service', description: '', active: true, draft: false }

    vi.stubGlobal('fetch', vi.fn()
      .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(mockServices) })
      .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(createdService) })
    )

    render(<ServicesManager />)

    await waitFor(() => {
      expect(screen.getByText('Create Service')).toBeInTheDocument()
    })

    await userEvent.click(screen.getByText('Create Service'))

    await userEvent.type(screen.getByPlaceholderText('Name'), 'New Service')
    await userEvent.click(screen.getByRole('button', { name: /^Create$/ }))

    await waitFor(() => {
      expect(screen.getByText('New Service')).toBeInTheDocument()
    })
  })

  it('calls update API and updates list', async () => {
    const updatedService = { id: 1, name: 'Updated Service', description: '', active: false, draft: true }

    vi.stubGlobal('fetch', vi.fn()
      .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(mockServices) })
      .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(updatedService) })
    )

    render(<ServicesManager />)

    await waitFor(() => {
      expect(screen.getByText('Haircut')).toBeInTheDocument()
    })

    await userEvent.click(screen.getAllByRole('button', { name: /Edit/ })[0])

    await userEvent.clear(screen.getByPlaceholderText('Name'))
    await userEvent.type(screen.getByPlaceholderText('Name'), 'Updated Service')
    await userEvent.click(screen.getByRole('button', { name: /Update/ }))

    await waitFor(() => {
      expect(screen.getByText('Updated Service')).toBeInTheDocument()
    })
  })

  it('calls delete API and removes from list', async () => {
    vi.stubGlobal('fetch', vi.fn()
      .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(mockServices) })
      .mockResolvedValueOnce({ ok: true, status: 204 })
    )

    render(<ServicesManager />)

    await waitFor(() => {
      expect(screen.getByText('Haircut')).toBeInTheDocument()
    })

    await userEvent.click(screen.getAllByRole('button', { name: /Delete/ })[0])

    await waitFor(() => {
      expect(screen.queryByText('Haircut')).not.toBeInTheDocument()
    })
  })
})
