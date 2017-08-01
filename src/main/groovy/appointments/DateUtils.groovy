package appointments

import appointments.ApplicationConfig

import java.time.format.DateTimeFormatter

/**
 * Created by H3ADLESS on 06.01.2017.
 */
class DateUtils {

    public final static DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.mm.yyyy").withLocale(Locale.GERMANY)

    /**
     * Gets a Date of day, month, year, hour and minutes
     * @param day
     * @param month
     * @param year
     * @param hour
     * @param minutes
     * @return
     */
    public static getDateAtTime(int day, int month, int year, int hour, int minutes){
        Calendar c = Calendar.getInstance()

        // Months are zero based!
        c.set(year, month, day, hour, minutes, 0)
        c.getTime()
    }

    /**
     * Resets the time to 00:00
     * @param date
     */
    public static resetTime(Date date) {
        Calendar c = Calendar.getInstance()
        c.setTime(date)
        setTimeOfDate(c,0,0,0,0)
        return c.getTime()
    }

    public static setTime(Date date, int hour, int minute) {
        Calendar c = Calendar.getInstance()
        c.setTime(date)
        setTimeOfDate(c,hour,minute,0,0)
        return c.getTime()
    }

    public static getEndOfDay(Date date){
        Calendar c = Calendar.getInstance()
        c.setTime(date)
        c = setTimeOfDate(c, 24,0,0,0)
        return c.getTime()
    }

    public static getHour(Date date) {
        Calendar c = Calendar.getInstance()
        c.setTime(date)
        return c.get(Calendar.HOUR_OF_DAY)
    }

    public static getMinute(Date date) {
        Calendar c = Calendar.getInstance()
        c.setTime(date)
        return c.get(Calendar.MINUTE)
    }

    public static addMinutesToDate(Date date, int minutes) {
        Calendar c = Calendar.getInstance()
        c.setTime(date)
        c.add(Calendar.MINUTE, minutes)
        return c.getTime()
    }

    public static substractHoursFromDate(Date date, int hours) {
        Calendar c = Calendar.getInstance()
        c.setTime(date)
        c.add(Calendar.HOUR, -hours)
        return c.getTime()
    }

    public static int getTimeDifferenceInMinutes(Date d1, Date d2) {
        if (d1 > d2) {
            return ((d1.getTime() - d2.getTime()) / (1000*60))
        } else {
            return ((d2.getTime() - d1.getTime()) / (1000*60))
        }
    }

    private static Calendar setTimeOfDate(Calendar c, int hour, int minute, int second, int millisecond){
        c.set(Calendar.HOUR_OF_DAY, hour)
        c.set(Calendar.MINUTE, minute)
        c.set(Calendar.SECOND, second)
        c.set(Calendar.MILLISECOND, millisecond)
        return c;
    }

    public static boolean sameDay(Date d1, Date d2){
        return resetTime(d1) == resetTime(d2)
    }

    public static long resetTimeAndGetTime(Date d1){
        return resetTime(d1).getTime()
    }

}
