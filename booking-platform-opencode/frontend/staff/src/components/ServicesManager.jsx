import { useState, useEffect } from 'react'
import { fetchServices, fetchService, createService, updateService, discardService } from '../api/client.js'

export default function ServicesManager() {
  const [services, setServices] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [formVisible, setFormVisible] = useState(false)
  const [editingService, setEditingService] = useState(null)
  const [formData, setFormData] = useState({ name: '', description: '', active: true, draft: false })

  useEffect(() => {
    let cancelled = false
    fetchServices()
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
  }, [])

  function openCreateForm() {
    setFormData({ name: '', description: '', active: true, draft: false })
    setEditingService(null)
    setFormVisible(true)
  }

  function openEditForm(service) {
    setFormData({ name: service.name, description: service.description || '', active: service.active, draft: service.draft })
    setEditingService(service)
    setFormVisible(true)
  }

  function closeForm() {
    setFormVisible(false)
    setEditingService(null)
  }

  async function handleSubmit(e) {
    e.preventDefault()
    try {
      if (editingService) {
        const updated = await updateService(editingService.id, formData)
        setServices((prev) => prev.map((s) => (s.id === editingService.id ? updated : s)))
      } else {
        const created = await createService(formData)
        setServices((prev) => [...prev, created])
      }
      closeForm()
    } catch (err) {
      setError(err.message)
    }
  }

  async function handleDelete(id) {
    try {
      await discardService(id)
      setServices((prev) => prev.filter((s) => s.id !== id))
    } catch (err) {
      setError(err.message)
    }
  }

  if (loading) return <p role="status">Loading services...</p>
  if (error) return <p role="alert">Error: {error}</p>

  return (
    <div>
      <h2>Services Manager</h2>
      <button onClick={openCreateForm}>Create Service</button>

      {formVisible && (
        <form onSubmit={handleSubmit}>
          <h3>{editingService ? 'Edit Service' : 'New Service'}</h3>
          <input placeholder="Name" value={formData.name} onChange={(e) => setFormData((prev) => ({ ...prev, name: e.target.value }))} required />
          <textarea placeholder="Description" value={formData.description} onChange={(e) => setFormData((prev) => ({ ...prev, description: e.target.value }))} />
          <label><input type="checkbox" checked={formData.active} onChange={(e) => setFormData((prev) => ({ ...prev, active: e.target.checked }))} /> Active</label>
          <label><input type="checkbox" checked={formData.draft} onChange={(e) => setFormData((prev) => ({ ...prev, draft: e.target.checked }))} /> Draft</label>
          <button type="submit">{editingService ? 'Update' : 'Create'}</button>
          <button type="button" onClick={closeForm}>Cancel</button>
        </form>
      )}

      <ul>
        {services.map((s) => (
          <li key={s.id}>
            <strong>{s.name}</strong> | {s.description || 'No description'} | Active: {s.active ? '✓' : '✗'} | Draft: {s.draft ? '✓' : '✗'}
            <button onClick={() => openEditForm(s)}>Edit</button>
            <button onClick={() => handleDelete(s.id)}>Delete</button>
          </li>
        ))}
      </ul>
    </div>
  )
}
