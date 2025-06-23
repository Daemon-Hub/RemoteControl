cmake_minimum_required(VERSION 3.10)
project(CertificateGeneration)

# Определите пути к утилитам Windows SDK
set(MAKECERT_PATH "C:/Program Files (x86)/Windows Kits/10/bin/10.0.26100.0/x64/makecert.exe")
set(PVK2PFX_PATH "C:/Program Files (x86)/Windows Kits/10/bin/10.0.26100.0/x64/pvk2pfx.exe")

# Параметры сертификата
set(CERT_NAME "CN=Daemon-Hub Certificate")
set(START_DATE "01/01/2025")
set(END_DATE "01/01/2026")
set(PVK_FILE "${CMAKE_CURRENT_BINARY_DIR}/key.pvk")
set(CER_FILE "${CMAKE_CURRENT_BINARY_DIR}/certificate.cer")
set(PFX_FILE "${CMAKE_CURRENT_BINARY_DIR}/certificate.pfx")
set(PFX_PASSWORD "12345678")

# Создание сертификата
add_custom_command(
    OUTPUT ${CER_FILE}
    COMMAND ${MAKECERT_PATH} -r -pe -n ${CERT_NAME} -b ${START_DATE} -e ${END_DATE} -eku 1.3.6.1.5.5.7.3.3 -sv ${PVK_FILE} ${CER_FILE}
    COMMENT "Generating certificate file ${CER_FILE}"
)

# Преобразование в .pfx
add_custom_command(
    OUTPUT ${PFX_FILE}
    DEPENDS ${CER_FILE}
    COMMAND ${PVK2PFX_PATH} -pvk ${PVK_FILE} -spc ${CER_FILE} -pfx ${PFX_FILE} -po ${PFX_PASSWORD}
    COMMENT "Converting to PFX file ${PFX_FILE}"
)

# Целевая цель для сборки сертификата
add_custom_target(generate_certificate ALL
    DEPENDS ${PFX_FILE}
)

# Очистка (опционально)
set_directory_properties(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES
    "${PVK_FILE};${CER_FILE};${PFX_FILE}"
)