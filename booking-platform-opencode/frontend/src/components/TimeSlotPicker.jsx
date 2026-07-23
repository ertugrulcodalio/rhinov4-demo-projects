import { useState, useEffect } from 'react'
import { fetchTimeSlots } from '../api/client.js'

export default function TimeSlotPicker({ orgSlug, service, onSelect, onBack }) {
  const [slots, setSlots] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  useEffect(() => {
    let cancelled = false
    setLoading(true)
    fetchTimeSlots(orgSlug)
      .then((data) => {
        if (!cancelled) {
          setSlots(data.filter((s) => s.service_id === service.id && s.available))
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
  }, [orgSlug, service.id])

  function formatTime(isoString) {
    return new Date(isoString).toLocaleString(undefined, {
      weekday: 'short', month: 'short', day: 'numeric',
      hour: '2-digit', minute: '2-digit'
    })
  }

  if (loading) return <p role="status">Loading time slots...</p>
  if (error) return <p role="alert">Error: {error}</p>

  return (
    <div>
      <button onClick={onBack} type="button">&larr; Back to services</button>
      <h2>Select a Time Slot for {service.name}</h2>
      {slots.length === 0 ? (
        <p>No available time slots for this service.</p>
      ) : (
        <ul>
          {slots.map((slot) => (
            <li key={slot.id}>
              <button onClick={() => onSelect(slot)} type="button">
                {formatTime(slot.start_time)} &ndash; {formatTime(slot.end_time)}
              </button>
            </li>
          ))}
        </ul>
      )}
    </div>
  )
}
