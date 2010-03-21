## Copyright (C) 1996, 2000, 2004, 2005, 2006, 2007
##               Auburn University. All rights reserved.
##
##
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or (at
## your option) any later version.
##
## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; see the file COPYING.  If not, see
## <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function File} {[@var{dec_min}, @var{dec_max}] =} __freqbounds__ (@var{sys})
## Get default range of frequencies based on cutoff frequencies of system
## poles and zeros.
## Frequency range is the interval
## @iftex
## @tex
## $ [ 10^{w_{min}}, 10^{w_{max}} ] $
## @end tex
## @end iftex
## @ifinfo
## [10^@var{wmin}, 10^@var{wmax}]
## @end ifinfo
##
## Used internally in @command{margin} (@command{bode}, @command{nyquist})
## @end deftypefn

## Adapted-By: Lukas Reichlin <lukas.reichlin@gmail.com>
## Date: October 2009
## Version: 0.1

function [dec_min, dec_max] = __freqbounds__ (sys, wbounds = "std")

  zer = zero (sys);
  pol = pole (sys);
  tsam = get (sys, "tsam");
  digital = (tsam > 0);  # static gains (tsam = -1) are continuous
  
  ## make sure zer, pol are row vectors
  pol = pol(:).';
  zer = zer(:).';

  ## check for natural frequencies away from omega = 0
  if (digital)
    ## The 2nd conditions prevents log(0) in the next log command
    iiz = find (abs(zer-1) > norm(zer)*eps && abs(zer) > norm(zer)*eps);
    iip = find (abs(pol-1) > norm(pol)*eps && abs(pol) > norm(pol)*eps);

    ## avoid dividing empty matrices, it would work but looks nasty
    if (! isempty (iiz))
      czer = log (zer(iiz))/tsam;
    else
      czer = [];
    endif

    if (! isempty (iip))
      cpol = log (pol(iip))/tsam;
    else
      cpol = [];
    endif
  else
    ## continuous
    iip = find (abs(pol) > norm(pol)*eps);
    iiz = find (abs(zer) > norm(zer)*eps);

    if (! isempty (zer))
      czer = zer(iiz);
    else
      czer = [];
    endif
    if (! isempty (pol))
      cpol = pol(iip);
    else
      cpol = [];
    endif
  endif
  
  if (isempty (iip) && isempty (iiz))
    ## no poles/zeros away from omega = 0; pick defaults
    dec_min = 0;  # -1
    dec_max = 2;  # 3
  else
    dec_min = floor (log10 (min (abs ([cpol, czer]))));
    dec_max = ceil (log10 (max (abs ([cpol, czer]))));
  endif

  ## expand to show the entirety of the "interesting" portion of the plot
  switch (wbounds)
    case "std"  # standard
      if (dec_min == dec_max)
        dec_min -= 2;
        dec_max += 2;
      else
        dec_min--;
        dec_max++;
      endif
    case "ext"  # extended (for nyquist)
      if (any (abs (pol) < sqrt (eps)))  # look for integrators
        ## dec_min -= 0.5;
        dec_max += 2;
      else 
        dec_min -= 2;
        dec_max += 2;
      endif
    otherwise
      error ("freqbounds: second argument invalid");
  endswitch

  ## run digital frequency all the way to pi
  if (digital)
    dec_max = log10 (pi/tsam);
  endif

endfunction