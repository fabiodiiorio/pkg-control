function retsys = tf2ss ()

num = {[1, 5, 7], [1]; [1, 7], [1, 5, 5]};
den = {[1, 5, 6], [1, 2]; [1, 8, 6], [1, 3, 2]};
sys = tf (num, den)

%{
sys = tf (1, [1, 0])
sys = tf (1, [1, 1])

sys = tf (1, conv ([1, 1, 1], [1, 4, 6, 4, 1]))
sys = tf (WestlandLynx)
%}

  [p, m] = size (sys);
  [num, den] = tfdata (sys);
  
  numc = cell (p, m);
  denc = cell (p, 1);
  
  ## multiply all denominators in a row and
  ## update each numerator accordingly 
  for i = 1 : p
    denc(i) = __conv__ (den{i,:});
    for j = 1 : m
      idx = setdiff (1:m, j);
      numc(i,j) = __conv__ (num{i,j}, den{i,idx});
    endfor
  endfor

  len_numc = cellfun (@length, numc);
  len_denc = cellfun (@length, denc);
  
  max_len_numc = max (len_numc(:));
  max_len_denc = max (len_denc(:));

  ## tfpoly ensures that there are no leading zeros
  if (length (max_len_numc) > length (max_len_denc))
    error ("tf: tf2ss: system must be proper");
  endif

  ucoeff = zeros (p, m, max_len_denc);
  dcoeff = zeros (p, max_len_denc);
  index = len_denc-1;

  for i = 1 : p
    len = len_denc(i);
    dcoeff(i, 1:len) = denc{i};
    for j = 1 : m
      ucoeff(i, j, len-len_numc(i,j)+1 : len) = numc{i,j};
    endfor
  endfor
%{
numc, denc
ucoeff(1,1,:)(:).'
%ucoeff(1,2,:)(:).'
%ucoeff(2,1,:)(:).'
%ucoeff(2,2,:)(:).'
dcoeff, index
%}
  [a, b, c, d] = sltd04ad (ucoeff, dcoeff, index);

  retsys = ss (a, b, c, d);

endfunction


function vec = __conv__ (vec, varargin)

  if (nargin == 1)
    return;
  else
    for k = 1 : nargin-1
      vec = conv (vec, varargin{k});
    endfor
  endif

endfunction
