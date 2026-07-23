import { describe, it, expect, vi, beforeEach } from 'vitest'
import { fetchServices, fetchService, fetchTimeSlots, createBooking } from '../api/client.js'

beforeEach(() => {
  vi.restoreAllMocks()
})

describe('fetchServices', () => {
  it('returns services for the given org slug', async () => {
    const mockServices = [{ id: 1, name: 'Haircut', active: true }]
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      json: () => Promise.resolve(mockServices)
    }))

    const result = await fetchServices('acme-salon')
    expect(result).toEqual(mockServices)
    expect(fetch).toHaveBeenCalledWith('/api/acme-salon/services')
  })

  it('throws on non-ok response', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: false,
      status: 500,
      json: () => Promise.resolve({ errors: ['Server error'] })
    }))

    await expect(fetchServices('acme-salon')).rejects.toThrow('Server error')
  })

  it('throws generic message when body has no errors', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: false,
      status: 503,
      json: () => Promise.resolve({})
    }))

    await expect(fetchServices('acme-salon')).rejects.toThrow('Request failed with status 503')
  })
})

describe('fetchService', () => {
  it('fetches a single service by id', async () => {
    const mockService = { id: 1, name: 'Manicure' }
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      json: () => Promise.resolve(mockService)
    }))

    const result = await fetchService('acme-salon', 1)
    expect(result).toEqual(mockService)
    expect(fetch).toHaveBeenCalledWith('/api/acme-salon/services/1')
  })
})

describe('fetchTimeSlots', () => {
  it('returns time slots for the given org slug', async () => {
    const mockSlots = [{ id: 1, service_id: 1, available: true }]
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      json: () => Promise.resolve(mockSlots)
    }))

    const result = await fetchTimeSlots('acme-salon')
    expect(result).toEqual(mockSlots)
    expect(fetch).toHaveBeenCalledWith('/api/acme-salon/time_slots')
  })
})

describe('createBooking', () => {
  it('posts booking data and returns the created booking', async () => {
    const bookingData = { service_id: 1, time_slot_id: 5, customer_name: 'Jane', customer_email: 'jane@test.com' }
    const created = { id: 42, ...bookingData, status: 'pending' }
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      status: 201,
      json: () => Promise.resolve(created)
    }))

    const result = await createBooking('acme-salon', bookingData)
    expect(result).toEqual(created)
    expect(fetch).toHaveBeenCalledWith('/api/acme-salon/bookings', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ booking: bookingData })
    })
  })

  it('throws validation errors from the API', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: false,
      status: 422,
      json: () => Promise.resolve({ errors: ["Customer name can't be blank"] })
    }))

    await expect(createBooking('acme-salon', {})).rejects.toThrow("Customer name can't be blank")
  })
})
