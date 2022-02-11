% Es la funcion de apoyo a blkproc en el algoritmo "conHough".

function [out]=apoyo(in)

bloque_out=real(ifft2(fft2(in).*(abs(fft2(in))).^1.2));
out=(bloque_out-min(min(bloque_out)))/(max(max(bloque_out))-min(min(bloque_out)));