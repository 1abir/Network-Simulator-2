areas=(250 500 750 1000 1250)
nodes=(20 40 60 80 100)
flows=(10 20 30 40 50)
area_outfile="1605104_area.csv"
node_outfile="1605104_node.csv"
flow_outfile="1605104_flow.csv"
logfile="1605104.log"
parser="1605104.awk"
tcl_file="1605104.tcl"
tracer="1605104.tr"
animation_file="1605104.nam"
python_file="1605104.py"

rm $logfile

rm $area_outfile
echo "Area,throughput,end_to_end_delay,delivery_ratio,drop_ratio" >> $area_outfile
for i in ${areas[@]}; do
    ns $tcl_file $i 40 20 $tracer $animation_file >> $logfile
    awk -v vari=$i -f $parser $tracer >> $area_outfile
    rm $animation_file
    rm $tracer
done
python3 $python_file "Area" $area_outfile


rm $node_outfile
echo "Node,throughput,end_to_end_delay,delivery_ratio,drop_ratio" >> $node_outfile
for i in ${nodes[@]}; do
    ns $tcl_file 500 $i 20 $tracer $animation_file >> $logfile
    awk -v vari=$i -f $parser $tracer >> $node_outfile
    rm $animation_file
    rm $tracer
done
python3 $python_file "Node" $node_outfile


rm $flow_outfile
echo "Flow,throughput,end_to_end_delay,delivery_ratio,drop_ratio" >> $flow_outfile
for i in ${flows[@]}; do
    ns $tcl_file 500 40 $i $tracer $animation_file >> $logfile
    awk -v vari=$i -f $parser $tracer >> $flow_outfile
    rm $animation_file
    rm $tracer
done
python3 $python_file "Flow" $flow_outfile

