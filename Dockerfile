FROM ubuntu:latest

ENV XC32VER v4.35
ENV MPLABXVER v6.15

RUN apt-get update && \
  apt-get install -y --no-install-recommends apt-utils \
  && apt-get update -yq \
  && apt-get install -yq --no-install-recommends ca-certificates wget git tree libusb-1.0-0-dev \
  && rm -rf /var/lib/apt/lists/*

# Install MPLAB ${MPLABXVER}
RUN wget https://ww1.microchip.com/downloads/aemDocuments/documents/DEV/ProductDocuments/SoftwareTools/MPLABX-${MPLABXVER}-linux-installer.tar -q --show-progress --progress=bar:force:noscroll -O MPLABX-${MPLABXVER}-linux-installer.tar \
  && tar xf MPLABX-${MPLABXVER}-linux-installer.tar && rm -f MPLABX-${MPLABXVER}-linux-installer.tar \
  && USER=root ./*-installer.sh --nox11 \
  -- --unattendedmodeui none --mode unattended \
  && rm -f MPLABX-${MPLABXVER}-linux-installer.sh && \
#Remove Packs that are not relevant to current changes
  cd /opt/microchip/mplabx/${MPLABXVER}/ && \
  rm -r docs && \
  rm Uninstall_MPLAB_X_IDE_${MPLABXVER} && \
  rm Uninstall_MPLAB_X_IDE_${MPLABXVER}.desktop && \
  rm Uninstall_MPLAB_X_IDE_v6.dat && \
  cd mplab_platform && rm  -r mplab_ipe && \ 
  cd ../packs && rm -r arm && \
  mv Microchip/PIC32MX_DFP/ mx_tmp  && \
  mv Microchip/PIC32MZ-EF_DFP/ mz_tmp && \
  rm -r Microchip && \
  mkdir Microchip && \
  mv mx_tmp Microchip/PIC32MX_DFP/  && \
  mv mz_tmp Microchip/PIC32MZ-EF_DFP/ 

# Install XC32 ${XC32VER}
RUN wget https://ww1.microchip.com/downloads/aemDocuments/documents/DEV/ProductDocuments/SoftwareTools/xc32-${XC32VER}-full-install-linux-x64-installer.tar -q --show-progress --progress=bar:force:noscroll -O xc32-${XC32VER}-full-install-linux-x64-installer.tar\
  && tar xf xc32-${XC32VER}-full-install-linux-x64-installer.tar && rm -f xc32-${XC32VER}-full-install-linux-x64-installer.tar \
  && chmod a+x xc32-${XC32VER}-full-install-linux-x64-installer.run \
  && ./xc32-${XC32VER}-full-install-linux-x64-installer.run \
  --mode unattended --unattendedmodeui none \
  --netservername localhost \
  && rm -f xc32-${XC32VER}-full-install-linux-x64-installer.run 

ENV PATH $PATH:/opt/microchip/xc32/${XC32VER}/bin
ENV PATH $PATH:/opt/microchip/mplabx/${MPLABXVER}/mplab_platform/bin  

COPY build.sh /build.sh

ENTRYPOINT [ "/build.sh" ]
