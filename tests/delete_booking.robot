*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../resources/keywords.robot
Suite Setup    Authenticate as Admin

*** Test Cases ***
Delete Booking
    ${booking_dates}=    Create Dictionary    checkin=2025-09-16    checkout=2025-09-19
    ${body}=    Create Dictionary    firstname=Sabrina    lastname=Freitas    totalprice=200    depositpaid=false    bookingdates=${booking_dates}
    ${response}=    POST    url=https://restful-booker.herokuapp.com/booking    json=${body}
    ${id}=    Set Variable    ${response.json()}[bookingid]
    ${header}=    Create Dictionary    Cookie=token\=${token}
    ${response}=    DELETE    url=https://restful-booker.herokuapp.com/booking/${id}    headers=${header}
    Status Should Be    201    ${response}