crashbackups stop
drc off
gds readonly true
gds rescale false
gds read /home/rpgraca/opendvs_final/project_final/gds/user_project_wrapper.gds
load user_project_wrapper -dereference
select top cell
extract do local
extract no all
extract do antenna
extract all
antennacheck debug
antennacheck
puts "ANTENNA_DONE"
quit -noprompt
