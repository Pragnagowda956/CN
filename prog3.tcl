set ns [new Simulator]
#Trace files
set mytrace [open example3.tr w]
$ns trace-all $mytrace
set myNAM [open example3.nam w]
$ns namtrace-all $myNAM

#Create nodes
set n0 [$ns node]
$n0 color "magenta"
$n0 label "src1"
set n1 [$ns node]
set n2 [$ns node]
$n2 color "magenta"
$n2 label "src2"
set n3 [$ns node]
$n3 color "blue"
$n3 label "dest2"
set n4 [$ns node]
set n5 [$ns node]
$n5 color "blue"
$n5 label "dest1"

# Create LAN
$ns make-lan "$n0 $n1 $n2 $n3 $n4" 100Mb 100ms LL Queue/DropTail Mac/802_3

#Link from LAN to destination node
$ns duplex-link $n4 $n5 1Mb 1ms DropTail

#TCP connection 1: n0-> n5
set tcp0 [new Agent/TCP] 
$ns attach-agent $n0 $tcp0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ftp0 set packetSize_ 500
$ftp0 set interval_ 0.0001
set sink5 [new Agent/TCPSink]
$ns attach-agent $n5 $sink5 
$ns connect $tcp0 $sink5 
#
#TCP connection 2: n2 -> n3
set tcp2 [new Agent/TCP]
$ns attach-agent $n2 $tcp2
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ftp2 set packetSize_ 600
$ftp2 set interval_ 0.001
set sink3 [new Agent/TCPSink]
$ns attach-agent $n3 $sink3
$ns connect $tcp2 $sink3


#TCP trace files
#-
set file1 [open file1.tr w]
$tcp0 attach $file1
set file2 [open file2.tr w]
$tcp2 attach $file2


#Trace congestion window
$tcp0 trace cwnd_
$tcp2 trace cwnd_
#
# Finish procedure
proc finish {} {
global ns mytrace myNAM
$ns flush-trace
close $mytrace
close $myNAM
exec nam example3.nam &
exit 0
}
#Schedule FTP traffic
$ns at 0.1 "$ftp0 start"
$ns at 5.0 "$ftp0 stop"
$ns at 7.0 "$ftp0 start"
$ns at 14.0 "$ftp0 stop"
$ns at 0.2 "$ftp2 start"
$ns at 8.2 "$ftp2 stop"
$ns at 10.0 "$ftp2 start"
$ns at 15.0 "$ftp2 stop"
#Finish simulation
$ns at 16.0 "finish"
$ns run
$ns at 16.0 "finish"
#Run simulation
$ns run
