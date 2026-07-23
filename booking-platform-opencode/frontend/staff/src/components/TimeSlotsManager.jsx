import { useState, useEffect } from 'react'
import { fetchServices, fetchTimeSlots, fetchTimeSlot, createTimeSlot, updateTimeSlot, discardTimeSlot } from '../api/client.js'

export default function TimeSlotsManager() {
  const [slots, setSlots] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [formVisible, setFormVisible] = useState(false)
  const [editingSlot, setEditingSlot] = useState(null)
  const [formData, setFormData] = useState({ service_id: '', staff_member_id: '', start_time: '', end_time: '', available: true, notes: '', staff_memo: '' })

  const [services, setServices] = useState([])

  useEffect(() => {
    let cancelled = false
    Promise.all([fetchTimeSlots(), fetchServices()])
      .then(([slotsData, servicesData]) => {
        if (!cancelled) {
          setSlots(slotsData)
          setServices(servicesData)
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
    const service = services[0]
    setFormData({ 
      service_id: service?.id || '', 
      staff_member_id: '', 
      start_time: '', 
      end_time: '', 
      available: true, 
      notes: '', 
      staff_memo: '' 
    })
    setEditingSlot(null)
    setFormVisible(true)
  }

  function openEditForm(slot) {
    setFormData({ 
      service_id: slot.service_id, 
      staff_member_id: slot.staff_member_id || '', 
      start_time: slot.start_time, 
      end_time: slot.end_time, 
      available: slot.available, 
      notes: slot.notes || '', 
      staff_memo: slot.staff_memo || '' 
    })
    setEditingSlot(slot)
    setFormVisible(true)
  }

  function closeForm() {
    setFormVisible(false)
    setEditingSlot(null)
  }

  async function handleSubmit(e) {
    e.preventDefault()
    try {
      if (editingSlot) {
        const updated = await updateTimeSlot(editingSlot.id, formData)
        setSlots((prev) => prev.map((s) => (s.id === editingSlot.id ? updated : s)))
      } else {
        const created = await createTimeSlot(formData)
        setSlots((prev) => [...prev, created])
      }
      closeForm()
    } catch (err) {
      setError(err.message)
    }
  }

  async function handleDelete(id) {
    try {
      await discardTimeSlot(id)
      setSlots((prev) => prev.filter((s) => s.id !== id))
    } catch (err) {
      setError(err.message)
    }
  }

  if (loading) return <p role="status">Loading time slots...</p>
  if (error) return <p role="alert">Error: {error}</p>

  return (
    <div>
      <h2>Time Slots Manager</h2>
      <button onClick={openCreateForm}>Create Time Slot</button>

      {formVisible && (
        <form onSubmit={handleSubmit}>
          <h3>{editingSlot ? 'Edit Time Slot' : 'New Time Slot'}</h3>
          <select value={formData.service_id} onChange={(e) => setFormData((prev) => ({ ...prev, service_id: e.target.value }))} required>
            <option value="">Select Service</option>
            {services.map((s) => (
              <option key={s.id} value={s.id}>{s.name}</option>
            ))}
          </select>
          <select value={formData.staff_member_id} onChange={(e) => setFormData((prev) => ({ ...prev, staff_member_id: e.target.value }))}>
            <option value="">No Staff</option>
            <option value="1">Test Staff</option>
          </select>
          <input type="datetime-local" value={formData.start_time} onChange={(e) => setFormData((prev) => ({ ...prev, start_time: e.target.value }))} required />
          <input type="datetime-local" value={formData.end_time} onChange={(e) => setFormData((prev) => ({ ...prev, end_time: e.target.value }))} required />
          <label><input type="checkbox" checked={formData.available} onChange={(e) => setFormData((prev) => ({ ...prev, available: e.target.checked }))} /> Available</label>
          <textarea placeholder="Notes" value={formData.notes} onChange={(e) => setFormData((prev) => ({ ...prev, notes: e.target.value }))} />
          <textarea placeholder="Staff memo" value={formData.staff_memo} onChange={(e) => setFormData((prev) => ({ ...prev, staff_memo: e.target.value }))} />
          <button type="submit">{editingSlot ? 'Update' : 'Create'}</button>
          <button type="button" onClick={closeForm}>Cancel</button>
        </form>
      )}

      <ul>
        {slots.map((s) => (
          <li key={s.id}>
            <strong>{s.id}</strong> | Service: {s.service_id} | Staff: {s.staff_member_id || 'N/A'} | {s.start_time} → {s.end_time} | Available: {s.available ? '✓' : '✗'}
            <button onClick={() => openEditForm(s)}>Edit</button>
            <button onClick={() => handleDelete(s.id)}>Delete</button>
          </li>
        ))}
      </ul>
    </div>
  )
}
