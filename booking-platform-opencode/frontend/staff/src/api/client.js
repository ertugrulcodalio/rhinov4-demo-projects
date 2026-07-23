const BASE_URL = '/api/staff'

async function handleResponse(response) {
  if (!response.ok) {
    const body = await response.json().catch(() => ({}))
    const message = body.errors?.join(', ') || `Request failed with status ${response.status}`
    throw new Error(message)
  }
  if (response.status === 204) return null
  return response.json()
}

export async function fetchServices() {
  const response = await fetch(`${BASE_URL}/services`)
  return handleResponse(response)
}

export async function fetchService(id) {
  const response = await fetch(`${BASE_URL}/services/${id}`)
  return handleResponse(response)
}

export async function createService(data) {
  const response = await fetch(`${BASE_URL}/services`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ service: data })
  })
  return handleResponse(response)
}

export async function updateService(id, data) {
  const response = await fetch(`${BASE_URL}/services/${id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ service: data })
  })
  return handleResponse(response)
}

export async function discardService(id) {
  const response = await fetch(`${BASE_URL}/services/${id}`, {
    method: 'DELETE'
  })
  return handleResponse(response)
}

export async function fetchStaffMembers() {
  const response = await fetch(`${BASE_URL}/staff_members`)
  return handleResponse(response)
}

export async function fetchStaffMember(id) {
  const response = await fetch(`${BASE_URL}/staff_members/${id}`)
  return handleResponse(response)
}

export async function createStaffMember(data) {
  const response = await fetch(`${BASE_URL}/staff_members`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ staff_member: data })
  })
  return handleResponse(response)
}

export async function updateStaffMember(id, data) {
  const response = await fetch(`${BASE_URL}/staff_members/${id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ staff_member: data })
  })
  return handleResponse(response)
}

export async function discardStaffMember(id) {
  const response = await fetch(`${BASE_URL}/staff_members/${id}`, {
    method: 'DELETE'
  })
  return handleResponse(response)
}

export async function fetchTimeSlots() {
  const response = await fetch(`${BASE_URL}/time_slots`)
  return handleResponse(response)
}

export async function fetchTimeSlot(id) {
  const response = await fetch(`${BASE_URL}/time_slots/${id}`)
  return handleResponse(response)
}

export async function createTimeSlot(data) {
  const response = await fetch(`${BASE_URL}/time_slots`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ time_slot: data })
  })
  return handleResponse(response)
}

export async function updateTimeSlot(id, data) {
  const response = await fetch(`${BASE_URL}/time_slots/${id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ time_slot: data })
  })
  return handleResponse(response)
}

export async function discardTimeSlot(id) {
  const response = await fetch(`${BASE_URL}/time_slots/${id}`, {
    method: 'DELETE'
  })
  return handleResponse(response)
}

export async function fetchBookings() {
  const response = await fetch(`${BASE_URL}/bookings`)
  return handleResponse(response)
}

export async function fetchBooking(id) {
  const response = await fetch(`${BASE_URL}/bookings/${id}`)
  return handleResponse(response)
}

export async function createBooking(data) {
  const response = await fetch(`${BASE_URL}/bookings`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ booking: data })
  })
  return handleResponse(response)
}

export async function updateBooking(id, data) {
  const response = await fetch(`${BASE_URL}/bookings/${id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ booking: data })
  })
  return handleResponse(response)
}

export async function discardBooking(id) {
  const response = await fetch(`${BASE_URL}/bookings/${id}`, {
    method: 'DELETE'
  })
  return handleResponse(response)
}
