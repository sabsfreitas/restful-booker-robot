*** Settings ***
Library    String
Resource    ../resources/improved_keywords.resource
Suite Setup    Authenticate As Admin

*** Variables ***
@{BOOKING_TEST_DATA}
...    João|Silva|300|2025-03-01|2025-03-05|WiFi
...    Maria|Santos|450|2025-04-01|2025-04-07|Breakfast
...    Pedro|Costa|200|2025-05-01|2025-05-03|Parking

*** Test Cases ***
Create Multiple Bookings With Different Data
    [Documentation]    Cria múltiplos bookings usando dados variados
    [Tags]    data-driven    create
    
    FOR    ${test_data}    IN    @{BOOKING_TEST_DATA}
        ${fields}=    Split String    ${test_data}    |
        &{booking_data}=    Create Dictionary
        ...    firstname=${fields}[0]
        ...    lastname=${fields}[1]
        ...    totalprice=${fields}[2]
        ...    checkin=${fields}[3]
        ...    checkout=${fields}[4]
        ...    additionalneeds=${fields}[5]
        
        ${booking_id}=    Create Booking With Custom Data    &{booking_data}
        ${created_booking}=    Get Booking Details By Id    ${booking_id}
        
        Validate Booking Data    ${created_booking}
        ...    firstname=${fields}[0]
        ...    lastname=${fields}[1]
        ...    totalprice=${fields}[2]
        
        Log    ✅ Booking criado: ${fields}[0] ${fields}[1] - ID: ${booking_id}
    END

Validate Multiple Bookings Retrieval
    [Documentation]    Testa recuperação de múltiplos bookings
    [Tags]    get    multiple
    
    ${bookings_list}=    Get Multiple Bookings With Details    max_bookings=3
    ${list_length}=      Get Length    ${bookings_list}
    
    Should Be True    ${list_length} <= 3
    Should Be True    ${list_length} > 0
    
    FOR    ${booking}    IN    @{bookings_list}
        Dictionary Should Contain Key    ${booking}    bookingid
        Dictionary Should Contain Key    ${booking}    firstname
        Dictionary Should Contain Key    ${booking}    lastname
        Log    📋 Booking encontrado: ${booking}[firstname] ${booking}[lastname] (ID: ${booking}[bookingid])
    END