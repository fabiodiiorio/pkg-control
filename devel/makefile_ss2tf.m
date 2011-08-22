## ==============================================================================
## Developer Makefile for OCT-files
## ==============================================================================
## USAGE: * fetch control from Octave-Forge by svn
##        * add control/inst, control/src and control/devel to your Octave path
##        * run makefile_*
## ==============================================================================

homedir = pwd ();
develdir = fileparts (which ("makefile_ss2tf"));
srcdir = [develdir, "/../src"];
cd (srcdir);

mkoctfile sltb04bd.cc \
          TB04BD.f MC01PY.f TB01ID.f TB01ZD.f MC01PD.f \
          TB04BX.f MA02AD.f MB02RD.f MB01PD.f MB02SD.f \
          MB01QD.f

cd (homedir);