import { useState, useEffect } from 'react'
import { fetchStaffMembers, fetchStaffMember, createStaffMember, updateStaffMember, discardStaffMember } from '../api/client.js'

export default function StaffMembersManager() {
  const [members, setMembers] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [formVisible, setFormVisible] = useState(false)
  const [editingMember, setEditingMember] = useState(null)
  const [formData, setFormData] = useState({ name: '', role: 'staff', email: '', phone: '', active: true })

  useEffect(() => {
    let cancelled = false
    fetchStaffMembers()
      .then((data) => {
        if (!cancelled) {
          setMembers(data)
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
    setFormData({ name: '', role: 'staff', email: '', phone: '', active: true })
    setEditingMember(null)
    setFormVisible(true)
  }

  function openEditForm(member) {
    setFormData({ name: member.name, role: member.role, email: member.email || '', phone: member.phone || '', active: member.active })
    setEditingMember(member)
    setFormVisible(true)
  }

  function closeForm() {
    setFormVisible(false)
    setEditingMember(null)
  }

  async function handleSubmit(e) {
    e.preventDefault()
    try {
      if (editingMember) {
        const updated = await updateStaffMember(editingMember.id, formData)
        setMembers((prev) => prev.map((m) => (m.id === editingMember.id ? updated : m)))
      } else {
        const created = await createStaffMember(formData)
        setMembers((prev) => [...prev, created])
      }
      closeForm()
    } catch (err) {
      setError(err.message)
    }
  }

  async function handleDelete(id) {
    try {
      await discardStaffMember(id)
      setMembers((prev) => prev.filter((m) => m.id !== id))
    } catch (err) {
      setError(err.message)
    }
  }

  if (loading) return <p role="status">Loading staff members...</p>
  if (error) return <p role="alert">Error: {error}</p>

  return (
    <div>
      <h2>Staff Members Manager</h2>
      <button onClick={openCreateForm}>Create Staff Member</button>

      {formVisible && (
        <form onSubmit={handleSubmit}>
          <h3>{editingMember ? 'Edit Staff Member' : 'New Staff Member'}</h3>
          <input placeholder="Name" value={formData.name} onChange={(e) => setFormData((prev) => ({ ...prev, name: e.target.value }))} required />
          <select value={formData.role} onChange={(e) => setFormData((prev) => ({ ...prev, role: e.target.value }))}>
            <option value="admin">Admin</option>
            <option value="manager">Manager</option>
            <option value="staff">Staff</option>
          </select>
          <input placeholder="Email" type="email" value={formData.email} onChange={(e) => setFormData((prev) => ({ ...prev, email: e.target.value }))} />
          <input placeholder="Phone" value={formData.phone} onChange={(e) => setFormData((prev) => ({ ...prev, phone: e.target.value }))} />
          <label><input type="checkbox" checked={formData.active} onChange={(e) => setFormData((prev) => ({ ...prev, active: e.target.checked }))} /> Active</label>
          <button type="submit">{editingMember ? 'Update' : 'Create'}</button>
          <button type="button" onClick={closeForm}>Cancel</button>
        </form>
      )}

      <ul>
        {members.map((m) => (
          <li key={m.id}>
            <strong>{m.name}</strong> | {m.role} | {m.email || 'No email'} | Active: {m.active ? '✓' : '✗'}
            <button onClick={() => openEditForm(m)}>Edit</button>
            <button onClick={() => handleDelete(m.id)}>Delete</button>
          </li>
        ))}
      </ul>
    </div>
  )
}
