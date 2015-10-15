/*
  ## TODO: write an oct-file and use it for all LTI constructors:
  ##       [mat_idx, opt_idx] = __name_of_oct_file__ (varargin)
  ##       adapt code from  ischar  in  libinterp/corefcn/strfns.cc
  ##       loop through cell and stop at first char,
  ##       then use the  colon  operator to build the two vectors
  
  str_idx = find (cellfun (@ischar, varargin));

  if (isempty (str_idx))
    mat_idx = 1 : nargin;
    opt_idx = [];
  else
    mat_idx = 1 : str_idx(1)-1;
    opt_idx = str_idx(1) : nargin;
  endif
  
*/


#include <octave/oct.h>


DEFUN_DLD (__lti_input_idx__, args, ,
       "-*- texinfo -*-\n\
@deftypefn {Built-in Function} {} ischar (@var{x})\n\
Return true if @var{x} is a character array.\n\
@seealso{isfloat, isinteger, islogical, isnumeric, iscellstr, isa}\n\
@end deftypefn")
{
  octave_value_list retval;
  octave_idx_type idx = 0;
  octave_idx_type nargin = args.length ();

  if (nargin == 1 && args(0).is_defined () && args(0).is_cell ())
  {
    octave_idx_type len = args(0).length ();
    
    for (octave_idx_type i = 0; i < len; i++)
    {
      //if ()
    
    }
    
    // retval = args(0).is_cell ();
  }
  else
    print_usage ();

  retval(0) = octave_value (idx);
  retval(1) = octave_value (idx);

  return retval;
}
