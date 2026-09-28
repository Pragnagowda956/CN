set ns [new Simulator]
set ntrace [open pro1.tr w]
$ns trace-all $ntrace
set namfile [open pro1.nam w]
$ns namtrace-all $namfile

proc Finish {} {
  global ns ntrace namfile
  $ns flush-trace
  close $ntrace 
  close $namfile
  exec nam pro1.nam &
  puts "the number of packets drop is [exec grep -c "^d" pro1.tr]"
  exit 0
}
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

$ns duplex-link $n0 $n1 10Mb 10ms DropTail
$ns duplex-link $n1 $n2 5Mb 10ms DropTail

$ns queue-limit $n0 $n1 10
$ns queue-limit $n1 $n2 5

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

set sink0 [new Agent/TCPSink]
$ns attach-agent $n2 $sink0

$ns connect $tcp0 $sink0

set cbr [new Application/Traffic/CBR]
$cbr set type_ CBR
$cbr set packetSize_ 100
$cbr set rate_ 1Mb
$cbr set random_ false
$cbr attach-agent $tcp0

$tcp0 set class_ 1

$ns at 1.0 "$cbr start"
$ns at 5.0 "Finish"

$ns run
