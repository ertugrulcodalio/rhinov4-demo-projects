import { useState, useEffect } from 'react'
import { fetchServices } from '../api/client.js'

export default function ServiceList({ orgSlug, onSelect }) {
  const [services, setServices] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  useEffect(() => {
    let cancelled = false
    setLoading(true)
    fetchServices(orgSlug)
      .then((data) => {
        if (!cancelled) {
          setServices(data)
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
  }, [orgSlug])

  if (loading) return <p role="status">Loading services...</p>
  if (error) return <p role="alert">Error: {error}</p>
  if (services.length === 0) return <p>No services available.</p>

  return (
    <div>
      <h2>Choose a Service</h2>
      <ul>
        {services.map((service) => (
          <li key={service.id}>
            <button onClick={() => onSelect(service)} type="button">
              <strong>{service.name}</strong>
              {service.description && <p>{service.description}</p>}
            </button>
          </li>
        ))}
      </ul>
    </div>
  )
}
