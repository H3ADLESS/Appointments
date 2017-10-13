package appointments

import appointments.notfications.NotificationType
import grails.transaction.Transactional

import javax.mail.Message
import javax.mail.PasswordAuthentication
import javax.mail.Session
import javax.mail.Authenticator
import javax.mail.Transport
import javax.mail.internet.InternetAddress
import javax.mail.internet.MimeMessage

@Transactional
class MailService {

    def boolean sendAppointmentNotification(Appointment appointment, NotificationType type) {
        Session session = getMailSession();
        UserSettings userSettings  = appointment.officeHour.lecturer.userSettings


        if (type == NotificationType.APPOINTMENT_CREATED) {
            if (!userSettings.onAppointmentCreation) {
                return true
            }
        }

        true
    }

    def boolean sendInviteTo(String recipient, String code) {
        try {
            Session session = getMailSession()
            Message msg = new MimeMessage(session);

            InternetAddress addressTo = new InternetAddress(recipient);

            String urlCode = URLEncoder.encode(code, "UTF-8")

            msg.setRecipient(Message.RecipientType.TO, addressTo);
            msg.setFrom(new InternetAddress("headless705@gmail.com"));
            msg.setSubject("Einladung zur Nutzung der Sprechstundenapplikation der FU Berlin");
            String message = """
Hallo,
          
Du wurdest dazu eingeladen die Webapp der FU-Berlin zu verwenden, um Deine Sprechstunden zu organisieren.

Wenn Du die App nutzen möchtest folge dem diesem Link:
https://localhost:8090/register/guest?id=${urlCode}

Solltest du diese Nachricht nicht angefordert haben ignoriere Sie einfach.
"""
            msg.setText(message, "UTF-8");
            Transport.send(msg);
            return true
        } catch (Exception e) {
            e.printStackTrace()
            return false
        }
    }

    private static Session getMailSession() {
        Properties props = new Properties();

        props.setProperty("mail.smtp.auth", "true");
        props.setProperty("mail.smtp.starttls.enable", "true");
        props.setProperty("mail.smtp.host", "smtp.gmail.com");
        props.setProperty("mail.smtp.port", "587");
        props.setProperty("mail.smtp.debug", "true");

//        props.setProperty( "mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
//        props.setProperty( "mail.smtp.socketFactory.fallback", "false");

        String username = ApplicationConfig.get(1).emailUsername
        String password = ApplicationConfig.get(1).emailPassword

        Session session = Session.getInstance( props, new Authenticator() {
            PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password)
            }
        });

        session.setDebug( true );
        return session
    }

}
