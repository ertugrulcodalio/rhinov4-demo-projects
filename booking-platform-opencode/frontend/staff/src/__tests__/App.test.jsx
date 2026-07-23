import { describe, it, expect, vi, beforeEach } from 'vitest'
import { render, screen } from '@testing-library/react'
import App from '../App.jsx'

beforeEach(() => {
  vi.restoreAllMocks()
  vi.unstubAllGlobals()
})

describe('StaffDashboard', () => {
  it('renders admin dashboard with navigation links', () => {
    render(<App />)

    expect(screen.getByText('Admin Dashboard')).toBeInTheDocument()
    expect(screen.getByText('Services')).toBeInTheDocument()
    expect(screen.getByText('Staff Members')).toBeInTheDocument()
    expect(screen.getByText('Time Slots')).toBeInTheDocument()
    expect(screen.getByText('Bookings')).toBeInTheDocument()
  })

  it('renders correct navigation hrefs', () => {
    render(<App />)

    expect(screen.getByText('Services').closest('a')).toHaveAttribute('href', '/staff/services')
    expect(screen.getByText('Staff Members').closest('a')).toHaveAttribute('href', '/staff/staff-members')
    expect(screen.getByText('Time Slots').closest('a')).toHaveAttribute('href', '/staff/time-slots')
    expect(screen.getByText('Bookings').closest('a')).toHaveAttribute('href', '/staff/bookings')
  })
})
