import { useState } from 'react'
import { QueryClient, QueryClientProvider, useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import * as api from './api'
import './App.css'

const queryClient = new QueryClient()

function LoginPage({ onLogin }: { onLogin: () => void }) {
  const [email, setEmail] = useState('alice@acme.com')
  const [password, setPassword] = useState('password')
  const [org, setOrg] = useState('acme-corp')
  const [role, setRole] = useState<'admin' | 'client'>('admin')
  const [error, setError] = useState('')

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setError('')
    try {
      const res = await api.login(email, password)
      api.setAuth(res.data.token, org, role)
      onLogin()
    } catch {
      setError('Invalid credentials')
    }
  }

  return (
    <div className="login-container">
      <h1>🅿️ Parking Manager</h1>
      <form onSubmit={handleSubmit} className="login-form">
        <h2>Sign In</h2>
        {error && <div className="error">{error}</div>}
        <input value={email} onChange={e => setEmail(e.target.value)} placeholder="Email" type="email" required />
        <input value={password} onChange={e => setPassword(e.target.value)} placeholder="Password" type="password" required />
        <input value={org} onChange={e => setOrg(e.target.value)} placeholder="Organization slug (e.g. acme-corp)" required />
        <div className="role-select">
          <label className={role === 'admin' ? 'role-btn active' : 'role-btn'} onClick={() => setRole('admin')}>
            <input type="radio" name="role" value="admin" checked={role === 'admin'} onChange={() => setRole('admin')} />
            Admin
          </label>
          <label className={role === 'client' ? 'role-btn active' : 'role-btn'} onClick={() => setRole('client')}>
            <input type="radio" name="role" value="client" checked={role === 'client'} onChange={() => setRole('client')} />
            Client
          </label>
        </div>
        <button type="submit">Sign In</button>
        <p className="hint">Default: alice@acme.com / password / acme-corp</p>
      </form>
    </div>
  )
}

// ── Admin views ───────────────────────────────────────────────────────────────

function AdminLots() {
  const qc = useQueryClient()
  const { data, isLoading } = useQuery({
    queryKey: ['parking_lots'],
    queryFn: () => api.getParkingLots().then(r => r.data.data),
  })
  const [showForm, setShowForm] = useState(false)
  const [name, setName] = useState('')
  const [address, setAddress] = useState('')
  const [spots, setSpots] = useState('50')

  const create = useMutation({
    mutationFn: () => api.createParkingLot({ name, address, total_spots: parseInt(spots) }),
    onSuccess: () => { qc.invalidateQueries({ queryKey: ['parking_lots'] }); setShowForm(false); setName(''); setAddress(''); setSpots('50') },
  })
  const remove = useMutation({
    mutationFn: (id: number) => api.deleteParkingLot(id),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['parking_lots'] }),
  })

  if (isLoading) return <div className="loading">Loading...</div>

  return (
    <div>
      <div className="section-header">
        <h2>Parking Lots</h2>
        <button onClick={() => setShowForm(!showForm)}>+ Add Lot</button>
      </div>
      {showForm && (
        <form className="inline-form" onSubmit={e => { e.preventDefault(); create.mutate() }}>
          <input value={name} onChange={e => setName(e.target.value)} placeholder="Name" required />
          <input value={address} onChange={e => setAddress(e.target.value)} placeholder="Address" required />
          <input value={spots} onChange={e => setSpots(e.target.value)} placeholder="Total spots" type="number" required />
          <button type="submit" disabled={create.isPending}>Create</button>
          <button type="button" onClick={() => setShowForm(false)}>Cancel</button>
        </form>
      )}
      <table>
        <thead><tr><th>ID</th><th>Name</th><th>Address</th><th>Total Spots</th><th>Actions</th></tr></thead>
        <tbody>
          {data?.map((lot: any) => (
            <tr key={lot.id}>
              <td>{lot.id}</td><td>{lot.name}</td><td>{lot.address}</td><td>{lot.total_spots}</td>
              <td><button onClick={() => remove.mutate(lot.id)}>Delete</button></td>
            </tr>
          ))}
          {(!data || data.length === 0) && <tr><td colSpan={5} className="empty">No parking lots yet</td></tr>}
        </tbody>
      </table>
    </div>
  )
}

function AdminSpots() {
  const qc = useQueryClient()
  const { data: lots } = useQuery({ queryKey: ['parking_lots'], queryFn: () => api.getParkingLots().then(r => r.data.data) })
  const { data, isLoading } = useQuery({
    queryKey: ['parking_spots'],
    queryFn: () => api.getParkingSpots().then(r => r.data.data),
  })
  const [showForm, setShowForm] = useState(false)
  const [lotId, setLotId] = useState('')
  const [number, setNumber] = useState('')
  const [spotType, setSpotType] = useState('standard')

  const create = useMutation({
    mutationFn: () => api.createParkingSpot({ number, spot_type: spotType, is_available: true, parking_lot_id: parseInt(lotId) }),
    onSuccess: () => { qc.invalidateQueries({ queryKey: ['parking_spots'] }); setShowForm(false); setNumber('') },
  })

  if (isLoading) return <div className="loading">Loading...</div>

  return (
    <div>
      <div className="section-header">
        <h2>Parking Spots</h2>
        <button onClick={() => setShowForm(!showForm)}>+ Add Spot</button>
      </div>
      {showForm && (
        <form className="inline-form" onSubmit={e => { e.preventDefault(); create.mutate() }}>
          <select value={lotId} onChange={e => setLotId(e.target.value)} required>
            <option value="">Select Lot</option>
            {lots?.map((l: any) => <option key={l.id} value={l.id}>{l.name}</option>)}
          </select>
          <input value={number} onChange={e => setNumber(e.target.value)} placeholder="Spot number (e.g. A1)" required />
          <select value={spotType} onChange={e => setSpotType(e.target.value)}>
            <option value="standard">Standard</option>
            <option value="compact">Compact</option>
            <option value="handicapped">Handicapped</option>
            <option value="ev">EV</option>
          </select>
          <button type="submit" disabled={create.isPending}>Create</button>
          <button type="button" onClick={() => setShowForm(false)}>Cancel</button>
        </form>
      )}
      <table>
        <thead><tr><th>ID</th><th>Number</th><th>Type</th><th>Available</th><th>Lot</th></tr></thead>
        <tbody>
          {data?.map((spot: any) => (
            <tr key={spot.id}>
              <td>{spot.id}</td><td>{spot.number}</td><td>{spot.spot_type}</td>
              <td><span className={spot.is_available ? 'badge green' : 'badge red'}>{spot.is_available ? 'Available' : 'Occupied'}</span></td>
              <td>{lots?.find((l: any) => l.id === spot.parking_lot_id)?.name ?? spot.parking_lot_id}</td>
            </tr>
          ))}
          {(!data || data.length === 0) && <tr><td colSpan={5} className="empty">No spots yet</td></tr>}
        </tbody>
      </table>
    </div>
  )
}

function AdminVehicles() {
  const { data, isLoading } = useQuery({
    queryKey: ['vehicles'],
    queryFn: () => api.getVehicles().then(r => r.data.data),
  })
  if (isLoading) return <div className="loading">Loading...</div>
  return (
    <div>
      <div className="section-header"><h2>All Vehicles</h2></div>
      <table>
        <thead><tr><th>ID</th><th>Plate</th><th>Make</th><th>Model</th><th>Color</th><th>Type</th></tr></thead>
        <tbody>
          {data?.map((v: any) => (
            <tr key={v.id}><td>{v.id}</td><td>{v.license_plate}</td><td>{v.make}</td><td>{v.model}</td><td>{v.color}</td><td>{v.vehicle_type}</td></tr>
          ))}
          {(!data || data.length === 0) && <tr><td colSpan={6} className="empty">No vehicles</td></tr>}
        </tbody>
      </table>
    </div>
  )
}

function AdminReservations() {
  const qc = useQueryClient()
  const { data, isLoading } = useQuery({
    queryKey: ['reservations'],
    queryFn: () => api.getReservations().then(r => r.data.data),
  })
  const updateStatus = useMutation({
    mutationFn: ({ id, status }: { id: number; status: string }) => api.updateReservation(id, { status }),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['reservations'] }),
  })
  if (isLoading) return <div className="loading">Loading...</div>
  return (
    <div>
      <div className="section-header"><h2>All Reservations</h2></div>
      <table>
        <thead><tr><th>ID</th><th>Status</th><th>Start</th><th>End</th><th>Cost</th><th>Actions</th></tr></thead>
        <tbody>
          {data?.map((r: any) => (
            <tr key={r.id}>
              <td>{r.id}</td>
              <td><span className={`badge ${r.status === 'active' ? 'green' : r.status === 'cancelled' ? 'red' : r.status === 'completed' ? 'blue' : 'gray'}`}>{r.status}</span></td>
              <td>{r.start_time ? new Date(r.start_time).toLocaleString() : '-'}</td>
              <td>{r.end_time ? new Date(r.end_time).toLocaleString() : '-'}</td>
              <td>{r.total_cost ? `$${r.total_cost}` : '-'}</td>
              <td>
                {r.status === 'pending' && <button onClick={() => updateStatus.mutate({ id: r.id, status: 'active' })}>Activate</button>}
                {r.status === 'active' && <button onClick={() => updateStatus.mutate({ id: r.id, status: 'completed' })}>Complete</button>}
                {(r.status === 'pending' || r.status === 'active') && <button onClick={() => updateStatus.mutate({ id: r.id, status: 'cancelled' })}>Cancel</button>}
              </td>
            </tr>
          ))}
          {(!data || data.length === 0) && <tr><td colSpan={6} className="empty">No reservations</td></tr>}
        </tbody>
      </table>
    </div>
  )
}

// ── Client views ──────────────────────────────────────────────────────────────

function ClientVehicles() {
  const qc = useQueryClient()
  const { data, isLoading } = useQuery({
    queryKey: ['vehicles'],
    queryFn: () => api.getVehicles().then(r => r.data.data),
  })
  const [showForm, setShowForm] = useState(false)
  const [plate, setPlate] = useState('')
  const [make, setMake] = useState('')
  const [model, setModel] = useState('')
  const [color, setColor] = useState('')
  const [type, setType] = useState('car')

  const create = useMutation({
    mutationFn: () => api.createVehicle({ license_plate: plate, make, model, color, vehicle_type: type }),
    onSuccess: () => { qc.invalidateQueries({ queryKey: ['vehicles'] }); setShowForm(false); setPlate(''); setMake(''); setModel(''); setColor('') },
  })

  if (isLoading) return <div className="loading">Loading...</div>

  return (
    <div>
      <div className="section-header">
        <h2>My Vehicles</h2>
        <button onClick={() => setShowForm(!showForm)}>+ Add Vehicle</button>
      </div>
      {showForm && (
        <form className="inline-form" onSubmit={e => { e.preventDefault(); create.mutate() }}>
          <input value={plate} onChange={e => setPlate(e.target.value)} placeholder="License Plate" required />
          <input value={make} onChange={e => setMake(e.target.value)} placeholder="Make" />
          <input value={model} onChange={e => setModel(e.target.value)} placeholder="Model" />
          <input value={color} onChange={e => setColor(e.target.value)} placeholder="Color" />
          <select value={type} onChange={e => setType(e.target.value)}>
            <option value="car">Car</option>
            <option value="motorcycle">Motorcycle</option>
            <option value="truck">Truck</option>
          </select>
          <button type="submit" disabled={create.isPending}>Add</button>
          <button type="button" onClick={() => setShowForm(false)}>Cancel</button>
        </form>
      )}
      <table>
        <thead><tr><th>Plate</th><th>Make</th><th>Model</th><th>Color</th><th>Type</th></tr></thead>
        <tbody>
          {data?.map((v: any) => (
            <tr key={v.id}><td>{v.license_plate}</td><td>{v.make}</td><td>{v.model}</td><td>{v.color}</td><td>{v.vehicle_type}</td></tr>
          ))}
          {(!data || data.length === 0) && <tr><td colSpan={5} className="empty">No vehicles yet — add one to make a reservation</td></tr>}
        </tbody>
      </table>
    </div>
  )
}

function ClientSpots() {
  const { data: lots } = useQuery({ queryKey: ['parking_lots'], queryFn: () => api.getParkingLots().then(r => r.data.data) })
  const { data, isLoading } = useQuery({
    queryKey: ['parking_spots'],
    queryFn: () => api.getParkingSpots().then(r => r.data.data),
  })

  const available = data?.filter((s: any) => s.is_available) ?? []

  if (isLoading) return <div className="loading">Loading...</div>

  return (
    <div>
      <div className="section-header">
        <h2>Available Spots</h2>
        <span className="badge green">{available.length} available</span>
      </div>
      <table>
        <thead><tr><th>Spot</th><th>Type</th><th>Lot</th><th>Address</th></tr></thead>
        <tbody>
          {available.map((spot: any) => {
            const lot = lots?.find((l: any) => l.id === spot.parking_lot_id)
            return (
              <tr key={spot.id}>
                <td><strong>{spot.number}</strong></td>
                <td><span className="badge blue">{spot.spot_type}</span></td>
                <td>{lot?.name ?? spot.parking_lot_id}</td>
                <td>{lot?.address ?? '-'}</td>
              </tr>
            )
          })}
          {available.length === 0 && <tr><td colSpan={4} className="empty">No available spots right now</td></tr>}
        </tbody>
      </table>
    </div>
  )
}

function ClientReservations() {
  const qc = useQueryClient()
  const { data, isLoading } = useQuery({
    queryKey: ['reservations'],
    queryFn: () => api.getReservations().then(r => r.data.data),
  })
  const { data: vehicles } = useQuery({ queryKey: ['vehicles'], queryFn: () => api.getVehicles().then(r => r.data.data) })
  const { data: spots } = useQuery({ queryKey: ['parking_spots'], queryFn: () => api.getParkingSpots().then(r => r.data.data) })

  const [showForm, setShowForm] = useState(false)
  const [vehicleId, setVehicleId] = useState('')
  const [spotId, setSpotId] = useState('')
  const [startTime, setStartTime] = useState('')
  const [endTime, setEndTime] = useState('')

  const create = useMutation({
    mutationFn: () => api.createReservation({
      vehicle_id: parseInt(vehicleId),
      parking_spot_id: parseInt(spotId),
      start_time: startTime,
      end_time: endTime,
      status: 'pending',
    }),
    onSuccess: () => { qc.invalidateQueries({ queryKey: ['reservations'] }); setShowForm(false); setVehicleId(''); setSpotId('') },
  })

  const cancel = useMutation({
    mutationFn: (id: number) => api.updateReservation(id, { status: 'cancelled' }),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['reservations'] }),
  })

  const availableSpots = spots?.filter((s: any) => s.is_available) ?? []

  if (isLoading) return <div className="loading">Loading...</div>

  return (
    <div>
      <div className="section-header">
        <h2>My Reservations</h2>
        <button onClick={() => setShowForm(!showForm)}>+ New Reservation</button>
      </div>
      {showForm && (
        <form className="inline-form" onSubmit={e => { e.preventDefault(); create.mutate() }}>
          <select value={vehicleId} onChange={e => setVehicleId(e.target.value)} required>
            <option value="">Select Vehicle</option>
            {vehicles?.map((v: any) => <option key={v.id} value={v.id}>{v.license_plate} — {v.make} {v.model}</option>)}
          </select>
          <select value={spotId} onChange={e => setSpotId(e.target.value)} required>
            <option value="">Select Spot</option>
            {availableSpots.map((s: any) => <option key={s.id} value={s.id}>Spot {s.number} ({s.spot_type})</option>)}
          </select>
          <input type="datetime-local" value={startTime} onChange={e => setStartTime(e.target.value)} required />
          <input type="datetime-local" value={endTime} onChange={e => setEndTime(e.target.value)} required />
          <button type="submit" disabled={create.isPending}>Reserve</button>
          <button type="button" onClick={() => setShowForm(false)}>Cancel</button>
        </form>
      )}
      <table>
        <thead><tr><th>Status</th><th>Spot</th><th>Start</th><th>End</th><th>Cost</th><th></th></tr></thead>
        <tbody>
          {data?.map((r: any) => (
            <tr key={r.id}>
              <td><span className={`badge ${r.status === 'active' ? 'green' : r.status === 'cancelled' ? 'red' : r.status === 'completed' ? 'blue' : 'gray'}`}>{r.status}</span></td>
              <td>{spots?.find((s: any) => s.id === r.parking_spot_id)?.number ?? r.parking_spot_id}</td>
              <td>{r.start_time ? new Date(r.start_time).toLocaleString() : '-'}</td>
              <td>{r.end_time ? new Date(r.end_time).toLocaleString() : '-'}</td>
              <td>{r.total_cost ? `$${r.total_cost}` : '-'}</td>
              <td>{(r.status === 'pending' || r.status === 'active') && <button onClick={() => cancel.mutate(r.id)}>Cancel</button>}</td>
            </tr>
          ))}
          {(!data || data.length === 0) && <tr><td colSpan={6} className="empty">No reservations yet</td></tr>}
        </tbody>
      </table>
    </div>
  )
}

// ── Dashboards ────────────────────────────────────────────────────────────────

type AdminTab = 'lots' | 'spots' | 'vehicles' | 'reservations'
type ClientTab = 'vehicles' | 'spots' | 'reservations'

function AdminDashboard({ onLogout }: { onLogout: () => void }) {
  const [tab, setTab] = useState<AdminTab>('lots')
  return (
    <div className="dashboard">
      <nav>
        <span className="brand">🅿️ Parking Manager</span>
        <span className="org-badge">{api.currentOrg}</span>
        <span className="role-badge admin">Admin</span>
        <div className="tabs">
          <button className={tab === 'lots' ? 'active' : ''} onClick={() => setTab('lots')}>Lots</button>
          <button className={tab === 'spots' ? 'active' : ''} onClick={() => setTab('spots')}>Spots</button>
          <button className={tab === 'vehicles' ? 'active' : ''} onClick={() => setTab('vehicles')}>Vehicles</button>
          <button className={tab === 'reservations' ? 'active' : ''} onClick={() => setTab('reservations')}>Reservations</button>
        </div>
        <button className="logout" onClick={() => { api.clearAuth(); onLogout() }}>Sign Out</button>
      </nav>
      <main>
        {tab === 'lots' && <AdminLots />}
        {tab === 'spots' && <AdminSpots />}
        {tab === 'vehicles' && <AdminVehicles />}
        {tab === 'reservations' && <AdminReservations />}
      </main>
    </div>
  )
}

function ClientDashboard({ onLogout }: { onLogout: () => void }) {
  const [tab, setTab] = useState<ClientTab>('reservations')
  return (
    <div className="dashboard">
      <nav>
        <span className="brand">🅿️ Parking Manager</span>
        <span className="org-badge">{api.currentOrg}</span>
        <span className="role-badge client">Client</span>
        <div className="tabs">
          <button className={tab === 'reservations' ? 'active' : ''} onClick={() => setTab('reservations')}>My Reservations</button>
          <button className={tab === 'vehicles' ? 'active' : ''} onClick={() => setTab('vehicles')}>My Vehicles</button>
          <button className={tab === 'spots' ? 'active' : ''} onClick={() => setTab('spots')}>Available Spots</button>
        </div>
        <button className="logout" onClick={() => { api.clearAuth(); onLogout() }}>Sign Out</button>
      </nav>
      <main>
        {tab === 'reservations' && <ClientReservations />}
        {tab === 'vehicles' && <ClientVehicles />}
        {tab === 'spots' && <ClientSpots />}
      </main>
    </div>
  )
}

function App() {
  const [authed, setAuthed] = useState(api.isAuthenticated())
  const [role, setRole] = useState(api.currentRole)

  const handleLogin = () => {
    setAuthed(true)
    setRole(api.currentRole)
  }

  const handleLogout = () => {
    setAuthed(false)
    setRole('client')
  }

  return (
    <QueryClientProvider client={queryClient}>
      {!authed
        ? <LoginPage onLogin={handleLogin} />
        : role === 'admin'
          ? <AdminDashboard onLogout={handleLogout} />
          : <ClientDashboard onLogout={handleLogout} />
      }
    </QueryClientProvider>
  )
}

export default App
