import { useState } from 'react'
import { createBooking } from '../api/client.js'

export default function BookingForm({ orgSlug, service, timeSlot, onBooked, onBack }) {
  const [form, setForm] = useState({
    customer_name: '',
    customer_email: '',
    customer_phone: '',
    notes: ''
  })
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState(null)

  function handleChange(e) {
    setForm((prev) => ({ ...prev, [e.target.name]: e.target.value }))
  }

  async function handleSubmit(e) {
    e.preventDefault()
    setSubmitting(true)
    setError(null)

    try {
      const booking = await createBooking(orgSlug, {
        service_id: service.id,
        time_slot_id: timeSlot.id,
        customer_name: form.customer_name,
        customer_email: form.customer_email,
        customer_phone: form.customer_phone || undefined,
        notes: form.notes || undefined
      })
      onBooked(booking)
    } catch (err) {
      setError(err.message)
      setSubmitting(false)
    }
  }

  return (
    <div>
      <button onClick={onBack} type="button">&larr; Back to time slots</button>
      <h2>Book {service.name}</h2>
      <p>
        {new Date(timeSlot.start_time).toLocaleString()} &ndash;{' '}
        {new Date(timeSlot.end_time).toLocaleString()}
      </p>

      <form onSubmit={handleSubmit}>
        <div>
          <label htmlFor="customer_name">Name *</label>
          <input
            id="customer_name"
            name="customer_name"
            value={form.customer_name}
            onChange={handleChange}
            required
          />
        </div>
        <div>
          <label htmlFor="customer_email">Email *</label>
          <input
            id="customer_email"
            name="customer_email"
            type="email"
            value={form.customer_email}
            onChange={handleChange}
            required
          />
        </div>
        <div>
          <label htmlFor="customer_phone">Phone</label>
          <input
            id="customer_phone"
            name="customer_phone"
            type="tel"
            value={form.customer_phone}
            onChange={handleChange}
          />
        </div>
        <div>
          <label htmlFor="notes">Notes</label>
          <textarea
            id="notes"
            name="notes"
            value={form.notes}
            onChange={handleChange}
          />
        </div>

        {error && <p role="alert">Error: {error}</p>}

        <button type="submit" disabled={submitting}>
          {submitting ? 'Booking...' : 'Confirm Booking'}
        </button>
      </form>
    </div>
  )
}
