export default function StaffDashboard() {
  const resources = [
    { name: 'Services', path: '/services' },
    { name: 'Staff Members', path: '/staff-members' },
    { name: 'Time Slots', path: '/time-slots' },
    { name: 'Bookings', path: '/bookings' },
  ]

  return (
    <div>
      <h1>Admin Dashboard</h1>
      <nav>
        <ul>
          {resources.map((r) => (
            <li key={r.path}>
              <a href={`/staff${r.path}`}>{r.name}</a>
            </li>
          ))}
        </ul>
      </nav>
    </div>
  )
}
