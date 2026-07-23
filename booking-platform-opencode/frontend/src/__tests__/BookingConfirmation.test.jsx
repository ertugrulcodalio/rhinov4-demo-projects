import { describe, it, expect, vi } from 'vitest'
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import BookingConfirmation from '../components/BookingConfirmation.jsx'

const booking = {
  id: 42,
  customer_name: 'Jane Doe',
  customer_email: 'jane@test.com',
  customer_phone: '555-1234',
  status: 'pending'
}

describe('BookingConfirmation', () => {
  it('displays booking details', () => {
    render(<BookingConfirmation booking={booking} onReset={() => {}} />)

    expect(screen.getByText('Booking Confirmed!')).toBeInTheDocument()
    expect(screen.getByText('42')).toBeInTheDocument()
    expect(screen.getByText('Jane Doe')).toBeInTheDocument()
    expect(screen.getByText('jane@test.com')).toBeInTheDocument()
    expect(screen.getByText('555-1234')).toBeInTheDocument()
    expect(screen.getByText('pending')).toBeInTheDocument()
  })

  it('hides phone when not provided', () => {
    const noPhone = { ...booking, customer_phone: null }
    render(<BookingConfirmation booking={noPhone} onReset={() => {}} />)
    expect(screen.queryByText('555-1234')).not.toBeInTheDocument()
  })

  it('calls onReset when button is clicked', async () => {
    const onReset = vi.fn()
    render(<BookingConfirmation booking={booking} onReset={onReset} />)

    await userEvent.click(screen.getByRole('button', { name: /Book Another/ }))
    expect(onReset).toHaveBeenCalled()
  })
})
