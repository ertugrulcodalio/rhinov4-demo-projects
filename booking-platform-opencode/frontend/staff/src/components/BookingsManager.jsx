import { useState, useEffect } from 'react'
import { fetchBookings, fetchBooking, createBooking, updateBooking, discardBooking } from '../api/client.js'

export default function BookingsManager() {
  const [bookings, setBookings] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [formVisible, setFormVisible] = useState(false)
  const [editingBooking, setEditingBooking] = useState(null)
  const [formData, setFormData] = useState({ service_id: '', time_slot_id: '', staff_member_id: '', customer_name: '', customer_email: '', customer_phone: '', notes: '', status: 'pending' })

  useEffect(() => {
    let cancelled = false
    fetchBookings()
      .then((data) => {
        if (!cancelled) {
          setBookings(data)
          setLoading(false)
        }
      })
      .catch((err) => {
        if (!cancelled) {
          setError(err.message)
          setLoading(false)
        }
      })
    return () => { cancelled = true }
  }, [])

  function openCreateForm() {
    const timeSlot = bookings.find(b => b.time_slot_id)?.time_slot_id || ''
    setFormData({ 
      service_id: bookings.find(b => b.service_id)?.service_id || '', 
      time_slot_id: timeSlot, 
      staff_member_id: '', 
      customer_name: '', 
      customer_email: '', 
      customer_phone: '', 
      notes: '', 
      status: 'pending' 
    })
    setEditingBooking(null)
    setFormVisible(true)
  }

  function openEditForm(booking) {
    setFormData({ 
      service_id: booking.service_id, 
      time_slot_id: booking.time_slot_id, 
      staff_member_id: booking.staff_member_id || '', 
      customer_name: booking.customer_name, 
      customer_email: booking.customer_email, 
      customer_phone: booking.customer_phone || '', 
      notes: booking.notes || '', 
      status: booking.status 
    })
    setEditingBooking(booking)
    setFormVisible(true)
  }

  function closeForm() {
    setFormVisible(false)
    setEditingBooking(null)
  }

  async function handleSubmit(e) {
    e.preventDefault()
    try {
      if (editingBooking) {
        const updated = await updateBooking(editingBooking.id, formData)
        setBookings((prev) => prev.map((b) => (b.id === editingBooking.id ? updated : b)))
      } else {
        const created = await createBooking(formData)
        setBookings((prev) => [...prev, created])
      }
      closeForm()
    } catch (err) {
      setError(err.message)
    }
  }

  async function handleDelete(id) {
    try {
      await discardBooking(id)
      setBookings((prev) => prev.filter((b) => b.id !== id))
    } catch (err) {
      setError(err.message)
    }
  }

  if (loading) return <p role="status">Loading bookings...</p>
  if (error) return <p role="alert">Error: {error}</p>

  return (
    <div>
      <h2>Bookings Manager</h2>
      <button onClick={openCreateForm}>Create Booking</button>

      {formVisible && (
        <form onSubmit={handleSubmit}>
          <h3>{editingBooking ? 'Edit Booking' : 'New Booking'}</h3>
          <input placeholder="Service ID" type="number" value={formData.service_id} onChange={(e) => setFormData((prev) => ({ ...prev, service_id: e.target.value }))} required />
          <input placeholder="Time Slot ID" type="number" value={formData.time_slot_id} onChange={(e) => setFormData((prev) => ({ ...prev, time_slot_id: e.target.value }))} required />
          <input placeholder="Staff Member ID" type="number" value={formData.staff_member_id} onChange={(e) => setFormData((prev) => ({ ...prev, staff_member_id: e.target.value }))} />
          <input placeholder="Customer Name" value={formData.customer_name} onChange={(e) => setFormData((prev) => ({ ...prev, customer_name: e.target.value }))} required />
          <input placeholder="Customer Email" type="email" value={formData.customer_email} onChange={(e) => setFormData((prev) => ({ ...prev, customer_email: e.target.value }))} required />
          <input placeholder="Customer Phone" value={formData.customer_phone} onChange={(e) => setFormData((prev) => ({ ...prev, customer_phone: e.target.value }))} />
          <textarea placeholder="Notes" value={formData.notes} onChange={(e) => setFormData((prev) => ({ ...prev, notes: e.target.value }))} />
          <select value={formData.status} onChange={(e) => setFormData((prev) => ({ ...prev, status: e.target.value }))}>
            <option value="pending">Pending</option>
            <option value="confirmed">Confirmed</option>
            <option value="cancelled">Cancelled</option>
            <option value="completed">Completed</option>
          </select>
          <button type="submit">{editingBooking ? 'Update' : 'Create'}</button>
          <button type="button" onClick={closeForm}>Cancel</button>
        </form>
      )}

      <ul>
        {bookings.map((b) => (
          <li key={b.id}>
            <strong>{b.id}</strong> | Customer: {b.customer_name} | Email: {b.customer_email} | Status: {b.status} | Service: {b.service_id} | Time Slot: {b.time_slot_id}
            <button onClick={() => openEditForm(b)}>Edit</button>
            <button onClick={() => handleDelete(b.id)}>Delete</button>
          </li>
        ))}
      </ul>
    </div>
  )
}
