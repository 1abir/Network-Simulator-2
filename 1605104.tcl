# simulator


set area [lindex $argv 0]
set n_nodes [lindex $argv 1]
set flow [lindex $argv 2]

set trace_file_name [lindex $argv 3]
set animation_file_name [lindex $argv 4]


# set area 500
# set n_nodes 20
# set flow 10

puts "Area:"
puts $area
puts "Number of Nodes:"
puts $n_nodes
puts "Number of Flow:"
puts $flow


set ns [new Simulator]





# ======================================================================
# Define options

set val(chan)         Channel/WirelessChannel     ;# channel type
set val(prop)         Propagation/TwoRayGround    ;# radio-propagation model
set val(ant)          Antenna/OmniAntenna         ;# Antenna type
set val(ll)           LL                          ;# Link layer type
set val(ifq)          Queue/DropTail/PriQueue     ;# Interface queue type
set val(ifqlen)       100000                      ;# max packet in ifq
# set val(netif)        Phy/WirelessPhy          ;# network interface type
# set val(mac)          Mac/802_11               ;# MAC type
set val(netif)        Phy/WirelessPhy/802_15_4    ;# network interface type
set val(mac)          Mac/802_15_4                ;# MAC type
set val(rp)           DSDV                        ;# ad-hoc routing protocol 
set val(nn)           $n_nodes                    ;# number of mobilenodes
set val(energyModel)  EnergyModel               ;#energyModel
set val(initialEnergy) 5.0                       ;#initialEnergy
set val(rxPower)       0.9                       ;#rxPower
set val(txPower)       0.5                       ;#txPower
set val(idlePower)     0.45                      ;#idlePower
set val(sleepPower)    0.05                      ;#sleepPower
# =======================================================================

# trace file
set trace_file [open $trace_file_name w]
$ns trace-all $trace_file

# nam file
set nam_file [open $animation_file_name w]
$ns namtrace-all-wireless $nam_file $area $area

# topology: to keep track of node movements
set topo [new Topography]
$topo load_flatgrid $area $area ;# 500m x 500m area


# general operation director for mobilenodes
create-god $val(nn)


# node configs
# ======================================================================

# $ns node-config -addressingType flat or hierarchical or expanded
#                  -adhocRouting   DSDV or DSR or TORA
#                  -llType	   LL
#                  -macType	   Mac/802_11
#                  -propType	   "Propagation/TwoRayGround"
#                  -ifqType	   "Queue/DropTail/PriQueue"
#                  -ifqLen	   50
#                  -phyType	   "Phy/WirelessPhy"
#                  -antType	   "Antenna/OmniAntenna"
#                  -channelType    "Channel/WirelessChannel"
#                  -topoInstance   $topo
#                  -energyModel    "EnergyModel"
#                  -initialEnergy  (in Joules)
#                  -rxPower        (in W)
#                  -txPower        (in W)
#                  -agentTrace     ON or OFF
#                  -routerTrace    ON or OFF
#                  -macTrace       ON or OFF
#                  -movementTrace  ON or OFF

# ======================================================================
set chan_1_ [new $val(chan)]
$ns node-config -adhocRouting $val(rp) \
                -llType $val(ll) \
                -macType $val(mac) \
                -ifqType $val(ifq) \
                -ifqLen $val(ifqlen) \
                -antType $val(ant) \
                -propType $val(prop) \
                -phyType $val(netif) \
                -topoInstance $topo \
                -channel $chan_1_ \
                -agentTrace ON \
                -routerTrace ON \
                -macTrace OFF \
                -movementTrace OFF \
                -energyModel $val(energyModel) \
                -initialEnergy $val(initialEnergy) \
                -rxPower $val(rxPower) \
                -txPower $val(txPower) \
                -idlePower $val(idlePower) \
                -sleepPower $val(sleepPower)
                

# $ns node-config -adhocRouting $val(rp) \
#                 -llType $val(ll) \
#                 -macType $val(mac) \
#                 -ifqType $val(ifq) \
#                 -ifqLen $val(ifqlen) \
#                 -antType $val(ant) \
#                 -propType $val(prop) \
#                 -phyType $val(netif) \
#                 -topoInstance $topo \
#                 -channelType $val(chan) \
#                 -agentTrace ON \
#                 -routerTrace ON \
#                 -macTrace OFF \
#                 -movementTrace OFF

# create nodes

set xl {}
set yl {}

for {set i 0} {$i < $val(nn) } {incr i} {

    set x1 [expr int(floor(rand()*$area))]
    set y1 [expr int(floor(rand()*$area))]

    set flag 1

    for {set index 0} {$index < [llength $xl]} {incr index} {
        if {[lindex $xl $index] == $x1 && [lindex $yl $index] == $yl} {
            set flag 0
            incr i -1
        }
    }

    if {$flag == 1} {
        set xl [linsert $xl end $x1]
        set yl [linsert $yl end $y1]

        set node($i) [$ns node]
        set randmotion [expr rand()*5]
        $node($i) random-motion 0

        $node($i) set X_ $x1
        $node($i) set Y_ $y1
        $node($i) set Z_ 0
        $ns initial_node_pos $node($i) $val(nn)
    }
    
} 





# Traffic
set val(nf)         $flow                ;# number of flows

set lasti [expr $val(nn)-1]
set dest [expr int(floor(rand()*$lasti))]
# $ns at 0.1 "$node($dest) color "#FF0000""
# $ns at 0.1 "$node($dest) color Red"
$node($dest) color Red

set udp_sink [new Agent/Null]
$ns attach-agent $node($dest) $udp_sink

# set srclist {}

for {set i 0} {$i < $val(nf)} {incr i} {
    # set src $i
    # set dest [expr $i + 10]
    set src [expr int(floor(rand()*($val(nn)-1)))]
    if { $src == $dest } {
        incr i -1
    } else {

        # Traffic config
        # create agent
        set udp($i) [new Agent/UDP]
        # attach to nodes
        $ns attach-agent $node($src) $udp($i)

        

        # Traffic generator
        set exptrf [new Application/Traffic/Exponential]
        $exptrf set packetSize_ 64
        # $exptrf set burst_time_ 500ms
        # $exptrf set idle_time_ 50ms
        $exptrf set rate_ 10k
        $exptrf attach-agent $udp($i)

        $ns connect $udp($i) $udp_sink

        $udp($i) set fid_ $i
        
        # # start traffic generation
        $ns at 1.0 "$exptrf start"
    }
}



# End Simulation

# Stop nodes
for {set i 0} {$i < $val(nn)} {incr i} {
    $ns at 50.0 "$node($i) reset"
}

# call final function
proc finish {} {
    global ns trace_file nam_file
    $ns flush-trace
    close $trace_file
    close $nam_file
}

proc halt_simulation {} {
    global ns
    puts "Simulation ending"
    $ns halt
}

$ns at 50.0001 "finish"
$ns at 50.0002 "halt_simulation"




# Run simulation
puts "Simulation starting"
$ns run

