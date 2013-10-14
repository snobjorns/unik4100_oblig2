%Finding recieved uplink carrier power
earth_radius =6.371e+6;
c = 3e+8
boltzmann = -228.6

%system parameters

bitrate = 10*log10(800e+3)
frequency_uplink = 30e+9
frequency_downlink  = 20e+9

lambda_uplink =c/frequency_uplink
lambda_downlink = c/frequency_downlink

%Satellite parameters
sat_longitude  = deg2rad(1);
sat_30_gain = 40
sat_20_gain = 36.5
sat_height = 35786e+3
sat_inputantenna_noise = 10*log10(288)
sat_transponder_gain = 117

%Gateway parameters
gw_longitude = deg2rad(2)
gw_latitude = deg2rad(43)
gw_height = 100
gw_transmitted_power = 10*log10(70)
gw_30_gain = 53 
gw_20_gain = 49.5
gw_inputantenna_noise = 10*log10(130)

%Earthstation parameters
es_longitude = deg2rad(2)
es_latitude = deg2rad(43)
es_height = 100
es_30_gain = 37
es_saturation_power= 10*log10(5)
es_output_backoff = 2
es_transmitted_power = es_saturation_power-es_output_backoff

%Calculating distance between gateway and satellite
relative_longitude = sat_longitude+gw_longitude
cosphi = cos(gw_latitude)*cos(relative_longitude);
sat_gw_distance = sqrt(sat_height^2 +2*earth_radius*(sat_height+earth_radius)*(1-cosphi))


%Calculate free space loss
fsl_up = 10*log10(((4*pi*sat_gw_distance)/lambda_uplink)^2 )
fsl_down= 10*log10(((4*pi*sat_gw_distance)/lambda_downlink)^2 )

%calculating uplink power reieved
uplink_power_received = es_transmitted_power +es_30_gain+sat_30_gain - fsl_up

%Calculate satelite noise spectral density 
sat_N0 = boltzmann+sat_inputantenna_noise

%calculate uplink Eb/N0
uplink_C_N0 =uplink_power_received - sat_N0
uplink_Eb_N0 = uplink_C_N0 - bitrate

%calculate satellite transmitted power
sat_transmitted_power = uplink_power_received + sat_transponder_gain

%calculate downlink
gw_power_received = sat_transmitted_power +sat_20_gain+gw_20_gain - fsl_up


%Calculate gateway noise spectral density 
gw_N0 = boltzmann+gw_inputantenna_noise

%calculate down Eb/N0
downlink_C_N0 =gw_power_received - gw_N0
downlink_Eb_N0 = downlink_C_N0 - bitrate

%calculate total eb_n0
total_eb_N0 = (downlink_Eb_N0^-1  + uplink_Eb_N0^-1  )^-1
%DB TEST
total_eb_N0 = 10*log10(( 10^(downlink_Eb_N0/10)^-1  + 10^(uplink_Eb_N0/10)^-1  )^-1)

