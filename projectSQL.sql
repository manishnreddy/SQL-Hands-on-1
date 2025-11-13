use Project

/* Appointments per doctor with rank (most to least busy) */
SELECT
    d.Fname , d.Lname,
    COUNT(a.AppointmentID) AS total_appointments,
    RANK() OVER (ORDER BY COUNT(a.AppointmentID) DESC) AS busy_rank
FROM DOCTOR AS d inner join PATIENTS_APPOIN_ATTAN AS a ON d.DoctorID = a.DoctorID
	where Status = 'Completed' OR Status = 'Scheduled'
GROUP BY
    d.DoctorID, d.Fname , d.Lname
ORDER BY
    busy_rank ASC, total_appointments DESC;


/* Which doctor has the most appointments? */
SELECT TOP 1
    d.Fname , d.Lname,
    COUNT(a.AppointmentID) AS total_appointments
FROM DOCTOR AS d inner join PATIENTS_APPOIN_ATTAN AS a ON d.DoctorID = a.DoctorID

where Status = 'Completed' OR Status = 'Scheduled'
GROUP BY d.DoctorID, d.Fname , d.Lname 
ORDER BY
    total_appointments DESC;

/* How many patients does each doctor treat? */
SELECT
    d.Fname , d.Lname,
    COUNT(a.PatientID) AS total_patients
FROM  DOCTOR AS d inner join PATIENTS_APPOIN_ATTAN AS a ON d.DoctorID = a.DoctorID and a.Status in ('Completed' ,'Scheduled')
	GROUP BY d.DoctorID, d.Fname , d.Lname 


/* Peak booking hours (by start time hour)  */
SELECT
  DATEPART(hour FROM date) AS booking_hour,
  COUNT(AppointmentID) AS total_bookings
FROM
    PATIENTS_APPOIN_ATTAN
GROUP BY DATEPART(hour FROM date)
ORDER BY total_bookings DESC;

/*Doctor–patient pairs with most interactions (top 10) */

SELECT top 10
    d.DoctorID,
    d.Fname,
    d.Lname,
    p.Fname AS patient_fname,
    p.Lname AS patient_lname,
    COUNT(a.Status) AS total_interactions
FROM
    PATIENTS_APPOIN_ATTAN AS a JOIN DOCTOR AS d ON a.DoctorID = d.DoctorID JOIN PATIENT AS p ON a.PatientID = p.PatientID
GROUP BY
    d.DoctorID,
    p.PatientID ,
	d.Fname,
    d.Lname ,
	p.Fname ,
	p.Lname
ORDER BY total_interactions DESC

/* First and most recent visit per patient (with total visits) */


SELECT
    PatientID,
    MIN(date) AS first_visit_date,
    MAX(date) AS most_recent_visit_date,
    COUNT(AppointmentID) AS total_visits
FROM PATIENTS_APPOIN_ATTAN
GROUP BY
    PatientID
ORDER BY
    total_visits desc


	