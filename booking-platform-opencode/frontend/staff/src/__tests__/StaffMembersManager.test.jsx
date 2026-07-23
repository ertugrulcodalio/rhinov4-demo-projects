import { describe, it, expect, vi, beforeEach } from 'vitest'
import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import StaffMembersManager from '../components/StaffMembersManager.jsx'

beforeEach(() => {
  vi.restoreAllMocks()
  vi.unstubAllGlobals()
})

const mockMembers = [
  { id: 1, name: 'John Doe', role: 'admin', email: 'john@test.com', phone: '', active: true },
  { id: 2, name: 'Jane Smith', role: 'staff', email: 'jane@test.com', phone: '555-1234', active: false }
]

describe('StaffMembersManager', () => {
  it('shows loading state initially', () => {
    vi.stubGlobal('fetch', vi.fn().mockReturnValue(new Promise(() => {})))
    render(<StaffMembersManager />)
    expect(screen.getByRole('status')).toHaveTextContent('Loading staff members...')
  })

  it('renders list of staff members after loading', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      json: () => Promise.resolve(mockMembers)
    }))

    render(<StaffMembersManager />)

    await waitFor(() => {
      expect(screen.getByText('John Doe')).toBeInTheDocument()
    })
    expect(screen.getByText('Jane Smith')).toBeInTheDocument()
  })

  it('shows create form when "Create Staff Member" is clicked', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      json: () => Promise.resolve([])
    }))

    render(<StaffMembersManager />)

    await waitFor(() => {
      expect(screen.getByText('Create Staff Member')).toBeInTheDocument()
    })

    await userEvent.click(screen.getByText('Create Staff Member'))
    expect(screen.getByText('New Staff Member')).toBeInTheDocument()
  })

  it('calls create API and updates list', async () => {
    const createdMember = { id: 3, name: 'New Staff', role: 'staff', email: 'new@test.com', phone: '', active: true }

    vi.stubGlobal('fetch', vi.fn()
      .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(mockMembers) })
      .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(createdMember) })
    )

    render(<StaffMembersManager />)

    await waitFor(() => {
      expect(screen.getByText('Create Staff Member')).toBeInTheDocument()
    })

    await userEvent.click(screen.getByText('Create Staff Member'))

    await userEvent.type(screen.getByPlaceholderText('Name'), 'New Staff')
    await userEvent.click(screen.getByRole('button', { name: /^Create$/ }))

    await waitFor(() => {
      expect(screen.getByText('New Staff')).toBeInTheDocument()
    })
  })

  it('calls update API and updates list', async () => {
    const updatedMember = { id: 1, name: 'Updated Staff', role: 'manager', email: 'updated@test.com', phone: '', active: true }

    vi.stubGlobal('fetch', vi.fn()
      .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(mockMembers) })
      .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(updatedMember) })
    )

    render(<StaffMembersManager />)

    await waitFor(() => {
      expect(screen.getByText('John Doe')).toBeInTheDocument()
    })

    await userEvent.click(screen.getAllByRole('button', { name: /Edit/ })[0])

    await userEvent.clear(screen.getByPlaceholderText('Name'))
    await userEvent.type(screen.getByPlaceholderText('Name'), 'Updated Staff')
    await userEvent.click(screen.getByRole('button', { name: /Update/ }))

    await waitFor(() => {
      expect(screen.getByText('Updated Staff')).toBeInTheDocument()
    })
  })

  it('calls delete API and removes from list', async () => {
    vi.stubGlobal('fetch', vi.fn()
      .mockResolvedValueOnce({ ok: true, json: () => Promise.resolve(mockMembers) })
      .mockResolvedValueOnce({ ok: true, status: 204 })
    )

    render(<StaffMembersManager />)

    await waitFor(() => {
      expect(screen.getByText('John Doe')).toBeInTheDocument()
    })

    await userEvent.click(screen.getAllByRole('button', { name: /Delete/ })[0])

    await waitFor(() => {
      expect(screen.queryByText('John Doe')).not.toBeInTheDocument()
    })
  })
})
