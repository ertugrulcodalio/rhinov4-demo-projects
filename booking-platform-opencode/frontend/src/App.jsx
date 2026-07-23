import { useState } from 'react'
import ServiceList from './components/ServiceList.jsx'
import TimeSlotPicker from './components/TimeSlotPicker.jsx'
import BookingForm from './components/BookingForm.jsx'
import BookingConfirmation from './components/BookingConfirmation.jsx'

const ORG_SLUG = 'acme-salon'

const STEPS = {
  SERVICES: 'services',
  TIME_SLOTS: 'time_slots',
  BOOKING_FORM: 'booking_form',
  CONFIRMATION: 'confirmation'
}

export default function App() {
  const [step, setStep] = useState(STEPS.SERVICES)
  const [selectedService, setSelectedService] = useState(null)
  const [selectedTimeSlot, setSelectedTimeSlot] = useState(null)
  const [booking, setBooking] = useState(null)

  function handleServiceSelect(service) {
    setSelectedService(service)
    setStep(STEPS.TIME_SLOTS)
  }

  function handleTimeSlotSelect(slot) {
    setSelectedTimeSlot(slot)
    setStep(STEPS.BOOKING_FORM)
  }

  function handleBooked(createdBooking) {
    setBooking(createdBooking)
    setStep(STEPS.CONFIRMATION)
  }

  function handleReset() {
    setSelectedService(null)
    setSelectedTimeSlot(null)
    setBooking(null)
    setStep(STEPS.SERVICES)
  }

  return (
    <main>
      <h1>Book an Appointment</h1>
      {step === STEPS.SERVICES && (
        <ServiceList orgSlug={ORG_SLUG} onSelect={handleServiceSelect} />
      )}
      {step === STEPS.TIME_SLOTS && (
        <TimeSlotPicker
          orgSlug={ORG_SLUG}
          service={selectedService}
          onSelect={handleTimeSlotSelect}
          onBack={() => setStep(STEPS.SERVICES)}
        />
      )}
      {step === STEPS.BOOKING_FORM && (
        <BookingForm
          orgSlug={ORG_SLUG}
          service={selectedService}
          timeSlot={selectedTimeSlot}
          onBooked={handleBooked}
          onBack={() => setStep(STEPS.TIME_SLOTS)}
        />
      )}
      {step === STEPS.CONFIRMATION && (
        <BookingConfirmation booking={booking} onReset={handleReset} />
      )}
    </main>
  )
}
