## Copyright (C) 2009-2015   Lukas F. Reichlin
##
## This file is part of LTI Syncope.
##
## LTI Syncope is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## LTI Syncope is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with LTI Syncope.  If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## Common code for adjusting SS model data.
## Used by @ss/ss.m, others possibly follow.

## Author: Lukas Reichlin <lukas.reichlin@gmail.com>
## Created: October 2010
## Version: 0.3

function [a, b, c, d, tsam] = __adjust_ss_data__ (a, b, c, d, tsam);

  if (isempty (a))                      # static system
    a = [];                             # avoid [](nx0) or [](0xn)
    tsam = -2;
  endif

  if (is_real_scalar (d) && d == 0)     # ss (a, b, c, 0)  (for matlab compatibility)
    d = zeros (rows (c), columns (b));  # test  d == 0  to avoid  ss (0)  returning 0x0 model
  endif

  if (isempty (d))
    if (all (size (c) == 0))            # ss (a, b), ss (a, b, [], [], ...), but allow c(0xn) and d(0xm)
      c = eye (size (a));
      d = zeros (rows (a), columns (b));
    else                                # ss (a, b, c), ss (a, b, c, [], ...)
      d = zeros (rows (c), columns (b));
    endif
  endif

  if (isempty (b) && isempty (c))       # sys = ss ([], [], [], d)
    b = zeros (0, columns (d));
    c = zeros (rows(d), 0);
    tsam = -2;
  endif

endfunction
