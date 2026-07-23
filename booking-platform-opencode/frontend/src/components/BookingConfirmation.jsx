export default function BookingConfirmation({ booking, onReset }) {
  return (
    <div>
      <h2>Booking Confirmed!</h2>
      <dl>
        <dt>Booking ID</dt>
        <dd>{booking.id}</dd>
        <dt>Name</dt>
        <dd>{booking.customer_name}</dd>
        <dt>Email</dt>
        <dd>{booking.customer_email}</dd>
        {booking.customer_phone && (
          <>
            <dt>Phone</dt>
            <dd>{booking.customer_phone}</dd>
          </>
        )}
        <dt>Status</dt>
        <dd>{booking.status}</dd>
      </dl>
      <button onClick={onReset} type="button">Book Another Appointment</button>
    </div>
  )
}
