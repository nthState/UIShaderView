
float Amplitude = 1.2;
float Frequency = 5.0;

#pragma body

vec2 nrm = _geometry.position.xz;
float len = length(nrm)+0.0001; // for robustness
nrm /= len;
float a = 0.0;
a = len + Amplitude * sin(Frequency * _geometry.position.z + u_time * 10.0);
_geometry.position.xz = nrm * a;