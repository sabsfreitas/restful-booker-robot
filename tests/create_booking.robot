*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../resources/keywords.robot
Suite Setup    Authenticate as Admin

*** Test Cases ***
Create a Booking at Restful Booker
    ${booking_dates}=    Create Dictionary    checkin=2025-09-16    checkout=2025-09-19
    ${body}=    Create Dictionary    firstname=Sabrina    lastname=Freitas    totalprice=200    depositpaid=false    bookingdates=${booking_dates}
    ${response}=    POST    url=https://restful-booker.herokuapp.com/booking    json=${body}
    ${id}=    Set Variable    ${response.json()}[bookingid]
    Set Suite Variable    ${id}
    ${response}=    GET    https://restful-booker.herokuapp.com/booking/${id}
    Log    ${response.json()}
    Should Be Equal    ${response.json()}[lastname]    Freitas
    Should Be Equal    ${response.json()}[firstname]    Sabrina
    Should Be Equal As Numbers    ${response.json()}[totalprice]    200
    Dictionary Should Contain Value    ${response.json()}    Freitas