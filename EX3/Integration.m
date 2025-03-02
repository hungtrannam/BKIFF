function sol = Integration(h, fv, Dim)

mesh = h.^Dim;
sol = mesh * sum(fv(:)); 

end