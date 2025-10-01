*** Settings ***
Resource    ../resources/improved_keywords.resource
Suite Setup    Authenticate As Admin

*** Variables ***
&{TEST_BOOKING_DATA}
...    firstname=João
...    lastname=Silva
...    totalprice=250
...    checkin=2025-02-01
...    checkout=2025-02-05
...    additionalneeds=WiFi

&{PARTIAL_UPDATE_DATA}
...    firstname=João
...    lastname=Santos

&{COMPLETE_UPDATE_DATA}
...    firstname=João
...    lastname=Santos
...    totalprice=350
...    checkin=2025-02-10
...    checkout=2025-02-15
...    additionalneeds=Spa

*** Test Cases ***
Complete CRUD Flow With Custom Data
    [Documentation]    Testa fluxo completo CRUD com dados personalizados
    [Tags]    crud    integration
    
    # CREATE
    ${booking_id}=    Create Booking With Custom Data    &{TEST_BOOKING_DATA}
    
    # READ
    ${created_booking}=    Get Booking Details By Id    ${booking_id}
    Validate Booking Data    ${created_booking}
    ...    firstname=${TEST_BOOKING_DATA.firstname}
    ...    lastname=${TEST_BOOKING_DATA.lastname}
    ...    totalprice=${TEST_BOOKING_DATA.totalprice}
    
    # UPDATE (Partial)
    ${updated_booking}=    Update Booking Partially    ${booking_id}    &{PARTIAL_UPDATE_DATA}
    Validate Booking Data    ${updated_booking}
    ...    firstname=${PARTIAL_UPDATE_DATA.firstname}
    ...    lastname=${PARTIAL_UPDATE_DATA.lastname}
    
    # UPDATE (Complete)
    ${final_booking}=    Update Booking Completely    ${booking_id}    &{COMPLETE_UPDATE_DATA}
    Validate Booking Data    ${final_booking}
    ...    firstname=${COMPLETE_UPDATE_DATA.firstname}
    ...    lastname=${COMPLETE_UPDATE_DATA.lastname}
    ...    totalprice=${COMPLETE_UPDATE_DATA.totalprice}
    
    # DELETE
    Delete Booking By Id    ${booking_id}

CRUD Flow With Default Data
    [Documentation]    Testa fluxo CRUD usando dados padrão
    [Tags]    crud    smoke
    
    ${booking_id}=    Create Booking With Default Data
    ${booking_data}=  Get Booking Details By Id    ${booking_id}
    
    Should Be Equal    ${booking_data}[firstname]    ${DEFAULT_FIRSTNAME}
    Should Be Equal    ${booking_data}[lastname]     ${DEFAULT_LASTNAME}
    
    Delete Booking By Id    ${booking_id}