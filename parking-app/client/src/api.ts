import axios from 'axios'

const api = axios.create({ baseURL: '/api' })

api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token')
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})

export let currentOrg = localStorage.getItem('org') || ''
export let currentRole: 'admin' | 'client' = (localStorage.getItem('role') as 'admin' | 'client') || 'client'

export function setAuth(token: string, org: string, role: 'admin' | 'client') {
  localStorage.setItem('token', token)
  localStorage.setItem('org', org)
  localStorage.setItem('role', role)
  currentOrg = org
  currentRole = role
}

export function clearAuth() {
  localStorage.removeItem('token')
  localStorage.removeItem('org')
  localStorage.removeItem('role')
  currentOrg = ''
  currentRole = 'client'
}

export function isAuthenticated() {
  return !!localStorage.getItem('token')
}

export function login(email: string, password: string) {
  return api.post('/auth/login', { email, password })
}

export function deleteParkingLot(id: number) {
  return api.delete(`/${currentOrg}/parking_lots/${id}`)
}

export function updateParkingLot(id: number, data: Record<string, unknown>) {
  return api.put(`/${currentOrg}/parking_lots/${id}`, data)
}

export function createParkingSpot(data: Record<string, unknown>) {
  return api.post(`/${currentOrg}/parking_spots`, data)
}

export function logout() {
  return api.post('/auth/logout').finally(clearAuth)
}

export function getParkingLots() {
  return api.get(`/${currentOrg}/parking_lots`)
}

export function getParkingLot(id: number) {
  return api.get(`/${currentOrg}/parking_lots/${id}`)
}

export function createParkingLot(data: Record<string, unknown>) {
  return api.post(`/${currentOrg}/parking_lots`, data)
}

export function getParkingSpots(lotId?: number) {
  const params = lotId ? `?parking_lot_id=${lotId}` : ''
  return api.get(`/${currentOrg}/parking_spots${params}`)
}

export function getVehicles() {
  return api.get(`/${currentOrg}/vehicles`)
}

export function createVehicle(data: Record<string, unknown>) {
  return api.post(`/${currentOrg}/vehicles`, data)
}

export function getReservations() {
  return api.get(`/${currentOrg}/reservations`)
}

export function createReservation(data: Record<string, unknown>) {
  return api.post(`/${currentOrg}/reservations`, data)
}

export function updateReservation(id: number, data: Record<string, unknown>) {
  return api.put(`/${currentOrg}/reservations/${id}`, data)
}

export default api
