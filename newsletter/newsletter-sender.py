#!/usr/bin/env python3
# by Dr. Torben Menke https://entorb.net
# https://github.com/entorb/COVID-19-Coronavirus-German-Regions

import os
import sqlite3
import json
import hashlib
import random
from datetime import date, timedelta
import sqlite3

# import time

# TODO


##########################
# Copy of common functions
##########################


def checkRunningOnServer() -> bool:
    if os.path.isdir("/var/www/virtual/entorb/data-web-pages/covid-19"):
        return True
    else:
        return False


def genHash(email: str) -> str:
    s = email + str(random.random())
    return gen_SHA256_string(s)


def gen_SHA256_string(s: str) -> str:
    m = hashlib.sha256()
    m.update(s.encode("ascii"))
    return m.hexdigest()


def db_connect():
    # check I running on entorb.net webserver
    if os.path.isdir("/var/www/virtual/entorb/data-web-pages/covid-19"):
        pathToDb = "/var/www/virtual/entorb/data-web-pages/covid-19/newsletter.db"
    else:
        pathToDb = "cache/newsletter.db"
    con = sqlite3.connect(pathToDb)
    con.row_factory = sqlite3.Row  # allows for access via row["name"]
    cur = con.cursor()
    return con, cur


def db_updateHash(email) -> str:
    "in DB: update hash of email. returns hash"
    # curUpdate = con.cursor()
    h = genHash(email)
    sql = "UPDATE newsletter SET hash = ? WHERE email = ?"
    db_newsletter_cursor_update.execute(sql, (h, email))
    db_newsletter_connection.commit()
    return h


# SENDMAIL = "/usr/sbin/sendmail"


# def sendmail(to: str, body: str, subject: str, sender: str = "no-reply@entorb.net"):
#     mail = f'To: {to}\nSubject: {subject}\nFrom: {sender}\nContent-Type: text/plain; charset="utf-8"\n\n{body}'
#     if checkRunningOnServer():
#         p = os.popen(f"{SENDMAIL} -t -i", "w")
#         p.write(mail)
#         # status = p.close()
#         p.close()
#     else:
#         print(mail)


def sendmail(
    to: str,
    body: str,
    subject: str = "[COVID-19 Landkreis Benachrichtigung]",
    sender: str = "no-reply@entorb.net",
):

    if checkRunningOnServer():
        # V1: via SENDMAIL
        # SENDMAIL = "/usr/sbin/sendmail"
        # p = os.popen(f"{SENDMAIL} -t -i", "w")
        # p.write(mail)
        # # status = p.close()
        # p.close()

        # V2: via my Mailer Daemon
        insertNewEMail(send_to=to, subject=subject, body=body, send_from=sender)

    else:
        print(f"To: {to}\nSubject: {subject}\nFrom: {sender}\n{body}")


def insertNewEMail(
    send_to: str,
    subject: str,
    body: str,
    send_from: str = "no-reply@entorb.net",
    send_cc: str = "",
    send_bcc: str = "",
):
    # This is a copy from mailer-daemon/insert.py
    # import sqlite3
    # PATH = "/var/www/virtual/entorb/mail-daemon/outbox.db"
    # ensureValidEMail(send_to) # uncommented, because send_to might contain the name as well

    # con = sqlite3.connect(PATH)
    # cur = con.cursor()
    db_outbox_cursor.execute(
        "INSERT INTO outbox(send_to, subject, body, send_from, send_cc, send_bcc, date_created, date_sent) VALUES (?,?,?,?,?,?,CURRENT_TIMESTAMP, NULL)",
        (send_to, subject, body, send_from, send_cc, send_bcc),
    )
    db_outbox_connection.commit()
    # cur.close()
    # con.close()


def format_line(
    value_relative: str, value_absolute: str, location: str, slope: str
) -> str:
    return "%5d | %8d | %3s | %s\n" % (
        value_relative,
        value_absolute,
        slope,
        location,
    )


def format_line_only_rel(value_relative: str, location: str, slope: str) -> str:
    return "%5d              %3s | %s\n" % (
        value_relative,
        slope,
        location,
    )


def format_line_no_slope(
    value_relative: str, value_absolute: str, location: str
) -> str:
    return "%5.1f | %8d | %s\n" % (
        value_relative,
        value_absolute,
        location,
    )


# def get_slope(slope: float) -> str:
#     if slope >= 3:
#         slope = "↑"
#     elif slope >= 1:
#         slope = "↗"
#     elif slope > -1:
#         slope = "→"
#     elif slope > -3:
#         slope = "↘"
#     else:
#         slope = "↓"
#     return slope


def get_slope_text(slope: float) -> str:
    s = "%+4d%%" % slope
    return s


def get_slope_text_from_dict(d: dict) -> str:
    slope = 0
    # if "Slope_Cases_Last_Week_Percent" in d:
    #     slope = d["Slope_Cases_Last_Week_Percent"]
    if "Cases_Last_Week_7Day_Percent" in d:
        slope = d["Cases_Last_Week_7Day_Percent"]
    return get_slope_text(slope)


##########################

# DB connections
if checkRunningOnServer():
    PATH = "/var/www/virtual/entorb/mail-daemon/outbox.db"
    db_outbox_connection = sqlite3.connect(PATH)
    db_outbox_cursor = db_outbox_connection.cursor()

db_newsletter_connection, db_newsletter_cursor = db_connect()
db_newsletter_cursor_update = db_newsletter_connection.cursor()

# set path variables
pathPrefixOnServer = "/var/www/virtual/entorb/html/COVID-19-coronavirus/"
pathToDataDeDistricts = "data/de-districts/de-districts-results.json"
pathToDataDeStates = "data/de-states/de-states-latest.json"
pathToDataCountries = "data/int/countries-latest-all.json"
if checkRunningOnServer():
    pathToDataDeDistricts = pathPrefixOnServer + pathToDataDeDistricts
    pathToDataDeStates = pathPrefixOnServer + pathToDataDeStates
    pathToDataCountries = pathPrefixOnServer + pathToDataCountries


# load latest data
d_data_DeDistricts = {}
with open(pathToDataDeDistricts, mode="r", encoding="utf-8") as fh:
    d_data_DeDistricts = json.load(fh)

s_date_data_hh = d_data_DeDistricts["02000"]["Date_Latest"]
date_data_hh = date.fromisoformat(s_date_data_hh)
date_yesterday = date.today() - timedelta(days=1)
assert (
    date_data_hh == date_yesterday
), f"date data hh: {date_data_hh} != date yesterday {date_yesterday}"
del date_data_hh, date_yesterday

d_data_DeStates = {}
with open(pathToDataDeStates, mode="r", encoding="utf-8") as fh:
    d_data_DeStates = json.load(fh)

d_data_Countries = {}
with open(pathToDataCountries, mode="r", encoding="utf-8") as fh:
    # convert list to dict
    l = json.load(fh)
    for d in l:
        code = d["Code"]
        del d["Code"]
        d_data_Countries[code] = d
del code, fh, l, d

# Ranking of worst Landkreise
d_id_cases_DeDistricts = {}
for id, d in d_data_DeDistricts.items():
    # handling of missing disticts from API response
    if id not in d_data_DeDistricts or "Cases_Last_Week_Per_Million" not in d:
        # print(id, d)
        continue
    d_id_cases_DeDistricts[id] = d["Cases_Last_Week_Per_Million"] / 10
    d["Slope"] = get_slope_text_from_dict(d)
l_worst_lk_ids = []
for id, value in sorted(
    d_id_cases_DeDistricts.items(), key=lambda item: item[1], reverse=True
):
    l_worst_lk_ids.append(id)
del d_id_cases_DeDistricts, id

# Ranking of worst Bundesländer
d_id_cases_DeStates = {}
for id, d in d_data_DeStates.items():
    if id == "DE-total":
        cases_DE_last_week_100k = d["Cases_Last_Week_Per_Million"] / 10
        cases_DE_last_week = d["Cases_Last_Week"]
        slope_DE = get_slope_text_from_dict(d)

    else:
        d_id_cases_DeStates[id] = d["Cases_Last_Week_Per_Million"] / 10
        d["Slope"] = get_slope_text_from_dict(d)
l_worst_bl_ids = []
for id, value in sorted(
    d_id_cases_DeStates.items(), key=lambda item: item[1], reverse=True
):
    l_worst_bl_ids.append(id)
del d_id_cases_DeStates, id

# Ranking of worst Countries - Cases
d_id_cases_Countries = {}
for id, d in d_data_Countries.items():
    d_id_cases_Countries[id] = d["Cases_Last_Week_Per_Million"] / 10
    d["Slope"] = get_slope_text_from_dict(d)
l_worst_country_ids = []
for id, value in sorted(
    d_id_cases_Countries.items(), key=lambda item: item[1], reverse=True
):
    l_worst_country_ids.append(id)
del d_id_cases_Countries, id

# Ranking of worst Countries - Cases
d_id_deaths_Countries = {}
for id, d in d_data_Countries.items():
    d_id_deaths_Countries[id] = d["Deaths_Last_Week_Per_Million"]
    # d["Slope"] = get_slope_text_from_dict(d)
l_worst_country_ids_deaths = []
for id, value in sorted(
    d_id_deaths_Countries.items(), key=lambda item: item[1], reverse=True
):
    l_worst_country_ids_deaths.append(id)
del id


# string snippet of worst DeDistricts
s_worst_lk = ""
max_lines = 10
count = 0
for id in l_worst_lk_ids:
    count += 1
    d = d_data_DeDistricts[id]
    s_worst_lk += format_line(
        value_relative=d["Cases_Last_Week_Per_Million"] / 10,
        value_absolute=d["Cases_Last_Week"],
        location=f"{d['LK_Name']} ({d['LK_Typ']} in {d['BL_Code']})",
        slope=d["Slope"],
    )
    if count == max_lines:
        break

# string snippet of worst Bundesländer
s_worst_bl = ""
for id in l_worst_bl_ids:
    d = d_data_DeStates[id]
    s_worst_bl += format_line(
        value_relative=d["Cases_Last_Week_Per_Million"] / 10,
        value_absolute=d["Cases_Last_Week"],
        location=f"{d['State']}",
        slope=d["Slope"],
    )

# string snippet of worst Countries - Cases
s_worst_countries = ""
max_lines = 30
count = 0
for id in l_worst_country_ids:
    count += 1
    d = d_data_Countries[id]
    s_worst_countries += format_line(
        value_relative=d["Cases_Last_Week_Per_Million"] / 10,
        value_absolute=d["Cases_Last_Week"],
        location=f"{d['Country']}",
        slope=d["Slope"],
    )
    if count == max_lines:
        break


# string snippet of worst Countries - Deaths
s_worst_countries_deaths = ""
max_lines = 30
count = 0
for id in l_worst_country_ids_deaths:
    count += 1
    d = d_data_Countries[id]
    s_worst_countries_deaths += format_line_no_slope(
        value_relative=d_id_deaths_Countries[id],
        value_absolute=d["Deaths_Last_Week"],
        location=f"{d['Country']}",
    )
    if count == max_lines:
        break


# loop over subscriptions
for row in db_newsletter_cursor.execute(
    "SELECT email, verified, hash, threshold, regions, frequency, date_registered FROM newsletter WHERE verified = 1 AND regions IS NOT NULL"
):
    mailBody = ""
    # TODO
    # for debugging: only send to me
    # if row["email"] != "my-email-address":
    #   continue
    #    mailBody += """Frage: Hat jemand einen Linux Mailserver, auf den ich diesen Newsletter-Versand umstellen kann? Mein Provider limitiert die Mails auf 60/60min, was zu erheblicher Verzögerung bei den aktuell 200 Abonnenten führt.
    # Kontakt: https://entorb.net/contact.php?origin=COVID-19
    # LG Torben\n\n\n"""

    mailTo = row["email"]
    s_this_regions = row["regions"]
    l_this_regions = row["regions"].split(",")
    # 16056 Eisenach was merged with 16063: LK Wartburgkreis
    # see https://www.eisenach.de/rathaus/fusion-der-stadt-eisenach
    if "16056" in l_this_regions:
        l_this_regions.remove("16056")

    # for sorting by value
    d_this_regions_cases_100k = {}
    for lk_id in l_this_regions:
        d_this_regions_cases_100k[lk_id] = (
            d_data_DeDistricts[lk_id]["Cases_Last_Week_Per_Million"] / 10
        )

    toSend = False
    reason_for_sending = ""
    # check if notification is due, based on threshold and frequency
    # daily sending
    if row["threshold"] <= max(d_this_regions_cases_100k.values()):
        toSend = True
        reason_for_sending = "Grenzwert überschritten"
    elif row["frequency"] == 1:
        toSend = True
        reason_for_sending = "Täglicher Versand"
    elif row["frequency"] == 7 and date.today().isoweekday() == 7:
        toSend = True
        reason_for_sending = "Sonntäglicher Versand"

    if toSend:
        # mailBody += f"Hinweis: Ich habe mal versucht eine bessere Ordnung in meine vielen Auswertungen zu bringen, Ergebnis siehe: \nhttps://entorb.net/COVID-19-coronavirus/\nÜber weitere Verbesserungsvorschläge freue ich mich.\nKontakt: https://entorb.net/contact.php?origin=COVID-19\n\n"
        # table header
        mailBody += "Infektionen (Quelle: RKI)\n\n"
        mailBody += "Rel.¹ | Absolut² | Änderung³\n"
        mailBody += "Deine Landkreisauswahl\n"
        # table body
        for lk_id, value in sorted(
            d_this_regions_cases_100k.items(), key=lambda item: item[1], reverse=True
        ):
            d = d_data_DeDistricts[lk_id]
            if "Slope" not in d:  # handling of missing disticts from API response
                continue
            mailBody += format_line(
                value_relative=d["Cases_Last_Week_Per_Million"] / 10,
                value_absolute=d["Cases_Last_Week"],
                location=f"{d['LK_Name']} ({d['LK_Typ']} in {d['BL_Code']})",
                slope=d["Slope"],
            )

        mailBody += f"\nZeitverlauf Deiner ausgewählten Landkreise: https://entorb.net/COVID-19-coronavirus/?yAxis=Cases_Last_Week_Per_100000&DeDistricts={s_this_regions}&Sort=Sort_by_last_value#DeDistrictChart\n"

        mailBody += "\nTop 10 Landkreise\n" + s_worst_lk

        mailBody += f"Datenstand Landkreisdaten: {s_date_data_hh}\n"

        mailBody += f"Hinweis: Die Landkreisdaten stammen vom RKI und werden dort um 0:00 Uhr veröffentlicht. Die Gesundheitsämter sind teilweise schneller in der Aktualisierung ihrer Zahlen, daher findet man unterschiedliche Zahlen in unterschiedlichen Quellen.\n"

        mailBody += "\nBundesländer\n" + s_worst_bl

        mailBody += "\nDeutschland gesamt\n" + format_line(
            cases_DE_last_week_100k, cases_DE_last_week, "Deutschland", slope_DE
        )
        # mailBody += "\nDeutschland\n" + format_line_only_rel(
        #     cases_DE_last_week_100k, "Deutschland", slope_DE
        # )
        mailBody += "\nLänder der Welt - Inzidenzen (Quelle: JHU)\n" + s_worst_countries

        # table footer
        mailBody += "Einheiten: Neu-Infektionen letzte Woche\n ¹relativ pro 100.000 Einwohner, ²absolut = Gesamtzahl, ³7-Tages Änderung\n"

        mailBody += "\n\nLänder der Welt - Opferzahlen (Quelle: JHU)\n"
        mailBody += "Rel.¹ | Absolut² | Land\n"

        mailBody += s_worst_countries_deaths
        # table footer
        mailBody += "Einheiten: Opfer letzte Woche\n ¹relativ pro Mill. Einwohner, ²absolut = Gesamtzahl\n"

        # create a new hash
        # add management link including new hash
        h = db_updateHash(mailTo)
        mailBody += f"\nAbmelden/Einstellungen ändern: https://entorb.net/COVID-19-coronavirus/newsletter-frontend.html?hash={h}\n"

        mailBody += "\nAlle Auswertungen: https://entorb.net/COVID-19-coronavirus/\n"
        mailBody += "\nNeu anmelden: https://entorb.net/COVID-19-coronavirus/newsletter-register.html\n"
        mailBody += "\nKontakt: https://entorb.net/contact.php?origin=COVID-19\n"

        # uses php mail function and my outbox mailer.php
        sendmail(
            to=mailTo,
            body=mailBody,
            subject=f"[COVID-19 Landkreis Benachrichtigung] - {reason_for_sending}",
        )

        # time.sleep(60 + 5)  # 65s, as Uberspace has a limit of 60 mails per hour

# DB disconnect
db_newsletter_cursor.close()
db_newsletter_cursor_update.close()
db_newsletter_connection.close()
if checkRunningOnServer():
    db_outbox_cursor.close()
    db_outbox_connection.close()
