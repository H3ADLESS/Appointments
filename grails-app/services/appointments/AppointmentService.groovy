package appointments

import appointments.notfications.NotificationType
import biweekly.Biweekly
import biweekly.ICalendar
import biweekly.component.VEvent
import biweekly.property.Summary
import biweekly.util.Frequency
import biweekly.util.Recurrence
import grails.transaction.Transactional

import java.time.Duration

@Transactional
class AppointmentService {

    def springSecurityService
    def mailService

    /**
     * Sets the duration of the appointment according to the limits set by the lecturer. If the appointment is made by
     * the office-hour-owner then the limit can be exceeded.
     */
    def setMaxDuration(params, OfficeHour officeHour, Appointment appointment, User user){
        int durationSet = Integer.parseInt(params.duration)
        Lecturer ohOwner = officeHour.lecturer
        appointment.duration = durationSet
        // if maxDuration is exceeded by somebody else than officeHour-owner or their assistants
        if (user != ohOwner && !ohOwner.assistants.contains(user)){
            if (officeHour.maxDurationInMinutes > 0 && durationSet > officeHour.maxDurationInMinutes){
                appointment.duration = officeHour.maxDurationInMinutes
            }
        }
    }

    /**
     * Checks if the current user is the owner of the appointment or the owner of the office hour of the appointment
     * @param appointment
     * @returns true if the user has special rights to the appointment
     */
    public boolean authorized(Appointment appointment) {
        if (appointment == null) return true

        User user = springSecurityService.getCurrentUser()
        User prof = (User) appointment.officeHour.lecturer
        if (!(appointment.user == user || prof == user)) {
            return false
        }
        return true
    }

    /**
     * Returns the maximum possible duration for the officeHour with the specified start date. It is limited by the
     * end of the officeHour, the next appointment or the constraints set by the lecturer
     * @param officeHour
     * @param start
     * @returns the maximum duration in minutes from the start date
     */
    public getMaxDuration(OfficeHour officeHour, Date start) {
        List<Appointment> appointments = Appointment.findAllByOfficeHourAndStartGreaterThan(officeHour, start)
        def x = appointments.min{
            it.start
        }

        long getTimeUntilNextAppointment
        long timeToNextAppointment = 0L
        if (x) {
            timeToNextAppointment = x.start.getTime() - start.getTime()
        }
        long timeToEnd = officeHour.end.getTime() - start.getTime()

        int maxDuration
        if (timeToNextAppointment != 0L) {
            maxDuration = (Math.min(timeToEnd, timeToNextAppointment) / 1000 / 60)
            if (officeHour.maxDurationInMinutes > 0) {
                maxDuration = (Math.min(maxDuration, officeHour.maxDurationInMinutes))
            }
        } else {
            maxDuration = (timeToEnd / 1000 / 60)
            if (officeHour.maxDurationInMinutes > 0) {
                maxDuration = (Math.min(maxDuration, officeHour.maxDurationInMinutes))
            }
        }
        return maxDuration
    }

    /**
     * Checks if the given appointment is overlapped by other appointments or the end of the office hour.
     * @param appointment
     * @returns true if the appointment has no conflict in time
     */
    def synchronized boolean checkIfFree(Appointment appointment){
        if (!appointment || !appointment.officeHour || !appointment.start || !appointment.end) {
            throw new IllegalArgumentException("Appointment must be not null. It must have an assigned officeHour, start and end.")
        }

        List<Appointment> appointments = Appointment.findAllByOfficeHourAndStartLessThanAndEndGreaterThan(appointment.officeHour, appointment.end, appointment.start)

        if(appointments.size() > 0) {
            // Zeitraum schon blockiert
            return false;
        }

        // Zeitraum noch frei
        if (appointment.end > appointment.officeHour.end) {
            // Der Termin darf nicht über die verfügbare Zeit hinausgehen
            return false;
        }

        return true;
    }

    /**
     * Creates a new appointment if there are no problems
     * @param appointment
     * @returns true if appointment was created
     */
    def synchronized checkBlockedAndCreate(Appointment appointment) {
        if (!checkIfFree(appointment)){
            return false
        }

        appointment.save()
        return !appointment.hasErrors()
    }

    /**
     * Returns a list with all dates of officeHours given by the lecturer
     * @param lecturer
     * @return List of longs, representing the date of the officeHours
     */
    def getOfficeHourDates(Lecturer lecturer) {
        if (lecturer == null) {
            return null;
        }

        List<OfficeHour> hours = OfficeHour.findAllByLecturerAndStartGreaterThanAndDeadlineGreaterThan(lecturer, new Date(), new Date())

        List<Long> result = hours.collect {
            DateUtils.resetTime(it.start).getTime()
        }

        return result
    }

    /**
     * Gets the next officeHour after the given date
     * @param d
     * @param lecturer
     */
    def getNextOfficeHourAfter(Date d, Lecturer lecturer){
        Date date = DateUtils.getEndOfDay(d)
        OfficeHour oH = OfficeHour.findByLecturerAndStartGreaterThanAndDeadlineGreaterThan(lecturer, date, new Date(), [sort: 'start', order: 'asc'])
        return oH
    }

    /**
     * Gets the previous officeHour before the given date
     * @param d
     * @param lecturer
     */
    def getPrevOfficeHourBefore(Date d, Lecturer lecturer){
        Date date = DateUtils.resetTime(d)
        OfficeHour oH = OfficeHour.findByLecturerAndStartLessThanAndDeadlineGreaterThan(lecturer, date, new Date(), [sort: 'start', order: 'desc'])
        return oH
    }


    // #######################################################################
    // #######################################################################
    // ### The following methods are used to prepare appointment selection ###
    // #######################################################################
    // #######################################################################

    /**
     * This method collects all necessary information to render the appointment selection page
     * @param lecturer
     * @param date
     * @return a map with the necessary data to render the appointment selection
     */
    def List<Map> getOfficeHourSlots(Lecturer lecturer, Date date) {
        if (lecturer == null) {
            return null
        }

        if (date == null) {
            OfficeHour nextOfficeHour = OfficeHour.findByLecturerAndStartGreaterThanAndDeadlineGreaterThan(lecturer, new Date(), new Date(), [sort: 'start'])
            if (nextOfficeHour == null) {
                date = new Date()
            } else {
                date = DateUtils.resetTime(nextOfficeHour.start)
            }
        }

        Date d = DateUtils.getEndOfDay(date)
        List<OfficeHour> officeHours = OfficeHour.findAllByLecturerAndStartGreaterThanAndDeadlineGreaterThanAndStartLessThan(lecturer, date, new Date(), d, [sort: 'start'])

        if (officeHours.isEmpty()) {
            return null
        }

        buildSlots(officeHours)
    }

    def List<Map> getOfficeHourSlots(OfficeHour officeHour, Date startSlot = null) {
        buildSlots([officeHour], startSlot)
    }

    def buildSlots(List<OfficeHour> officeHours, Date slotDate = null){
        List<Map> officeHourSlots = []

        for (OfficeHour oH in officeHours) {

            int minHour = DateUtils.getHour(oH.start)
            int minMinute = DateUtils.getMinute(oH.start)

            int maxHour = DateUtils.getHour(oH.end)
            int maxMinute = DateUtils.getMinute(oH.end)

            List<Map> slots = []
            Map lastSlot = null
            for (int hour = minHour; hour <= maxHour; hour++ ) {
                if (hour == minHour && hour == maxHour) {
                    for (int minute = minMinute; minute < maxMinute; minute += 5) {
                        Map slot = getSlot(hour, minute, oH, lastSlot, slotDate)
                        lastSlot = slot
                        slots.add(slot)
                    }
                } else if (hour == minHour) {
                    for (int minute = minMinute; minute < 60; minute+=5 ) {
                        Map slot = getSlot(hour, minute, oH, lastSlot, slotDate)
                        lastSlot = slot
                        slots.add(slot)
                    }
                } else if (hour == maxHour) {
                    for (int minute = 0; minute < maxMinute; minute+=5 ) {
                        Map slot = getSlot(hour, minute, oH, lastSlot, slotDate)
                        lastSlot = slot
                        slots.add(slot)
                    }
                } else {
                    for (int minute = 0; minute < 60; minute+=5 ) {
                        Map slot = getSlot(hour, minute, oH, lastSlot, slotDate)
                        lastSlot = slot
                        slots.add(slot)
                    }
                }
            }

            officeHourSlots.add ([
                    date : DateUtils.resetTime(oH.start),
                    startHour: DateUtils.getHour(oH.start),
                    startMinute: DateUtils.getMinute(oH.start),
                    endHour: DateUtils.getHour(oH.end),
                    endMinute: DateUtils.getMinute(oH.end),
                    slots: slots,
                    publicTitle: oH.publicTitle,
                    publicDescription: oH.publicDescription,
                    maxDuration: oH.maxDurationInMinutes
            ]);
        }

        return officeHourSlots
    }

    def getSlot(int hour, int minute, OfficeHour officeHour, Map lastSlot, Date slotDate = null) {
        Date current = DateUtils.setTime(officeHour.start, hour, minute)
        Appointment appointmentBlockingSlot = null


        Map m
        if (current >= officeHour.start && current < officeHour.end){
            m = [officeHourId: officeHour.id, date: DateUtils.setTime(officeHour.start, hour, minute).getTime(), startHour: hour, startMinute: minute, officeHour: true, blocked: false, appointmentId: 0, even: true, first: true, rowspan: 1]

            appointmentBlockingSlot = getSlotBlockingAppointment(officeHour, hour, minute)
            if (appointmentBlockingSlot != null) {
                m.blocked = true
                m.appointmentId = appointmentBlockingSlot.id
            }
        } else {
            m = [officeHourId: officeHour.id, date: DateUtils.setTime(officeHour.start, hour, minute).getTime(), startHour: hour, startMinute: minute, officeHour: false, blocked: true, even: true, first: true, rowspan: 1]
        }

        if (lastSlot != null) {
            if (lastSlot.appointmentId == m.appointmentId && lastSlot.appointmentId != 0) {
                m.even = lastSlot.even
                m.first = false
            } else {
                m.even = !lastSlot.even
                m.first = true
            }
        }

        if (m.first && m.blocked && appointmentBlockingSlot) {
            int duration = DateUtils.getTimeDifferenceInMinutes(appointmentBlockingSlot.start, appointmentBlockingSlot.end)
            m.rowspan = duration.intdiv(5)
        }

        m = checkAndAddStartSlot(officeHour, hour, minute, slotDate, m, lastSlot)

        return m;
    }

    def checkAndAddStartSlot(OfficeHour officeHour, int hour, int minute, Date slotDate, Map m, Map lastSlot) {
        if (lastSlot != null && lastSlot.selectedSlot == true){
            m.put("afterSelectedSlot", true)
        }

        if (slotDate != null) {
            Date d1 = DateUtils.setTime(officeHour.start, hour, minute)
            if (d1 == slotDate) {
                m.put("selectedSlot", true)
            }
        }
        return m;
    }

    def Appointment getSlotBlockingAppointment(OfficeHour officeHour, int hour, int minute) {
        Date start = DateUtils.setTime(officeHour.start, hour, minute)
        Date end = DateUtils.setTime(officeHour.start, hour, minute + 5)

        if (officeHour.start > start || officeHour.end < end) {
            return true
        }

        Appointment appointment = Appointment.findByOfficeHourAndStartLessThanAndEndGreaterThan(officeHour, end, start)
        if (appointment) return appointment
        return null
    }

    // #######################################################################
    // #######################################################################
    // ####################### RESCHEDULE APPOINTMENTS #######################
    // #######################################################################
    // #######################################################################

    /**
     *
     * @param officeHour
     * @return List<OfficeHour> which are left over
     */
    def List<Appointment> rescheduleChangedOfficeHour(OfficeHour officeHour){
        List<Appointment> appointments = Appointment.findAllByOfficeHour(officeHour, [orderBy: 'start'])
        rescheduleIntoEmptyOfficeHour(officeHour, appointments)

    }

    def List<Appointment> rescheduleIntoEmptyOfficeHour(OfficeHour officeHour, List<Appointment> appointments) {
        Date nextAppointmentDate = officeHour.start

        Iterator iterator = appointments.iterator();
        while (iterator.hasNext()) {
            Appointment appointment = (Appointment) iterator.next();
            appointment.rescheduleTo(nextAppointmentDate, officeHour)
            if (appointment.end > officeHour.end) {
                // TODO: reschedule appointment to another officeHour or cancel it.
                println("TODO: reschedule appointment to another officeHour or cancel it.")
                appointment.discard()
                // Don't break here. Let's see if a smaller appointment could fit.
            } else {
                mailService.sendAppointmentNotification(appointment, NotificationType.APPOINTMENT_RESCHEDULED)
                appointment.save()
                iterator.remove()
                nextAppointmentDate = appointment.end
            }
        }

        return appointments
    }

    /**
     * Fits the given appointments into the given timeslot specified by start and end. This slot is considered as free.
     * @param start
     * @param end
     * @param officeHour
     * @param appointments
     * @return remaining appointments or empty list
     */
    def List<Appointment> fitIntoTimeSlot(Date start, Date end, OfficeHour officeHour, List<Appointment> appointments) {
        if (DateUtils.getTimeDifferenceInMinutes(start, end) == 0) {
            return appointments
        }

        if (appointments.size() == 0) {
            return appointments
        }

        Date currentTime = start
        while (currentTime < end && appointments.size() > 0) {
            int delta = DateUtils.getTimeDifferenceInMinutes(currentTime, end)
            Appointment a = appointments.find{it.getCurrentDuration() < delta}
            if (!a) {
                return appointments
            } else {
                a.rescheduleTo(currentTime, officeHour)
                a.save()
                appointments.remove(a)
            }
        }
        return appointments
    }

    /**
     * Fits the given appointments into left timeslots if possible. Returns remaining appointments
     * @param officeHour
     * @return remaining appointments
     */
    def List<Appointment> fitAppointmentsIntoOfficeHour(List<Appointment> appointments, OfficeHour officeHour) {
        List<Appointment> appointmentsToFit = appointments.sort {a, b -> b.getCurrentDuration() <=> a.getCurrentDuration()}
        List<Appointment> givenAppointments = officeHour.appointments.sort { it.start }

        if (givenAppointments.size() == 0) {
            // OfficeHour has no appointments: fill officeHour
            return rescheduleIntoEmptyOfficeHour(officeHour, appointmentsToFit)
        } else if (givenAppointments.size() == 1) {
            // OfficeHour has one appointment: fill before and after appointment
            // Slot between officeHour start and appointment
            appointmentsToFit = fitIntoTimeSlot(officeHour.start, givenAppointments.first().start, officeHour, appointmentsToFit)
            // Fill slots between appointment end and officeHour end
            appointmentsToFit = fitIntoTimeSlot(givenAppointments.first().end, officeHour.end, officeHour, appointmentsToFit)
            return appointmentsToFit
        } else {
            // Handle time between office hour start and first appointment
            appointmentsToFit = fitIntoTimeSlot(officeHour.start, givenAppointments.first().start, officeHour, appointmentsToFit)

            for (int i = 1; i < givenAppointments.size()-1; i++) {
                appointmentsToFit = fitIntoTimeSlot(givenAppointments.get(i).end, givenAppointments.get(i+1).start, officeHour, appointmentsToFit)
                if (appointmentsToFit.size() == 0) {
                    return appointmentsToFit
                }
            }
        }
        return appointmentsToFit
    }

    // TODO: notify participants
    /**
     * Fits appointments from a changed officeHour into other officeHours. If deleting mode is enabled all appointments of
     * the given officeHour are moved to other officeHours.
     * @param officeHour, deletingMode
     * @return remaining office hours that couldn't be moved or an empty list.
     */
    def List<Appointment> rescheduleAppointments(OfficeHour officeHour, boolean deletingMode = false) {
        List<Appointment> remainingAppointments = officeHour.appointments as List<Appointment>

        if (! deletingMode) {
            // if not deleting mode, the length has probably changed...
            remainingAppointments = rescheduleChangedOfficeHour(officeHour).sort { a, b -> b.getCurrentDuration() <=> a.getCurrentDuration() }
        } else {
            // Clear set before removing because of cascade
            officeHour.appointments.clear()
        }

        // Reschedule remaining appointments
        List<OfficeHour> nextOfficeHours = OfficeHour.findAllByLecturerAndDeadlineGreaterThan(officeHour.lecturer, new Date(), [sort: "start", order: "asc"])
        nextOfficeHours.remove(officeHour)
        for (nextOfficeHour in nextOfficeHours) {
            remainingAppointments = fitAppointmentsIntoOfficeHour(remainingAppointments, nextOfficeHour)
        }

        return remainingAppointments

    }

    def createICal(Appointment appointment) {
        ICalendar ical = new ICalendar();
        VEvent event = new VEvent();
        Summary summary = event.setSummary("Sprechstunde bei ${appointment.officeHour.lecturer.name}");
        summary.setLanguage("de-DE");

        Date start = appointment.start
        event.setDateStart(start)

        biweekly.util.Duration duration = biweekly.util.Duration.Builder().minutes(appointment.duration).build();
        event.setDuration(duration);

        // Recurrence recur = new Recurrence.Builder(Frequency.WEEKLY).interval(2).build();
        // event.setRecurrenceRule(recur);
        ical.addEvent(event);

        String str = Biweekly.write(ical).go();
    }

}
