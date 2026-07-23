const BASE_URL = '/api'

async function handleResponse(response) {
  if (!response.ok) {
    const body = await response.json().catch(() => ({}))
    const message = body.errors?.join(', ') || `Request failed with status ${response.status}`
    throw new Error(message)
  }
  if (response.status === 204) return null
  return response.json()
}

export async function fetchServices(orgSlug) {
  const response = await fetch(`${BASE_URL}/${orgSlug}/services`)
  return handleResponse(response)
}

export async function fetchService(orgSlug, serviceId) {
  const response = await fetch(`${BASE_URL}/${orgSlug}/services/${serviceId}`)
  return handleResponse(response)
}

export async function fetchTimeSlots(orgSlug) {
  const response = await fetch(`${BASE_URL}/${orgSlug}/time_slots`)
  return handleResponse(response)
}

export async function createTimeSlot(orgSlug, timeSlotData) {
  const response = await fetch(`${BASE_URL}/${orgSlug}/time_slots`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ time_slot: timeSlotData })
  })
  return handleResponse(response)
}

export async function createBooking(orgSlug, bookingData) {
  const response = await fetch(`${BASE_URL}/${orgSlug}/bookings`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ booking: bookingData })
  })
  return handleResponse(response)
}
